export function buildMigrationOrder(tables, foreignKeys) {
  const graph = {};
  tables.forEach(t => (graph[t] = []));
  foreignKeys.forEach(fk => graph[fk.referencedTable].push(fk.tableName));

  const visited = new Set();
  const result = [];

  function visit(node) {
    if (visited.has(node)) return;
    visited.add(node);
    (graph[node] || []).forEach(child => visit(child));
    result.push(node);
  }

  tables.forEach(t => visit(t));

  return result.reverse(); // parent first
}
