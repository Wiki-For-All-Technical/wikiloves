-- ============================================
-- WIKI LOVES EARTH - CATEGORY DISCOVERY
-- ============================================
-- Run this query first to discover all available categories
-- Database: commonswiki_p
-- 
-- This will show you all category names that contain "Wiki Loves Earth"
-- Copy this into Quarry: https://quarry.wmcloud.org

SELECT DISTINCT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT cl.cl_from) AS file_count
FROM categorylinks cl
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Earth%'
    OR cl.cl_to LIKE '%Wiki_Loves_Earth_%'
    OR cl.cl_to LIKE '%Images_from_Wiki_Loves_Earth%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_%'
  )
GROUP BY cl.cl_to
ORDER BY cl.cl_to;
