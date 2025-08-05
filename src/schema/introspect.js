export async function introspectMySQL(mysqlDB) {
  const tables = await mysqlDB
    .select('TABLE_NAME as tableName')
    .from('information_schema.tables')
    .where({ table_schema: mysqlDB.client.config.connection.database });

  const foreignKeys = await mysqlDB
    .select(
      'TABLE_NAME as tableName',
      'COLUMN_NAME as columnName',
      'REFERENCED_TABLE_NAME as referencedTable',
      'REFERENCED_COLUMN_NAME as referencedColumn'
    )
    .from('information_schema.key_column_usage')
    .where({ table_schema: mysqlDB.client.config.connection.database })
    .whereNotNull('REFERENCED_TABLE_NAME');

  return { tables: tables.map(t => t.tableName), foreignKeys };
}
