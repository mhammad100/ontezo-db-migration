
CREATE TABLE IF NOT EXISTS checklist_items (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    description VARCHAR NOT NULL,
    is_checked BOOLEAN DEFAULT FALSE,
    checklist_id INTEGER
);
