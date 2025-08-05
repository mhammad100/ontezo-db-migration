import knex from 'knex';

export function connectMySQL(conn) {
  return knex({ client: 'mysql2', connection: conn });
}
