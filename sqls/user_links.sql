CREATE TABLE IF NOT EXISTS user_links (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    url VARCHAR NOT NULL,
    description VARCHAR,
    type VARCHAR,
    platform user_links_platform_enum DEFAULT 'github',
    task_id INTEGER NOT NULL,
    team_member_id INTEGER NOT NULL
);
