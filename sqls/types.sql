-- Create ENUM types
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'comments_tag_enum') THEN
        CREATE TYPE comments_tag_enum AS ENUM ('project', 'task');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'media_tag_enum') THEN
        CREATE TYPE media_tag_enum AS ENUM ('comment', 'user', 'project', 'task');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'media_type_enum') THEN
        CREATE TYPE media_type_enum AS ENUM ('image', 'video', 'document', 'other');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'project_duration_enum') THEN
        CREATE TYPE project_duration_enum AS ENUM ('short-term', 'mid-term', 'long-term', 'on-going');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'sprints_status_enum') THEN
        CREATE TYPE sprints_status_enum AS ENUM ('UPCOMING', 'PLANNED', 'ACTIVE', 'COMPLETED', 'CANCELLED');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'user_links_platform_enum') THEN
        CREATE TYPE user_links_platform_enum AS ENUM ('github', 'gitlab');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'user_preferences_category_enum') THEN
        CREATE TYPE user_preferences_category_enum AS ENUM ('usage', 'management', 'features');
    END IF;
END$$;