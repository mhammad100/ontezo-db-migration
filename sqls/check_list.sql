CREATE TABLE IF NOT EXISTS checklists (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    name VARCHAR NOT NULL,
    status VARCHAR DEFAULT 'active',
    phase_id INTEGER
);