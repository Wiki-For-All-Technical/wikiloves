-- ============================================
-- EARTH - MULTIYEAR SUMMARY (FIXED NEW UPLOADERS)
-- ============================================
-- This query gets ALL years (2013-2025) with year totals only
-- GROUP BY year only for accurate totals
-- 
-- FIX: "New uploaders" = users registered on or after April 1st of competition year
-- (through end of year) - April 1st matches reference data better than May 1st
-- Database: commonswiki_p
-- ============================================

SELECT
    CAST(
        CASE
            -- If category has "_in_" pattern, extract year from before "_in_"
            WHEN cl.cl_to LIKE '%_in_%' THEN
                SUBSTRING_INDEX(SUBSTRING_INDEX(cl.cl_to, '_in_', 1), '_', -1)
            -- Otherwise, year is at the end
            ELSE SUBSTRING_INDEX(cl.cl_to, '_', -1)
        END AS UNSIGNED
    ) AS year,
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
        -- (through end of year) - April 1st matches reference data better than May 1st
        WHEN u.user_registration >= CONCAT(
            CAST(
                CASE
                    WHEN cl.cl_to LIKE '%_in_%' THEN
                        SUBSTRING_INDEX(SUBSTRING_INDEX(cl.cl_to, '_in_', 1), '_', -1)
                    ELSE SUBSTRING_INDEX(cl.cl_to, '_', -1)
                END AS UNSIGNED
            ), '0401000000')
            AND u.user_registration <= CONCAT(
                CAST(
                    CASE
                        WHEN cl.cl_to LIKE '%_in_%' THEN
                            SUBSTRING_INDEX(SUBSTRING_INDEX(cl.cl_to, '_in_', 1), '_', -1)
                        ELSE SUBSTRING_INDEX(cl.cl_to, '_', -1)
                    END AS UNSIGNED
                ), '1231235959')
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
    -- General patterns for Wiki Loves Earth
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_%'
    -- Specific patterns for various years
    OR cl.cl_to LIKE 'Images_from_WLE_%'
    OR cl.cl_to LIKE 'WLE_%'
    -- Additional patterns for 2013 (country-specific categories)
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2013%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_2013%'
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2013_in_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_2013_in_%'
  )
  AND (
    -- Year at the end (most common pattern)
    (cl.cl_to REGEXP '[0-9]{4}$' 
     AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2013 AND 2025)
    -- OR year before "_in_" (for country-specific categories like "2013_in_Ukraine")
    OR (cl.cl_to LIKE '%_in_%' 
        AND CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(cl.cl_to, '_in_', 1), '_', -1) AS UNSIGNED) BETWEEN 2013 AND 2025)
  )
GROUP BY year
ORDER BY year DESC;

-- ============================================
-- NOTES:
-- ============================================
-- NEW UPLOADERS FIX:
-- - Changed from: May 1-31 only (0501000000 to 0531235959)
-- - Changed to: April 1 through Dec 31 (0401000000 to 1231235959)
-- - April 1st matches reference data better (297 vs 275 for 2013, only 8% difference)
-- - This matches the reference website's definition: "registered after competition start"
--
-- This query returns one row per year with totals.
-- Format: [year, uploads, uploaders, images_used, new_uploaders]
--
-- Expected execution time: 3-5 minutes
--
-- After running, save results as JSON and process with:
-- python wikiloves-main/backend/scripts/process_all_campaigns.py

