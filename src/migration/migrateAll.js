import fs from 'fs';
import path from 'path';
import { connectMySQL } from '../db/mysql.js';
import { connectPostgres } from '../db/postgres.js';

/**
 * Fetches column types from Postgres for validation
 */
async function getPostgresColumns(pgDB, tableName) {
  const columns = await pgDB('information_schema.columns')
    .select('column_name', 'data_type', 'is_nullable')
    .where({ table_schema: 'public', table_name: tableName });

  const colMap = {};
  for (const col of columns) {
    colMap[col.column_name] = {
      type: col.data_type,
      nullable: col.is_nullable === 'YES'
    };
  }
  return colMap;
}

/**
 * Safely converts a value according to Postgres column type
 */
function convertValue(value, colType) {
  if (value === null || value === undefined) return null;

  // Handle string primary keys (UUIDs) - don't convert them to numbers
  if (typeof value === 'string' && colType.includes('int')) {
    // If it's a string that looks like a UUID or other non-numeric ID, keep it as string
    if (!/^\d+$/.test(value)) {
      return value;
    }
    // If it's a numeric string, try to convert
    if (isNaN(parseInt(value))) return null;
    return parseInt(value);
  }

  if (colType.includes('int')) {
    if (isNaN(parseInt(value))) return null;
    return parseInt(value);
  }

  if (colType.includes('numeric') || colType.includes('decimal')) {
    if (isNaN(parseFloat(value))) return null;
    return parseFloat(value);
  }

  if (colType.includes('timestamp') || colType.includes('date')) {
    const date = new Date(value);
    return isNaN(date.getTime()) ? null : date;
  }

  // Handle boolean values
  if (colType.includes('bool')) {
    if (typeof value === 'boolean') return value;
    if (typeof value === 'string') {
      return value.toLowerCase() === 'true' || value === '1';
    }
    if (typeof value === 'number') return value === 1;
    return null;
  }

  return value; // default: string or text
}

/**
 * Main Migration Flow
 */
export async function migrateAll({ mysql, postgres, batch, mapping, dryRun }) {
  const mysqlDB = connectMySQL(mysql);
  const pgDB = connectPostgres(postgres);

  // Validate mapping file exists
  if (!fs.existsSync(mapping)) {
    console.error(`❌ Mapping file not found: ${mapping}`);
    process.exit(1);
  }

  const mappings = JSON.parse(fs.readFileSync(mapping, 'utf-8'));
  const errorLogPath = path.resolve('migration_errors.log');
  fs.writeFileSync(errorLogPath, ''); // reset log

  console.log('🚀 Starting ERP Migration...');

  for (const [sourceTable, tableMap] of Object.entries(mappings)) {
    const targetTable = tableMap.target_table;
    console.log(`🔹 Migrating: ${sourceTable} -> ${targetTable}`);

    // 1️⃣ Get Postgres column types
    const targetCols = await getPostgresColumns(pgDB, targetTable);
    if (!Object.keys(targetCols).length) {
      console.warn(`⚠️ Skipping ${sourceTable} because target table ${targetTable} does not exist in Postgres`);
      continue;
    }

    // 2️⃣ Fetch rows from MySQL in batches
    let offset = 0;
    while (true) {
      const rows = await mysqlDB.select('*').from(sourceTable).limit(batch).offset(offset);
      if (!rows.length) break;

      console.log(`   Processing ${rows.length} rows from offset ${offset}`);
      const validInserts = [];

      for (const row of rows) {
        const insertRow = {};
        let valid = true;

        for (const [srcCol, tgtCol] of Object.entries(tableMap.column_mapping)) {
          if (!tgtCol || !targetCols[tgtCol]) continue;

          const colType = targetCols[tgtCol].type;
          const rawValue = row[srcCol];
          const safeValue = convertValue(rawValue, colType);

          // Handle nullable columns more gracefully
          if (safeValue === null && !targetCols[tgtCol].nullable) {
            // For non-nullable columns, use default values where possible
            if (colType.includes('int') || colType.includes('numeric') || colType.includes('decimal')) {
              safeValue = 0;
            } else if (colType.includes('bool')) {
              safeValue = false;
            } else if (colType.includes('timestamp') || colType.includes('date')) {
              safeValue = new Date();
            } else {
              safeValue = ''; // For string columns
            }
            // Log the substitution but don't skip the row
            fs.appendFileSync(errorLogPath, `Substituted default for NULL in non-nullable column ${tgtCol} in table ${targetTable}, source value: ${rawValue}\n`);
          }

          insertRow[tgtCol] = safeValue;
        }

        // Only skip row if it would violate primary key constraints
        if (Object.values(insertRow).every(val => val === null || val === '')) {
          fs.appendFileSync(errorLogPath, `Skipping empty row in ${targetTable}\n`);
        } else {
          validInserts.push(insertRow);
        }
      }

      // 3️⃣ Insert into Postgres
      if (!dryRun && validInserts.length) {
        try {
          // Insert rows individually to get better error reporting
          for (const row of validInserts) {
            try {
              await pgDB(targetTable).insert(row);
            } catch (err) {
              fs.appendFileSync(errorLogPath, `Insert error in ${targetTable}: ${err.message}, row: ${JSON.stringify(row)}\n`);
              console.error(`❌ Insert failed for row in ${targetTable}`, err.message);
            }
          }
        } catch (err) {
          fs.appendFileSync(errorLogPath, `Batch insert error in ${targetTable}: ${err.message}\n`);
          console.error(`❌ Insert failed for batch in ${targetTable}`, err.message);
        }
      }

      offset += batch;
    }

    console.log(`✅ Completed: ${sourceTable} -> ${targetTable}`);
  }

  await mysqlDB.destroy();
  await pgDB.destroy();

  console.log('🎉 Migration Complete!');
  console.log(`📄 Check migration_errors.log for any skipped rows or issues.`);
}
