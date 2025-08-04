
CREATE TABLE IF NOT EXISTS task_assignees (
    task_id INTEGER NOT NULL,
    team_member_id INTEGER NOT NULL,
    PRIMARY KEY (task_id, team_member_id)
);