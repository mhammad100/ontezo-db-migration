CREATE TABLE IF NOT EXISTS audit_logs (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    action VARCHAR NOT NULL,
    "timestamp" TIMESTAMP NOT NULL,
    team_member_id INTEGER NOT NULL,
    task_id INTEGER,
    project_id INTEGER
);
