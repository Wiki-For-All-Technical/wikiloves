-- ============================================
-- EARTH 2013 - INVESTIGATE NEW UPLOADERS
-- ============================================
-- This query helps understand why new_uploaders is 101 instead of 275
-- Let's check user registration dates for 2013 uploaders
-- Database: commonswiki_p
-- ============================================

-- Check distribution of user registration dates for 2013 uploaders
SELECT 
    CASE
        WHEN u.user_registration IS NULL THEN 'No registration date'
        WHEN u.user_registration < '20130501000000' THEN 'Before May 1, 2013'
        WHEN u.user_registration >= '20130501000000' AND u.user_registration <= '20130531235959' THEN 'May 1-31, 2013'
        WHEN u.user_registration >= '20130601000000' AND u.user_registration <= '20131231235959' THEN 'June 1 - Dec 31, 2013'
        WHEN u.user_registration >= '20140101000000' THEN 'After 2013'
        ELSE 'Other'
    END AS registration_period,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT i.img_name) AS uploads
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
GROUP BY registration_period
ORDER BY 
    CASE registration_period
        WHEN 'Before May 1, 2013' THEN 1
        WHEN 'May 1-31, 2013' THEN 2
        WHEN 'June 1 - Dec 31, 2013' THEN 3
        WHEN 'After 2013' THEN 4
        WHEN 'No registration date' THEN 5
        ELSE 6
    END;

