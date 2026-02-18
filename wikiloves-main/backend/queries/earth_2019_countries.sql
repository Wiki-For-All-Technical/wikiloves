-- ============================================
-- WIKI LOVES EARTH 2019 - COUNTRY STATISTICS
-- ============================================
-- Gets statistics broken down by country for year 2019
-- Countries ordered alphabetically (A-Z)
-- Database: commonswiki_p
-- Year: 2019
--
-- Copy this into Quarry: https://quarry.wmcloud.org
--
-- This query matches the data structure shown on:
-- https://wikiloves.toolforge.org/earth/2019

SELECT 
    2019 AS year,
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            REPLACE(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', ' ')
        ELSE 'Global'
    END AS country,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(2019, '0501000000')
            AND u.user_registration <= CONCAT(2019, '0531235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
LEFT JOIN actor act ON a.actor_id = act.actor_id
LEFT JOIN user u ON act.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_%'
  )
  AND CAST(SUBSTRING_INDEX(
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            SUBSTRING_INDEX(cl.cl_to, '_in_', 1)
        ELSE cl.cl_to
    END, '_', -1) AS UNSIGNED) = 2019
GROUP BY year, country
ORDER BY country ASC;
