-- ============================================
-- CAMPAIGN-LEVEL QUERIES (NO COUNTRY BREAKDOWN)
-- ============================================
-- These queries get statistics for campaigns at the campaign level only
-- (excluding country-specific categories like "Images_from_Wiki_Loves_Earth_2025_in_Ukraine")
-- Database: commonswiki_p (Quarry / Toolforge replica)
-- ============================================

-- ============================================
-- 1. WIKI SCIENCE COMPETITION (WL SCIENCE)
-- ============================================
SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    'Wiki Science Competition' AS campaign,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1101000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
LEFT JOIN actor act ON a.actor_id = act.actor_id
LEFT JOIN user u ON act.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE 'Wiki_Science_Competition_%'
    OR cl.cl_to LIKE 'Images_from_Wiki_Science_Competition_%'
  )
  AND cl.cl_to NOT LIKE '%_in_%'
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;

-- ============================================
-- 2. WIKI LOVES FOLKLORE (WL FOLKLORE)
-- ============================================
SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    'Wiki Loves Folklore' AS campaign,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0201000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0228235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
LEFT JOIN actor act ON a.actor_id = act.actor_id
LEFT JOIN user u ON act.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Folklore_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Folklore_%'
  )
  AND cl.cl_to NOT LIKE '%_in_%'
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;

-- ============================================
-- 3. WIKI LOVES AFRICA (WL AFRICA)
-- ============================================
SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    'Wiki Loves Africa' AS campaign,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0331235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
LEFT JOIN actor act ON a.actor_id = act.actor_id
LEFT JOIN user u ON act.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Africa_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Africa_%'
  )
  AND cl.cl_to NOT LIKE '%_in_%'
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;

-- ============================================
-- 4. WIKI LOVES FOOD (WL FOOD)
-- ============================================
SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    'Wiki Loves Food' AS campaign,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0701000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0831235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
LEFT JOIN actor act ON a.actor_id = act.actor_id
LEFT JOIN user u ON act.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to LIKE 'Images_from_Wiki_Loves_Food_%'
  AND cl.cl_to NOT LIKE '%_in_%'
  AND cl.cl_to REGEXP 'Images_from_Wiki_Loves_Food_[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;

-- ============================================
-- 5. WIKI LOVES PUBLIC ART (WL PUBLIC ART)
-- ============================================
SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    'Wiki Loves Public Art' AS campaign,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0501000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0631235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
LEFT JOIN actor act ON a.actor_id = act.actor_id
LEFT JOIN user u ON act.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Public_Art_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Public_Art_%'
  )
  AND cl.cl_to NOT LIKE '%_in_%'
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;

-- ============================================
-- 6. WIKI LOVES EARTH (WL EARTH)
-- ============================================
SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    'Wiki Loves Earth' AS campaign,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0501000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0531235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
LEFT JOIN actor act ON a.actor_id = act.actor_id
LEFT JOIN user u ON act.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_%'
  )
  AND cl.cl_to NOT LIKE '%_in_%'
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;

-- ============================================
-- 7. WIKI LOVES MONUMENTS (WL MONUMENTS)
-- ============================================
-- Note: Wiki Loves Monuments typically has country breakdowns,
-- but this query gets campaign-level totals only
SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    'Wiki Loves Monuments' AS campaign,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0901000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0931235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
LEFT JOIN actor act ON a.actor_id = act.actor_id
LEFT JOIN user u ON act.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Monuments_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Monuments_%'
  )
  AND cl.cl_to NOT LIKE '%_in_%'
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;

-- ============================================
-- COMBINED QUERY: ALL 7 CAMPAIGNS IN ONE
-- ============================================
-- This query combines all campaigns into a single result set
SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    CASE
        WHEN cl.cl_to LIKE '%Wiki_Science_Competition%' OR cl.cl_to LIKE '%Wiki_Science%' THEN 'Wiki Science Competition'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Folklore%' THEN 'Wiki Loves Folklore'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Africa%' THEN 'Wiki Loves Africa'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Food%' THEN 'Wiki Loves Food'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Public_Art%' THEN 'Wiki Loves Public Art'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Earth%' THEN 'Wiki Loves Earth'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Monuments%' THEN 'Wiki Loves Monuments'
        ELSE 'Unknown'
    END AS campaign,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN (
            (cl.cl_to LIKE '%Wiki_Science_Competition%' OR cl.cl_to LIKE '%Wiki_Science%')
            AND u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1101000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        )
        OR (
            cl.cl_to LIKE '%Wiki_Loves_Folklore%'
            AND u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0201000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0228235959')
        )
        OR (
            cl.cl_to LIKE '%Wiki_Loves_Africa%'
            AND u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0331235959')
        )
        OR (
            cl.cl_to LIKE '%Wiki_Loves_Food%'
            AND u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0701000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0831235959')
        )
        OR (
            cl.cl_to LIKE '%Wiki_Loves_Public_Art%'
            AND u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0501000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0631235959')
        )
        OR (
            cl.cl_to LIKE '%Wiki_Loves_Earth%'
            AND u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0501000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0531235959')
        )
        OR (
            cl.cl_to LIKE '%Wiki_Loves_Monuments%'
            AND u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0901000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0931235959')
        )
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
LEFT JOIN actor act ON a.actor_id = act.actor_id
LEFT JOIN user u ON act.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Science_Competition%'
    OR cl.cl_to LIKE '%Wiki_Science%'
    OR cl.cl_to LIKE '%Wiki_Loves_Folklore%'
    OR cl.cl_to LIKE '%Wiki_Loves_Africa%'
    OR cl.cl_to LIKE '%Wiki_Loves_Food%'
    OR cl.cl_to LIKE '%Wiki_Loves_Public_Art%'
    OR cl.cl_to LIKE '%Wiki_Loves_Earth%'
    OR cl.cl_to LIKE '%Wiki_Loves_Monuments%'
  )
  AND cl.cl_to NOT LIKE '%_in_%'
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year, campaign
ORDER BY campaign ASC, year DESC;
