#!/usr/bin/env node
import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';
import { migrateAll } from './src/migration/migrateAll.js';
import { generateMapping } from './src/utils/autoMapper.js';
import { validateMapping } from './src/utils/validateMapping.js';
import { connectMySQL } from './src/db/mysql.js';
import { connectPostgres } from './src/db/postgres.js';

const argv = yargs(hideBin(process.argv))
  .option('mysql', { type: 'string', demandOption: true })
  .option('postgres', { type: 'string', demandOption: true })
  .option('batch', { type: 'number', default: 5000 })
  .option('mapping', { type: 'string', default: './mapping.json' })
  .option('dryRun', { type: 'boolean', default: false })
  .option('autoMap', { type: 'boolean', default: false })
  .option('validate', { type: 'boolean', default: false })
  .argv;

(async () => {
  const mysqlDB = connectMySQL(argv.mysql);
  const pgDB = connectPostgres(argv.postgres);

  if (argv.autoMap) {
    console.log('🔹 Generating suggested mapping...');
    await generateMapping(mysqlDB, pgDB, './mapping_suggested.json');
    await mysqlDB.destroy();
    await pgDB.destroy();
    process.exit(0);
  }

  if (argv.validate) {
    console.log('🔹 Validating mapping before migration...');
    await validateMapping(pgDB, argv.mapping);
    await mysqlDB.destroy();
    await pgDB.destroy();
    process.exit(0);
  }

  console.log('🚀 Starting migration...');
  await migrateAll(argv);

  await mysqlDB.destroy();
  await pgDB.destroy();
})();
