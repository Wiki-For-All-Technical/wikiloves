# Earth 2013 Query Guide - Fast Execution

## Problem

The comprehensive query with broad patterns (`%Earth%2013%`) is very slow because:
- Wildcards at the start (`%Earth%`) can't use indexes
- Multiple LIKE patterns scan the entire table
- Takes 5-15+ minutes to run

## Solution: Use Specific Patterns

### Step 1: Find Categories (FAST - 10-30 seconds)

Run this query first to find all Earth 2013 categories:

```sql
SELECT DISTINCT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT i.img_name) AS file_count
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2013%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_2013%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_%_2013'
  )
GROUP BY cl.cl_to
ORDER BY file_count DESC;
```

**Why this is fast:**
- Patterns start with specific text (can use indexes)
- Only checks a few specific patterns
- Returns quickly with category names

### Step 2: Query Specific Categories (FAST - 1-2 minutes)

Once you have the category names, use exact matches:

```sql
SELECT 
    2013 AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT i.img_name) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20130501000000'
            AND u.user_registration <= '20130531235959'
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
    cl.cl_to = 'Images_from_Wiki_Loves_Earth_2013'
    OR cl.cl_to = 'Wiki_Loves_Earth_2013'
    -- Add more specific categories from Step 1
  )
GROUP BY year;
```

**Why this is fast:**
- Uses exact matches (`=`) instead of LIKE
- Can use indexes efficiently
- Only queries known categories

## Files Available

1. **`earth_2013_FAST.sql`** - Step-by-step approach (recommended)
2. **`earth_2013_ULTRA_FAST.sql`** - Single optimized query
3. **`earth_2013_comprehensive.sql`** - Original (slow, but comprehensive)

## Recommendation

1. Run **Step 1** from `earth_2013_FAST.sql` (10-30 seconds)
2. Note the category names with the most files
3. Use **Step 2** with those specific category names (1-2 minutes)
4. This should give you the complete 2013 data

## Expected Results

- Step 1: Should show categories like:
  - `Images_from_Wiki_Loves_Earth_2013`
  - `Wiki_Loves_Earth_2013`
  - Possibly country-specific ones like `Wiki_Loves_Earth_2013_in_Country`

- Step 2: Should return ~9,655 uploads (matching reference website)

## Why 2013 Might Be Different

2013 was the first year of Wiki Loves Earth, so:
- Category naming might be inconsistent
- May have different patterns than later years
- Some categories might not follow the standard format

The Step 1 query will reveal all the actual category names used in 2013.

