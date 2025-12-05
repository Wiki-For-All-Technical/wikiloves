-- ============================================
-- Wiki Loves Biodiversity - Quarry Queries (ALL YEARS)
-- ============================================
-- Database: commonswiki_p
-- Categories: Images_from_Wiki_Loves_Biodiversity_YYYY
-- Campaign Period: Varies by year (adjust dates as needed)
-- 
-- USAGE:
-- 1. For multi-year data: Use QUERY 1 (Multi-Year Summary)
-- 2. For single year: Use QUERY 2-6 with specific year
-- 3. Run in Quarry (may take several minutes for large datasets)
-- 4. Download as JSON
-- 5. Process with: python backend/scripts/process_multiyear_quarry.py <file.json> biodiversity
-- ============================================

-- ============================================
-- QUERY 1: Wiki Loves Biodiversity - Multi-Year Summary (ALL YEARS)
-- ============================================
-- Gets statistics for ALL years of Wiki Loves Biodiversity campaigns
-- Campaign prefix: biodiversity
-- File name: biodiversity_multiyear.json
-- This query extracts all years in one execution

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0101000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Biodiversity_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Biodiversity_%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;

-- ============================================
-- QUERY 2: Wiki Loves Biodiversity - Single Year Complete Statistics
-- ============================================
-- Gets total uploads, unique uploaders, images used, and new uploaders
-- Replace '2024' with the desired year

SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240101000000'
            AND u.user_registration <= '20241231235959'
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN user u ON a.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to = 'Images_from_Wiki_Loves_Biodiversity_2024'
    OR cl.cl_to = 'Wiki_Loves_Biodiversity_2024'
  );

-- ============================================
-- QUERY 3: Wiki Loves Biodiversity - Uploads by User (Single Year)
-- ============================================
-- Shows uploads per user, sorted by most uploads
-- Replace '2024' with the desired year

SELECT 
    COUNT(i.img_name) AS uploads,
    a.actor_name AS uploader,
    a.actor_user AS user_id
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to = 'Images_from_Wiki_Loves_Biodiversity_2024'
    OR cl.cl_to = 'Wiki_Loves_Biodiversity_2024'
  )
GROUP BY a.actor_name, a.actor_user
ORDER BY uploads DESC;

-- ============================================
-- QUERY 4: Wiki Loves Biodiversity - Uploads by Month (Single Year)
-- ============================================
-- Shows uploads per month for trend analysis
-- Replace '2024' with the desired year

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
  AND (
    cl.cl_to = 'Images_from_Wiki_Loves_Biodiversity_2024'
    OR cl.cl_to = 'Wiki_Loves_Biodiversity_2024'
  )
GROUP BY DATE_FORMAT(i.img_timestamp, '%Y-%m')
ORDER BY month;

-- ============================================
-- QUERY 5: Wiki Loves Biodiversity - Overall Statistics (Simplified, Single Year)
-- ============================================
-- Basic stats without new uploaders
-- Replace '2024' with the desired year

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
  AND (
    cl.cl_to = 'Images_from_Wiki_Loves_Biodiversity_2024'
    OR cl.cl_to = 'Wiki_Loves_Biodiversity_2024'
  );

-- ============================================
-- QUERY 6: Discover Wiki Loves Biodiversity Categories (ALL YEARS)
-- ============================================
-- Run this FIRST to find all available Wiki Loves Biodiversity categories

SELECT DISTINCT cl.cl_to AS category_name,
       COUNT(DISTINCT i.img_name) AS file_count
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Biodiversity%'
    OR cl.cl_to LIKE '%Biodiversity%Wiki_Loves%'
  )
GROUP BY cl.cl_to
ORDER BY file_count DESC;

-- ============================================
-- QUERY 7: Wiki Loves Biodiversity - Multiple Categories (if exists)
-- ============================================
-- Use this if Wiki Loves Biodiversity has multiple category patterns
-- Adjust category names based on QUERY 6 results

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
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Biodiversity_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Biodiversity_%'
    OR cl.cl_to LIKE '%Biodiversity%Wiki_Loves%'
  );

-- ============================================
-- QUERY 8: Wiki Loves Biodiversity - Country Breakdown (ALL YEARS)
-- ============================================
-- Returns country-level statistics for all years
-- Use this if Wiki Loves Biodiversity has country-specific categories

