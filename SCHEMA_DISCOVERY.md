# Discovering the Commons Database Schema

The Commons database schema might be different than expected. Let's discover it step by step.

## Step 1: Check the Image Table Structure

Run this in Quarry first:

```sql
DESCRIBE image;
```

Or:

```sql
SHOW COLUMNS FROM image;
```

This will show you all available columns in the `image` table.

## Step 2: Check for User Information

The user information might be stored differently. Try:

```sql
-- Check if user table exists
DESCRIBE user;

-- Check if actor table exists (newer MediaWiki)
DESCRIBE actor;

-- Find all user-related columns
SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'commonswiki_p'
  AND TABLE_NAME = 'image'
  AND COLUMN_NAME LIKE '%user%';
```

## Step 3: Use the Simple Queries

I've created `quarry_simple_working.sql` with queries that:
- ✅ Don't require user information
- ✅ Just count uploads by category
- ✅ Work with basic image and categorylinks tables

These will at least give you:
- Total uploads
- Images used (via imagelinks)
- Upload trends by month

## Step 4: Once You Know the Schema

After running the schema discovery queries, share the results and I can create the perfect query for your needs.

## Quick Working Query (No User Info)

For now, use this simple query that should work:

```sql
-- Get total uploads for Wiki Loves Monuments 2024
SELECT 
    COUNT(*) AS uploads,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks 
            WHERE il_from = img.img_id
        ) THEN img.img_id 
    END) AS images_used
FROM image img
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= '20240901000000'
  AND img.img_timestamp <= '20240930235959'
  AND (
    cl.cl_to LIKE '%Images_from_Wiki_Loves_Monuments_2024%'
    OR cl.cl_to LIKE '%Wiki_Loves_Monuments_2024%'
  );
```

This gives you:
- `uploads`: Total number of uploads
- `images_used`: How many are actually used in articles

## Next Steps

1. Run the schema discovery queries
2. Share what columns you see
3. I'll create the perfect query with user/uploader information

Or use the simple queries for now to get basic statistics!









