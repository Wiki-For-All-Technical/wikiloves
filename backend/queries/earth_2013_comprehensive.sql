-- ============================================
-- EARTH 2013 - COMPREHENSIVE QUERY
-- ============================================
-- This query tries to find ALL Earth 2013 data
-- Uses very broad patterns to catch all possible categories
-- ============================================

SELECT 
    2013 AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
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
    -- Try all possible patterns for Earth 2013
    cl.cl_to LIKE '%Earth%2013%'
    OR cl.cl_to LIKE '%2013%Earth%'
    OR cl.cl_to LIKE '%Wiki_Loves_Earth%2013%'
    OR cl.cl_to LIKE '%Earth%Wiki_Loves%2013%'
    OR (cl.cl_to LIKE '%Earth%' AND cl.cl_to LIKE '%2013%')
  )
  AND (
    cl.cl_to REGEXP '2013'
    OR cl.cl_to LIKE '%_2013'
    OR cl.cl_to LIKE '%_2013_%'
    OR cl.cl_to LIKE '2013_%'
  );

-- ============================================
-- ALTERNATIVE: Find what categories exist for 2013
-- ============================================
-- Run this first to see all Earth 2013 categories

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
    cl.cl_to LIKE '%Earth%2013%'
    OR cl.cl_to LIKE '%2013%Earth%'
    OR (cl.cl_to LIKE '%Earth%' AND cl.cl_to LIKE '%2013%')
  )
GROUP BY cl.cl_to
ORDER BY file_count DESC;

