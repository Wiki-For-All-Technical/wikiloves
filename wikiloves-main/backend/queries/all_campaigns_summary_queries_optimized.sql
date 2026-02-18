-- ============================================
-- ALL WIKI LOVES CAMPAIGNS - SUMMARY QUERIES (A-Z) - OPTIMIZED
-- ============================================
-- This file contains OPTIMIZED summary queries (year totals only)
-- Each query processes one campaign and returns year-level totals
-- 
-- EXPECTED TIME: 30 seconds - 2 minutes per query
-- ============================================

-- ============================================
-- 1. WIKI LOVES AFRICA (africa) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Africa
-- Slug: africa
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: africa_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'africa' AS campaign_slug,
    'Wiki Loves Africa' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Africa%' OR cl.cl_to LIKE 'Wiki_Loves_Africa%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 2. WIKI LOVES ANDES (andes) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Andes
-- Slug: andes
-- Year totals only (no country breakdown)
-- Date Range: October 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: andes_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'andes' AS campaign_slug,
    'Wiki Loves Andes' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1001000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Andes%' OR cl.cl_to LIKE 'Wiki_Loves_Andes%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 3. WIKI LOVES ART BELGIUM (art-belgium) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Art Belgium
-- Slug: art-belgium
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: art-belgium_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'art-belgium' AS campaign_slug,
    'Wiki Loves Art Belgium' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Art_Belgium%' OR cl.cl_to LIKE 'Wiki_Loves_Art_Belgium%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 4. WIKI LOVES ASSAMESE CULTURE (assamese-culture) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Assamese Culture
-- Slug: assamese-culture
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: assamese-culture_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'assamese-culture' AS campaign_slug,
    'Wiki Loves Assamese Culture' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Assamese_Culture%' OR cl.cl_to LIKE 'Wiki_Loves_Assamese_Culture%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 5. WIKI LOVES BANGLA (bangla) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Bangla
-- Slug: bangla
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: bangla_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'bangla' AS campaign_slug,
    'Wiki Loves Bangla' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Bangla%' OR cl.cl_to LIKE 'Wiki_Loves_Bangla%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 6. WIKI LOVES BIRDS (birds) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Birds
-- Slug: birds
-- Year totals only (no country breakdown)
-- Date Range: April 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: birds_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'birds' AS campaign_slug,
    'Wiki Loves Birds' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0401000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Birds%' OR cl.cl_to LIKE 'Wiki_Loves_Birds%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 7. WIKI LOVES BIRDS INDIA (birds-india) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Birds India
-- Slug: birds-india
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: birds-india_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'birds-india' AS campaign_slug,
    'Wiki Loves Birds India' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Birds_India%' OR cl.cl_to LIKE 'Wiki_Loves_Birds_India%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 8. WIKI LOVES BOTSWANA (botswana) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Botswana
-- Slug: botswana
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: botswana_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'botswana' AS campaign_slug,
    'Wiki Loves Botswana' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Botswana%' OR cl.cl_to LIKE 'Wiki_Loves_Botswana%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 9. WIKI LOVES BUSTO ARSIZIO (busto-arsizio) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Busto Arsizio
-- Slug: busto-arsizio
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: busto-arsizio_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'busto-arsizio' AS campaign_slug,
    'Wiki Loves Busto Arsizio' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Busto_Arsizio%' OR cl.cl_to LIKE 'Wiki_Loves_Busto_Arsizio%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 10. WIKI LOVES CANOEING HAMBURG (canoeing-hamburg) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Canoeing Hamburg
-- Slug: canoeing-hamburg
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: canoeing-hamburg_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'canoeing-hamburg' AS campaign_slug,
    'Wiki Loves Canoeing Hamburg' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Canoeing_Hamburg%' OR cl.cl_to LIKE 'Wiki_Loves_Canoeing_Hamburg%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 11. WIKI LOVES CHILDREN (children) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Children
-- Slug: children
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: children_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'children' AS campaign_slug,
    'Wiki Loves Children' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Children%' OR cl.cl_to LIKE 'Wiki_Loves_Children%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 12. WIKI LOVES CHINA (china) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves China
