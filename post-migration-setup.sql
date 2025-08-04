-- Post-Migration Setup Script
-- This script should be run after the main migration to set up relationships and additional data

-- 1. Set up user-role relationships (many-to-many)
-- Map old employee-role relationships to new user-role relationships
INSERT INTO user_roles ("usersId", "rolesId")
SELECT 
    e.id as "usersId",
    e.role_id as "rolesId"
FROM users u
JOIN employees e ON u.email = e.email
WHERE e.role_id IS NOT NULL;

-- 2. Set up team_members table from employees
INSERT INTO team_members (
    user_id,
    joinin_date,
    monthly_salary,
    department,
    designation,
    skills,
    experience,
    created_by_id
)
SELECT 
    u.id as user_id,
    e.joining_date as joinin_date,
    e.monthly_salary as monthly_salary,
    e.department as department,
    e.designation as designation,
    e.skills as skills,
    e.experience as experience,
    1 as created_by_id  -- Default to first user as creator
FROM users u
JOIN employees e ON u.email = e.email
WHERE e.id IS NOT NULL;

-- 3. Set up project assignees from old ProjectEmployees table
INSERT INTO project_assignees (project_id, team_member_id)
SELECT 
    pe.project_id as project_id,
    tm.id as team_member_id
FROM project_employees pe
JOIN team_members tm ON tm.user_id = pe.user_id
WHERE pe.project_id IS NOT NULL;

-- 4. Set up task assignees from old Tasks.assigned_to field
INSERT INTO task_assignees (task_id, team_member_id)
SELECT 
    t.id as task_id,
    tm.id as team_member_id
FROM tasks t
JOIN team_members tm ON tm.user_id = t.assigned_to
WHERE t.assigned_to IS NOT NULL;

-- 5. Update comment entity references
-- Map comments to proper project_id or task_id based on entityType
UPDATE comments 
SET project_id = CASE 
    WHEN tag = 'project' THEN entity_id::integer 
    ELSE NULL 
END,
task_id = CASE 
    WHEN tag = 'task' THEN entity_id::integer 
    ELSE NULL 
END
WHERE entity_id IS NOT NULL;

-- 6. Set up default tenant if not exists
INSERT INTO tenants (id, name, subdomain, email)
VALUES (1, 'Default Tenant', 'default', 'admin@example.com')
ON CONFLICT (id) DO NOTHING;

-- 7. Create default roles if they don't exist
INSERT INTO roles (name, label, description, role_type, feature, tenant_id)
VALUES 
    ('SUPER_ADMIN', 'Super Admin', 'Has all permissions', 'SUPER_ADMIN', 'General', 1),
    ('ADMIN', 'Admin', 'Has administrative permissions', 'ADMIN', 'General', 1),
    ('USER', 'User', 'Standard user permissions', 'USER', 'General', 1)
ON CONFLICT (name, tenant_id) DO NOTHING;

-- 8. Create basic permissions if they don't exist
INSERT INTO permissions (name, permission_type, feature)
VALUES 
    ('READ_USER', 'READ', 'General'),
    ('WRITE_USER', 'WRITE', 'General'),
    ('DELETE_USER', 'DELETE', 'General'),
    ('READ_PROJECT', 'READ', 'Project Management'),
    ('WRITE_PROJECT', 'WRITE', 'Project Management'),
    ('DELETE_PROJECT', 'DELETE', 'Project Management'),
    ('READ_TASK', 'READ', 'Project Management'),
    ('WRITE_TASK', 'WRITE', 'Project Management'),
    ('DELETE_TASK', 'DELETE', 'Project Management'),
    ('READ_CLIENT', 'READ', 'CRM'),
    ('WRITE_CLIENT', 'WRITE', 'CRM'),
    ('DELETE_CLIENT', 'DELETE', 'CRM'),
    ('READ_SPRINT', 'READ', 'Project Management'),
    ('WRITE_SPRINT', 'WRITE', 'Project Management'),
    ('DELETE_SPRINT', 'DELETE', 'Project Management')
ON CONFLICT (name) DO NOTHING;

