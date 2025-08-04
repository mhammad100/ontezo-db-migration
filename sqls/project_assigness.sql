CREATE TABLE IF NOT EXISTS project_assignees (
    project_id INTEGER NOT NULL,
    team_member_id INTEGER NOT NULL,
    PRIMARY KEY (project_id, team_member_id)
);