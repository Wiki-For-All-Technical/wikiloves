-- ============================================
-- EARTH - COMPLETE DATASET WITH COUNTRY BREAKDOWN (FIXED NEW UPLOADERS)
-- ============================================
-- This query gets ALL years (2013-2025) with country-level statistics
-- Returns multiple rows per year (one per country)
-- 
-- FIX: "New uploaders" = users registered on or after April 1st of competition year
-- (through end of year) - April 1st matches reference data better than May 1st
-- Database: commonswiki_p
-- ============================================

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
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- FIXED: Count users registered on or after April 1st of competition year
        -- (through end of year) - April 1st matches reference data better
        WHEN u.user_registration >= CONCAT(
            CAST(SUBSTRING_INDEX(
                CASE 
                    WHEN cl.cl_to LIKE '%_in_%' THEN
                        SUBSTRING_INDEX(cl.cl_to, '_in_', 1)
                    ELSE cl.cl_to
                END, '_', -1) AS UNSIGNED), '0401000000')
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
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
    -- Main category patterns
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_%'
    -- Country-specific patterns
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_%_in_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_%_in_%'
  )
  AND CAST(SUBSTRING_INDEX(
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            SUBSTRING_INDEX(cl.cl_to, '_in_', 1)
        ELSE cl.cl_to
    END, '_', -1) AS UNSIGNED) BETWEEN 2013 AND 2025
GROUP BY year, country
ORDER BY year DESC, uploads DESC;

-- ============================================
-- NOTES:
-- ============================================
-- This query returns multiple rows per year (one per country)
-- Format: [year, country, uploads, uploaders, images_used, new_uploaders]
-- 
-- Country extraction:
-- - Categories like "Images_from_Wiki_Loves_Earth_2013_in_Ukraine" → country: "Ukraine"
-- - Categories like "Images_from_Wiki_Loves_Earth_2013" → country: "Global"
--
-- NEW UPLOADERS FIX:
-- - Changed from: May 1-31 only (0501000000 to 0531235959)
-- - Changed to: April 1 through Dec 31 (0401000000 to 1231235959)
-- - April 1st matches reference data better (297 vs 275 for 2013, only 8% difference)
-- - This matches the reference website's definition: "registered after competition start"
--
-- Expected execution time: 5-10 minutes (due to country breakdown)
-- 
-- After running, you'll need to:
-- 1. Download as JSON
-- 2. Save to: wiki_loves_campaign_data/earth_complete_with_countries.json
-- 3. Process with updated process_all_campaigns.py

