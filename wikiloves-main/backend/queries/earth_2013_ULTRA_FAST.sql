-- ============================================
-- EARTH 2013 - ULTRA FAST QUERY
-- ============================================
-- This is the fastest approach: query specific known categories
-- Based on common Wiki Loves Earth category patterns
-- ============================================

SELECT 
    2013 AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT i.img_name) AS images_used,  -- Approximation (same as uploads)
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
    -- Most common patterns (indexed, fast)
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2013%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_2013%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_%_2013'
    -- Exact matches (fastest)
    OR cl.cl_to = 'Images_from_Wiki_Loves_Earth_2013'
    OR cl.cl_to = 'Wiki_Loves_Earth_2013'
  )
GROUP BY year;

-- ============================================
-- EVEN FASTER: If you know the exact category name
-- ============================================
-- Replace 'Images_from_Wiki_Loves_Earth_2013' with the actual category name

/*
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
  AND cl.cl_to = 'Images_from_Wiki_Loves_Earth_2013'  -- Exact match (fastest!)
GROUP BY year;
*/

