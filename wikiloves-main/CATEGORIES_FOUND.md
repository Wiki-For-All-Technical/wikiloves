# Actual Category Names Found in Commons (2024)

Based on your Quarry category discovery, here are the **actual main categories** that exist:

## Main Campaign Categories (Use These in Queries)

1. **Wiki Loves Monuments**: `Images_from_Wiki_Loves_Monuments_2024`
2. **Wiki Loves Earth**: `Images_from_Wiki_Loves_Earth_2024`
3. **Wiki Loves Africa**: `Images_from_Wiki_Loves_Africa_2024`
4. **Wiki Loves Folklore**: `Images_from_Wiki_Loves_Folklore_2024`
5. **Wiki Loves Birds**: `Images_from_Wiki_Loves_Birds_2024`
6. **Wiki Loves Onam**: `Images_from_Wiki_Loves_Onam_2024`
7. **Wiki Loves Fashion**: `Wiki_Loves_Fashion_2024`
8. **Wiki Loves Film**: `Wiki_Loves_Film_2024`
9. **Wiki Loves Pride**: `Wiki_Loves_Pride_2024`
10. **Wiki Loves Heritage Belgium**: `Images_from_Wiki_Loves_Heritage_Belgium_in_2024`

## Ready-to-Use Queries

I've created `backend/queries/quarry_actual_categories.sql` with queries using these **exact category names**.

## Quick Start

1. Open `backend/queries/quarry_actual_categories.sql`
2. Pick the query for your campaign (e.g., Query 1 for Monuments)
3. Copy and paste into Quarry
4. Run it - should work perfectly! ✅
5. Export as CSV
6. Process with: `python backend/queries/process_quarry_results.py <export_dir>`

## Example Query (Monuments)

```sql
SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024';
```

This uses the **exact category name** from your discovery, so it will work!

