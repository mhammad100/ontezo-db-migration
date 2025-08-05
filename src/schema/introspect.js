import fs from 'fs';

/**
 * Extract database schema information
 * @param {*} db Knex instance
 * @param {string} outputFile Path to save schema JSON
 */
export async function extractSchema(db, outputFile) {
  console.log('🔹 Extracting database schema...');

  // Get database type
  const dbType = db.client.config.client;

  // 1️⃣ Get all tables
  let tablesQuery;
  if (dbType === 'mysql' || dbType === 'mysql2') {
    tablesQuery = db('information_schema.tables')
      .select('TABLE_NAME')
      .where({ table_schema: db.client.config.connection.database });
  } else if (dbType === 'pg') {
    tablesQuery = db('information_schema.tables')
      .select('table_name')
      .where({ table_schema: 'public' });
  } else {
    throw new Error(`Unsupported database type: ${dbType}`);
  }

  const tablesRaw = await tablesQuery;
  const tableNames = tablesRaw.map(t => t.TABLE_NAME || t.table_name).filter(Boolean);

  if (tableNames.length === 0) {
    throw new Error(`❌ No tables found in database`);
  }

  // 2️⃣ Get columns for each table
  const schema = { tables: {} };

  for (const tableName of tableNames) {
    let columnsQuery;
    if (dbType === 'mysql' || dbType === 'mysql2') {
      columnsQuery = db('information_schema.columns')
        .select('COLUMN_NAME', 'DATA_TYPE', 'IS_NULLABLE', 'COLUMN_KEY', 'EXTRA')
        .where({
          table_schema: db.client.config.connection.database,
          table_name: tableName
        });
    } else if (dbType === 'pg') {
      columnsQuery = db('information_schema.columns')
        .select('column_name', 'data_type', 'is_nullable', 'column_default')
        .where({
          table_schema: 'public',
          table_name: tableName
        });
    }

    const columnsRaw = await columnsQuery;
    const columns = {};

    for (const col of columnsRaw) {
      const columnName = col.COLUMN_NAME || col.column_name;
      const dataType = col.DATA_TYPE || col.data_type;
      const isNullable = col.IS_NULLABLE === 'YES' || col.is_nullable === 'YES';
      const isPrimaryKey = col.COLUMN_KEY === 'PRI' || col.column_name === 'id';
      const isAutoIncrement = col.EXTRA === 'auto_increment' || col.column_default?.includes('nextval');

      columns[columnName] = {
        type: dataType,
        nullable: isNullable,
        primary_key: isPrimaryKey,
        auto_increment: isAutoIncrement
      };
    }

    schema.tables[tableName] = { columns };
  }

  // 3️⃣ Save schema file
  fs.writeFileSync(outputFile, JSON.stringify(schema, null, 2));
  console.log(`✅ Schema saved to ${outputFile}`);
  console.log(`ℹ️ Found ${tableNames.length} tables`);

  return schema;
}
