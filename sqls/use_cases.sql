CREATE TABLE IF NOT EXISTS use_cases (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    title VARCHAR NOT NULL,
    description VARCHAR,
    "isChecked" BOOLEAN DEFAULT FALSE,
    task_id INTEGER NOT NULL
);

SET session_replication_role = replica;

