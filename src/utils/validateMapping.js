import fs from 'fs';
import stringSimilarity from 'string-similarity';

/**
 * AI-enhanced mapping validator and modifier
 * @param {*} mysqlDB Knex instance for MySQL
 * @param {*} pgDB Knex instance for PostgreSQL
 * @param {*} mappingFile Path to mapping file
 * @param {*} sourceSchemaFile Path to source schema JSON
 * @param {*} targetSchemaFile Path to target schema JSON
 */
export async function validateAndModifyMapping(
  mysqlDB,
  pgDB,
  mappingFile = './mapping.json',
  sourceSchemaFile = './source_schema.json',
  targetSchemaFile = './target_schema.json'
) {
  console.log('🔹 Validating and modifying mapping with AI...');

  // 1️⃣ Load mapping and schema files
  const mapping = JSON.parse(fs.readFileSync(mappingFile, 'utf-8'));
  const sourceSchema = JSON.parse(fs.readFileSync(sourceSchemaFile, 'utf-8'));
  const targetSchema = JSON.parse(fs.readFileSync(targetSchemaFile, 'utf-8'));

  // 2️⃣ Get table and column information from schemas
  const sourceTables = Object.keys(sourceSchema.tables || {});
  const targetTables = Object.keys(targetSchema.tables || {});

  // 3️⃣ Validate and modify mapping
  const modifiedMapping = {};
  const unmappedSourceTables = [];
  const unmappedTargetTables = [...targetTables];

  for (const [sourceTable, tableMap] of Object.entries(mapping)) {
    // Check if source table exists in source schema
    if (!sourceTables.includes(sourceTable)) {
      console.warn(`⚠️ Source table ${sourceTable} not found in source schema`);
      continue;
    }

    // Get target table from mapping
    let targetTable = tableMap.target_table;

    // If no target table or it doesn't exist, find the best match
    if (!targetTable || !targetTables.includes(targetTable)) {
      const bestMatch = stringSimilarity.findBestMatch(sourceTable, targetTables);
      targetTable = bestMatch.bestMatch.rating > 0.3 ? bestMatch.bestMatch.target : '';

      if (!targetTable) {
        unmappedSourceTables.push(sourceTable);
        continue;
      }
    }

    // Remove from unmapped target tables list
    unmappedTargetTables.splice(unmappedTargetTables.indexOf(targetTable), 1);

    // Get source and target columns
    const sourceColumns = Object.keys(sourceSchema.tables[sourceTable].columns || {});
    const targetColumns = Object.keys(targetSchema.tables[targetTable].columns || {});

    // Validate and modify column mapping
    const modifiedColumnMapping = {};
    const unmappedSourceColumns = [];
    const unmappedTargetColumns = [...targetColumns];

    for (const [srcCol, tgtCol] of Object.entries(tableMap.column_mapping || {})) {
      // Check if source column exists
      if (!sourceColumns.includes(srcCol)) {
        console.warn(`⚠️ Source column ${srcCol} not found in ${sourceTable}`);
        continue;
      }

      // Check if target column exists
      if (!targetColumns.includes(tgtCol)) {
        // Find best match for target column
        const bestMatch = stringSimilarity.findBestMatch(srcCol, targetColumns);
        const bestTargetCol = bestMatch.bestMatch.rating > 0.4 ? bestMatch.bestMatch.target : '';

        if (bestTargetCol) {
          modifiedColumnMapping[srcCol] = bestTargetCol;
          unmappedTargetColumns.splice(unmappedTargetColumns.indexOf(bestTargetCol), 1);
        } else {
          unmappedSourceColumns.push(srcCol);
        }
        continue;
      }

      // Remove from unmapped columns lists
      unmappedSourceColumns.splice(unmappedSourceColumns.indexOf(srcCol), 1);
      unmappedTargetColumns.splice(unmappedTargetColumns.indexOf(tgtCol), 1);

      // Check data type compatibility
      const srcType = sourceSchema.tables[sourceTable].columns[srcCol].type;
      const tgtType = targetSchema.tables[targetTable].columns[tgtCol].type;

      if (!areTypesCompatible(srcType, tgtType)) {
        console.warn(`⚠️ Incompatible types for ${srcCol} (${srcType}) -> ${tgtCol} (${tgtType})`);
        // Find compatible column
        const compatibleCol = findCompatibleColumn(srcCol, srcType, targetColumns, targetSchema.tables[targetTable].columns);
        if (compatibleCol) {
          modifiedColumnMapping[srcCol] = compatibleCol;
        } else {
          unmappedSourceColumns.push(srcCol);
        }
      } else {
        modifiedColumnMapping[srcCol] = tgtCol;
      }
    }

    // Add unmapped source columns if they have compatible target columns
    for (const srcCol of unmappedSourceColumns) {
      const srcType = sourceSchema.tables[sourceTable].columns[srcCol].type;
      const compatibleCol = findCompatibleColumn(srcCol, srcType, unmappedTargetColumns, targetSchema.tables[targetTable].columns);

      if (compatibleCol) {
        modifiedColumnMapping[srcCol] = compatibleCol;
        unmappedTargetColumns.splice(unmappedTargetColumns.indexOf(compatibleCol), 1);
      }
    }

    // Determine primary key
    let primaryKey = tableMap.pk || '';
    if (!sourceColumns.includes(primaryKey)) {
      // Find primary key in source table
      primaryKey = sourceColumns.find(col => col.toLowerCase().includes('id')) || sourceColumns[0] || '';
    }

    modifiedMapping[sourceTable] = {
      target_table: targetTable,
      pk: primaryKey,
      column_mapping: modifiedColumnMapping
    };
  }

  // 4️⃣ Save modified mapping
  fs.writeFileSync(mappingFile, JSON.stringify(modifiedMapping, null, 2));

  // 5️⃣ Generate report
  const report = {
    modified_mapping: mappingFile,
    unmapped_source_tables: unmappedSourceTables,
    unmapped_target_tables: unmappedTargetTables,
    summary: `Modified mapping saved to ${mappingFile}\n` +
             `Unmapped source tables: ${unmappedSourceTables.length}\n` +
             `Unmapped target tables: ${unmappedTargetTables.length}`
  };

  console.log('✅ Mapping validation and modification complete');
  console.log(report.summary);

  return report;
}

