-- ============================================
-- ALL WIKI LOVES CAMPAIGNS - COUNTRY DATA QUERIES
-- ============================================
-- Run these queries in Quarry (https://quarry.wmcloud.org)
-- Database: commonswiki_p
-- 
-- After running each query:
-- 1. Click "Download" and choose JSON format
-- 2. Save the file to quarry_data/ folder with the campaign name
-- 3. Run the processing script to update catalog.py
-- ============================================

-- ============================================
-- QUERY 1: WIKI LOVES AFRICA - All Years with Countries
-- ============================================
-- This query gets ALL country-level data for Wiki Loves Africa

SELECT 
    CAST(REGEXP_SUBSTR(cl.cl_to, '[0-9]{4}') AS UNSIGNED) AS year,
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            REPLACE(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', ' ')
        ELSE 'Global'
    END AS country,
    COUNT(DISTINCT p.page_title) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT p.page_title) AS images_used,
    0 AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id AND p.page_namespace = 6
LEFT JOIN image i ON i.img_name = p.page_title
LEFT JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Africa_%'
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Africa_%_in_%'
  )
  AND cl.cl_to REGEXP 'Wiki_Loves_Africa_[0-9]{4}'
GROUP BY year, country
HAVING year BETWEEN 2014 AND 2025 AND uploads > 0
ORDER BY year DESC, uploads DESC;


-- ============================================
-- QUERY 2: WIKI LOVES FOLKLORE - All Years with Countries
-- ============================================

SELECT 
    CAST(REGEXP_SUBSTR(cl.cl_to, '[0-9]{4}') AS UNSIGNED) AS year,
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            REPLACE(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', ' ')
        ELSE 'Global'
    END AS country,
    COUNT(DISTINCT p.page_title) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT p.page_title) AS images_used,
    0 AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id AND p.page_namespace = 6
LEFT JOIN image i ON i.img_name = p.page_title
LEFT JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Folklore_%'
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Folklore_%_in_%'
  )
  AND cl.cl_to REGEXP 'Wiki_Loves_Folklore_[0-9]{4}'
GROUP BY year, country
HAVING year BETWEEN 2020 AND 2025 AND uploads > 0
ORDER BY year DESC, uploads DESC;


-- ============================================
-- QUERY 3: WIKI SCIENCE COMPETITION - All Years with Countries
-- ============================================

SELECT 
    CAST(REGEXP_SUBSTR(cl.cl_to, '[0-9]{4}') AS UNSIGNED) AS year,
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            REPLACE(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', ' ')
        ELSE 'Global'
    END AS country,
    COUNT(DISTINCT p.page_title) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT p.page_title) AS images_used,
    0 AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id AND p.page_namespace = 6
LEFT JOIN image i ON i.img_name = p.page_title
LEFT JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE 'Images_from_Wiki_Science_Competition_%'
    OR cl.cl_to LIKE 'Images_from_Wiki_Science_Competition_%_in_%'
  )
  AND cl.cl_to REGEXP 'Science_Competition_[0-9]{4}'
GROUP BY year, country
HAVING year BETWEEN 2015 AND 2025 AND uploads > 0
ORDER BY year DESC, uploads DESC;


-- ============================================
-- QUERY 4: WIKI LOVES FOOD - All Years with Countries
-- ============================================

SELECT 
    CAST(REGEXP_SUBSTR(cl.cl_to, '[0-9]{4}') AS UNSIGNED) AS year,
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            REPLACE(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', ' ')
        ELSE 'Global'
    END AS country,
    COUNT(DISTINCT p.page_title) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT p.page_title) AS images_used,
    0 AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id AND p.page_namespace = 6
LEFT JOIN image i ON i.img_name = p.page_title
LEFT JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Food_%'
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Food_%_in_%'
  )
  AND cl.cl_to REGEXP 'Wiki_Loves_Food_[0-9]{4}'
GROUP BY year, country
HAVING year BETWEEN 2016 AND 2025 AND uploads > 0
ORDER BY year DESC, uploads DESC;


-- ============================================
-- QUERY 5: WIKI LOVES PUBLIC ART - All Years with Countries
-- ============================================

SELECT 
    CAST(REGEXP_SUBSTR(cl.cl_to, '[0-9]{4}') AS UNSIGNED) AS year,
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            REPLACE(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', ' ')
        ELSE 'Global'
    END AS country,
    COUNT(DISTINCT p.page_title) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT p.page_title) AS images_used,
    0 AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id AND p.page_namespace = 6
LEFT JOIN image i ON i.img_name = p.page_title
LEFT JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Public_Art_%'
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Public_Art_%_in_%'
  )
  AND cl.cl_to REGEXP 'Public_Art_[0-9]{4}'
GROUP BY year, country
HAVING year BETWEEN 2012 AND 2025 AND uploads > 0
ORDER BY year DESC, uploads DESC;


-- ============================================
-- QUERY 6: DISCOVER ALL WIKI LOVES CAMPAIGN CATEGORIES
-- ============================================
-- Use this to find what categories exist for any campaign

SELECT 
    cl.cl_to AS category_name,
    COUNT(*) AS file_count
FROM categorylinks cl
WHERE cl.cl_type = 'file'
  AND cl.cl_to LIKE 'Images_from_Wiki_Loves_%'
GROUP BY cl.cl_to
HAVING file_count > 10
ORDER BY cl.cl_to;


-- ============================================
-- INSTRUCTIONS:
-- ============================================
-- 1. Go to https://quarry.wmcloud.org
-- 2. Login with your Wikimedia account
-- 3. Select database: commonswiki_p
-- 4. Copy ONE query at a time and run it
-- 5. Download results as JSON
-- 6. Save to quarry_data/ folder:
--    - africa_country_data.json
--    - folklore_country_data.json
--    - science_country_data.json
--    - food_country_data.json
--    - public_art_country_data.json
-- 7. Run: python backend/scripts/process_all_country_data.py
-- ============================================

