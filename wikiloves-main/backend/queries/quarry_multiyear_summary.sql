-- ============================================
-- MULTI-YEAR SUMMARY QUERY TEMPLATE
-- ============================================
-- This query extracts ALL years of data for a campaign in one query
-- Database: commonswiki_p
-- 
-- USAGE:
-- 1. Replace the category pattern (e.g., 'Images_from_Wiki_Loves_Monuments_%')
-- 2. Adjust date range if needed (currently covers 2010-2025)
-- 3. Run in Quarry and download as JSON
-- 4. Process with: python backend/scripts/process_multiyear_quarry.py <file.json>
-- ============================================

-- ============================================
-- TEMPLATE: Wiki Loves Monuments (All Years)
-- ============================================
-- Extracts year from category name pattern: Images_from_Wiki_Loves_Monuments_YYYY
-- Returns one row per year with totals

SELECT 
    -- Extract year from category name (last 4 digits)
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
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0901000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0930235959')
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
  AND cl.cl_to LIKE 'Images_from_Wiki_Loves_Monuments_%'
  AND cl.cl_to REGEXP 'Images_from_Wiki_Loves_Monuments_[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;

-- ============================================
-- ALTERNATIVE: Extract Year from Timestamp
-- ============================================
-- Use this if category names don't consistently include year
-- This version extracts year from image upload timestamp

SELECT 
    YEAR(FROM_UNIXTIME(UNIX_TIMESTAMP(STR_TO_DATE(img.img_timestamp, '%Y%m%d%H%i%s')))) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN YEAR(FROM_UNIXTIME(UNIX_TIMESTAMP(STR_TO_DATE(u.user_registration, '%Y%m%d%H%i%s')))) = 
             YEAR(FROM_UNIXTIME(UNIX_TIMESTAMP(STR_TO_DATE(img.img_timestamp, '%Y%m%d%H%i%s'))))
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
  AND cl.cl_to LIKE 'Images_from_Wiki_Loves_Monuments_%'
  AND img.img_timestamp >= '20100901000000'
  AND img.img_timestamp <= '20250930235959'
GROUP BY year
ORDER BY year DESC;

-- ============================================
-- GENERIC TEMPLATE FOR ANY CAMPAIGN
-- ============================================
-- Replace these values:
--   {CATEGORY_PATTERN} - e.g., 'Images_from_Wiki_Loves_Earth_%'
--   {START_YEAR} - e.g., 2013
--   {END_YEAR} - e.g., 2025
--   {START_MONTH} - Campaign start month (e.g., 05 for May)
--   {END_MONTH} - Campaign end month (e.g., 05 for May)
--   {START_DAY} - Campaign start day (e.g., 01)
--   {END_DAY} - Campaign end day (e.g., 31)

/*
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
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '{START_MONTH}{START_DAY}000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '{END_MONTH}{END_DAY}235959')
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
  AND cl.cl_to LIKE '{CATEGORY_PATTERN}'
  AND cl.cl_to REGEXP '{CATEGORY_PATTERN}[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN {START_YEAR} AND {END_YEAR}
GROUP BY year
ORDER BY year DESC;
*/

-- ============================================
-- NOTES:
-- ============================================
-- 1. Year extraction: Uses SUBSTRING_INDEX to get last part of category name
-- 2. Pattern matching: REGEXP ensures we only match 4-digit years
-- 3. Date range: BETWEEN clause filters years (adjust as needed)
-- 4. New uploaders: Calculated based on registration date matching campaign year
-- 5. Output: One row per year, sorted descending (newest first)
--
-- Expected JSON output format:
-- [
--   {"year": 2024, "uploads": 239104, "uploaders": 4358, "images_used": 239104, "new_uploaders": 0},
--   {"year": 2023, "uploads": 217420, "uploaders": 4694, "images_used": 29877, "new_uploaders": 0},
--   ...
-- ]
-- ============================================