/**
 * Check if data types are compatible
 */
function areTypesCompatible(srcType, tgtType) {
  // Basic type compatibility rules
  const srcBaseType = srcType.split('(')[0].toLowerCase();
  const tgtBaseType = tgtType.split('(')[0].toLowerCase();

  // String types - MySQL to PostgreSQL
  const mysqlStringTypes = ['char', 'varchar', 'text', 'string', 'tinytext', 'mediumtext', 'longtext'];
  const pgStringTypes = ['char', 'varchar', 'text', 'string', 'character varying', 'character'];

  if (mysqlStringTypes.includes(srcBaseType) && pgStringTypes.includes(tgtBaseType)) {
    return true;
  }

  // Numeric types
  const numericTypes = ['int', 'integer', 'bigint', 'smallint', 'decimal', 'numeric', 'float', 'double', 'real'];
  if (numericTypes.includes(srcBaseType) && numericTypes.includes(tgtBaseType)) {
    return true;
  }

  // Date/Time types - MySQL to PostgreSQL
  const mysqlDateTypes = ['date', 'datetime', 'timestamp', 'time'];
  const pgDateTypes = ['date', 'datetime', 'timestamp', 'time', 'timestamp without time zone', 'timestamp with time zone'];

  if (mysqlDateTypes.includes(srcBaseType) && pgDateTypes.includes(tgtBaseType)) {
    return true;
  }

  // Boolean types - MySQL tinyint(1) to PostgreSQL boolean
  const mysqlBoolTypes = ['bool', 'boolean', 'tinyint'];
  const pgBoolTypes = ['bool', 'boolean', 'tinyint'];

  if (mysqlBoolTypes.includes(srcBaseType) && pgBoolTypes.includes(tgtBaseType)) {
    return true;
  }

  // JSON types
  if (srcBaseType === 'json' && tgtBaseType === 'json') {
    return true;
  }

  return false;
}

/**
 * Find compatible column by name and type
 */
function findCompatibleColumn(srcCol, srcType, targetColumns, targetColumnInfo) {
  // First try to find by name similarity
  const nameMatches = stringSimilarity.findBestMatch(srcCol, targetColumns);
  const bestNameMatch = nameMatches.bestMatch.rating > 0.4 ? nameMatches.bestMatch.target : '';

  if (bestNameMatch && areTypesCompatible(srcType, targetColumnInfo[bestNameMatch].type)) {
    return bestNameMatch;
  }

  // If no good name match, try to find by type only
  for (const tgtCol of targetColumns) {
    if (areTypesCompatible(srcType, targetColumnInfo[tgtCol].type)) {
      return tgtCol;
    }
  }

  return '';
}
