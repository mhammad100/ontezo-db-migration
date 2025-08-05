# **ERP Data Migration Tool (MySQL → PostgreSQL)**

This Node.js-based migration engine enables seamless **data onboarding from a customer’s MySQL ERP** to **your fixed PostgreSQL ERP schema**.  

It supports:

- **Dynamic source schema discovery**
- **Fixed target (ERP) schema migration**
- **Batch ETL processing**
- **ID remapping to preserve foreign keys**
- **Mapping-based transformations**
- **Optional auto-mapping & pre-migration validation**

---

## **Features**

- ✅ MySQL → PostgreSQL data migration  
- ✅ Supports **dry run** mode  
- ✅ **Mapping.json** for flexible column mapping  
- ✅ **ID remapping** to maintain referential integrity  
- ✅ **Auto-mapping generator** for new customers  
- ✅ **Pre-migration validation & reporting**  
- ✅ Handles **millions of rows** with batch processing  

---

## **1. Installation**

```bash
# Install dependencies
npm install

node migrate.js \
  --mysql "mysql://root:secret@127.0.0.1:3306/customer_erp" \
  --postgres "postgres://postgres:secret@127.0.0.1:5432/my_erp" \
  --autoMap


# Validate mapping
node migrate.js \
  --mysql "mysql://root:secret@127.0.0.1:3306/customer_erp" \
  --postgres "postgres://postgres:secret@127.0.0.1:5432/my_erp" \
  --mapping ./mapping.json \
  --validate

# Run migration

node migrate.js \
  --mysql "mysql://root:secret@127.0.0.1:3306/customer_erp" \
  --postgres "postgres://postgres:secret@127.0.0.1:5432/my_erp" \
  --mapping ./mapping.json \
  --batch 5000

# Dry Run Mode

node migrate.js \
  --mysql "mysql://root:secret@127.0.0.1:3306/customer_erp" \
  --postgres "postgres://postgres:secret@127.0.0.1:5432/my_erp" \
  --mapping ./mapping.json \
  --dryRun true

# Full Example

node migrate.js \
  --mysql "mysql://root:secret@localhost:3306/customer_erp" \
  --postgres "postgres://postgres:secret@localhost:5432/my_erp" \
  --mapping ./mapping.json \
  --batch 10000 \
  --dryRun false

# Full Example

node migrate.js \
  --mysql "mysql://root:secret@localhost:3306/customer_erp" \
  --postgres "postgres://postgres:secret@localhost:5432/my_erp" \
  --mapping ./mapping.json \
  --batch 10000 \
  --dryRun false
  --autoMap