-- Slug: china
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: china_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'china' AS campaign_slug,
    'Wiki Loves China' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_China%' OR cl.cl_to LIKE 'Wiki_Loves_China%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 13. WIKI LOVES CLASSICS (classics) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Classics
-- Slug: classics
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: classics_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'classics' AS campaign_slug,
    'Wiki Loves Classics' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Classics%' OR cl.cl_to LIKE 'Wiki_Loves_Classics%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 14. WIKI LOVES COCKTAILS AT WIKICON (cocktails-at-wikicon) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Cocktails At Wikicon
-- Slug: cocktails-at-wikicon
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: cocktails-at-wikicon_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'cocktails-at-wikicon' AS campaign_slug,
    'Wiki Loves Cocktails At Wikicon' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Cocktails_At_Wikicon%' OR cl.cl_to LIKE 'Wiki_Loves_Cocktails_At_Wikicon%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 15. WIKI LOVES COSPLAY (cosplay) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Cosplay
-- Slug: cosplay
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: cosplay_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'cosplay' AS campaign_slug,
    'Wiki Loves Cosplay' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Cosplay%' OR cl.cl_to LIKE 'Wiki_Loves_Cosplay%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 16. WIKI LOVES CULTURA POPULAR BRASIL (cultura-popular-brasil) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Cultura Popular Brasil
-- Slug: cultura-popular-brasil
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: cultura-popular-brasil_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'cultura-popular-brasil' AS campaign_slug,
    'Wiki Loves Cultura Popular Brasil' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Cultura_Popular_Brasil%' OR cl.cl_to LIKE 'Wiki_Loves_Cultura_Popular_Brasil%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 17. WIKI LOVES CULTURE (culture) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Culture
-- Slug: culture
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: culture_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'culture' AS campaign_slug,
    'Wiki Loves Culture' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Culture%' OR cl.cl_to LIKE 'Wiki_Loves_Culture%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 18. WIKI LOVES DENDERLAND (denderland) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Denderland
-- Slug: denderland
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: denderland_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'denderland' AS campaign_slug,
    'Wiki Loves Denderland' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Denderland%' OR cl.cl_to LIKE 'Wiki_Loves_Denderland%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 19. WIKI LOVES EARTH (earth) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Earth
-- Slug: earth
-- Year totals only (no country breakdown)
-- Date Range: May 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: earth_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'earth' AS campaign_slug,
    'Wiki Loves Earth' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0501000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth%' OR cl.cl_to LIKE 'Wiki_Loves_Earth%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 20. WIKI LOVES EEMLAND (eemland) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Eemland
-- Slug: eemland
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: eemland_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'eemland' AS campaign_slug,
    'Wiki Loves Eemland' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Eemland%' OR cl.cl_to LIKE 'Wiki_Loves_Eemland%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 21. WIKI LOVES EMIRATES (emirates) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Emirates
-- Slug: emirates
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: emirates_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'emirates' AS campaign_slug,
    'Wiki Loves Emirates' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Emirates%' OR cl.cl_to LIKE 'Wiki_Loves_Emirates%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 22. WIKI LOVES EUROPRIDE (europride) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Europride
-- Slug: europride
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: europride_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'europride' AS campaign_slug,
    'Wiki Loves Europride' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Europride%' OR cl.cl_to LIKE 'Wiki_Loves_Europride%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 23. WIKI LOVES FALLES (falles) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Falles
-- Slug: falles
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: falles_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'falles' AS campaign_slug,
    'Wiki Loves Falles' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Falles%' OR cl.cl_to LIKE 'Wiki_Loves_Falles%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 24. WIKI LOVES FASHION (fashion) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Fashion
-- Slug: fashion
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: fashion_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'fashion' AS campaign_slug,
    'Wiki Loves Fashion' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Fashion%' OR cl.cl_to LIKE 'Wiki_Loves_Fashion%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 25. WIKI LOVES FESTIVALS (festivals) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Festivals
-- Slug: festivals
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: festivals_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'festivals' AS campaign_slug,
    'Wiki Loves Festivals' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Festivals%' OR cl.cl_to LIKE 'Wiki_Loves_Festivals%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 26. WIKI LOVES FILM (film) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Film
