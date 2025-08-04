const fs = require('fs');
const path = require('path');
const DataParser = require('./data-parser');

class DatabaseMigration {
    constructor() {
        this.oldStructure = {};
        this.newStructure = {};
        this.oldData = {};
        this.mappingRules = {};
        this.generatedSQL = [];
        this.dataParser = new DataParser();
    }

    // Parse old database structure
    parseOldStructure(filePath) {
        console.log('Parsing old database structure...');
        const content = fs.readFileSync(filePath, 'utf8');
        
        // Extract table definitions
        const tableMatches = content.match(/CREATE TABLE `([^`]+)`\s*\(([\s\S]*?)\) ENGINE=/g);
        
        tableMatches.forEach(match => {
            const tableName = match.match(/CREATE TABLE `([^`]+)`/)[1];
            const tableDefinition = match.match(/CREATE TABLE `[^`]+`\s*\(([\s\S]*?)\) ENGINE=/)[1];
            
            this.oldStructure[tableName] = this.parseTableDefinition(tableDefinition);
        });
        
        console.log(`Parsed ${Object.keys(this.oldStructure).length} tables from old structure`);
    }

    // Parse new database structure
    parseNewStructure(filePath) {
        console.log('Parsing new database structure...');
        const content = fs.readFileSync(filePath, 'utf8');
        
        // Extract table definitions
        const tableMatches = content.match(/CREATE TABLE public\.([^\s]+)\s*\(([\s\S]*?)\);/g);
        
        tableMatches.forEach(match => {
            const tableName = match.match(/CREATE TABLE public\.([^\s]+)/)[1];
            const tableDefinition = match.match(/CREATE TABLE public\.[^\s]+\s*\(([\s\S]*?)\);/)[1];
            
            this.newStructure[tableName] = this.parseTableDefinition(tableDefinition);
        });
        
        console.log(`Parsed ${Object.keys(this.newStructure).length} tables from new structure`);
    }

    // Parse table definition
    parseTableDefinition(definition) {
        const columns = {};
        const lines = definition.split('\n');
        
        lines.forEach(line => {
            line = line.trim();
            if (line && !line.startsWith('--') && !line.startsWith('PRIMARY KEY') && !line.startsWith('KEY') && !line.startsWith('CONSTRAINT')) {
                const columnMatch = line.match(/^`?([^`\s]+)`?\s+([^,\s]+)/);
                if (columnMatch) {
                    const columnName = columnMatch[1];
                    const columnType = columnMatch[2];
                    columns[columnName] = columnType;
                }
            }
        });
        
        return columns;
    }

    // Generate table creation SQL based on entities
    generateTableCreationSQL() {
        console.log('Generating table creation SQL...');
        
        this.generatedSQL.push('-- Database Migration SQL');
        this.generatedSQL.push('-- Generated from old MySQL to new PostgreSQL');
        this.generatedSQL.push('-- Generated on: ' + new Date().toISOString());
        this.generatedSQL.push('');
        
        // Create ENUM types first
        this.generatedSQL.push('-- Create ENUM types');
        this.generatedSQL.push("CREATE TYPE IF NOT EXISTS comments_tag_enum AS ENUM ('project', 'task');");
        this.generatedSQL.push("CREATE TYPE IF NOT EXISTS media_tag_enum AS ENUM ('comment', 'user', 'project', 'task');");
        this.generatedSQL.push("CREATE TYPE IF NOT EXISTS media_type_enum AS ENUM ('image', 'video', 'document', 'other');");
        this.generatedSQL.push("CREATE TYPE IF NOT EXISTS project_duration_enum AS ENUM ('short-term', 'mid-term', 'long-term', 'on-going');");
        this.generatedSQL.push("CREATE TYPE IF NOT EXISTS sprints_status_enum AS ENUM ('UPCOMING', 'PLANNED', 'ACTIVE', 'COMPLETED', 'CANCELLED');");
        this.generatedSQL.push("CREATE TYPE IF NOT EXISTS user_links_platform_enum AS ENUM ('github', 'gitlab');");
        this.generatedSQL.push("CREATE TYPE IF NOT EXISTS user_preferences_category_enum AS ENUM ('usage', 'management', 'features');");
        this.generatedSQL.push('');
        
        // Create tables
        this.generatedSQL.push('-- Create tables');
        
        // Base table (for inheritance)
        this.generatedSQL.push(`
-- Base table for common fields
CREATE TABLE IF NOT EXISTS base_entity (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL
);`);
        
        // Tenants table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS tenants (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    name VARCHAR UNIQUE NOT NULL,
    subdomain VARCHAR UNIQUE NOT NULL,
    email VARCHAR,
    database_name VARCHAR,
    database_host VARCHAR,
    database_user VARCHAR,
    database_pwd VARCHAR,
    "ownerId" INTEGER
);`);
        
        // Users table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    email VARCHAR UNIQUE NOT NULL,
    password VARCHAR NOT NULL,
    otp_code VARCHAR,
    is_email_verified BOOLEAN DEFAULT FALSE,
    is_password_forget BOOLEAN DEFAULT FALSE,
    otp_expiry TIMESTAMP,
    tenant_id INTEGER,
    timezone VARCHAR,
    last_login TIMESTAMPTZ,
    is_agree_terms BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    is_deleted BOOLEAN DEFAULT FALSE
);`);
        
        // User profiles table
        this.generatedSQL.push(`
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
);`);
        
        // Roles table
        this.generatedSQL.push(`
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
);`);
        
        // Permissions table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS permissions (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    name VARCHAR UNIQUE NOT NULL,
    permission_type VARCHAR,
    feature VARCHAR
);`);
        
        // Role permissions table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS role_permissions (
    id SERIAL PRIMARY KEY,
    role_id INTEGER NOT NULL,
    permission_id INTEGER NOT NULL,
    is_global BOOLEAN DEFAULT FALSE,
    UNIQUE(role_id, permission_id)
);`);
        
        // User roles table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS user_roles (
    "usersId" INTEGER NOT NULL,
    "rolesId" INTEGER NOT NULL,
    PRIMARY KEY ("usersId", "rolesId")
);`);
        
        // Team members table
        this.generatedSQL.push(`
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
);`);
        
        // Clients table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS clients (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    name VARCHAR NOT NULL,
    designation VARCHAR,
    phone VARCHAR,
    email VARCHAR,
    company_name VARCHAR,
    company_phone VARCHAR,
    company_email VARCHAR,
    created_by_id INTEGER
);`);
        
        // Projects table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS projects (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    name VARCHAR NOT NULL,
    slug VARCHAR UNIQUE NOT NULL,
    description VARCHAR,
    status VARCHAR DEFAULT 'active',
    is_sprint_project BOOLEAN DEFAULT FALSE,
    "clientId" INTEGER,
    start_date DATE DEFAULT '2025-07-28',
    end_date DATE,
    created_by_id INTEGER,
    project_duration project_duration_enum,
    documents JSON
);`);
        
        // Project statuses table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS project_statuses (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    display_name VARCHAR NOT NULL,
    name VARCHAR NOT NULL,
    "order" INTEGER NOT NULL,
    project_id INTEGER NOT NULL
);`);
        
        // Tasks table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    title VARCHAR NOT NULL,
    slug VARCHAR UNIQUE NOT NULL,
    description VARCHAR,
    status VARCHAR DEFAULT 'pending',
    start_date DATE DEFAULT '2025-07-28' NOT NULL,
    due_date DATE,
    priority VARCHAR DEFAULT 'low',
    tags JSON,
    project_id INTEGER NOT NULL,
    sprint_id INTEGER,
    parent_task_id INTEGER,
    created_by_id INTEGER,
    story_point NUMERIC(4,1) DEFAULT 0.0 NOT NULL,
    sprint_status_id INTEGER,
    project_status_id INTEGER
);`);
        
        // Sprints table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS sprints (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    name VARCHAR NOT NULL,
    description VARCHAR,
    status sprints_status_enum DEFAULT 'PLANNED',
    project_id INTEGER NOT NULL,
    start_date DATE,
    end_date DATE,
    duration VARCHAR,
    old_id VARCHAR
);`);
        
        // Sprint statuses table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS sprint_statuses (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    display_name VARCHAR NOT NULL,
    name VARCHAR NOT NULL,
    "order" INTEGER NOT NULL,
    sprint_id INTEGER NOT NULL
);`);
        
        // Comments table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS comments (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    content VARCHAR NOT NULL,
    parent_comment_id INTEGER,
    team_member_id INTEGER NOT NULL,
    project_id INTEGER,
    task_id INTEGER,
    tag comments_tag_enum DEFAULT 'project',
    is_edited BOOLEAN DEFAULT FALSE,
    attachment JSON
);`);
        
        // Time logs table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS time_logs (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    hours DOUBLE PRECISION,
    description VARCHAR,
    task_id INTEGER NOT NULL,
    team_member_id INTEGER NOT NULL
);`);
        
        // Media table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS media (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    file_name VARCHAR,
    original_name VARCHAR,
    mime_type VARCHAR,
    size INTEGER,
    url VARCHAR,
    type media_type_enum DEFAULT 'other',
    tag media_tag_enum DEFAULT 'user',
    description VARCHAR,
    bucket VARCHAR NOT NULL,
    "key" VARCHAR NOT NULL,
    thumbnail VARCHAR,
    created_by_id INTEGER
);`);
        
        // Media records table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS media_records (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    media_id INTEGER NOT NULL,
    user_id INTEGER,
    project_id INTEGER,
    task_id INTEGER,
    comment_id INTEGER
);`);
        
        // Test cases table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS test_cases (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    title VARCHAR NOT NULL,
    description VARCHAR,
    "isChecked" BOOLEAN DEFAULT FALSE,
    steps VARCHAR,
    expected_result VARCHAR,
    actual_result VARCHAR,
    task_id INTEGER NOT NULL
);`);
        
        // Use cases table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS use_cases (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    title VARCHAR NOT NULL,
    description VARCHAR,
    "isChecked" BOOLEAN DEFAULT FALSE,
    task_id INTEGER NOT NULL
);`);
        
        // User preferences table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS user_preferences (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    category user_preferences_category_enum NOT NULL,
    value TEXT,
    user_id INTEGER NOT NULL,
    "userId" INTEGER
);`);
        
        // User links table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS user_links (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    url VARCHAR NOT NULL,
    description VARCHAR,
    type VARCHAR,
    platform user_links_platform_enum DEFAULT 'github',
    task_id INTEGER NOT NULL,
    team_member_id INTEGER NOT NULL
);`);
        
        // Phases table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS phases (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    title VARCHAR NOT NULL,
    name VARCHAR NOT NULL,
    status VARCHAR DEFAULT 'in-progress',
    project_id INTEGER
);`);
        
        // Checklists table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS checklists (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    name VARCHAR NOT NULL,
    status VARCHAR DEFAULT 'active',
    phase_id INTEGER
);`);
        
        // Checklist items table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS checklist_items (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    description VARCHAR NOT NULL,
    is_checked BOOLEAN DEFAULT FALSE,
    checklist_id INTEGER
);`);
        
        // Project assignees table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS project_assignees (
    project_id INTEGER NOT NULL,
    team_member_id INTEGER NOT NULL,
    PRIMARY KEY (project_id, team_member_id)
);`);
        
        // Task assignees table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS task_assignees (
    task_id INTEGER NOT NULL,
    team_member_id INTEGER NOT NULL,
    PRIMARY KEY (task_id, team_member_id)
);`);
        
        // Audit logs table
        this.generatedSQL.push(`
CREATE TABLE IF NOT EXISTS audit_logs (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    action VARCHAR NOT NULL,
    "timestamp" TIMESTAMP NOT NULL,
    team_member_id INTEGER NOT NULL,
    task_id INTEGER,
    project_id INTEGER
);`);
        
        this.generatedSQL.push('');
        
        // Add indexes
        this.generatedSQL.push('-- Create indexes');
        this.generatedSQL.push('CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);');
        this.generatedSQL.push('CREATE INDEX IF NOT EXISTS idx_team_members_user_id ON team_members(user_id);');
        this.generatedSQL.push('CREATE INDEX IF NOT EXISTS idx_project_assignees_project_id ON project_assignees(project_id);');
        this.generatedSQL.push('CREATE INDEX IF NOT EXISTS idx_task_assignees_task_id ON task_assignees(task_id);');
        this.generatedSQL.push('CREATE INDEX IF NOT EXISTS idx_comments_project_id ON comments(project_id);');
        this.generatedSQL.push('CREATE INDEX IF NOT EXISTS idx_comments_task_id ON comments(task_id);');
        this.generatedSQL.push('CREATE INDEX IF NOT EXISTS idx_media_records_media_id ON media_records(media_id);');
        this.generatedSQL.push('CREATE INDEX IF NOT EXISTS idx_audit_logs_project_id ON audit_logs(project_id);');
        this.generatedSQL.push('CREATE INDEX IF NOT EXISTS idx_audit_logs_task_id ON audit_logs(task_id);');
        this.generatedSQL.push('');
    }

    // Define mapping rules between old and new schemas
    defineMappingRules() {
        console.log('Defining mapping rules...');
        
        // Core entity mappings
        this.mappingRules = {
            // Users/Employees mapping
            'Employees': {
                targetTable: 'users',
                fieldMappings: {
                    'id': 'id',
                    'email': 'email',
                    'is_active': 'is_active',
                    'createdAt': 'created_at',
                    'updatedAt': 'updated_at'
                },
                additionalTables: {
                    'user_profiles': {
                        'full_name': 'full_name',
                        'phone': 'phone',
                        'address': 'address',
                        'city': 'city',
                        'country': 'country',
                        'is_profile_completed': 'is_profile_complete'
                    }
                },
                // Add email verification fields
                computedFields: {
                    'is_email_verified': 'true', // Set all existing users as verified
                    'otp_code': 'NULL',
                    'is_password_forget': 'false',
                    'is_agree_terms': 'true',
                    'is_deleted': 'false',
                    'password': '\'default_password_hash\'', // You'll need to update this
                    'tenant_id': '1' // Default tenant
                }
            },
            
            // Roles mapping
            'Roles': {
                targetTable: 'roles',
                fieldMappings: {
                    'id': 'id',
                    'name': 'name',
                    'description': 'description',
                    'is_active': 'is_active',
                    'createdAt': 'created_at',
                    'updatedAt': 'updated_at'
                },
                computedFields: {
                    'tenant_id': '1', // Default tenant ID - you may need to adjust this
                    'label': 'name', // Use name as label initially
                    'role_type': 'CUSTOM_ROLE',
                    'feature': 'General'
                }
            },
            
            // Permissions mapping (from old Permissions table)
            'Permissions': {
                targetTable: 'permissions',
                fieldMappings: {
                    'id': 'id',
                    'permission_name': 'name',
                    'display_name': 'label',
                    'group_by': 'feature',
                    'is_active': 'is_active',
                    'createdAt': 'created_at',
                    'updatedAt': 'updated_at'
                },
                computedFields: {
                    'permission_type': 'CRUD'
                }
            },
            
            // RolePermissions mapping (from old RolePermissions table)
            'RolePermissions': {
                targetTable: 'role_permissions',
                fieldMappings: {
                    'role_id': 'role_id',
                    'permission_id': 'permission_id',
                    'is_active': 'is_global',
                    'createdAt': 'created_at',
                    'updatedAt': 'updated_at'
                }
            },
            
            // Projects mapping
            'Projects': {
                targetTable: 'projects',
                fieldMappings: {
                    'id': 'id',
                    'name': 'name',
                    'description': 'description',
                    'status': 'status',
                    'start_date': 'start_date',
                    'end_date': 'end_date',
                    'createdAt': 'created_at',
                    'updatedAt': 'updated_at'
                },
                computedFields: {
                    'slug': 'LOWER(REPLACE(name, \' \', \'-\'))',
                    'is_sprint_project': 'false',
                    'project_duration': 'mid-term',
                    'created_by_id': '1' // Default to first user
                },
                additionalTables: {
                    'clients': {
                        'client_name': 'name'
                    }
                }
            },
            
            // Tasks mapping
            'Tasks': {
                targetTable: 'tasks',
                fieldMappings: {
                    'id': 'id',
                    'name': 'title',
                    'description': 'description',
                    'status': 'status',
                    'start_date': 'start_date',
                    'end_date': 'due_date',
                    'project_id': 'project_id',
                    'priority': 'priority',
                    'estimated_hours': 'estimated_hours',
                    'actual_hours': 'actual_hours',
                    'createdAt': 'created_at',
                    'updatedAt': 'updated_at'
                },
                computedFields: {
                    'slug': 'LOWER(REPLACE(title, \' \', \'-\'))',
                    'story_point': '0.0',
                    'created_by_id': '1' // Default to first user
                },
                additionalTables: {
                    'task_assignees': {
                        'assigned_to': 'team_member_id'
                    }
                }
            },
            
            // Sprints mapping
            'Sprints': {
                targetTable: 'sprints',
                fieldMappings: {
                    'id': 'old_id',
                    'title': 'name',
                    'goal': 'description',
                    'start_date': 'start_date',
                    'end_date': 'end_date',
                    'status': 'status',
                    'duration': 'duration',
                    'project_id': 'project_id',
                    'createdAt': 'created_at',
                    'updatedAt': 'updated_at'
                }
            },
            
            // Comments mapping
            'Comments': {
                targetTable: 'comments',
                fieldMappings: {
                    'id': 'id',
                    'comment': 'content',
                    'employee_id': 'team_member_id',
                    'entityType': 'tag',
                    'entityId': 'entity_id',
                    'edit': 'is_edited',
                    'documents': 'attachment',
                    'createdAt': 'created_at',
                    'updatedAt': 'updated_at'
                }
            },
            
            // TimeLogs mapping
            'TimeLogs': {
                targetTable: 'time_logs',
                fieldMappings: {
                    'id': 'id',
                    'start_date': 'start_time',
                    'end_date': 'end_time',
                    'time_spent': 'hours',
                    'remarks': 'description',
                    'task_id': 'task_id',
                    'user_id': 'team_member_id',
                    'createdAt': 'created_at',
                    'updatedAt': 'updated_at'
                }
            },
            
            // Clients mapping (from LeadsClients)
            'LeadsClients': {
                targetTable: 'clients',
                fieldMappings: {
                    'id': 'id',
                    'client_name': 'name',
                    'company_name': 'company_name',
                    'createdAt': 'created_at',
                    'updatedAt': 'updated_at'
                },
                computedFields: {
                    'created_by_id': '1' // Default to first user
                }
            },
            
            // Media mapping
            'media': {
                targetTable: 'media',
                fieldMappings: {
                    'id': 'id',
                    'name': 'file_name',
                    'type': 'type',
                    'size': 'size',
                    'url': 'url',
                    'createdAt': 'created_at',
                    'updatedAt': 'updated_at'
                },
                computedFields: {
                    'original_name': 'file_name',
                    'mime_type': 'type',
                    'bucket': '\'default\'',
                    'key': 'url',
                    'tag': '\'user\'',
                    'created_by_id': '1'
                }
            },
            
            // TestCases mapping
            'TestCases': {
                targetTable: 'test_cases',
                fieldMappings: {
                    'id': 'id',
                    'name': 'title',
                    'description': 'description',
                    'is_completed': 'isChecked',
                    'task_id': 'task_id',
                    'createdAt': 'created_at',
                    'updatedAt': 'updated_at'
                }
            },
            
            // UseCases mapping (if exists in old data)
            'UseCases': {
                targetTable: 'use_cases',
                fieldMappings: {
                    'id': 'id',
                    'name': 'title',
                    'description': 'description',
                    'is_completed': 'isChecked',
                    'task_id': 'task_id',
                    'createdAt': 'created_at',
                    'updatedAt': 'updated_at'
                }
            },
            
            // Labels mapping (if needed for tags)
            'Labels': {
                targetTable: 'labels',
                fieldMappings: {
                    'id': 'id',
                    'name': 'name',
                    'bgColor': 'bg_color',
                    'fontColor': 'font_color',
                    'createdAt': 'created_at',
                    'updatedAt': 'updated_at'
                }
            }
        };
        
        console.log('Mapping rules defined');
    }

    // Parse old data file using the data parser
    async parseOldData(filePath) {
        console.log('Parsing old data file...');
        this.oldData = await this.dataParser.parseDataFile(filePath);
        console.log(`Parsed data for ${Object.keys(this.oldData).length} tables`);
    }

    // Generate migration SQL
    generateMigrationSQL() {
        console.log('Generating migration SQL...');
        
        // Generate table creation SQL first
        this.generateTableCreationSQL();
        
        // Disable foreign key checks temporarily
        this.generatedSQL.push('-- Temporarily disable foreign key checks');
        this.generatedSQL.push('SET session_replication_role = replica;');
        this.generatedSQL.push('');
        
        // Generate INSERT statements for each mapped table
        Object.keys(this.mappingRules).forEach(oldTable => {
            const mapping = this.mappingRules[oldTable];
            const targetTable = mapping.targetTable;
            
            if (this.oldData[oldTable]) {
                this.generateTableMigration(oldTable, mapping);
            }
        });
        
        // Re-enable foreign key checks
        this.generatedSQL.push('-- Re-enable foreign key checks');
        this.generatedSQL.push('SET session_replication_role = DEFAULT;');
        this.generatedSQL.push('');
        
        console.log('Migration SQL generated');
    }

    // Generate migration for a specific table
    generateTableMigration(oldTable, mapping) {
        const targetTable = mapping.targetTable;
        const fieldMappings = mapping.fieldMappings;
        const computedFields = mapping.computedFields || {};
        
        console.log(`Migrating ${oldTable} to ${targetTable}...`);
        
        this.generatedSQL.push(`-- Migrating ${oldTable} to ${targetTable}`);
        
        if (this.oldData[oldTable]) {
            this.oldData[oldTable].forEach((row, index) => {
                const insertSQL = this.generateInsertStatement(oldTable, targetTable, row, fieldMappings, computedFields, index);
                if (insertSQL) {
                    this.generatedSQL.push(insertSQL);
                }
            });
        }
        
        this.generatedSQL.push('');
    }

    // Generate INSERT statement
    generateInsertStatement(oldTable, targetTable, row, fieldMappings, computedFields, rowIndex) {
        const columns = [];
        const values = [];
        
        // Map fields according to mapping rules
        Object.keys(fieldMappings).forEach(oldField => {
            const newField = fieldMappings[oldField];
            const fieldIndex = this.getFieldIndex(oldTable, oldField);
            
            if (fieldIndex !== -1 && row[fieldIndex] && row[fieldIndex] !== 'NULL') {
                columns.push(newField);
                values.push(this.formatValue(row[fieldIndex], oldField, newField));
            }
        });
        
        // Add computed fields
        Object.keys(computedFields).forEach(computedField => {
            columns.push(computedField);
            values.push(computedFields[computedField]);
        });
        
        if (columns.length > 0) {
            return `INSERT INTO ${targetTable} (${columns.join(', ')}) VALUES (${values.join(', ')});`;
        }
        
        return null;
    }

    // Get field index in old table
    getFieldIndex(tableName, fieldName) {
        if (this.oldStructure[tableName]) {
            const fields = Object.keys(this.oldStructure[tableName]);
            return fields.indexOf(fieldName);
        }
        return -1;
    }

    // Format value for PostgreSQL
    formatValue(value, oldField, newField) {
        // Remove quotes if present
        value = value.replace(/^['"]|['"]$/g, '');
        
        // Handle NULL values
        if (value === 'NULL' || value === 'null') {
            return 'NULL';
        }
        
        // Handle boolean values
        if (value === '1' && (newField.includes('is_') || newField === 'active')) {
            return 'true';
        }
        if (value === '0' && (newField.includes('is_') || newField === 'active')) {
            return 'false';
        }
        
        // Handle dates
        if (newField.includes('date') || newField.includes('created_at') || newField.includes('updated_at')) {
            if (value && value !== 'NULL') {
                return `'${value}'`;
            }
            return 'NULL';
        }
        
        // Handle JSON fields
        if (newField === 'attachment' || newField === 'documents' || newField === 'tags') {
            if (value && value !== 'NULL') {
                return `'${value}'::json`;
            }
            return 'NULL';
        }
        
        // Handle enum fields
        if (newField === 'tag') {
            if (value === 'project') return "'project'";
            if (value === 'task') return "'task'";
            return "'project'"; // default
        }
        
        // Handle media type enum
        if (newField === 'type' && oldField === 'type') {
            if (value.includes('image')) return "'image'";
            if (value.includes('video')) return "'video'";
            if (value.includes('document')) return "'document'";
            return "'other'";
        }
        
        // Default: string value
        return `'${value.replace(/'/g, "''")}'`;
    }

    // Write migration SQL to file
    writeMigrationFile(outputPath) {
        console.log(`Writing migration SQL to ${outputPath}...`);
        fs.writeFileSync(outputPath, this.generatedSQL.join('\n'));
        console.log('Migration file written successfully');
    }

    // Run the complete migration process
    async run() {
        console.log('Starting database migration process...');
        
        try {
            // Parse structures
            this.parseOldStructure('old-ontezo-db-structure.sql');
            this.parseNewStructure('new-ontezo-db-structure.sql');
            
            // Define mapping rules
            this.defineMappingRules();
            
            // Parse data
            await this.parseOldData('old-ontezo-db-data.sql');
            
            // Generate migration SQL
            this.generateMigrationSQL();
            
            // Write to file
            this.writeMigrationFile('migration-output.sql');
            
            console.log('Migration process completed successfully!');
            console.log('Generated files:');
            console.log('- migration-output.sql: Main migration SQL file (includes table creation)');
            console.log('');
            console.log('Important Notes:');
            console.log('1. All tables will be created if they don\'t exist');
            console.log('2. All existing users are set as email verified (is_email_verified = true)');
            console.log('3. Roles are assigned to tenant_id = 1 (adjust as needed)');
            console.log('4. Role permissions are preserved through role_permissions table');
            console.log('5. User passwords are set to default - users will need to reset passwords');
            console.log('6. Clients are mapped from LeadsClients table');
            console.log('7. Media files are mapped with default bucket/key structure');
            console.log('8. Review the generated SQL before importing to production');
            
        } catch (error) {
            console.error('Migration failed:', error);
        }
    }
}

// Run the migration
const migration = new DatabaseMigration();
migration.run(); 