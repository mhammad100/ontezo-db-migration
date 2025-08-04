-- Database Migration SQL
-- Generated from old MySQL to new PostgreSQL
-- Generated on: 2025-08-04T08:28:43.836Z



-- Create indexes
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_team_members_user_id ON team_members(user_id);
CREATE INDEX IF NOT EXISTS idx_project_assignees_project_id ON project_assignees(project_id);
CREATE INDEX IF NOT EXISTS idx_task_assignees_task_id ON task_assignees(task_id);
CREATE INDEX IF NOT EXISTS idx_comments_project_id ON comments(project_id);
CREATE INDEX IF NOT EXISTS idx_comments_task_id ON comments(task_id);
CREATE INDEX IF NOT EXISTS idx_media_records_media_id ON media_records(media_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_project_id ON audit_logs(project_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_task_id ON audit_logs(task_id);

-- Temporarily disable foreign key checks
SET session_replication_role = replica;

-- Re-enable foreign key checks
SET session_replication_role = DEFAULT;
