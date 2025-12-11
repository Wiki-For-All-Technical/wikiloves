-- ============================================
-- COUNTRY-LEVEL STATISTICS QUERY
-- ============================================
-- This query gets upload statistics broken down by country
-- for Wiki Loves Monuments 2024
--
-- IMPORTANT: Replace these values:
--   - 'Images_from_Wiki_Loves_Monuments_2024' with your category name
--   - '20240901000000' with start date (YYYYMMDDHHMMSS)
--   - '20240930235959' with end date (YYYYMMDDHHMMSS)
--   - '20240901000000' and '20240930235959' in new_uploaders section
-- ============================================

SELECT 
    -- Extract country from category name
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            SUBSTRING_INDEX(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', 1)
        ELSE 'Unknown'
    END AS country,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240901000000'
            AND u.user_registration <= '20240930235959'
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024'
  AND i.img_timestamp >= '20240901000000'
  AND i.img_timestamp <= '20240930235959'
GROUP BY country
ORDER BY uploads DESC;

-- ============================================
-- ALTERNATIVE: If country is in a separate category
-- ============================================
-- Some campaigns have country-specific categories like:
-- "Images_from_Wiki_Loves_Monuments_2024_in_Italy"
-- This query handles that pattern:

SELECT 
    -- Extract country from category name (after "_in_")
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            REPLACE(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', ' ')
        ELSE 'Global'
    END AS country,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240901000000'
            AND u.user_registration <= '20240930235959'
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024'
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Monuments_2024_in_%'
  )
  AND i.img_timestamp >= '20240901000000'
  AND i.img_timestamp <= '20240930235959'
GROUP BY country
ORDER BY uploads DESC;

