# Ontezo Database Migration Tool

This tool migrates data from an old MySQL database to a new PostgreSQL database with TypeORM, converting the database structure and data accordingly.

## Overview

The migration tool reads your old database structure and data, maps it to the new PostgreSQL schema, and generates SQL files that you can import into your new database. This ensures a smooth transition for your users from the old platform to the new system.

## Features

- **Schema Analysis**: Parses both old MySQL and new PostgreSQL database structures
- **Data Mapping**: Maps old table structures to new schema with configurable rules
- **Data Transformation**: Converts data types and formats appropriately
- **SQL Generation**: Creates PostgreSQL-compatible INSERT statements
- **Large File Handling**: Efficiently processes large data files using streaming
- **Error Handling**: Robust error handling and logging
- **Email Verification**: Handles user email verification status
- **Role Permissions**: Preserves role-permission relationships
- **Tenant Support**: Supports multi-tenant architecture

## Prerequisites

- Node.js 14.0.0 or higher
- Your database files:
  - `old-ontezo-db-structure.sql` - Old MySQL database structure
  - `new-ontezo-db-structure.sql` - New PostgreSQL database structure
  - `old-ontezo-db-data.sql` - Old database data (INSERT statements)

## Installation

1. Clone or download this repository
2. Place your database files in the project directory
3. Install dependencies (if any):
   ```bash
   npm install
   ```

## Usage

### Basic Migration

Run the migration script:

```bash
npm start
```

or

```bash
node migration-script.js
```

### What the Script Does

1. **Parses Database Structures**: Reads and analyzes both old and new database schemas
2. **Defines Mapping Rules**: Maps old table fields to new schema fields
3. **Processes Data**: Parses the large data file efficiently
4. **Generates SQL**: Creates PostgreSQL-compatible INSERT statements
5. **Outputs Files**: Generates `migration-output.sql` for importing

### Generated Files

- `migration-output.sql` - Main migration SQL file to import into your new PostgreSQL database
- `post-migration-setup.sql` - Additional setup script for relationships and configuration

## Migration Process

### Step 1: Main Migration

Run the migration script to generate the main SQL file:

```bash
node migration-script.js
```

### Step 2: Import Main Migration

Import the generated SQL into your new database:

```bash
psql -d your_new_database -f migration-output.sql
```

### Step 3: Post-Migration Setup

Run the post-migration setup script to establish relationships:

```bash
psql -d your_new_database -f post-migration-setup.sql
```

## Mapping Configuration

The tool includes predefined mappings for common entities:

### Core Mappings

- **Employees** → **users** + **user_profiles**
- **Roles** → **roles** (with tenant support)
- **Permissions** → **permissions**
- **RolePermissions** → **role_permissions**
- **Projects** → **projects**
- **Tasks** → **tasks** + **task_assignees**
- **Sprints** → **sprints**
- **Comments** → **comments**
- **TimeLogs** → **time_logs**

### Special Handling

#### Email Verification

- All existing users are set as email verified (`is_email_verified = true`)
- OTP codes are set to NULL for existing users
- New users will need to verify their email through your application

#### Role Permissions

- Preserves the many-to-many relationship between roles and permissions
- Maps old `RolePermissions` table to new `role_permissions` table
- Maintains permission assignments for existing roles

#### Tenant Support

- Roles are assigned to a default tenant (tenant_id = 1)
- You can modify the tenant assignment in the migration script
- Supports multi-tenant architecture

### Field Mappings

The script maps fields between old and new schemas:

```javascript
// Example mapping for Employees table
'Employees': {
    targetTable: 'users',
    fieldMappings: {
        'id': 'id',
        'email': 'email',
        'is_active': 'is_active',
        'createdAt': 'created_at',
        'updatedAt': 'updated_at'
    },
    computedFields: {
        'is_email_verified': 'true',
        'otp_code': 'NULL',
        'is_password_forget': 'false',
        'is_agree_terms': 'true',
        'is_deleted': 'false'
    }
}
```

## Customizing Mappings

To customize the field mappings, edit the `defineMappingRules()` method in `migration-script.js`:

1. Add new table mappings
2. Modify existing field mappings
3. Add additional table relationships
4. Adjust computed fields for your specific needs

## Data Type Conversions

The tool automatically handles common data type conversions:

