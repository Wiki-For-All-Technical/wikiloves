-- ============================================
-- EARTH 2013 AND 2014 - OPTIMIZED FIX QUERIES
-- ============================================
-- These queries are optimized to find ALL categories for 2013 and 2014
-- Use specific patterns that can use indexes for faster execution
-- Database: commonswiki_p
-- ============================================

-- ============================================
-- EARTH 2013 - COMPREHENSIVE QUERY
-- ============================================
-- This query finds ALL Earth 2013 data including country-specific categories
-- Based on findings: Images_from_Wiki_Loves_Earth_2013_in_Ukraine (11,732 files)

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
    -- Main patterns (indexed, fast)
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2013%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_2013%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_%_2013'
    -- Country-specific patterns
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2013_in_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_2013_in_%'
  )
GROUP BY year;

-- ============================================
-- EARTH 2014 - COMPREHENSIVE QUERY
-- ============================================
-- This query finds ALL Earth 2014 data including country-specific categories

SELECT 
    2014 AS year,
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
        WHEN u.user_registration >= '20140501000000'
            AND u.user_registration <= '20140531235959'
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
    -- Main patterns (indexed, fast)
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2014%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_2014%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_%_2014'
    -- Country-specific patterns
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2014_in_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_2014_in_%'
  )
GROUP BY year;

-- ============================================
-- ALTERNATIVE: Combined query for both years
-- ============================================
-- Use this if you want both years in one result set

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
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
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2013%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_2013%'
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2014%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_2014%'
  )
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) IN (2013, 2014)
GROUP BY year
ORDER BY year DESC;

