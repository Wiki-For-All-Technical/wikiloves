-- ============================================
-- WIKI LOVES MOMENTS 2025 - SUMMARY BY COUNTRY (FAST)
-- ============================================
-- Returns one row per country. "images_used_in_the_wikis" is set to 0
-- here because joining imagelinks is very slow on replicas; run the
-- optional query below separately if you need that metric.
--
-- Competition start (for "registered after"): 1 September 2025
-- Database: commonswiki (Quarry / Toolforge replica)

SELECT
    2025 AS year,
    REPLACE(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', ' ') AS countries,
    COUNT(DISTINCT i.img_name) AS uploads,
    0 AS images_used_in_the_wikis,
    COUNT(DISTINCT a.actor_id) AS uploaders,
    COUNT(DISTINCT CASE
        WHEN u.user_registration >= '20250901000000' THEN a.actor_id
    END) AS uploaders_registered_after_competition_start
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN user u ON u.user_id = a.actor_user
WHERE cl.cl_type = 'file'
  AND cl.cl_to LIKE 'Images_from_Wiki_Loves_Monuments_2025_in_%'
GROUP BY cl.cl_to
ORDER BY uploads DESC;
https://quarry.wmcloud.org/run/1072347/output/0/json

-- ============================================
-- OPTIONAL: Images used in wikis (slower, run separately)
-- ============================================
-- Uncomment and run if you need images_used; then merge with main results by country.
/*
SELECT
    REPLACE(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', ' ') AS countries,
    COUNT(DISTINCT CASE WHEN il.il_to IS NOT NULL THEN i.img_name END) AS images_used_in_the_wikis
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id AND p.page_namespace = 6 AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
LEFT JOIN imagelinks il ON il.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to LIKE 'Images_from_Wiki_Loves_Monuments_2025_in_%'
GROUP BY cl.cl_to;
*/
