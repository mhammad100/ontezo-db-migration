import knex from 'knex';

export function connectPostgres(conn) {
  return knex({ client: 'pg', connection: conn });
}
