CREATE TABLE IF NOT EXISTS phases (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    title VARCHAR NOT NULL,
    name VARCHAR NOT NULL,
    status VARCHAR DEFAULT 'in-progress',
    project_id INTEGER
);