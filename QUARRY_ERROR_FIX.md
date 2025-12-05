# Fix for Quarry Query Error

## The Error

If you see: **"Unknown column 'img.img_user_text' in 'SELECT'"**

This means the query is using a column name that doesn't exist in the Commons database.

## The Fix

The Commons database schema uses:
- `image.img_user` (user ID, not username)
- `user.user_name` (username, from user table)
- `user.user_id` (user ID)

We need to **join with the user table** to get usernames.

## Corrected Query Format

### ❌ Wrong (causes error):
```sql
SELECT img.img_user_text  -- This column doesn't exist!
FROM image img
```

### ✅ Correct:
```sql
SELECT COALESCE(user.user_name, CAST(img.img_user AS CHAR))
FROM image img
LEFT JOIN user ON img.img_user = user.user_id
```

## Updated Queries

I've created **fixed queries** in:
- `backend/queries/quarry_fixed_queries.sql` - Ready-to-use corrected queries

## Quick Fix for Your Current Query

Replace this pattern everywhere it appears:
```sql
img.img_user_text
```

With:
```sql
COALESCE(user.user_name, CAST(img.img_user AS CHAR))
```

And make sure you have:
```sql
LEFT JOIN user ON img.img_user = user.user_id
```

## Example: Fixed Monuments Query

```sql
SELECT 
    COUNT(*) AS uploads,
    COUNT(DISTINCT COALESCE(user.user_name, CAST(img.img_user AS CHAR))) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks 
            WHERE il_from = img.img_id
        ) THEN img.img_id 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN user.user_registration >= '20240901000000'
            AND user.user_registration <= '20240930235959'
        THEN COALESCE(user.user_name, CAST(img.img_user AS CHAR))
    END) AS new_uploaders
FROM image img
LEFT JOIN user ON img.img_user = user.user_id
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= '20240901000000'
  AND img.img_timestamp <= '20240930235959'
  AND (
    cl.cl_to LIKE '%Images_from_Wiki_Loves_Monuments_2024%'
    OR cl.cl_to LIKE '%Wiki_Loves_Monuments_2024%'
  );
```

## Use the Fixed Queries

1. Open `backend/queries/quarry_fixed_queries.sql`
2. Copy the query for your campaign
3. Replace `2024` with your actual year
4. Paste into Quarry and run

## Updated Generator Script

The query generator script has also been fixed:
```bash
python backend/scripts/generate_quarry_query.py monuments 2024
```

This now generates correct queries automatically.









