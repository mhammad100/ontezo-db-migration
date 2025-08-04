CREATE TABLE IF NOT EXISTS permissions (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    name VARCHAR UNIQUE NOT NULL,
    permission_type VARCHAR,
    feature VARCHAR
);

SET session_replication_role = replica;


INSERT INTO permissions (name, permission_type, feature)
VALUES
  -- Team Management
  ('CREATE_TEAM', 'CRUD', 'Team Management'),
  ('READ_TEAM', 'READ', 'Team Management'),
  ('UPDATE_TEAM', 'CRUD', 'Team Management'),
  ('DELETE_TEAM', 'CRUD', 'Team Management'),

  -- User Management
  ('CREATE_USER', 'CRUD', 'User Management'),
  ('READ_USER', 'READ', 'User Management'),
  ('UPDATE_USER', 'CRUD', 'User Management'),
  ('DELETE_USER', 'CRUD', 'User Management'),

  -- Role Management
  ('CREATE_ROLE', 'CRUD', 'Role Management'),
  ('READ_ROLE', 'READ', 'Role Management'),
  ('UPDATE_ROLE', 'CRUD', 'Role Management'),
  ('DELETE_ROLE', 'CRUD', 'Role Management'),

  -- Project Management
  ('CREATE_PROJECT', 'CRUD', 'Project Management'),
  ('READ_PROJECT', 'READ', 'Project Management'),
  ('UPDATE_PROJECT', 'CRUD', 'Project Management'),
  ('DELETE_PROJECT', 'CRUD', 'Project Management'),

  -- Sprint Management
  ('CREATE_SPRINT', 'CRUD', 'Sprint Management'),
  ('READ_SPRINT', 'READ', 'Sprint Management'),
  ('UPDATE_SPRINT', 'CRUD', 'Sprint Management'),
  ('DELETE_SPRINT', 'CRUD', 'Sprint Management'),

  -- Task Management
  ('CREATE_TASK', 'CRUD', 'Task Management'),
  ('READ_TASK', 'READ', 'Task Management'),
  ('UPDATE_TASK', 'CRUD', 'Task Management'),
  ('DELETE_TASK', 'CRUD', 'Task Management'),

  -- Tenant Management
  ('CREATE_TENANT', 'CRUD', 'Tenant Management'),
  ('READ_TENANT', 'READ', 'Tenant Management'),
  ('UPDATE_TENANT', 'CRUD', 'Tenant Management'),
  ('DELETE_TENANT', 'CRUD', 'Tenant Management');
