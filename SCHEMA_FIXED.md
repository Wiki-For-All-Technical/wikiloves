# Schema Fixed! ✅

## What We Discovered

The Commons database uses the **actor system** (modern MediaWiki):

- ✅ `image.img_actor` (not `img_user`) → links to `actor.actor_id`
- ✅ `actor.actor_name` → gives us the username directly
- ✅ `actor.actor_user` → links to `user.user_id` (for registered users)
- ✅ `user.user_registration` → registration date

## Correct Join Structure

```sql
image 
  → img_actor → actor.actor_id
    → actor_name (username)
    → actor_user → user.user_id
      → user_registration (for new users)
```

## Fixed Queries

I've created **corrected queries** in:
- `backend/queries/quarry_correct_queries.sql` - All fixed queries ready to use!

## Quick Start

1. **Open** `backend/queries/quarry_correct_queries.sql`
2. **Pick a query** (e.g., Query 1 for Monuments)
3. **Replace `2024`** with your actual year (appears 4 times)
4. **Copy and paste** into Quarry
5. **Run it** - should work now! ✅

## Example: Fixed Monuments Query

```sql
SELECT 
    COUNT(*) AS uploads,
    COUNT(DISTINCT actor.actor_name) AS uploaders,
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
        THEN actor.actor_name
    END) AS new_uploaders
FROM image img
INNER JOIN actor ON img.img_actor = actor.actor_id
LEFT JOIN user ON actor.actor_user = user.user_id
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= '20240901000000'
  AND img.img_timestamp <= '20240930235959'
  AND (
    cl.cl_to LIKE '%Images_from_Wiki_Loves_Monuments_2024%'
    OR cl.cl_to LIKE '%Wiki_Loves_Monuments_2024%'
  );
```

## Key Changes

1. ✅ `img.img_actor` instead of `img.img_user`
2. ✅ `INNER JOIN actor ON img.img_actor = actor.actor_id`
3. ✅ `actor.actor_name` for usernames
4. ✅ `LEFT JOIN user ON actor.actor_user = user.user_id` for registration dates

## Next Steps

1. Use the corrected queries from `quarry_correct_queries.sql`
2. Run Query 5 first to discover actual category names
3. Then run the main query for your campaign
4. Export as CSV and process!

The queries should work perfectly now! 🎉