-- 9. Assign permissions to roles
-- Super Admin gets all permissions
INSERT INTO role_permissions (role_id, permission_id, is_global)
SELECT r.id, p.id, true
FROM roles r, permissions p
WHERE r.name = 'SUPER_ADMIN'
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- Admin gets most permissions
INSERT INTO role_permissions (role_id, permission_id, is_global)
SELECT r.id, p.id, true
FROM roles r, permissions p
WHERE r.name = 'ADMIN' 
AND p.name NOT LIKE 'DELETE_%'
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- User gets read permissions
INSERT INTO role_permissions (role_id, permission_id, is_global)
SELECT r.id, p.id, true
FROM roles r, permissions p
WHERE r.name = 'USER' 
AND p.name LIKE 'READ_%'
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- 10. Update user profiles for users without profiles
INSERT INTO user_profiles (user_id, full_name, phone, address, city, country, is_profile_complete)
SELECT 
    u.id as user_id,
    e.full_name as full_name,
    e.phone as phone,
    e.address as address,
    e.city as city,
    e.country as country,
    e.is_profile_completed as is_profile_complete
FROM users u
JOIN employees e ON u.email = e.email
WHERE NOT EXISTS (
    SELECT 1 FROM user_profiles up WHERE up.user_id = u.id
);

-- 11. Set up project statuses
INSERT INTO project_statuses (display_name, name, "order", project_id)
SELECT 
    'Active' as display_name,
    'active' as name,
    1 as "order",
    p.id as project_id
FROM projects p
WHERE p.status = 'active'
ON CONFLICT DO NOTHING;

-- 12. Set up sprint statuses
INSERT INTO sprint_statuses (display_name, name, "order", sprint_id)
SELECT 
    'Active' as display_name,
    'active' as name,
    1 as "order",
    s.id as sprint_id
FROM sprints s
WHERE s.status = 'active'
ON CONFLICT DO NOTHING;

-- 13. Update task statuses to match new schema
UPDATE tasks 
SET status = CASE 
    WHEN status = 'pending' THEN 'pending'
    WHEN status = 'in_progress' THEN 'in-progress'
    WHEN status = 'completed' THEN 'completed'
    ELSE 'pending'
END;

-- 14. Set up media records for existing media
INSERT INTO media_records (media_id, user_id, project_id, task_id)
SELECT 
    m.id as media_id,
    u.id as user_id,
    NULL as project_id,
    NULL as task_id
FROM media m
JOIN users u ON u.id = m.created_by_id
WHERE m.created_by_id IS NOT NULL;

-- 15. Set up client-project relationships
UPDATE projects 
SET "clientId" = c.id
FROM clients c
WHERE projects.client_name = c.name;

-- 16. Set up test cases for tasks
INSERT INTO test_cases (title, description, "isChecked", task_id)
SELECT 
    tc.name as title,
    tc.description as description,
    tc.is_completed as "isChecked",
    tc.task_id as task_id
FROM test_cases tc
WHERE tc.task_id IS NOT NULL;

-- 17. Set up use cases for tasks (if they exist)
INSERT INTO use_cases (title, description, "isChecked", task_id)
SELECT 
    uc.name as title,
    uc.description as description,
    uc.is_completed as "isChecked",
    uc.task_id as task_id
FROM use_cases uc
WHERE uc.task_id IS NOT NULL;

-- 18. Set up audit logs for projects and tasks
INSERT INTO audit_logs (action, "timestamp", team_member_id, project_id, task_id)
SELECT 
    'created' as action,
    p.created_at as "timestamp",
    tm.id as team_member_id,
    p.id as project_id,
    NULL as task_id
FROM projects p
JOIN team_members tm ON tm.user_id = p.created_by_id
WHERE p.created_by_id IS NOT NULL;

INSERT INTO audit_logs (action, "timestamp", team_member_id, project_id, task_id)
SELECT 
    'created' as action,
    t.created_at as "timestamp",
    tm.id as team_member_id,
    t.project_id as project_id,
    t.id as task_id
FROM tasks t
JOIN team_members tm ON tm.user_id = t.created_by_id
WHERE t.created_by_id IS NOT NULL;

-- 19. Set up user preferences for existing users
INSERT INTO user_preferences (category, value, user_id)
SELECT 
    'usage' as category,
    '{"theme": "light", "language": "en"}' as value,
    u.id as user_id
FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM user_preferences up WHERE up.user_id = u.id
);

-- 20. Set up user links (GitHub links) for tasks
INSERT INTO user_links (url, description, type, platform, task_id, team_member_id)
SELECT 
    jq.github_link as url,
    jq.comment as description,
    'repository' as type,
    'github' as platform,
    jq.task_id as task_id,
    tm.id as team_member_id
