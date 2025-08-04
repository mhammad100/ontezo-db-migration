CREATE TABLE IF NOT EXISTS team_members (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    joinin_date TIMESTAMP,
    monthly_salary INTEGER,
    department VARCHAR,
    designation VARCHAR,
    skills JSON,
    experience VARCHAR,
    user_id INTEGER UNIQUE,
    created_by_id INTEGER
);


SET session_replication_role = replica;