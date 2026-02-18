-- ============================================
-- ALL WIKI LOVES CAMPAIGNS - SUMMARY QUERIES A-Z
-- ============================================
-- This file contains YEAR-ONLY summary queries (no country breakdown)
-- Each query returns: year, uploads, uploaders, images_used, new_uploaders
-- Queries are sorted alphabetically by campaign name
-- Database: commonswiki_p
-- 
-- USAGE: Same as comprehensive queries, but returns year totals only
-- ============================================

-- ============================================
-- 1. WIKI LOVES AFRICA - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Africa
-- Slug: africa
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Africa%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 2. WIKI LOVES ANDES - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Andes
-- Slug: andes
-- Date Range: Month 10
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 10/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Andes%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 3. WIKI LOVES ART BELGIUM - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Art Belgium
-- Slug: art-belgium
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Art_Belgium%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 4. WIKI LOVES ASSAMESE CULTURE - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Assamese Culture
-- Slug: assamese-culture
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Assamese_Culture%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 5. WIKI LOVES BANGLA - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Bangla
-- Slug: bangla
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Bangla%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 6. WIKI LOVES BIRDS - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Birds
-- Slug: birds
-- Date Range: Month 4
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 4/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Birds%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 7. WIKI LOVES BIRDS INDIA - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Birds India
-- Slug: birds-india
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Birds_India%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 8. WIKI LOVES BOTSWANA - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Botswana
-- Slug: botswana
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Botswana%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 9. WIKI LOVES BUSTO ARSIZIO - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Busto Arsizio
-- Slug: busto-arsizio
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Busto_Arsizio%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 10. WIKI LOVES CANOEING HAMBURG - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Canoeing Hamburg
-- Slug: canoeing-hamburg
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Canoeing_Hamburg%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 11. WIKI LOVES CHILDREN - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Children
-- Slug: children
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Children%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 12. WIKI LOVES CHINA - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves China
-- Slug: china
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_China%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 13. WIKI LOVES CLASSICS - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Classics
-- Slug: classics
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Classics%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 14. WIKI LOVES COCKTAILS AT WIKICON - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Cocktails At Wikicon
-- Slug: cocktails-at-wikicon
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Cocktails_At_Wikicon%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 15. WIKI LOVES COSPLAY - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Cosplay
-- Slug: cosplay
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Cosplay%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 16. WIKI LOVES CULTURA POPULAR BRASIL - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Cultura Popular Brasil
-- Slug: cultura-popular-brasil
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Cultura_Popular_Brasil%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 17. WIKI LOVES CULTURE - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Culture
-- Slug: culture
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Culture%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 18. WIKI LOVES DENDERLAND - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Denderland
-- Slug: denderland
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Denderland%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 19. WIKI LOVES EARTH - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Earth
-- Slug: earth
-- Date Range: Month 5
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 5/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Earth%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 20. WIKI LOVES EEMLAND - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Eemland
-- Slug: eemland
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Eemland%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 21. WIKI LOVES EMIRATES - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Emirates
-- Slug: emirates
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Emirates%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 22. WIKI LOVES EUROPRIDE - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Europride
-- Slug: europride
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Europride%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 23. WIKI LOVES FALLES - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Falles
-- Slug: falles
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Falles%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 24. WIKI LOVES FASHION - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Fashion
-- Slug: fashion
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Fashion%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 25. WIKI LOVES FESTIVALS - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Festivals
-- Slug: festivals
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Festivals%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 26. WIKI LOVES FILM - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Film
-- Slug: film
-- Date Range: Month 5
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 5/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Film%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 27. WIKI LOVES FIUMEFREDDO - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Fiumefreddo
-- Slug: fiumefreddo
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Fiumefreddo%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 28. WIKI LOVES FOLK - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Folk
-- Slug: folk
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Folk%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 29. WIKI LOVES FOLKLORE - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Folklore
-- Slug: folklore
-- Date Range: Month 2
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 2/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Folklore%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 30. WIKI LOVES FOOD - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Food
-- Slug: food
-- Date Range: Month 7
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 7/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Food%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 31. WIKI LOVES FOR RURAL WORKS - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves For Rural Works
-- Slug: for-rural-works
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_For_Rural_Works%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 32. WIKI LOVES HERITAGE BELGIUM - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Heritage Belgium
-- Slug: heritage-belgium
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Heritage_Belgium%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 33. WIKI LOVES HERITAGE GHANA - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Heritage Ghana
-- Slug: heritage-ghana
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Heritage_Ghana%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 34. WIKI LOVES LIBRARIANS - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Librarians
-- Slug: librarians
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Librarians%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 35. WIKI LOVES LIBRARIES SAAM - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Libraries Saam
-- Slug: libraries-saam
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Libraries_Saam%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 36. WIKI LOVES LITTÉRATURE HAÏTIENNE - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Littérature Haïtienne
-- Slug: littérature-haïtienne
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Littérature_Haïtienne%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 37. WIKI LOVES LIVING HERITAGE - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Living Heritage
-- Slug: living-heritage
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Living_Heritage%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 38. WIKI LOVES LOVE - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Love
-- Slug: love
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Love%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 39. WIKI LOVES MANGALURU - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Mangaluru
-- Slug: mangaluru
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Mangaluru%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 40. WIKI LOVES MAPS - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Maps
-- Slug: maps
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Maps%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 41. WIKI LOVES MEXICO - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Mexico
-- Slug: mexico
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Mexico%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 42. WIKI LOVES MONUMENTS - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Monuments
-- Slug: monuments
-- Date Range: Month 9
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 9/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Monuments%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 43. WIKI LOVES MUSEUMS - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Museums
-- Slug: museums
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Museums%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 44. WIKI LOVES MUSEUMS INDIA - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Museums India
-- Slug: museums-india
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Museums_India%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 45. WIKI LOVES MUZIRIS - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Muziris
-- Slug: muziris
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Muziris%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 46. WIKI LOVES MÉXICO - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves México
-- Slug: méxico
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_México%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 47. WIKI LOVES NAMIBIA - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Namibia
-- Slug: namibia
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Namibia%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 48. WIKI LOVES NYC PARKS - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Nyc Parks
-- Slug: nyc-parks
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Nyc_Parks%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 49. WIKI LOVES ONAM - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Onam
-- Slug: onam
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Onam%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 50. WIKI LOVES PAJOTTENLAND ZENNEVALLEI - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Pajottenland Zennevallei
-- Slug: pajottenland-zennevallei
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Pajottenland_Zennevallei%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 51. WIKI LOVES PARLIAMENTS - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Parliaments
-- Slug: parliaments
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Parliaments%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 52. WIKI LOVES PESTO GENOVESE - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Pesto Genovese
-- Slug: pesto-genovese
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Pesto_Genovese%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 53. WIKI LOVES PIEMONTE - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Piemonte
-- Slug: piemonte
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Piemonte%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 54. WIKI LOVES PLANTS - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Plants
-- Slug: plants
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Plants%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 55. WIKI LOVES PRIDE - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Pride
-- Slug: pride
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Pride%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 56. WIKI LOVES PUBLIC ART - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Public Art
-- Slug: public-art
-- Date Range: Month 5
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 5/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Public_Art%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 57. WIKI LOVES PUBLIC SPACE - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Public Space
-- Slug: public-space
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Public_Space%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 58. WIKI LOVES PUGLIA - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Puglia
-- Slug: puglia
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Puglia%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 59. WIKI LOVES RAMADAN - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Ramadan
-- Slug: ramadan
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Ramadan%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 60. WIKI LOVES RATHA JATRA - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Ratha Jatra
-- Slug: ratha-jatra
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Ratha_Jatra%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 61. WIKI LOVES ROMANIA - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Romania
-- Slug: romania
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Romania%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 62. WIKI LOVES SCHOOLS - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Schools
-- Slug: schools
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Schools%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 63. WIKI LOVES SICILIA - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Sicilia
-- Slug: sicilia
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Sicilia%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 64. WIKI LOVES SMALL MUSEUMS - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Small Museums
-- Slug: small-museums
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Small_Museums%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 65. WIKI LOVES SPORT - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Sport
-- Slug: sport
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Sport%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 66. WIKI LOVES STUFF - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Stuff
-- Slug: stuff
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Stuff%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 67. WIKI LOVES SUDAN - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Sudan
-- Slug: sudan
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Sudan%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 68. WIKI LOVES SWITZERLAND - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Switzerland
-- Slug: switzerland
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Switzerland%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 69. WIKI LOVES TIRRENO COSENTINO - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Tirreno Cosentino
-- Slug: tirreno-cosentino
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Tirreno_Cosentino%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 70. WIKI LOVES TRENTINO - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Trentino
-- Slug: trentino
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Trentino%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 71. WIKI LOVES TRIBAL CULTURE - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Tribal Culture
-- Slug: tribal-culture
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Tribal_Culture%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 72. WIKI LOVES VALLE DEL PRIMO PRESEPE - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Valle Del Primo Presepe
-- Slug: valle-del-primo-presepe
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Valle_Del_Primo_Presepe%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 73. WIKI LOVES VILLAGES - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Villages
-- Slug: villages
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Villages%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 74. WIKI LOVES VIZAG - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Vizag
-- Slug: vizag
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Vizag%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 75. WIKI LOVES WAHRAN - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Wahran
-- Slug: wahran
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Wahran%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 76. WIKI LOVES WOMEN - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Loves Women
-- Slug: women
-- Date Range: Month 3
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 3/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Women%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- 77. WIKI SCIENCE COMPETITION - YEAR SUMMARY
-- ============================================
-- Campaign: Wiki Science Competition
-- Slug: science
-- Date Range: Month 11
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after 11/1 of competition year
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
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Science_Competition%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;


-- ============================================
-- SUMMARY
-- ============================================
-- Total campaigns: 77
-- Generated: 77 queries
-- ============================================
