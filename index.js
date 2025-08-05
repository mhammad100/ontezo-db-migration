#!/usr/bin/env node
import dotenv from 'dotenv';
import { migrateAll } from './src/migration/migrateAll.js';
import { generateMapping } from './src/utils/autoMapper.js';
import { validateAndModifyMapping } from './src/utils/validateMapping.js';
import { extractSchema } from './src/schema/introspect.js';
import { connectMySQL } from './src/db/mysql.js';
import { connectPostgres } from './src/db/postgres.js';

// Load environment variables from .env file
dotenv.config();

(async () => {
  try {
    // Get configuration from environment variables
    const mysqlPath = process.env.SQL_PATH;
    const postgresPath = process.env.PG_PATH;
    const mappingPath = process.env.MAPPING_PATH || './mapping.json';
    const batchSize = parseInt(process.env.BATCH_SIZE) || 5000;
    const dryRun = process.env.DRY_RUN === 'true';
    const autoMap = process.env.AUTO_MAP === 'true';
    const validate = process.env.VALIDATE === 'true';
    const migrate = process.env.MIGRATE === 'true';

    if (!mysqlPath || !postgresPath) {
      throw new Error('Database connection strings are not properly configured in .env file');
    }

    const mysqlDB = connectMySQL(mysqlPath);
    const pgDB = connectPostgres(postgresPath);

    // 1️⃣ Extract schemas from both databases
    console.log('🔹 Extracting source database schema...');
    await extractSchema(mysqlDB, './source_schema.json');

    console.log('🔹 Extracting target database schema...');
    await extractSchema(pgDB, './target_schema.json');

    if (autoMap) {
      console.log('🔹 Generating suggested mapping...');
      await generateMapping(mysqlDB, pgDB, mappingPath);
    }

    if (validate) {
      console.log('🔹 Validating mapping before migration...');
      await validateAndModifyMapping(mysqlDB, pgDB, mappingPath);
    }

    if(migrate || dryRun){
      console.log('🚀 Starting migration...');
      await migrateAll({
        mysql: mysqlPath,
        postgres: postgresPath,
        batch: batchSize,
        mapping: mappingPath,
        dryRun: dryRun
      });

    }
    await mysqlDB.destroy();
    await pgDB.destroy();
  } catch (error) {
    console.error('❌ Migration failed:', error.message);
    process.exit(1);
  }
})();
