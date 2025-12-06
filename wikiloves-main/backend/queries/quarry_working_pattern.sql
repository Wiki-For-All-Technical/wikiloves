-- ============================================
-- WORKING Quarry Queries - Based on Proven Pattern
-- ============================================
-- This pattern works with the actual Commons database structure
-- Uses: categorylinks → page → image → actor_image
-- 
-- Database: commonswiki_p
-- IMPORTANT: Replace 2024 and category name as needed!
-- ============================================

-- ============================================
-- QUERY 1: Wiki Loves Monuments - Uploads by User
-- ============================================
-- Replace 'Images_from_Wiki_Loves_Monuments_2024' with actual category name
-- This gives you uploads per user

SELECT 
    COUNT(a.actor_name) AS uploads,
    a.actor_name AS uploader,
    a.actor_user AS user_id
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024'
GROUP BY a.actor_name, a.actor_user
ORDER BY uploads DESC;

-- ============================================
-- QUERY 2: Wiki Loves Monuments - Overall Statistics
-- ============================================
-- Gets total uploads, unique uploaders, and images used

SELECT 
    COUNT(DISTINCT i.img_name) AS total_uploads,
    COUNT(DISTINCT a.actor_name) AS total_uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024';

-- ============================================
-- QUERY 3: Wiki Loves Monuments - With New Uploaders
-- ============================================
-- Includes new uploaders (registered during campaign period)

SELECT 
    COUNT(DISTINCT i.img_name) AS total_uploads,
    COUNT(DISTINCT a.actor_name) AS total_uploaders,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240901000000'
            AND u.user_registration <= '20240930235959'
        THEN a.actor_name
    END) AS new_uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN user u ON a.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024';

-- ============================================
-- QUERY 4: Discover Available Categories
-- ============================================
-- Run this FIRST to find exact category names

SELECT DISTINCT cl.cl_to AS category_name
FROM categorylinks cl
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves%2024%'
    OR cl.cl_to LIKE '%Monuments%2024%'
    OR cl.cl_to LIKE '%Earth%2024%'
    OR cl.cl_to LIKE '%Africa%2024%'
  )
ORDER BY cl.cl_to
LIMIT 100;

-- ============================================
-- QUERY 5: Generic Template - Customize for Any Campaign
-- ============================================
-- Replace:
--   'Images_from_Wiki_Loves_Monuments_2024' with your category name
--   '20240901000000' and '20240930235959' with campaign dates

SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240901000000'
            AND u.user_registration <= '20240930235959'
        THEN a.actor_name
    END) AS new_uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN user u ON a.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024';

-- ============================================
-- QUERY 6: Uploads by Month (Trend Analysis)
-- ============================================
-- Shows uploads per month for trend visualization

SELECT 
    DATE_FORMAT(i.img_timestamp, '%Y-%m') AS month,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024'
GROUP BY DATE_FORMAT(i.img_timestamp, '%Y-%m')
ORDER BY month;

-- ============================================
-- QUERY 7: Multiple Categories (if campaign uses multiple)
-- ============================================
-- Use this if a campaign has multiple category patterns

SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024'
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Monuments_2024_in_%'
    OR cl.cl_to = 'Wiki_Loves_Monuments_2024'
  );

-- ============================================
-- NOTES:
-- ============================================
-- Key Pattern:
--   1. Start with categorylinks (cl) - has the category info
--   2. Join to page (p) - links category to page
--   3. Join to image (i) - matches page title to image name
--   4. Join to actor_image (a) - gets user info
--   5. Optionally join to user (u) - for registration dates
--
-- Important Filters:
--   - p.page_namespace = 6 (File namespace)
--   - p.page_is_redirect = 0 (Not a redirect)
--   - cl.cl_type = 'file' (File category)
--
-- Steps:
--   1. Run QUERY 4 to discover exact category names
--   2. Use the category name in other queries
--   3. Export results as CSV
--   4. Process with: python backend/queries/process_quarry_results.py <export_dir>







