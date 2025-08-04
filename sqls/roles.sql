CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    name VARCHAR UNIQUE NOT NULL,
    label VARCHAR,
    description VARCHAR,
    role_type VARCHAR,
    feature VARCHAR,
    tenant_id INTEGER NOT NULL,
    UNIQUE(tenant_id, name)
);

SET session_replication_role = replica;


-- Migrating Roles to roles
INSERT INTO roles (id, name, description, created_at, updated_at, tenant_id, label, role_type, feature) VALUES
('1', 'Employee', 'Employee can add task and access Public projects boards, docs, dashboards.', '2024-07-05 06:07:22', '2024-07-05 11:38:47', 1, 'name', 'CUSTOM_ROLE', 'General'),
('3', 'Business Analyst', 'Business Analyst can create and manage leads and projects.', '2024-07-05 06:07:22', '2025-03-07 06:33:22', 1, 'name', 'CUSTOM_ROLE', 'General'),
('4', 'HR Manager', 'HR Manager', '2024-07-05 06:08:08', '2024-07-05 06:08:08', 1, 'name', 'CUSTOM_ROLE', 'General'),
('5', 'Technical Project Manager', 'Technical Project Manager', '2024-07-05 06:13:49', '2025-06-23 12:20:09', 1, 'name', 'CUSTOM_ROLE', 'General'),
('6', 'Sub_Admin', 'Sub_Admin', '2024-07-05 12:21:55', '2024-12-17 12:56:14', 1, 'name', 'CUSTOM_ROLE', 'General'),
('7', 'QA', 'Quality Assurance', '2024-08-05 07:12:41', '2024-11-18 12:36:01', 1, 'name', 'CUSTOM_ROLE', 'General'),
('9', 'APM', 'Associate Project Manager', '2024-10-29 08:02:21', '2024-10-29 11:14:58', 1, 'name', 'CUSTOM_ROLE', 'General'),
('10', 'BDE', 'Bidding and Lead Generation', '2024-11-19 13:29:30', '2025-05-26 10:19:21', 1, 'name', 'CUSTOM_ROLE', 'General'),
('11', 'client', 'can manage board', '2024-11-28 10:07:38', '2024-11-28 10:10:50', 1, 'name', 'CUSTOM_ROLE', 'General'),
('12', 'BDM', '', '2025-07-17 10:43:24', '2025-07-17 10:43:24', 1, 'name', 'CUSTOM_ROLE', 'General');