-- Slug: film
-- Year totals only (no country breakdown)
-- Date Range: May 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: film_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'film' AS campaign_slug,
    'Wiki Loves Film' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0501000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Film%' OR cl.cl_to LIKE 'Wiki_Loves_Film%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 27. WIKI LOVES FIUMEFREDDO (fiumefreddo) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Fiumefreddo
-- Slug: fiumefreddo
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: fiumefreddo_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'fiumefreddo' AS campaign_slug,
    'Wiki Loves Fiumefreddo' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Fiumefreddo%' OR cl.cl_to LIKE 'Wiki_Loves_Fiumefreddo%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 28. WIKI LOVES FOLK (folk) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Folk
-- Slug: folk
-- Year totals only (no country breakdown)
-- Date Range: February 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: folk_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'folk' AS campaign_slug,
    'Wiki Loves Folk' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0201000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Folklore%' OR cl.cl_to LIKE 'Wiki_Loves_Folklore%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 29. WIKI LOVES FOLKLORE (folklore) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Folklore
-- Slug: folklore
-- Year totals only (no country breakdown)
-- Date Range: February 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: folklore_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'folklore' AS campaign_slug,
    'Wiki Loves Folklore' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0201000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Folklore%' OR cl.cl_to LIKE 'Wiki_Loves_Folklore%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 30. WIKI LOVES FOOD (food) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Food
-- Slug: food
-- Year totals only (no country breakdown)
-- Date Range: July 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: food_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'food' AS campaign_slug,
    'Wiki Loves Food' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0701000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Food%' OR cl.cl_to LIKE 'Wiki_Loves_Food%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 31. WIKI LOVES FOR RURAL WORKS (for-rural-works) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves For Rural Works
-- Slug: for-rural-works
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: for-rural-works_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'for-rural-works' AS campaign_slug,
    'Wiki Loves For Rural Works' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_For_Rural_Works%' OR cl.cl_to LIKE 'Wiki_Loves_For_Rural_Works%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 32. WIKI LOVES HERITAGE BELGIUM (heritage-belgium) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Heritage Belgium
-- Slug: heritage-belgium
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: heritage-belgium_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'heritage-belgium' AS campaign_slug,
    'Wiki Loves Heritage Belgium' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Heritage_Belgium%' OR cl.cl_to LIKE 'Wiki_Loves_Heritage_Belgium%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 33. WIKI LOVES HERITAGE GHANA (heritage-ghana) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Heritage Ghana
-- Slug: heritage-ghana
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: heritage-ghana_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'heritage-ghana' AS campaign_slug,
    'Wiki Loves Heritage Ghana' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Heritage_Ghana%' OR cl.cl_to LIKE 'Wiki_Loves_Heritage_Ghana%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 34. WIKI LOVES LIBRARIANS (librarians) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Librarians
-- Slug: librarians
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: librarians_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'librarians' AS campaign_slug,
    'Wiki Loves Librarians' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Librarians%' OR cl.cl_to LIKE 'Wiki_Loves_Librarians%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 35. WIKI LOVES LIBRARIES SAAM (libraries-saam) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Libraries Saam
-- Slug: libraries-saam
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: libraries-saam_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'libraries-saam' AS campaign_slug,
    'Wiki Loves Libraries Saam' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Libraries_Saam%' OR cl.cl_to LIKE 'Wiki_Loves_Libraries_Saam%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 36. WIKI LOVES LITTÉRATURE HAÏTIENNE (littérature-haïtienne) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Littérature Haïtienne
-- Slug: littérature-haïtienne
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: littérature-haïtienne_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'littérature-haïtienne' AS campaign_slug,
    'Wiki Loves Littérature Haïtienne' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Littérature_Haïtienne%' OR cl.cl_to LIKE 'Wiki_Loves_Littérature_Haïtienne%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 37. WIKI LOVES LIVING HERITAGE (living-heritage) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Living Heritage
-- Slug: living-heritage
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: living-heritage_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'living-heritage' AS campaign_slug,
    'Wiki Loves Living Heritage' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Living_Heritage%' OR cl.cl_to LIKE 'Wiki_Loves_Living_Heritage%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 38. WIKI LOVES LOVE (love) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Love
