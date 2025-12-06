-- ============================================
-- FIND ALL EARTH 2013 CATEGORIES
-- ============================================
-- This query finds all categories that contain Earth 2013 data
-- Run this first to see what categories we're missing
-- ============================================

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
    OR cl.cl_to LIKE '%Wiki_Loves_Earth%2013%'
  )
GROUP BY cl.cl_to
ORDER BY file_count DESC
LIMIT 50;