SELECT 
    CAST(SUBSTRING_INDEX(
        CASE 
            WHEN cl.cl_to LIKE '%_in_%' THEN
                SUBSTRING_INDEX(cl.cl_to, '_in_', 1)
            ELSE cl.cl_to
        END, '_', -1) AS UNSIGNED) AS year,
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            REPLACE(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', ' ')
        ELSE 'Global'
    END AS country,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(
            CAST(SUBSTRING_INDEX(
                CASE 
                    WHEN cl.cl_to LIKE '%_in_%' THEN
                        SUBSTRING_INDEX(cl.cl_to, '_in_', 1)
                    ELSE cl.cl_to
                END, '_', -1) AS UNSIGNED), '0101000000')
            AND u.user_registration <= CONCAT(
                CAST(SUBSTRING_INDEX(
                    CASE 
                        WHEN cl.cl_to LIKE '%_in_%' THEN
                            SUBSTRING_INDEX(cl.cl_to, '_in_', 1)
                        ELSE cl.cl_to
                    END, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Biodiversity_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Biodiversity_%'
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Biodiversity_%_in_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Biodiversity_%_in_%'
  )
  AND CAST(SUBSTRING_INDEX(
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            SUBSTRING_INDEX(cl.cl_to, '_in_', 1)
        ELSE cl.cl_to
    END, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year, country
ORDER BY year DESC, uploads DESC;

-- ============================================
-- QUERY 9: Wiki Loves Biodiversity - Uploads by Month (ALL YEARS)
-- ============================================
-- Shows uploads per month across all years for trend analysis

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
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
  AND (
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Biodiversity_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Biodiversity_%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year, DATE_FORMAT(i.img_timestamp, '%Y-%m')
ORDER BY year DESC, month;

-- ============================================
-- QUERY 10: Wiki Loves Biodiversity - Top Uploaders (ALL YEARS)
-- ============================================
-- Shows top uploaders across all years

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(i.img_name) AS uploads,
    a.actor_name AS uploader,
    a.actor_user AS user_id
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Biodiversity_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Biodiversity_%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year, a.actor_name, a.actor_user
ORDER BY year DESC, uploads DESC
LIMIT 100;

-- ============================================
-- QUERY 11: Wiki Loves Biodiversity - Images Used vs Total (ALL YEARS)
-- ============================================
-- Shows usage statistics across all years

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS total_uploads,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    ROUND(
        (COUNT(DISTINCT CASE 
            WHEN EXISTS (
                SELECT 1 FROM imagelinks il 
                WHERE il.il_from = p.page_id
            ) THEN i.img_name 
        END) * 100.0) / COUNT(DISTINCT i.img_name), 
        2
    ) AS usage_percentage
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Biodiversity_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Biodiversity_%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;

-- ============================================
-- QUERY 12: Wiki Loves Biodiversity - New vs Returning Uploaders (ALL YEARS)
-- ============================================
-- Shows new uploaders vs returning uploaders by year

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT a.actor_name) AS total_uploaders,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0101000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders,
    COUNT(DISTINCT a.actor_name) - COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0101000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS returning_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Biodiversity_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Biodiversity_%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;

-- ============================================
-- NOTES:
-- ============================================
-- MULTI-YEAR QUERIES:
-- 1. QUERY 1: Use this to get statistics for ALL years in one query
-- 2. QUERY 6: Run this FIRST to discover all available categories
-- 3. QUERY 8: Country breakdown across all years (if country categories exist)
-- 4. QUERY 9: Monthly trends across all years
-- 5. QUERY 10: Top uploaders across all years
-- 6. QUERY 11: Usage statistics (images used vs total)
-- 7. QUERY 12: New vs returning uploaders analysis
--
-- SINGLE-YEAR QUERIES:
-- 1. QUERY 2-5: Use these for specific year analysis
-- 2. Replace '2024' with desired year in category name
-- 3. Adjust registration date range based on actual campaign dates
--
-- GENERAL NOTES:
-- 1. Wiki Loves Biodiversity campaign dates vary by year
-- 2. Adjust the registration date range (0101000000 to 1231235959 = Jan 1-Dec 31)
--    based on actual campaign dates for each year
-- 3. The category name format may be:
--    - Images_from_Wiki_Loves_Biodiversity_YYYY
--    - Wiki_Loves_Biodiversity_YYYY
-- 4. Run QUERY 6 first to discover exact category names
-- 5. Export results as JSON from Quarry for multi-year queries
-- 6. Export results as CSV for single-year queries
-- 7. Process multi-year JSON with: python backend/scripts/process_multiyear_quarry.py <file.json> biodiversity
-- 8. Process single-year CSV with: python backend/queries/process_quarry_results.py <export_dir>
--
-- Database: commonswiki_p
-- Tables used:
--   - categorylinks (cl): Links files to categories
--   - page (p): Page information
--   - image (i): Image metadata
--   - actor_image (a): User/actor information for images
--   - actor: Actor table for user linking
--   - user (u): User registration dates
--   - imagelinks (il): Tracks image usage on pages

