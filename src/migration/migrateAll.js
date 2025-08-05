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

  // 1️⃣ First pass: Migrate tables without foreign key dependencies
  for (const [sourceTable, tableMap] of Object.entries(mappings)) {
    const targetTable = tableMap.target_table;
    console.log(`🔹 Migrating: ${sourceTable} -> ${targetTable}`);

    // Get Postgres column types
    const targetCols = await getPostgresColumns(pgDB, targetTable);
    if (!Object.keys(targetCols).length) {
      console.warn(`⚠️ Skipping ${sourceTable} because target table ${targetTable} does not exist in Postgres`);
      continue;
    }

    // Check if this table has primary key that should be skipped
    const pkColumn = tableMap.pk || 'id';
    const pkIsStringInSource = await checkIfPrimaryKeyIsString(mysqlDB, sourceTable, pkColumn);
    const pkIsIntInTarget = targetCols[pkColumn]?.type.includes('int');

    // 2️⃣ Fetch rows from MySQL in batches
    let offset = 0;
    while (true) {
      const rows = await mysqlDB.select('*').from(sourceTable).limit(batch).offset(offset);
      if (!rows.length) break;

      console.log(`   Processing ${rows.length} rows from offset ${offset}`);
      const validInserts = [];

      for (const row of rows) {
        const insertRow = {};

        // Handle primary key - skip if it's string in source and int in target
        if (pkIsStringInSource && pkIsIntInTarget) {
          // Skip the primary key to let Postgres auto-generate it
          console.log(`   🔑 Skipping string primary key ${pkColumn} to let Postgres auto-generate`);
        } else {
          // Include the primary key in the insert
          const pkValue = convertValue(row[pkColumn], targetCols[pkColumn].type);
          if (pkValue !== null) {
            insertRow[pkColumn] = pkValue;
          }
        }

        // Process all other columns
        for (const [srcCol, tgtCol] of Object.entries(tableMap.column_mapping)) {
          if (!tgtCol || !targetCols[tgtCol] || srcCol === pkColumn) continue;

          const colType = targetCols[tgtCol].type;
          const rawValue = row[srcCol];
          let safeValue = convertValue(rawValue, colType);

          // Handle nullable columns more gracefully
          let finalValue = safeValue;
          if (finalValue === null && !targetCols[tgtCol].nullable) {
            // For non-nullable columns, use default values where possible
            if (colType.includes('int') || colType.includes('numeric') || colType.includes('decimal')) {
              finalValue = 0;
            } else if (colType.includes('bool')) {
              finalValue = false;
            } else if (colType.includes('timestamp') || colType.includes('date')) {
              finalValue = new Date();
            } else {
              finalValue = ''; // For string columns
            }
            // Log the substitution but don't skip the row
            fs.appendFileSync(errorLogPath, `Substituted default for NULL in non-nullable column ${tgtCol} in table ${targetTable}, source value: ${rawValue}\n`);
          }

          // Check if we're trying to insert string content into numeric fields
          if ((colType.includes('int') || colType.includes('numeric') || colType.includes('decimal')) &&
              typeof finalValue === 'string' && isNaN(parseFloat(finalValue))) {
            // If it looks like HTML or contains special characters, skip this field
            if (/<[a-z][\s\S]*>/i.test(finalValue) || /[<>&'"]/.test(finalValue)) {
              fs.appendFileSync(errorLogPath, `Skipping HTML content for numeric column ${tgtCol} in table ${targetTable}\n`);
              continue; // Skip this column
            }
          }

          insertRow[tgtCol] = finalValue;
        }

        // Only skip row if it would violate primary key constraints
        if (Object.values(insertRow).every(val => val === null || val === '')) {
          fs.appendFileSync(errorLogPath, `Skipping empty row in ${targetTable}\n`);
        } else {
          validInserts.push(insertRow);
        }
      }

      // 3️⃣ Insert into Postgres and track ID mapping
      if (!dryRun && validInserts.length) {
        try {
          // Insert rows individually to get better error reporting and track new IDs
          for (const row of validInserts) {
            try {
              const inserted = await pgDB(targetTable).insert(row).returning('id');
              const newId = inserted[0]?.id;

              // If we skipped the primary key, map the old ID to the new one
              if (pkIsStringInSource && pkIsIntInTarget && newId) {
                const oldId = row[pkColumn];
                if (oldId) {
                  mapId(sourceTable, oldId, newId);
                }
              }
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

  // 2️⃣ Second pass: Update foreign key relationships
  console.log('🔄 Updating foreign key relationships...');
  for (const [sourceTable, tableMap] of Object.entries(mappings)) {
    const targetTable = tableMap.target_table;

    // Get Postgres column types
    const targetCols = await getPostgresColumns(pgDB, targetTable);
    if (!Object.keys(targetCols).length) continue;

    // Find foreign key columns
    const fkColumns = Object.entries(tableMap.column_mapping)
      .filter(([srcCol, tgtCol]) => tgtCol.endsWith('_id') && tgtCol !== 'id')
      .map(([srcCol, tgtCol]) => ({ srcCol, tgtCol }));

    if (fkColumns.length === 0) continue;

    console.log(`   🔗 Updating foreign keys for ${targetTable}`);

    // Get all rows from the target table
    const targetRows = await pgDB.select('*').from(targetTable);

    // Update foreign keys using the ID mapping
    for (const row of targetRows) {
      let needsUpdate = false;
      const updateData = { id: row.id };

      for (const { srcCol, tgtCol } of fkColumns) {
        const oldFkValue = row[tgtCol];
        if (oldFkValue) {
          // Check if this is a string UUID that needs to be mapped
          if (typeof oldFkValue === 'string' && oldFkValue.includes('-')) {
            // Find the referenced table and get the new ID
            const refTable = Object.keys(mappings).find(t =>
              mappings[t].target_table === tgtCol.replace('_id', '')
            );

            if (refTable) {
              const newFkId = getMappedId(refTable, oldFkValue);
              if (newFkId) {
                updateData[tgtCol] = newFkId;
                needsUpdate = true;
                console.log(`      🔄 Mapping FK ${tgtCol}: ${oldFkValue} -> ${newFkId}`);
              }
            }
          }
        }
      }

      // Update the row if needed
      if (needsUpdate && Object.keys(updateData).length > 1) {
        try {
          await pgDB(targetTable)
            .where({ id: updateData.id })
            .update(updateData);
        } catch (err) {
          fs.appendFileSync(errorLogPath, `FK update error in ${targetTable}: ${err.message}, data: ${JSON.stringify(updateData)}\n`);
          console.error(`❌ FK update failed for ${targetTable}`, err.message);
        }
      }
    }
  }

  await mysqlDB.destroy();
  await pgDB.destroy();

  console.log('🎉 Migration Complete!');
  console.log(`📄 Check migration_errors.log for any skipped rows or issues.`);
}

/**
 * Check if primary key is string in source table
 */
async function checkIfPrimaryKeyIsString(mysqlDB, tableName, pkColumn) {
  try {
    const result = await mysqlDB('information_schema.columns')
      .select('data_type')
      .where({
        table_schema: mysqlDB.client.config.connection.database,
        table_name: tableName,
        column_name: pkColumn
      })
      .first();

    return result && result.data_type && result.data_type.includes('char');
  } catch (err) {
    console.warn(`⚠️ Could not determine PK type for ${tableName}.${pkColumn}: ${err.message}`);
    return false;
  }
}
