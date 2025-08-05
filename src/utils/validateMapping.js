import fs from 'fs';

export async function validateMapping(pgDB, mappingFile) {
  console.log(`🔹 Validating mapping file: ${mappingFile}`);

  const mapping = JSON.parse(fs.readFileSync(mappingFile, 'utf-8'));

  // Get all tables and columns in Postgres ERP
  const tables = await pgDB('information_schema.tables')
    .select('table_name')
    .where({ table_schema: 'public' });

  const tableNames = tables.map(t => t.table_name);

  const columns = {};
  for (const t of tableNames) {
    const cols = await pgDB('information_schema.columns')
      .select('column_name')
      .where({ table_schema: 'public', table_name: t });
    columns[t] = cols.map(c => c.column_name);
  }

  let hasError = false;

  for (const [sourceTable, mappingDef] of Object.entries(mapping)) {
    const targetTable = mappingDef.target_table;
    if (!tableNames.includes(targetTable)) {
      console.error(`❌ Target table '${targetTable}' does not exist in Postgres schema.`);
      hasError = true;
    }

    for (const destCol of Object.values(mappingDef.column_mapping)) {
      if (!columns[targetTable]?.includes(destCol)) {
        console.error(`❌ Column '${destCol}' does not exist in target table '${targetTable}'.`);
        hasError = true;
      }
    }
  }

  if (hasError) {
    console.error('❌ Mapping validation failed. Please fix the mapping.json file.');
    process.exit(1);
  } else {
    console.log('✅ Mapping validation successful. Ready for migration.');
  }
}
