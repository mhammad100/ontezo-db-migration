import { transformRow } from './transform.js';
import { mapId } from './idMapper.js';

export async function migrateTable(mysqlDB, pgDB, tableName, mapping, batchSize, dryRun) {
  let offset = 0;

  while (true) {
    const rows = await mysqlDB.select('*').from(tableName).limit(batchSize).offset(offset);
    if (!rows.length) break;

    const transformed = rows.map(r => transformRow(r, mapping));

    let insertedIds = [];
    if (!dryRun) {
      const inserted = await pgDB(mapping.target_table).insert(transformed).returning('id');
      insertedIds = inserted.map(r => r.id);
    }

    rows.forEach((row, idx) => {
      if (insertedIds[idx] !== undefined) {
        mapId(tableName, row[mapping.pk || 'id'], insertedIds[idx]);
      }
    });

    console.log(`Migrated ${rows.length} rows from ${tableName}`);
    offset += batchSize;
  }
}