-- Slug: love
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: love_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'love' AS campaign_slug,
    'Wiki Loves Love' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Love%' OR cl.cl_to LIKE 'Wiki_Loves_Love%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 39. WIKI LOVES MANGALURU (mangaluru) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Mangaluru
-- Slug: mangaluru
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: mangaluru_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'mangaluru' AS campaign_slug,
    'Wiki Loves Mangaluru' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Mangaluru%' OR cl.cl_to LIKE 'Wiki_Loves_Mangaluru%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 40. WIKI LOVES MAPS (maps) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Maps
-- Slug: maps
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: maps_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'maps' AS campaign_slug,
    'Wiki Loves Maps' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Maps%' OR cl.cl_to LIKE 'Wiki_Loves_Maps%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 41. WIKI LOVES MEXICO (mexico) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Mexico
-- Slug: mexico
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: mexico_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'mexico' AS campaign_slug,
    'Wiki Loves Mexico' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Mexico%' OR cl.cl_to LIKE 'Wiki_Loves_Mexico%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 42. WIKI LOVES MONUMENTS (monuments) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Monuments
-- Slug: monuments
-- Year totals only (no country breakdown)
-- Date Range: September 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: monuments_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'monuments' AS campaign_slug,
    'Wiki Loves Monuments' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0901000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Monuments%' OR cl.cl_to LIKE 'Wiki_Loves_Monuments%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 43. WIKI LOVES MUSEUMS (museums) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Museums
-- Slug: museums
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: museums_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'museums' AS campaign_slug,
    'Wiki Loves Museums' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Museums%' OR cl.cl_to LIKE 'Wiki_Loves_Museums%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 44. WIKI LOVES MUSEUMS INDIA (museums-india) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Museums India
-- Slug: museums-india
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: museums-india_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'museums-india' AS campaign_slug,
    'Wiki Loves Museums India' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Museums_India%' OR cl.cl_to LIKE 'Wiki_Loves_Museums_India%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 45. WIKI LOVES MUZIRIS (muziris) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Muziris
-- Slug: muziris
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: muziris_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'muziris' AS campaign_slug,
    'Wiki Loves Muziris' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Muziris%' OR cl.cl_to LIKE 'Wiki_Loves_Muziris%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 46. WIKI LOVES MÉXICO (méxico) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves México
-- Slug: méxico
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: méxico_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'méxico' AS campaign_slug,
    'Wiki Loves México' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_México%' OR cl.cl_to LIKE 'Wiki_Loves_México%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 47. WIKI LOVES NAMIBIA (namibia) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Namibia
-- Slug: namibia
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: namibia_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'namibia' AS campaign_slug,
    'Wiki Loves Namibia' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Namibia%' OR cl.cl_to LIKE 'Wiki_Loves_Namibia%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 48. WIKI LOVES NYC PARKS (nyc-parks) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Nyc Parks
-- Slug: nyc-parks
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: nyc-parks_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'nyc-parks' AS campaign_slug,
    'Wiki Loves Nyc Parks' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Nyc_Parks%' OR cl.cl_to LIKE 'Wiki_Loves_Nyc_Parks%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 49. WIKI LOVES ONAM (onam) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Onam
-- Slug: onam
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: onam_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'onam' AS campaign_slug,
    'Wiki Loves Onam' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Onam%' OR cl.cl_to LIKE 'Wiki_Loves_Onam%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 50. WIKI LOVES PAJOTTENLAND ZENNEVALLEI (pajottenland-zennevallei) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Pajottenland Zennevallei
-- Slug: pajottenland-zennevallei
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: pajottenland-zennevallei_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'pajottenland-zennevallei' AS campaign_slug,
    'Wiki Loves Pajottenland Zennevallei' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Pajottenland_Zennevallei%' OR cl.cl_to LIKE 'Wiki_Loves_Pajottenland_Zennevallei%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 51. WIKI LOVES PARLIAMENTS (parliaments) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Parliaments
-- Slug: parliaments
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: parliaments_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'parliaments' AS campaign_slug,
    'Wiki Loves Parliaments' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Parliaments%' OR cl.cl_to LIKE 'Wiki_Loves_Parliaments%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 52. WIKI LOVES PESTO GENOVESE (pesto-genovese) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Pesto Genovese
