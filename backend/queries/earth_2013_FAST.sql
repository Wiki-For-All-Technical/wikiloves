-- ============================================
-- EARTH 2013 - FAST QUERY (OPTIMIZED)
-- ============================================
-- This query is optimized for faster execution
-- Strategy: Use specific patterns that can use indexes
-- ============================================

-- STEP 1: First, find all Earth 2013 categories (FAST - runs in seconds)
-- Run this first to see what categories exist, then use STEP 2

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
    OR cl.cl_to = 'Images_from_Wiki_Loves_Earth_2013'
    OR cl.cl_to = 'Wiki_Loves_Earth_2013'
  )
GROUP BY cl.cl_to
ORDER BY file_count DESC
LIMIT 50;

-- ============================================
-- STEP 2: Once you know the category names, use this (FAST)
-- Replace the category names with actual ones from STEP 1
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
    -- Add specific category names here (from STEP 1 results)
    cl.cl_to = 'Images_from_Wiki_Loves_Earth_2013'
    OR cl.cl_to = 'Wiki_Loves_Earth_2013'
    -- Add more specific categories as needed
  );

-- ============================================
-- STEP 3: Alternative - Use REGEXP (faster than multiple LIKE)
-- ============================================

SELECT 
    2013 AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT i.img_name) AS images_used,  -- Approximation
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
  AND cl.cl_to REGEXP '^(Images_from_)?Wiki_Loves_Earth.*2013'
GROUP BY year;