FROM job_queues jq
JOIN team_members tm ON tm.user_id = jq.assigned_to
WHERE jq.github_link IS NOT NULL AND jq.github_link != '';

-- 21. Set up phases for projects
INSERT INTO phases (title, name, status, project_id)
SELECT 
    'Phase 1' as title,
    'Planning' as name,
    'in-progress' as status,
    p.id as project_id
FROM projects p
WHERE NOT EXISTS (
    SELECT 1 FROM phases ph WHERE ph.project_id = p.id
);

-- 22. Set up checklists for phases
INSERT INTO checklists (name, status, phase_id)
SELECT 
    'Project Checklist' as name,
    'active' as status,
    ph.id as phase_id
FROM phases ph
WHERE NOT EXISTS (
    SELECT 1 FROM checklists cl WHERE cl.phase_id = ph.id
);

-- 23. Set up checklist items
INSERT INTO checklist_items (description, is_checked, checklist_id)
SELECT 
    'Review project requirements' as description,
    false as is_checked,
    cl.id as checklist_id
FROM checklists cl
WHERE NOT EXISTS (
    SELECT 1 FROM checklist_items ci WHERE ci.checklist_id = cl.id
);

-- 24. Set up subscriptions (if you have subscription data)
-- This would need to be customized based on your subscription model
-- INSERT INTO subscriptions (...) VALUES (...);

-- 25. Set up plans (if you have plan data)
-- This would need to be customized based on your pricing model
-- INSERT INTO plans (...) VALUES (...);

-- 26. Set up webhook events (if you have webhook data)
-- This would need to be customized based on your webhook requirements
-- INSERT INTO webhook_events (...) VALUES (...);

-- 27. Set up user auth providers (if you have OAuth data)
-- This would need to be customized based on your authentication providers
-- INSERT INTO user_auth_providers (...) VALUES (...);

-- 28. Set up invites (if you have invitation data)
-- This would need to be customized based on your invitation system
-- INSERT INTO invites (...) VALUES (...);

-- 29. Set up menu items (if you have menu data)
-- This would need to be customized based on your menu structure
-- INSERT INTO menu (...) VALUES (...);

-- 30. Final cleanup - remove any orphaned records
DELETE FROM user_roles WHERE "usersId" NOT IN (SELECT id FROM users);
DELETE FROM role_permissions WHERE role_id NOT IN (SELECT id FROM roles);
DELETE FROM role_permissions WHERE permission_id NOT IN (SELECT id FROM permissions);
DELETE FROM media_records WHERE media_id NOT IN (SELECT id FROM media);
DELETE FROM media_records WHERE user_id NOT IN (SELECT id FROM users);
DELETE FROM task_assignees WHERE task_id NOT IN (SELECT id FROM tasks);
DELETE FROM task_assignees WHERE team_member_id NOT IN (SELECT id FROM team_members);
DELETE FROM project_assignees WHERE project_id NOT IN (SELECT id FROM projects);
DELETE FROM project_assignees WHERE team_member_id NOT IN (SELECT id FROM team_members);

-- 31. Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_team_members_user_id ON team_members(user_id);
CREATE INDEX IF NOT EXISTS idx_project_assignees_project_id ON project_assignees(project_id);
CREATE INDEX IF NOT EXISTS idx_task_assignees_task_id ON task_assignees(task_id);
CREATE INDEX IF NOT EXISTS idx_comments_project_id ON comments(project_id);
CREATE INDEX IF NOT EXISTS idx_comments_task_id ON comments(task_id);
CREATE INDEX IF NOT EXISTS idx_media_records_media_id ON media_records(media_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_project_id ON audit_logs(project_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_task_id ON audit_logs(task_id);

-- 32. Update sequence values to prevent conflicts
SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));
SELECT setval('roles_id_seq', (SELECT MAX(id) FROM roles));
SELECT setval('permissions_id_seq', (SELECT MAX(id) FROM permissions));
SELECT setval('projects_id_seq', (SELECT MAX(id) FROM projects));
SELECT setval('tasks_id_seq', (SELECT MAX(id) FROM tasks));
SELECT setval('sprints_id_seq', (SELECT MAX(id) FROM sprints));
SELECT setval('clients_id_seq', (SELECT MAX(id) FROM clients));
SELECT setval('media_id_seq', (SELECT MAX(id) FROM media));
SELECT setval('team_members_id_seq', (SELECT MAX(id) FROM team_members));

-- Migration completed successfully!
SELECT 'Post-migration setup completed successfully!' as status; 