-- Slug: pesto-genovese
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: pesto-genovese_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'pesto-genovese' AS campaign_slug,
    'Wiki Loves Pesto Genovese' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Pesto_Genovese%' OR cl.cl_to LIKE 'Wiki_Loves_Pesto_Genovese%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 53. WIKI LOVES PIEMONTE (piemonte) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Piemonte
-- Slug: piemonte
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: piemonte_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'piemonte' AS campaign_slug,
    'Wiki Loves Piemonte' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Piemonte%' OR cl.cl_to LIKE 'Wiki_Loves_Piemonte%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 54. WIKI LOVES PLANTS (plants) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Plants
-- Slug: plants
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: plants_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'plants' AS campaign_slug,
    'Wiki Loves Plants' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Plants%' OR cl.cl_to LIKE 'Wiki_Loves_Plants%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 55. WIKI LOVES PRIDE (pride) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Pride
-- Slug: pride
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: pride_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'pride' AS campaign_slug,
    'Wiki Loves Pride' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Pride%' OR cl.cl_to LIKE 'Wiki_Loves_Pride%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 56. WIKI LOVES PUBLIC ART (public-art) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Public Art
-- Slug: public-art
-- Year totals only (no country breakdown)
-- Date Range: May 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: public-art_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'public-art' AS campaign_slug,
    'Wiki Loves Public Art' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0501000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Public_Art%' OR cl.cl_to LIKE 'Wiki_Loves_Public_Art%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 57. WIKI LOVES PUBLIC SPACE (public-space) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Public Space
-- Slug: public-space
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: public-space_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'public-space' AS campaign_slug,
    'Wiki Loves Public Space' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Public_Space%' OR cl.cl_to LIKE 'Wiki_Loves_Public_Space%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 58. WIKI LOVES PUGLIA (puglia) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Puglia
-- Slug: puglia
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: puglia_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'puglia' AS campaign_slug,
    'Wiki Loves Puglia' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Puglia%' OR cl.cl_to LIKE 'Wiki_Loves_Puglia%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 59. WIKI LOVES RAMADAN (ramadan) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Ramadan
-- Slug: ramadan
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: ramadan_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'ramadan' AS campaign_slug,
    'Wiki Loves Ramadan' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Ramadan%' OR cl.cl_to LIKE 'Wiki_Loves_Ramadan%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 60. WIKI LOVES RATHA JATRA (ratha-jatra) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Ratha Jatra
-- Slug: ratha-jatra
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: ratha-jatra_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'ratha-jatra' AS campaign_slug,
    'Wiki Loves Ratha Jatra' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Ratha_Jatra%' OR cl.cl_to LIKE 'Wiki_Loves_Ratha_Jatra%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 61. WIKI LOVES ROMANIA (romania) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Romania
-- Slug: romania
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: romania_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'romania' AS campaign_slug,
    'Wiki Loves Romania' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Romania%' OR cl.cl_to LIKE 'Wiki_Loves_Romania%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 62. WIKI LOVES SCHOOLS (schools) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Schools
-- Slug: schools
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: schools_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'schools' AS campaign_slug,
    'Wiki Loves Schools' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Schools%' OR cl.cl_to LIKE 'Wiki_Loves_Schools%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 63. WIKI LOVES SICILIA (sicilia) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Sicilia
-- Slug: sicilia
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: sicilia_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'sicilia' AS campaign_slug,
    'Wiki Loves Sicilia' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Sicilia%' OR cl.cl_to LIKE 'Wiki_Loves_Sicilia%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 64. WIKI LOVES SMALL MUSEUMS (small-museums) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Small Museums
-- Slug: small-museums
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: small-museums_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'small-museums' AS campaign_slug,
    'Wiki Loves Small Museums' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Small_Museums%' OR cl.cl_to LIKE 'Wiki_Loves_Small_Museums%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 65. WIKI LOVES SPORT (sport) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Sport
-- Slug: sport
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: sport_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'sport' AS campaign_slug,
    'Wiki Loves Sport' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Sport%' OR cl.cl_to LIKE 'Wiki_Loves_Sport%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 66. WIKI LOVES STUFF (stuff) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Stuff
