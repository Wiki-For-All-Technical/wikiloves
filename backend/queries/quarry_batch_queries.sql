-- ============================================
-- BATCH QUARRY QUERIES FOR WIKI LOVES CAMPAIGNS
-- ============================================
-- This file contains ready-to-use SQL queries for batch processing
-- Database: commonswiki_p
-- 
-- USAGE:
-- 1. Copy the query you need for a campaign/year
-- 2. Replace YEAR (2024) with your actual year (appears in dates and category names)
-- 3. Adjust date ranges based on campaign dates
-- 4. Run in Quarry and download as JSON
-- 5. Save file as: {campaign_prefix}_{year}.json (e.g., monuments_2024.json)
-- 6. Process all files: python backend/queries/process_quarry_results.py quarry_data
-- ============================================

-- ============================================
-- PART 1: SUMMARY QUERIES (Totals Only)
-- ============================================
-- These return: uploads, uploaders, images_used, new_uploaders
-- Use these for quick data entry or when country breakdown isn't needed
-- ============================================

-- ============================================
-- SUMMARY 1: Wiki Loves Monuments
-- ============================================
-- Campaign prefix: monuments
-- Typical dates: September (replace 202409 with your year/month)
-- Category: Images_from_Wiki_Loves_Monuments_2024

SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240901000000'
            AND u.user_registration <= '20240930235959'
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
  AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024';

-- ============================================
-- SUMMARY 2: Wiki Loves Earth
-- ============================================
-- Campaign prefix: earth
-- Typical dates: May (replace 202405 with your year/month)
-- Category: Images_from_Wiki_Loves_Earth_2024

SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240501000000'
            AND u.user_registration <= '20240531235959'
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
  AND cl.cl_to = 'Images_from_Wiki_Loves_Earth_2024';

-- ============================================
-- SUMMARY 3: Wiki Loves Africa
-- ============================================
-- Campaign prefix: africa
-- Typical dates: March (replace 202403 with your year/month)
-- Category: Images_from_Wiki_Loves_Africa_2024

SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240301000000'
            AND u.user_registration <= '20240331235959'
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
  AND cl.cl_to = 'Images_from_Wiki_Loves_Africa_2024';

-- ============================================
-- SUMMARY 4: Wiki Loves Folklore
-- ============================================
-- Campaign prefix: folklore
-- Typical dates: February (replace 202402 with your year/month)
-- Category: Images_from_Wiki_Loves_Folklore_2024

SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240201000000'
            AND u.user_registration <= '20240228235959'
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
  AND cl.cl_to = 'Images_from_Wiki_Loves_Folklore_2024';

-- ============================================
-- PART 2: COUNTRY-LEVEL QUERIES
-- ============================================
-- These return breakdown by country
-- Required columns: country, uploads, uploaders, images_used, new_uploaders
-- ============================================

-- ============================================
-- COUNTRY 1: Wiki Loves Monuments (by Country)
-- ============================================
-- File name: monuments_2024.json
-- Extracts country from category names like: Images_from_Wiki_Loves_Monuments_2024_in_Italy

SELECT 
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
        WHEN u.user_registration >= '20240901000000'
            AND u.user_registration <= '20240930235959'
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
    cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024'
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Monuments_2024_in_%'
  )
  AND i.img_timestamp >= '20240901000000'
  AND i.img_timestamp <= '20240930235959'
GROUP BY country
ORDER BY uploads DESC;

-- ============================================
-- COUNTRY 2: Wiki Loves Earth (by Country)
-- ============================================
-- File name: earth_2024.json

SELECT 
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
        WHEN u.user_registration >= '20240501000000'
            AND u.user_registration <= '20240531235959'
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
    cl.cl_to = 'Images_from_Wiki_Loves_Earth_2024'
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2024_in_%'
  )
  AND i.img_timestamp >= '20240501000000'
  AND i.img_timestamp <= '20240531235959'
GROUP BY country
ORDER BY uploads DESC;

-- ============================================
-- COUNTRY 3: Wiki Loves Africa (by Country)
-- ============================================
-- File name: africa_2024.json

SELECT 
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
        WHEN u.user_registration >= '20240301000000'
            AND u.user_registration <= '20240331235959'
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
    cl.cl_to = 'Images_from_Wiki_Loves_Africa_2024'
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Africa_2024_in_%'
  )
  AND i.img_timestamp >= '20240301000000'
  AND i.img_timestamp <= '20240331235959'
GROUP BY country
ORDER BY uploads DESC;

-- ============================================
-- COUNTRY 4: Wiki Loves Folklore (by Country)
-- ============================================
-- File name: folklore_2024.json

SELECT 
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
        WHEN u.user_registration >= '20240201000000'
            AND u.user_registration <= '20240228235959'
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
    cl.cl_to = 'Images_from_Wiki_Loves_Folklore_2024'
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Folklore_2024_in_%'
  )
  AND i.img_timestamp >= '20240201000000'
  AND i.img_timestamp <= '20240228235959'
GROUP BY country
ORDER BY uploads DESC;

-- ============================================
-- GENERIC TEMPLATE: For Any Campaign/Year
-- ============================================
-- Copy this template and replace:
--   {YEAR} - Replace with year (4 digits)
--   {CATEGORY} - Replace with exact category name from Commons
--   {START_DATE} - Replace with start date (YYYYMMDDHHMMSS)
--   {END_DATE} - Replace with end date (YYYYMMDDHHMMSS)
--   {PREFIX} - Campaign prefix for file naming (e.g., "monuments", "earth")

-- SUMMARY TEMPLATE:
/*
SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '{START_DATE}'
            AND u.user_registration <= '{END_DATE}'
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
  AND cl.cl_to = '{CATEGORY}';
*/

-- COUNTRY TEMPLATE:
/*
SELECT 
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
        WHEN u.user_registration >= '{START_DATE}'
            AND u.user_registration <= '{END_DATE}'
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
    cl.cl_to = '{CATEGORY}'
    OR cl.cl_to LIKE '{CATEGORY}_in_%'
  )
  AND i.img_timestamp >= '{START_DATE}'
  AND i.img_timestamp <= '{END_DATE}'
GROUP BY country
ORDER BY uploads DESC;
*/

-- ============================================
-- FILE NAMING GUIDE
-- ============================================
-- Files must be named: {campaign_prefix}_{year}.json
-- 
-- Examples:
--   monuments_2024.json
--   earth_2023.json
--   africa_2024.json
--   folklore_2022.json
--
-- Campaign prefixes (from campaigns_metadata.py):
--   monuments, earth, folklore, africa, science, public_art,
--   food, women, birds, fashion, film, pride, sport, etc.
-- ============================================

