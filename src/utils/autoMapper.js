import fs from 'fs';
import stringSimilarity from 'string-similarity';

/**
 * Auto-generates a starter mapping file by comparing MySQL and Postgres schemas
 * @param {*} mysqlDB Knex instance for MySQL
 * @param {*} pgDB Knex instance for PostgreSQL
 * @param {*} outputFile Path to save mapping JSON
 */
export async function generateMapping(mysqlDB, pgDB, outputFile = './mapping_suggested.json') {
  console.log('🔹 Generating suggested mapping...');

  // 1️⃣ Fetch MySQL tables
  const mysqlTablesRaw = await mysqlDB('information_schema.tables')
    .select('TABLE_NAME')
    .where({ table_schema: mysqlDB.client.config.connection.database });

  const mysqlTables = mysqlTablesRaw.map(t => t.TABLE_NAME).filter(Boolean);

  if (mysqlTables.length === 0) {
    throw new Error(`❌ No tables found in MySQL schema: ${mysqlDB.client.config.connection.database}`);
  }

  // 2️⃣ Fetch PostgreSQL tables
  const pgTablesRaw = await pgDB('information_schema.tables')
    .select('table_name')
    .where({ table_schema: 'public' });

  const pgTableNames = pgTablesRaw.map(t => t.table_name).filter(Boolean);

  if (pgTableNames.length === 0) {
    throw new Error('❌ No tables found in PostgreSQL public schema');
  }

  // 3️⃣ Fetch MySQL columns for each table
  const mysqlCols = {};
  for (const tableName of mysqlTables) {
    const cols = await mysqlDB('information_schema.columns')
      .select('COLUMN_NAME')
      .where({ table_schema: mysqlDB.client.config.connection.database, table_name: tableName });

    mysqlCols[tableName] = cols.map(c => c.COLUMN_NAME);
  }

  // 4️⃣ Fetch PostgreSQL columns for each table
  const pgCols = {};
  for (const tableName of pgTableNames) {
    const cols = await pgDB('information_schema.columns')
      .select('column_name')
      .where({ table_schema: 'public', table_name: tableName });

    pgCols[tableName] = cols.map(c => c.column_name);
  }

  // ✅ Declare mapping object here!
  const mapping = {};

  // Special table name mappings
  const specialTableMappings = {
    "Employees": "users",
    "employee": "users",
    "users": "users",
    "Employee": "users",
    "Comments": "comments",
    "Tasks": "tasks",
    "Projects": "projects",
    "TimeLogs": "time_logs",
    "Leads": "clients"
  };

  // 5️⃣ Auto-generate mapping suggestions
  for (const sourceTable of mysqlTables) {
    // Check for special table mappings first
    let targetTable = specialTableMappings[sourceTable];

    // If no special mapping, use string similarity
    if (!targetTable && pgTableNames.length > 0) {
      const tableMatch = stringSimilarity.findBestMatch(sourceTable, pgTableNames);
      targetTable = tableMatch.bestMatch.target;
    }

    // Get primary key - try common PK column names
    let primaryKey = '';
    const commonPkNames = ['id', 'uuid', 'guid', `${sourceTable.toLowerCase()}_id`];
    for (const pkName of commonPkNames) {
      if (mysqlCols[sourceTable]?.includes(pkName)) {
        primaryKey = pkName;
        break;
      }
    }
    // Fallback to first column if no common PK found
    if (!primaryKey) {
      primaryKey = mysqlCols[sourceTable]?.[0] || '';
    }

    mapping[sourceTable] = {
      target_table: targetTable || '',
      pk: primaryKey,
      column_mapping: {}
    };

    // Column mapping
    const sourceCols = mysqlCols[sourceTable] || [];
    const targetCols = pgCols[targetTable] || [];

    for (const srcCol of sourceCols) {
      let bestCol = '';
      if (targetCols.length > 0) {
        const bestMatch = stringSimilarity.findBestMatch(srcCol, targetCols);
        bestCol = bestMatch.bestMatch.target;
      }
      mapping[sourceTable].column_mapping[srcCol] = bestCol;
    }
  }

  // 6️⃣ Save mapping file
  fs.writeFileSync(outputFile, JSON.stringify(mapping, null, 2));
  console.log(`✅ Starter mapping saved to ${outputFile}`);
  console.log(`ℹ️ Found ${mysqlTables.length} MySQL tables → Suggested mapping for ${pgTableNames.length} Postgres tables`);
}
