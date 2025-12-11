# Query Optimization Tips for Faster Execution

## Why Queries Are Slow

The multiyear summary queries can be slow because they:
1. Join 5-6 large tables (categorylinks, page, image, actor_image, actor, user)
2. Use EXISTS subqueries for `imagelinks` (can be very slow)
3. Use complex string operations in WHERE clauses
4. Scan many categories with LIKE patterns

## Optimization Strategies

### 1. Use More Specific Patterns (FASTEST)

Instead of:
```sql
AND (cl.cl_to LIKE '%Wiki_Loves_Earth%')
```

Use:
```sql
AND (
  cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_%'
  OR cl.cl_to LIKE 'Wiki_Loves_Earth_%'
)
```

**Why:** More specific patterns use indexes better.

### 2. Move Filters to JOIN Conditions

Instead of:
```sql
JOIN page p ON cl.cl_from = p.page_id
WHERE p.page_namespace = 6
```

Use:
```sql
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6
    AND p.page_is_redirect = 0
```

**Why:** Filters are applied earlier, reducing rows to join.

### 3. Remove images_used Check (If Not Critical)

The `images_used` check uses an EXISTS subquery which is very slow:

```sql
-- SLOW:
COUNT(DISTINCT CASE 
    WHEN EXISTS (
        SELECT 1 FROM imagelinks il 
        WHERE il.il_from = p.page_id
    ) THEN i.img_name 
END) AS images_used
```

**Option 1:** Set to 0 and calculate separately if needed:
```sql
0 AS images_used
```

**Option 2:** Use a simpler approximation (if acceptable):
```sql
COUNT(DISTINCT i.img_name) AS images_used  -- Same as uploads
```

### 4. Limit Year Range

Instead of:
```sql
BETWEEN 2010 AND 2025
```

Use:
```sql
BETWEEN 2013 AND 2025  -- Only years you need
```

### 5. Use LIMIT in EXISTS (Slight Improvement)

```sql
EXISTS (
    SELECT 1 FROM imagelinks il 
    WHERE il.il_from = p.page_id
    LIMIT 1
)
```

## Fastest Query Template

Here's the fastest version (without images_used):

```sql
SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT i.img_name) AS images_used,  -- Approximation
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0501000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0531235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2013 AND 2025
GROUP BY year
ORDER BY year DESC;
```

## Expected Execution Times

- **With images_used EXISTS:** 5-15 minutes (very slow)
- **Without images_used EXISTS:** 1-3 minutes (acceptable)
- **With specific patterns only:** 30 seconds - 2 minutes (fast)

## Recommendation

For Earth campaign (query #19), use the **FAST version** without the EXISTS subquery. The `images_used` can be approximated as equal to `uploads` for most campaigns, or calculated separately if needed.

## Alternative: Run Per-Year Queries

If multiyear queries are still too slow, you can run separate queries for each year:

```sql
-- For 2013 only
SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2013'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_2013%'
  );
```

Then combine the results manually.

