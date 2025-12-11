-- ============================================
-- EARTH 2013 - TEST ALTERNATIVE DATE RANGES
-- ============================================
-- Test different date ranges to find which one gives ~275 new_uploaders
-- Database: commonswiki_p
-- ============================================

-- Test 1: May 1-31 only (current result: 98-101)
SELECT 
    'May 1-31 only' AS date_range,
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
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2013%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_2013%'
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2013_in_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_2013_in_%'
  )

UNION ALL

-- Test 2: May 1 - Dec 31 (current result: 101)
SELECT 
    'May 1 - Dec 31' AS date_range,
    COUNT(DISTINCT CASE
        WHEN u.user_registration >= '20130501000000'
            AND u.user_registration <= '20131231235959'
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
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2013_in_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_2013_in_%'
  )

UNION ALL

-- Test 3: April 1 - Dec 31 (maybe competition started earlier?)
SELECT 
    'April 1 - Dec 31' AS date_range,
    COUNT(DISTINCT CASE
        WHEN u.user_registration >= '20130401000000'
            AND u.user_registration <= '20131231235959'
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
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2013_in_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_2013_in_%'
  )

UNION ALL

-- Test 4: Jan 1 - Dec 31 (entire year)
SELECT 
    'Jan 1 - Dec 31 (entire year)' AS date_range,
    COUNT(DISTINCT CASE
        WHEN u.user_registration >= '20130101000000'
            AND u.user_registration <= '20131231235959'
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
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2013_in_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_2013_in_%'
  )

UNION ALL

-- Test 5: All uploaders (to see total)
SELECT 
    'Total uploaders' AS date_range,
    COUNT(DISTINCT a.actor_name) AS new_uploaders
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
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2013_in_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_2013_in_%'
  );

