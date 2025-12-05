-- ============================================
-- FIXED Quarry Queries for Wiki Loves Campaigns
-- ============================================
-- These queries use the correct Commons database schema
-- Database: commonswiki_p
-- 
-- IMPORTANT: Replace 2024 with your actual year before running!
-- ============================================

-- ============================================
-- QUERY 1: Wiki Loves Monuments - Overall Statistics
-- ============================================
-- Replace 2024 with the actual year
-- Monuments typically runs in September

SELECT 
    COUNT(*) AS uploads,
    COUNT(DISTINCT COALESCE(user.user_name, CAST(img.img_user AS CHAR))) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks 
            WHERE il_from = img.img_id
        ) THEN img.img_id 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN user.user_registration >= '20240901000000'
            AND user.user_registration <= '20240930235959'
        THEN COALESCE(user.user_name, CAST(img.img_user AS CHAR))
    END) AS new_uploaders
FROM image img
LEFT JOIN user ON img.img_user = user.user_id
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= '20240901000000'
  AND img.img_timestamp <= '20240930235959'
  AND (
    cl.cl_to LIKE '%Images_from_Wiki_Loves_Monuments_2024%'
    OR cl.cl_to LIKE '%Wiki_Loves_Monuments_2024%'
    OR cl.cl_to LIKE '%Images_from_Wiki_Loves_Monuments_2024_in_%'
  );

-- ============================================
-- QUERY 2: Wiki Loves Earth - Overall Statistics
-- ============================================
-- Replace 2024 with the actual year
-- Earth typically runs in May

SELECT 
    COUNT(*) AS uploads,
    COUNT(DISTINCT COALESCE(user.user_name, CAST(img.img_user AS CHAR))) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks 
            WHERE il_from = img.img_id
        ) THEN img.img_id 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN user.user_registration >= '20240501000000'
            AND user.user_registration <= '20240531235959'
        THEN COALESCE(user.user_name, CAST(img.img_user AS CHAR))
    END) AS new_uploaders
FROM image img
LEFT JOIN user ON img.img_user = user.user_id
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= '20240501000000'
  AND img.img_timestamp <= '20240531235959'
  AND (
    cl.cl_to LIKE '%Images_from_Wiki_Loves_Earth_2024%'
    OR cl.cl_to LIKE '%Wiki_Loves_Earth_2024%'
    OR cl.cl_to LIKE '%Images_from_Wiki_Loves_Earth_2024_in_%'
  );

-- ============================================
-- QUERY 3: Wiki Loves Africa - Overall Statistics
-- ============================================
-- Replace 2024 with the actual year
-- Africa typically runs in March

SELECT 
    COUNT(*) AS uploads,
    COUNT(DISTINCT COALESCE(user.user_name, CAST(img.img_user AS CHAR))) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks 
            WHERE il_from = img.img_id
        ) THEN img.img_id 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN user.user_registration >= '20240301000000'
            AND user.user_registration <= '20240331235959'
        THEN COALESCE(user.user_name, CAST(img.img_user AS CHAR))
    END) AS new_uploaders
FROM image img
LEFT JOIN user ON img.img_user = user.user_id
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= '20240301000000'
  AND img.img_timestamp <= '20240331235959'
  AND (
    cl.cl_to LIKE '%Images_from_Wiki_Loves_Africa_2024%'
    OR cl.cl_to LIKE '%Wiki_Loves_Africa_2024%'
    OR cl.cl_to LIKE '%Images_from_Wiki_Loves_Africa_2024_in_%'
  );

-- ============================================
-- QUERY 4: Wiki Loves Folklore - Overall Statistics
-- ============================================
-- Replace 2024 with the actual year
-- Folklore typically runs in February

SELECT 
    COUNT(*) AS uploads,
    COUNT(DISTINCT COALESCE(user.user_name, CAST(img.img_user AS CHAR))) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks 
            WHERE il_from = img.img_id
        ) THEN img.img_id 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN user.user_registration >= '20240201000000'
            AND user.user_registration <= '20240228235959'
        THEN COALESCE(user.user_name, CAST(img.img_user AS CHAR))
    END) AS new_uploaders
FROM image img
LEFT JOIN user ON img.img_user = user.user_id
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= '20240201000000'
  AND img.img_timestamp <= '20240228235959'
  AND (
    cl.cl_to LIKE '%Images_from_Wiki_Loves_Folklore_2024%'
    OR cl.cl_to LIKE '%Wiki_Loves_Folklore_2024%'
    OR cl.cl_to LIKE '%Images_from_Wiki_Loves_Folklore_2024_in_%'
  );

-- ============================================
-- QUERY 5: Discover Available Categories
-- ============================================
-- Use this FIRST to see what categories actually exist
-- Replace 2024 and 'Monuments' as needed

SELECT DISTINCT cl.cl_to AS category_name
FROM categorylinks cl
WHERE (
    cl.cl_to LIKE '%Wiki_Loves%2024%'
    OR cl.cl_to LIKE '%Monuments%2024%'
)
ORDER BY cl.cl_to
LIMIT 100;

-- ============================================
-- QUERY 6: Generic Template (Customize for any campaign)
-- ============================================
-- Replace:
--   '2024' with year (appears 4 times)
--   '0501' with start month/day
--   '0531' with end month/day  
--   'Earth' with campaign name
--   'earth' with campaign prefix (lowercase)

SELECT 
    COUNT(*) AS uploads,
    COUNT(DISTINCT COALESCE(user.user_name, CAST(img.img_user AS CHAR))) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks 
            WHERE il_from = img.img_id
        ) THEN img.img_id 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN user.user_registration >= '20240501000000'
            AND user.user_registration <= '20240531235959'
        THEN COALESCE(user.user_name, CAST(img.img_user AS CHAR))
    END) AS new_uploaders
FROM image img
LEFT JOIN user ON img.img_user = user.user_id
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= '20240501000000'
  AND img.img_timestamp <= '20240531235959'
  AND (
    cl.cl_to LIKE '%Images_from_Wiki_Loves_Earth_2024%'
    OR cl.cl_to LIKE '%Wiki_Loves_Earth_2024%'
    OR cl.cl_to LIKE '%Images_from_Wiki_Loves_Earth_2024_in_%'
  );

-- ============================================
-- NOTES:
-- ============================================
-- 1. The Commons database uses:
--    - image table: img_id, img_user (ID), img_timestamp, img_name
--    - user table: user_id, user_name, user_registration
--    - categorylinks table: cl_from (image ID), cl_to (category name)
--    - imagelinks table: il_from (image ID) - indicates image is used
--
-- 2. Country detection is complex - these queries give overall stats.
--    For country breakdown, you may need campaign-specific tracking data.
--
-- 3. Always run QUERY 5 first to discover actual category names.
--
-- 4. Export results as CSV, then process with:
--    python backend/queries/process_quarry_results.py <export_dir>
--
-- 5. File naming: campaignprefix_year.csv (e.g., monuments_2024.csv)









