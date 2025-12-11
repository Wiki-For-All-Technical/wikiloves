-- ============================================
-- EARTH 2013 - FIXED QUERY (STANDALONE)
-- ============================================
-- This query specifically targets 2013 with the correct date range
-- Should return ~275 new_uploaders (not 100)
-- Database: commonswiki_p
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
        -- FIXED: May 1 - Dec 31 (not just May 1-31)
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
    -- All possible 2013 patterns
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2013%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_2013%'
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2013_in_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_2013_in_%'
    OR cl.cl_to LIKE 'Images_from_WLE_2013%'
    OR cl.cl_to LIKE 'WLE_2013%'
  )
GROUP BY year;

-- Expected results:
-- uploads: ~11,736
-- uploaders: ~392
-- new_uploaders: ~275 (not 100!)

