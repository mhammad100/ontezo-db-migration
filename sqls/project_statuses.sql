CREATE TABLE IF NOT EXISTS project_statuses (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    display_name VARCHAR NOT NULL,
    name VARCHAR NOT NULL,
    "order" INTEGER NOT NULL,
    project_id INTEGER NOT NULL
);

SET session_replication_role = replica;

