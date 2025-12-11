-- ============================================
-- SIMPLE WORKING Quarry Queries for Wiki Loves
-- ============================================
-- These queries work with the actual Commons database schema
-- Database: commonswiki_p
-- 
-- IMPORTANT: Replace 2024 with your actual year!
-- ============================================

-- ============================================
-- STEP 1: First, check what columns exist in the image table
-- ============================================
-- Run this first to see the actual schema:

DESCRIBE image;

-- Or check a sample row:
SELECT * FROM image LIMIT 1;

-- ============================================
-- QUERY 1: Simple - Just count uploads by category
-- ============================================
-- This should work regardless of schema differences

SELECT 
    cl.cl_to AS category_name,
    COUNT(*) AS uploads
FROM image img
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= '20240901000000'
  AND img.img_timestamp <= '20240930235959'
  AND (
    cl.cl_to LIKE '%Images_from_Wiki_Loves_Monuments_2024%'
    OR cl.cl_to LIKE '%Wiki_Loves_Monuments_2024%'
  )
GROUP BY cl.cl_to
ORDER BY uploads DESC;

-- ============================================
-- QUERY 2: Get total uploads for a campaign
-- ============================================
-- Replace 2024 and adjust category patterns as needed

SELECT 
    COUNT(*) AS total_uploads,
    COUNT(DISTINCT img.img_name) AS unique_images
FROM image img
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= '20240901000000'
  AND img.img_timestamp <= '20240930235959'
  AND (
    cl.cl_to LIKE '%Images_from_Wiki_Loves_Monuments_2024%'
    OR cl.cl_to LIKE '%Wiki_Loves_Monuments_2024%'
    OR cl.cl_to LIKE '%Images_from_Wiki_Loves_Monuments_2024_in_%'
  );

-- ============================================
-- QUERY 3: Check if images are used (via imagelinks)
-- ============================================

SELECT 
    COUNT(*) AS total_uploads,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks 
            WHERE il_from = img.img_id
        ) THEN img.img_id 
    END) AS images_used
FROM image img
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= '20240901000000'
  AND img.img_timestamp <= '20240930235959'
  AND (
    cl.cl_to LIKE '%Images_from_Wiki_Loves_Monuments_2024%'
    OR cl.cl_to LIKE '%Wiki_Loves_Monuments_2024%'
  );

-- ============================================
-- QUERY 4: Discover categories (run this first!)
-- ============================================
-- Use this to find the exact category names

SELECT DISTINCT cl.cl_to AS category_name
FROM categorylinks cl
WHERE cl.cl_to LIKE '%Wiki_Loves%2024%'
   OR cl.cl_to LIKE '%Monuments%2024%'
ORDER BY cl.cl_to
LIMIT 50;

-- ============================================
-- QUERY 5: Get uploads by month (trend analysis)
-- ============================================

SELECT 
    DATE_FORMAT(img.img_timestamp, '%Y-%m') AS month,
    COUNT(*) AS uploads
FROM image img
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= '20240901000000'
  AND img.img_timestamp <= '20240930235959'
  AND (
    cl.cl_to LIKE '%Images_from_Wiki_Loves_Monuments_2024%'
    OR cl.cl_to LIKE '%Wiki_Loves_Monuments_2024%'
  )
GROUP BY DATE_FORMAT(img.img_timestamp, '%Y-%m')
ORDER BY month;

-- ============================================
-- NOTES:
-- ============================================
-- 1. Start with QUERY 4 to discover actual category names
-- 2. Then use QUERY 2 to get basic statistics
-- 3. The user/uploader information requires knowing the exact
--    schema - run DESCRIBE image; first to see available columns
-- 4. For now, these queries give you upload counts which is
--    the most important statistic
-- 5. Once you know the schema, we can add user/uploader stats









