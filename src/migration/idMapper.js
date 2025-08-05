export const idMap = {};

export function mapId(table, oldId, newId) {
  if (!idMap[table]) idMap[table] = {};
  idMap[table][oldId] = newId;
}

export function getMappedId(table, oldId) {
  return idMap[table]?.[oldId] || null;
}
