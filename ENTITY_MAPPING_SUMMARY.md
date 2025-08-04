# Entity Mapping Summary

This document provides a comprehensive overview of all entities in your new schema and how they're mapped from the old database.

## Core Entities

### 1. User Management

#### User Entity (`users`)

- **Source**: `Employees` table
- **Key Features**:
  - Email verification (`is_email_verified`)
  - OTP handling (`otp_code`, `otp_expiry`)
  - Password management (`password`, `is_password_forget`)
  - Tenant support (`tenant_id`)
  - Terms agreement (`is_agree_terms`)

#### User Profile Entity (`user_profiles`)

- **Source**: `Employees` table (additional fields)
- **Mapped Fields**:
  - `full_name`, `phone`, `address`, `city`, `country`
  - `date_of_birth`, `state`, `postal_code`
  - `profile_picture`, `is_profile_complete`

#### Team Member Entity (`team_members`)

- **Source**: `Employees` table
- **Key Features**:
  - Employment details (`joinin_date`, `monthly_salary`)
  - Department info (`department`, `designation`)
  - Skills and experience (`skills`, `experience`)
  - One-to-one relationship with User

### 2. Role & Permission System

#### Role Entity (`roles`)

- **Source**: `Roles` table
- **Key Features**:
  - Tenant-based roles (`tenant_id`)
  - Role types (`role_type`, `feature`)
  - Many-to-many with Users and Permissions

#### Permission Entity (`permissions`)

- **Source**: `Permissions` table
- **Key Features**:
  - Permission types (`permission_type`)
  - Feature grouping (`feature`)
  - Many-to-many with Roles

#### Role Permission Entity (`role_permissions`)

- **Source**: `RolePermissions` table
- **Key Features**:
  - Junction table for Role-Permission relationships
  - Global permissions (`is_global`)

### 3. Project Management

#### Project Entity (`projects`)

- **Source**: `Projects` table
- **Key Features**:
  - Slug generation (`slug`)
  - Project duration enum (`project_duration`)
  - Sprint project flag (`is_sprint_project`)
  - Client relationship (`clientId`)
  - Many-to-many with Team Members

#### Project Status Entity (`project_statuses`)

- **Key Features**:
  - Custom statuses per project
  - Order management
  - Display names

#### Task Entity (`tasks`)

- **Source**: `Tasks` table
- **Key Features**:
  - Slug generation (`slug`)
  - Story points (`story_point`)
  - Parent-child relationships (`parent_task_id`)
  - Sprint assignment (`sprint_id`)
  - Many-to-many with Team Members

#### Sprint Entity (`sprints`)

- **Source**: `Sprints` table
- **Key Features**:
  - Status enum (`status`)
  - Duration tracking
  - Old ID preservation (`old_id`)

#### Sprint Status Entity (`sprint_statuses`)

- **Key Features**:
  - Custom statuses per sprint
  - Order management

### 4. Communication & Collaboration

#### Comment Entity (`comments`)

- **Source**: `Comments` table
- **Key Features**:
  - Tag system (`tag` enum: project/task)
  - Parent-child relationships
  - Attachment support (`attachment` JSON)
  - Edit tracking (`is_edited`)

#### Time Log Entity (`time_logs`)

- **Source**: `TimeLogs` table
- **Key Features**:
  - Time tracking (`start_time`, `end_time`, `hours`)
  - Description field
  - Team member association

### 5. Client Management

#### Client Entity (`clients`)

- **Source**: `LeadsClients` table
- **Key Features**:
  - Company information
  - Contact details
  - Created by tracking

### 6. Media & Files

#### Media Entity (`media`)

- **Source**: `media` table
- **Key Features**:
  - File metadata (`file_name`, `original_name`, `mime_type`)
  - Storage info (`bucket`, `key`)
  - Type enum (`type`: image/video/document/other)
  - Tag system (`tag`: comment/user/project/task)

#### Media Record Entity (`media_records`)

- **Key Features**:
  - Junction table for Media relationships
  - Links media to users, projects, tasks, comments

### 7. Testing & Quality Assurance

#### Test Case Entity (`test_cases`)

- **Source**: `TestCases` table
- **Key Features**:
  - Test case management
  - Completion tracking (`isChecked`)

