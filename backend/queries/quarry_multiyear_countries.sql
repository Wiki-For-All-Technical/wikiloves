-- ============================================
-- MULTI-YEAR COUNTRY BREAKDOWN QUERY TEMPLATE
-- ============================================
-- This query extracts ALL years of data with country breakdown in one query
-- Database: commonswiki_p
-- 
-- USAGE:
-- 1. Replace the category pattern (e.g., 'Images_from_Wiki_Loves_Monuments_%')
-- 2. Adjust date range if needed (currently covers 2010-2025)
-- 3. Run in Quarry and download as JSON
-- 4. Process with: python backend/scripts/process_multiyear_quarry.py <file.json>
-- ============================================

-- ============================================
-- TEMPLATE: Wiki Loves Monuments (All Years + Countries)
-- ============================================
-- Extracts year from category name and country from subcategories
-- Returns multiple rows per year (one per country)

SELECT 
    -- Extract year from main category
    CAST(SUBSTRING_INDEX(
        CASE 
            WHEN cl.cl_to LIKE '%_in_%' THEN
                SUBSTRING_INDEX(cl.cl_to, '_in_', 1)
            ELSE cl.cl_to
        END, '_', -1) AS UNSIGNED) AS year,
    -- Extract country from category name
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
                END, '_', -1) AS UNSIGNED), '0901000000')
            AND u.user_registration <= CONCAT(
                CAST(SUBSTRING_INDEX(
                    CASE 
                        WHEN cl.cl_to LIKE '%_in_%' THEN
                            SUBSTRING_INDEX(cl.cl_to, '_in_', 1)
                        ELSE cl.cl_to
                    END, '_', -1) AS UNSIGNED), '0930235959')
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
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Monuments_%'
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Monuments_%_in_%'
  )
  AND (
    cl.cl_to REGEXP 'Images_from_Wiki_Loves_Monuments_[0-9]{4}$'
    OR cl.cl_to REGEXP 'Images_from_Wiki_Loves_Monuments_[0-9]{4}_in_'
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
-- SIMPLIFIED VERSION: Using Timestamp for Year
-- ============================================
-- This version uses image upload timestamp to determine year
-- More reliable if category names vary

SELECT 
    YEAR(FROM_UNIXTIME(UNIX_TIMESTAMP(STR_TO_DATE(img.img_timestamp, '%Y%m%d%H%i%s')))) AS year,
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
  AND (
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Monuments_%'
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Monuments_%_in_%'
  )
  AND img.img_timestamp >= '20100901000000'
  AND img.img_timestamp <= '20250930235959'
GROUP BY year, country
ORDER BY year DESC, uploads DESC;

-- ============================================
-- GENERIC TEMPLATE FOR ANY CAMPAIGN
-- ============================================
-- Replace these values:
--   {CATEGORY_PATTERN} - e.g., 'Images_from_Wiki_Loves_Earth_%'
--   {START_YEAR} - e.g., 2013
--   {END_YEAR} - e.g., 2025

/*
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
                END, '_', -1) AS UNSIGNED), '{START_MONTH}{START_DAY}000000')
            AND u.user_registration <= CONCAT(
                CAST(SUBSTRING_INDEX(
                    CASE 
                        WHEN cl.cl_to LIKE '%_in_%' THEN
                            SUBSTRING_INDEX(cl.cl_to, '_in_', 1)
                        ELSE cl.cl_to
                    END, '_', -1) AS UNSIGNED), '{END_MONTH}{END_DAY}235959')
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
    cl.cl_to LIKE '{CATEGORY_PATTERN}'
    OR cl.cl_to LIKE '{CATEGORY_PATTERN}_in_%'
  )
  AND CAST(SUBSTRING_INDEX(
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            SUBSTRING_INDEX(cl.cl_to, '_in_', 1)
        ELSE cl.cl_to
    END, '_', -1) AS UNSIGNED) BETWEEN {START_YEAR} AND {END_YEAR}
GROUP BY year, country
ORDER BY year DESC, uploads DESC;
*/

-- ============================================
-- NOTES:
-- ============================================
-- 1. Year extraction: From main category name (before _in_ if present)
-- 2. Country extraction: From subcategory pattern (after _in_)
-- 3. Output: Multiple rows per year (one per country)
-- 4. Sorting: By year (desc) then uploads (desc) for easy reading
--
-- Expected JSON output format:
-- [
--   {"year": 2024, "country": "Italy", "uploads": 45000, "uploaders": 500, ...},
--   {"year": 2024, "country": "Germany", "uploads": 38000, "uploaders": 420, ...},
--   {"year": 2023, "country": "Italy", "uploads": 42000, "uploaders": 480, ...},
--   ...
-- ]
-- ============================================







