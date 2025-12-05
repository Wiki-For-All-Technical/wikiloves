# Working Query Pattern ✅

Based on your guide's example, here's the correct pattern that works!

## The Working Pattern

The key is to join through the `page` table:

```
categorylinks → page → image → actor_image
```

## Key Differences

❌ **Wrong approach** (what we tried):
- Direct join: `image` → `categorylinks` using `img_id`
- Problem: `img_id` doesn't exist in the WHERE clause context

✅ **Correct approach** (from your guide):
- Join through `page`: `categorylinks` → `page` → `image`
- Use `page.page_title = image.img_name` to match
- Use `actor_image` view (not `actor` table directly)

## Working Query Structure

```sql
SELECT 
    COUNT(a.actor_name) AS uploads,
    a.actor_name AS uploader
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024'
GROUP BY a.actor_name;
```

## Important Filters

- `p.page_namespace = 6` - File namespace
- `p.page_is_redirect = 0` - Exclude redirects
- `cl.cl_type = 'file'` - Only file categories
- `cl.cl_to = '...'` - Exact category name

## Step-by-Step Process

1. **Discover Category Name** (run this first):
   ```sql
   SELECT DISTINCT cl.cl_to 
   FROM categorylinks cl
   WHERE cl.cl_type = 'file'
     AND cl.cl_to LIKE '%Wiki_Loves%2024%'
   ORDER BY cl.cl_to;
   ```

2. **Get Statistics** (use exact category name):
   ```sql
   SELECT 
       COUNT(DISTINCT i.img_name) AS uploads,
       COUNT(DISTINCT a.actor_name) AS uploaders
   FROM categorylinks cl
   JOIN page p ON cl.cl_from = p.page_id
   JOIN image i ON i.img_name = p.page_title 
       AND p.page_namespace = 6 
       AND p.page_is_redirect = 0
   JOIN actor_image a ON i.img_actor = a.actor_id
   WHERE cl.cl_type = 'file'
     AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024';
   ```

## Files Created

✅ **`backend/queries/quarry_working_pattern.sql`** - All queries using the correct pattern!

This file includes:
- Query 1: Uploads by user
- Query 2: Overall statistics
- Query 3: With new uploaders
- Query 4: Category discovery
- Query 5: Generic template
- Query 6: Trend analysis
- Query 7: Multiple categories

## Next Steps

1. Open `backend/queries/quarry_working_pattern.sql`
2. Run Query 4 first to discover category names
3. Use the exact category name in other queries
4. Export results and process!

These queries should work perfectly now! 🎉







