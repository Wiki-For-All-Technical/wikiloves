-- ============================================
-- CORRECT Quarry Queries for Wiki Loves Campaigns
-- ============================================
-- Based on actual Commons database schema:
-- - image table uses img_actor (not img_user)
-- - actor table links to user table
-- - actor.actor_name gives username directly
-- 
-- Database: commonswiki_p
-- IMPORTANT: Replace 2024 with your actual year!
-- ============================================

-- ============================================
-- QUERY 1: Wiki Loves Monuments - Complete Statistics
-- ============================================
-- Replace 2024 with actual year (appears 4 times in dates)
-- Monuments typically runs in September

SELECT 
    COUNT(*) AS uploads,
    COUNT(DISTINCT actor.actor_name) AS uploaders,
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
        THEN actor.actor_name
    END) AS new_uploaders
FROM image img
INNER JOIN actor ON img.img_actor = actor.actor_id
LEFT JOIN user ON actor.actor_user = user.user_id
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= '20240901000000'
  AND img.img_timestamp <= '20240930235959'
  AND (
    cl.cl_to LIKE '%Images_from_Wiki_Loves_Monuments_2024%'
    OR cl.cl_to LIKE '%Wiki_Loves_Monuments_2024%'
    OR cl.cl_to LIKE '%Images_from_Wiki_Loves_Monuments_2024_in_%'
  );

-- ============================================
-- QUERY 2: Wiki Loves Earth - Complete Statistics
-- ============================================
-- Replace 2024 with actual year
-- Earth typically runs in May

SELECT 
    COUNT(*) AS uploads,
    COUNT(DISTINCT actor.actor_name) AS uploaders,
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
        THEN actor.actor_name
    END) AS new_uploaders
FROM image img
INNER JOIN actor ON img.img_actor = actor.actor_id
LEFT JOIN user ON actor.actor_user = user.user_id
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= '20240501000000'
  AND img.img_timestamp <= '20240531235959'
  AND (
    cl.cl_to LIKE '%Images_from_Wiki_Loves_Earth_2024%'
    OR cl.cl_to LIKE '%Wiki_Loves_Earth_2024%'
    OR cl.cl_to LIKE '%Images_from_Wiki_Loves_Earth_2024_in_%'
  );

-- ============================================
-- QUERY 3: Wiki Loves Africa - Complete Statistics
-- ============================================
-- Replace 2024 with actual year
-- Africa typically runs in March

SELECT 
    COUNT(*) AS uploads,
    COUNT(DISTINCT actor.actor_name) AS uploaders,
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
        THEN actor.actor_name
    END) AS new_uploaders
FROM image img
INNER JOIN actor ON img.img_actor = actor.actor_id
LEFT JOIN user ON actor.actor_user = user.user_id
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= '20240301000000'
  AND img.img_timestamp <= '20240331235959'
  AND (
    cl.cl_to LIKE '%Images_from_Wiki_Loves_Africa_2024%'
    OR cl.cl_to LIKE '%Wiki_Loves_Africa_2024%'
    OR cl.cl_to LIKE '%Images_from_Wiki_Loves_Africa_2024_in_%'
  );

-- ============================================
-- QUERY 4: Wiki Loves Folklore - Complete Statistics
-- ============================================
-- Replace 2024 with actual year
-- Folklore typically runs in February

SELECT 
    COUNT(*) AS uploads,
    COUNT(DISTINCT actor.actor_name) AS uploaders,
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
        THEN actor.actor_name
    END) AS new_uploaders
FROM image img
INNER JOIN actor ON img.img_actor = actor.actor_id
LEFT JOIN user ON actor.actor_user = user.user_id
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= '20240201000000'
  AND img.img_timestamp <= '20240228235959'
  AND (
    cl.cl_to LIKE '%Images_from_Wiki_Loves_Folklore_2024%'
    OR cl.cl_to LIKE '%Wiki_Loves_Folklore_2024%'
    OR cl.cl_to LIKE '%Images_from_Wiki_Loves_Folklore_2024_in_%'
  );

-- ============================================
-- QUERY 5: Discover Categories (Run This First!)
-- ============================================
-- Use this to find exact category names before running main queries

SELECT DISTINCT cl.cl_to AS category_name
FROM categorylinks cl
WHERE cl.cl_to LIKE '%Wiki_Loves%2024%'
   OR cl.cl_to LIKE '%Monuments%2024%'
ORDER BY cl.cl_to
LIMIT 50;

-- ============================================
-- QUERY 6: Generic Template (Customize for any campaign)
-- ============================================
-- Replace:
--   '2024' with year (appears 4 times in dates)
--   '0501' with start month/day
--   '0531' with end month/day
--   'Earth' with campaign name in category patterns

SELECT 
    COUNT(*) AS uploads,
    COUNT(DISTINCT actor.actor_name) AS uploaders,
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
        THEN actor.actor_name
    END) AS new_uploaders
FROM image img
INNER JOIN actor ON img.img_actor = actor.actor_id
LEFT JOIN user ON actor.actor_user = user.user_id
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= '20240501000000'
  AND img.img_timestamp <= '20240531235959'
  AND (
    cl.cl_to LIKE '%Images_from_Wiki_Loves_Earth_2024%'
    OR cl.cl_to LIKE '%Wiki_Loves_Earth_2024%'
    OR cl.cl_to LIKE '%Images_from_Wiki_Loves_Earth_2024_in_%'
  );

-- ============================================
-- QUERY 7: Uploads by Month (Trend Analysis)
-- ============================================

SELECT 
    DATE_FORMAT(img.img_timestamp, '%Y-%m') AS month,
    COUNT(*) AS uploads,
    COUNT(DISTINCT actor.actor_name) AS uploaders
FROM image img
INNER JOIN actor ON img.img_actor = actor.actor_id
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
-- Schema Structure:
--   image.img_actor → actor.actor_id
--   actor.actor_user → user.user_id (if registered user)
--   actor.actor_name → username (works for all users)
--
-- Key Points:
-- 1. Always run QUERY 5 first to discover actual category names
-- 2. Replace 2024 with your actual year (4 times in each query)
-- 3. Adjust date ranges based on campaign dates
-- 4. Export results as CSV
-- 5. Process with: python backend/queries/process_quarry_results.py <export_dir>
--
-- File naming: campaignprefix_year.csv (e.g., monuments_2024.csv)