- **Booleans**: MySQL `tinyint(1)` → PostgreSQL `boolean`
- **Dates**: MySQL `datetime` → PostgreSQL `timestamp`
- **JSON**: MySQL `json` → PostgreSQL `json`
- **Strings**: Proper escaping and quoting for PostgreSQL
- **Enums**: Maps enum values appropriately

## Post-Migration Setup

The `post-migration-setup.sql` script handles:

1. **User-Role Relationships**: Sets up many-to-many user-role relationships
2. **Team Members**: Creates team_members records from employees
3. **Project Assignees**: Maps project assignments
4. **Task Assignees**: Maps task assignments
5. **Comment References**: Updates comment entity references
6. **Default Tenant**: Creates default tenant configuration
7. **Default Roles**: Creates standard roles (SUPER_ADMIN, ADMIN, USER)
8. **Default Permissions**: Creates basic permissions
9. **Role-Permission Assignments**: Assigns permissions to roles
10. **User Profiles**: Creates user profiles for existing users
11. **Status Setup**: Sets up project and sprint statuses
12. **Data Cleanup**: Removes orphaned records
13. **Performance Indexes**: Adds performance indexes

## Importing to New Database

1. **Backup your new database** (important!)
2. **Run the main migration**:
   ```bash
   psql -d your_new_database -f migration-output.sql
   ```
3. **Run the post-migration setup**:
   ```bash
   psql -d your_new_database -f post-migration-setup.sql
   ```
4. **Verify the migration** by checking data integrity
5. **Update any foreign key references** if needed

## Important Notes

### Email Verification

- All existing users are automatically marked as email verified
- New users will need to go through email verification
- OTP codes are set to NULL for existing users

### Role Permissions

- The migration preserves all role-permission relationships
- Default roles (SUPER_ADMIN, ADMIN, USER) are created
- Basic permissions are created and assigned to roles

### Tenant Configuration

- Roles are assigned to tenant_id = 1 by default
- Modify the tenant assignment in the migration script if needed
- Supports multi-tenant architecture

## Troubleshooting

### Common Issues

1. **Large Data Files**: The tool uses streaming to handle large files efficiently
2. **Memory Issues**: If you encounter memory problems, the data parser processes files in chunks
3. **Data Type Errors**: Check the `formatValue()` method for custom data type handling
4. **Foreign Key Constraints**: The script temporarily disables foreign key checks during import
5. **Email Verification**: Ensure your application handles email verification for new users
6. **Role Permissions**: Verify role-permission assignments after migration

### Debugging

- Check console output for parsing progress
- Review generated SQL for data format issues
- Verify field mappings match your schema
- Check post-migration setup for relationship issues

## File Structure

```
dbmigration/
├── migration-script.js      # Main migration script
├── data-parser.js          # Data parsing utilities
├── package.json            # Node.js project configuration
├── README.md              # This file
├── old-ontezo-db-structure.sql  # Old database structure
├── new-ontezo-db-structure.sql  # New database structure
├── old-ontezo-db-data.sql       # Old database data
├── migration-output.sql          # Generated migration SQL (output)
└── post-migration-setup.sql     # Post-migration setup script
```

## Advanced Usage

### Custom Field Transformations

Add custom field transformations in the `formatValue()` method:

```javascript
formatValue(value, oldField, newField) {
    // Custom transformations
    if (newField === 'status') {
        return this.transformStatus(value);
    }
    // ... existing code
}
```

### Adding New Table Mappings

Add new mappings to the `mappingRules` object:

```javascript
'NewTable': {
    targetTable: 'new_table',
    fieldMappings: {
        'old_field': 'new_field',
        // ... more mappings
    },
    computedFields: {
        'computed_field': 'default_value'
    }
}
```

### Modifying Email Verification

To change email verification behavior, modify the computed fields:

```javascript
computedFields: {
    'is_email_verified': 'false', // Set to false to require verification
    'otp_code': 'generate_otp()', // Generate OTP codes
    // ... other fields
}
```

## Security Considerations

- Always backup your databases before migration
- Test the migration on a copy of your production data first
- Review generated SQL before importing to production
- Consider data privacy and compliance requirements
- Verify email verification settings for your use case
- Check role-permission assignments after migration

## Support

For issues or questions:

1. Check the console output for error messages
2. Verify your database files are in the correct format
3. Review the mapping rules for your specific schema
4. Check the post-migration setup for relationship issues

## License

MIT License - feel free to modify and use for your projects.