#### Use Case Entity (`use_cases`)

- **Source**: `UseCases` table (if exists)
- **Key Features**:
  - Use case management
  - Completion tracking

### 8. Project Organization

#### Phase Entity (`phases`)

- **Key Features**:
  - Project phase management
  - Status tracking
  - Checklist relationships

#### Checklist Entity (`checklists`)

- **Key Features**:
  - Phase-based checklists
  - Status management

#### Checklist Item Entity (`checklist_items`)

- **Key Features**:
  - Individual checklist items
  - Completion tracking (`is_checked`)

### 9. User Experience

#### User Preference Entity (`user_preferences`)

- **Key Features**:
  - Category-based preferences (`category` enum)
  - JSON value storage
  - User-specific settings

#### User Link Entity (`user_links`)

- **Source**: `JobQueues` table (GitHub links)
- **Key Features**:
  - External link management
  - Platform enum (`platform`: github/gitlab)
  - Task association

### 10. Authentication & Security

#### User Auth Provider Entity (`user_auth_providers`)

- **Key Features**:
  - OAuth provider management
  - Social login support

#### Invite Entity (`invites`)

- **Key Features**:
  - User invitation system
  - Token-based invitations
  - Role assignment

### 11. Billing & Subscriptions

#### Plan Entity (`plans`)

- **Key Features**:
  - Pricing plans
  - Stripe integration
  - Feature management

#### Subscription Entity (`subscriptions`)

- **Key Features**:
  - User subscriptions
  - Stripe integration
  - Billing management

### 12. System & Monitoring

#### Tenant Entity (`tenants`)

- **Key Features**:
  - Multi-tenant support
  - Subdomain management
  - Database configuration

#### Audit Log Entity (`audit_logs`)

- **Key Features**:
  - Activity tracking
  - Entity-specific logging
  - Team member association

#### Webhook Event Entity (`webhook_events`)

- **Key Features**:
  - Webhook management
  - Event tracking
  - Retry logic

#### Menu Entity (`menu`)

- **Key Features**:
  - Navigation management
  - Hierarchical structure
  - Visibility control

## Key Relationships

### Many-to-Many Relationships

1. **Users ↔ Roles** (via `user_roles`)
2. **Roles ↔ Permissions** (via `role_permissions`)
3. **Projects ↔ Team Members** (via `project_assignees`)
4. **Tasks ↔ Team Members** (via `task_assignees`)

### One-to-One Relationships

1. **User ↔ User Profile**
2. **User ↔ Team Member**

### One-to-Many Relationships

1. **Tenant → Users**
2. **Tenant → Roles**
3. **Project → Tasks**
4. **Project → Sprints**
5. **Project → Comments**
6. **Task → Comments**
7. **Task → Time Logs**
8. **Sprint → Tasks**

## Migration Notes

### Email Verification

- All existing users are marked as email verified
- OTP codes are set to NULL for existing users
- New users will need email verification

### Password Management

- Default passwords are set for existing users
- Users will need to reset passwords on first login
- Password forget flag is set to false

### Tenant Support

- All entities are assigned to tenant_id = 1 by default
- Multi-tenant architecture is preserved
- Tenant relationships are maintained

### Role Permissions

- All role-permission relationships are preserved
- Default roles (SUPER_ADMIN, ADMIN, USER) are created
- Basic permissions are assigned to roles

### Data Integrity

- Foreign key relationships are maintained
- Orphaned records are cleaned up
- Sequence values are updated to prevent conflicts

## Post-Migration Tasks

1. **Password Reset**: Users need to reset passwords
2. **Email Verification**: New users need email verification
3. **Tenant Configuration**: Adjust tenant assignments as needed
4. **Role Assignment**: Verify role-permission assignments
5. **Media Files**: Update media file paths if needed
6. **External Links**: Verify GitHub/GitLab links
7. **Custom Fields**: Add any missing custom fields
8. **Testing**: Verify all relationships work correctly

## Performance Considerations

- Indexes are created for frequently queried fields
- Foreign key constraints are properly set
- Sequence values are updated to prevent conflicts
- Orphaned records are cleaned up

This migration ensures a smooth transition from your old MySQL database to the new PostgreSQL schema while preserving all data relationships and adding the new features like email verification, role permissions, and tenant support.
