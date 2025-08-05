import fs from 'fs';
import stringSimilarity from 'string-similarity';

/**
 * Auto-generates a starter mapping file by comparing MySQL and Postgres schemas
 * @param {*} mysqlDB Knex instance for MySQL
 * @param {*} pgDB Knex instance for PostgreSQL
 * @param {*} outputFile Path to save mapping JSON
 */
export async function generateMapping(mysqlDB, pgDB, outputFile = './mapping_suggested.json') {
  console.log('🔹 Generating AI-enhanced suggested mapping...');

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
      .select('COLUMN_NAME', 'DATA_TYPE')
      .where({ table_schema: mysqlDB.client.config.connection.database, table_name: tableName });

    mysqlCols[tableName] = cols.map(c => ({
      name: c.COLUMN_NAME,
      type: c.DATA_TYPE
    }));
  }

  // 4️⃣ Fetch PostgreSQL columns for each table with data types
  const pgCols = {};
  for (const tableName of pgTableNames) {
    const cols = await pgDB('information_schema.columns')
      .select('column_name', 'data_type')
      .where({ table_schema: 'public', table_name: tableName });

    pgCols[tableName] = cols.map(c => ({
      name: c.column_name,
      type: c.data_type
    }));
  }

  // ✅ Declare mapping object here!
  const mapping = {};

  // Enhanced special table name mappings with AI-like pattern matching
  const specialTableMappings = [
    { pattern: "Employees", target: "users" },
    { pattern: "employee", target: "users" },
    { pattern: "users", target: "users" },
    { pattern: "Employee", target: "users" },
    { pattern: "Comments", target: "comments" },
    { pattern: "Tasks", target: "tasks" },
    { pattern: "Projects", target: "projects" },
    { pattern: "TimeLogs", target: "time_logs" },
    { pattern: "Leads", target: "clients" },
    // AI-enhanced patterns
    { pattern: /.*user.*/i, target: "users" },
    { pattern: /.*comment.*/i, target: "comments" },
    { pattern: /.*task.*/i, target: "tasks" },
    { pattern: /.*project.*/i, target: "projects" },
    { pattern: /.*client.*/i, target: "clients" },
    { pattern: /.*lead.*/i, target: "clients" }
  ];

  // 5️⃣ Auto-generate mapping suggestions with AI-enhanced logic
  for (const sourceTable of mysqlTables) {
    // Check for special table mappings first (exact matches)
    let targetTable;
    for (const mapping of specialTableMappings) {
      if (typeof mapping.pattern === 'string' && mapping.pattern === sourceTable) {
        targetTable = mapping.target;
        break;
      }
    }

    // Check for pattern matches if no exact match
    if (!targetTable) {
      for (const mapping of specialTableMappings) {
        if (mapping.pattern instanceof RegExp && mapping.pattern.test(sourceTable)) {
          targetTable = mapping.target;
          break;
        }
      }
    }

    // If still no special mapping, use enhanced string similarity
    if (!targetTable && pgTableNames.length > 0) {
      // Get table columns for better similarity calculation
      const sourceColumns = mysqlCols[sourceTable] || [];
      const targetTableScores = {};

      for (const pgTable of pgTableNames) {
        const targetColumns = pgCols[pgTable] || [];
        let score = 0;

        // Table name similarity (30% weight)
        const nameSimilarity = stringSimilarity.compareTwoStrings(sourceTable.toLowerCase(), pgTable.toLowerCase());
        score += nameSimilarity * 0.3;

        // Column name similarity (50% weight)
        let colMatchScore = 0;
        for (const srcCol of sourceColumns) {
          const bestMatch = stringSimilarity.findBestMatch(srcCol.name, targetColumns.map(c => c.name));
          colMatchScore += bestMatch.bestMatch.rating;
        }
        const avgColSimilarity = sourceColumns.length ? colMatchScore / sourceColumns.length : 0;
        score += avgColSimilarity * 0.5;

        // Column type compatibility (20% weight)
        let typeCompatScore = 0;
        for (const srcCol of sourceColumns) {
          const bestMatch = stringSimilarity.findBestMatch(srcCol.name, targetColumns.map(c => c.name));
          const targetCol = targetColumns.find(c => c.name === bestMatch.bestMatch.target);
          if (targetCol) {
            // Basic type compatibility check
            const srcType = srcCol.type.toLowerCase();
            const tgtType = targetCol.type.toLowerCase();
            if (
              (srcType.includes('int') && tgtType.includes('int')) ||
              (srcType.includes('char') && tgtType.includes('text')) ||
              (srcType.includes('date') && tgtType.includes('timestamp'))
            ) {
              typeCompatScore += 1;
            } else if (srcType === targetCol.type) {
              typeCompatScore += 0.8;
            } else {
              typeCompatScore += 0.2;
            }
          }
        }
        const avgTypeCompat = sourceColumns.length ? typeCompatScore / sourceColumns.length : 0;
        score += avgTypeCompat * 0.2;

        targetTableScores[pgTable] = score;
      }

      // Find best scoring table
      const sortedTables = Object.entries(targetTableScores).sort((a, b) => b[1] - a[1]);
      if (sortedTables.length > 0 && sortedTables[0][1] > 0.4) { // Minimum threshold
        targetTable = sortedTables[0][0];
      }
    }

    // Get primary key - enhanced detection
    let primaryKey = '';
    const commonPkNames = ['id', 'uuid', 'guid', `${sourceTable.toLowerCase()}_id`, 'pk', 'primary_key'];
    for (const pkName of commonPkNames) {
      if (mysqlCols[sourceTable]?.find(col => col.name === pkName)) {
        primaryKey = pkName;
        break;
      }
    }
    // Fallback to first column if no common PK found
    if (!primaryKey && mysqlCols[sourceTable]?.length) {
      primaryKey = mysqlCols[sourceTable][0].name;
    }

    mapping[sourceTable] = {
      target_table: targetTable || '',
      pk: primaryKey,
      column_mapping: {}
    };

    // Enhanced column mapping with type awareness
    const sourceCols = mysqlCols[sourceTable] || [];
    const targetCols = pgCols[targetTable] || [];

    for (const srcCol of sourceCols) {
      let bestCol = '';
      let bestScore = 0;

      for (const tgtCol of targetCols) {
        // Calculate similarity score (name + type compatibility)
        const nameSimilarity = stringSimilarity.compareTwoStrings(srcCol.name.toLowerCase(), tgtCol.name.toLowerCase());

        // Basic type compatibility check
        let typeCompatScore = 0;
        const srcType = srcCol.type.toLowerCase();
        const tgtType = tgtCol.type.toLowerCase();

        if (
          (srcType.includes('int') && tgtType.includes('int')) ||
          (srcType.includes('char') && tgtType.includes('text')) ||
          (srcType.includes('date') && tgtType.includes('timestamp'))
        ) {
          typeCompatScore = 1;
        } else if (srcType === tgtType) {
          typeCompatScore = 0.8;
        } else {
          typeCompatScore = 0.2;
        }

        const totalScore = nameSimilarity * 0.7 + typeCompatScore * 0.3;

        if (totalScore > bestScore) {
          bestScore = totalScore;
          bestCol = tgtCol.name;
        }
      }

      // Only map if we have a reasonable match
      if (bestScore > 0.3) { // Minimum threshold for column mapping
        mapping[sourceTable].column_mapping[srcCol.name] = bestCol;
      }
    }
  }

  // 6️⃣ Save mapping file
  fs.writeFileSync(outputFile, JSON.stringify(mapping, null, 2));
  console.log(`✅ AI-enhanced mapping saved to ${outputFile}`);
  console.log(`ℹ️ Found ${mysqlTables.length} MySQL tables → Suggested mapping for ${pgTableNames.length} Postgres tables`);
}
