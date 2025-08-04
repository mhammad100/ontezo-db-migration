CREATE TABLE IF NOT EXISTS tenants (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    name VARCHAR UNIQUE NOT NULL,
    subdomain VARCHAR UNIQUE NOT NULL,
    email VARCHAR,
    database_name VARCHAR,
    database_host VARCHAR,
    database_user VARCHAR,
    database_pwd VARCHAR,
    "ownerId" INTEGER
);

-- Temporarily disable foreign key checks
SET session_replication_role = replica;