-- Slug: stuff
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: stuff_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'stuff' AS campaign_slug,
    'Wiki Loves Stuff' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Stuff%' OR cl.cl_to LIKE 'Wiki_Loves_Stuff%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 67. WIKI LOVES SUDAN (sudan) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Sudan
-- Slug: sudan
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: sudan_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'sudan' AS campaign_slug,
    'Wiki Loves Sudan' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Sudan%' OR cl.cl_to LIKE 'Wiki_Loves_Sudan%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 68. WIKI LOVES SWITZERLAND (switzerland) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Switzerland
-- Slug: switzerland
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: switzerland_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'switzerland' AS campaign_slug,
    'Wiki Loves Switzerland' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Switzerland%' OR cl.cl_to LIKE 'Wiki_Loves_Switzerland%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 69. WIKI LOVES TIRRENO COSENTINO (tirreno-cosentino) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Tirreno Cosentino
-- Slug: tirreno-cosentino
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: tirreno-cosentino_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'tirreno-cosentino' AS campaign_slug,
    'Wiki Loves Tirreno Cosentino' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Tirreno_Cosentino%' OR cl.cl_to LIKE 'Wiki_Loves_Tirreno_Cosentino%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 70. WIKI LOVES TRENTINO (trentino) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Trentino
-- Slug: trentino
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: trentino_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'trentino' AS campaign_slug,
    'Wiki Loves Trentino' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Trentino%' OR cl.cl_to LIKE 'Wiki_Loves_Trentino%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 71. WIKI LOVES TRIBAL CULTURE (tribal-culture) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Tribal Culture
-- Slug: tribal-culture
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: tribal-culture_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'tribal-culture' AS campaign_slug,
    'Wiki Loves Tribal Culture' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Tribal_Culture%' OR cl.cl_to LIKE 'Wiki_Loves_Tribal_Culture%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 72. WIKI LOVES VALLE DEL PRIMO PRESEPE (valle-del-primo-presepe) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Valle Del Primo Presepe
-- Slug: valle-del-primo-presepe
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: valle-del-primo-presepe_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'valle-del-primo-presepe' AS campaign_slug,
    'Wiki Loves Valle Del Primo Presepe' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Valle_Del_Primo_Presepe%' OR cl.cl_to LIKE 'Wiki_Loves_Valle_Del_Primo_Presepe%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 73. WIKI LOVES VILLAGES (villages) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Villages
-- Slug: villages
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: villages_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'villages' AS campaign_slug,
    'Wiki Loves Villages' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Villages%' OR cl.cl_to LIKE 'Wiki_Loves_Villages%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 74. WIKI LOVES VIZAG (vizag) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Vizag
-- Slug: vizag
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: vizag_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'vizag' AS campaign_slug,
    'Wiki Loves Vizag' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Vizag%' OR cl.cl_to LIKE 'Wiki_Loves_Vizag%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 75. WIKI LOVES WAHRAN (wahran) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Wahran
-- Slug: wahran
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: wahran_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'wahran' AS campaign_slug,
    'Wiki Loves Wahran' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Wahran%' OR cl.cl_to LIKE 'Wiki_Loves_Wahran%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 76. WIKI LOVES WOMEN (women) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Loves Women
-- Slug: women
-- Year totals only (no country breakdown)
-- Date Range: March 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: women_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'women' AS campaign_slug,
    'Wiki Loves Women' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0301000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Images_from_Wiki_Loves_Women%' OR cl.cl_to LIKE 'Wiki_Loves_Women%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- 77. WIKI SCIENCE COMPETITION (science) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: Wiki Science Competition
-- Slug: science
-- Year totals only (no country breakdown)
-- Date Range: November 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: science_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    'science' AS campaign_slug,
    'Wiki Science Competition' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
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
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    (cl.cl_to LIKE 'Wiki_Science_Competition%' OR cl.cl_to LIKE 'Images_from_Wiki_Science_Competition%' OR cl.cl_to LIKE '%WikiScience%')
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;



-- ============================================
-- SUMMARY
-- ============================================
-- Total campaigns: 77
-- Generated: OPTIMIZED summary queries
-- ============================================
