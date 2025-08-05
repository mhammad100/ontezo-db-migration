import { getMappedId } from './idMapper.js';

export function transformRow(row, mapping, fkMap = {}) {
  const transformed = {};
  for (const [srcCol, destCol] of Object.entries(mapping.column_mapping)) {
    let value = row[srcCol];

    // Boolean conversion
    if (typeof value === 'number' && (value === 0 || value === 1)) {
      value = !!value;
    }

    // FK Remapping if needed
    if (fkMap[srcCol]) {
      value = getMappedId(fkMap[srcCol], value);
    }

    transformed[destCol] = value;
  }
  return transformed;
}
