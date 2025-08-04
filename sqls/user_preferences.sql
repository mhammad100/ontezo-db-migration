
CREATE TABLE IF NOT EXISTS user_preferences (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    category user_preferences_category_enum NOT NULL,
    value TEXT,
    user_id INTEGER NOT NULL,
    "userId" INTEGER
);
