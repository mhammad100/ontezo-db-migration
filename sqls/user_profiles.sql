CREATE TABLE IF NOT EXISTS user_profiles (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    full_name VARCHAR,
    phone VARCHAR,
    date_of_birth DATE,
    address VARCHAR,
    city VARCHAR,
    state VARCHAR,
    postal_code VARCHAR,
    country VARCHAR,
    profile_picture VARCHAR,
    is_profile_complete BOOLEAN DEFAULT FALSE,
    user_id INTEGER UNIQUE NOT NULL
);

SET session_replication_role = replica;