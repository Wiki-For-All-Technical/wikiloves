-- ============================================
-- EARTH 2013 & 2014 - FIX QUERY (Multiyear Summary with Fixed New Uploaders)
-- ============================================
-- This query gets 2013 and 2014 data with optimized category patterns
-- GROUP BY year only for accurate totals
-- 
-- FIX: "New uploaders" = users registered on or after May 1st of competition year
-- (not just during May, but from May 1st onwards through end of year)
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
        -- FIXED: Count users registered on or after May 1st of competition year
        -- (through end of year, not just during May)
        WHEN u.user_registration >= CONCAT(
            CAST(
                CASE
                    WHEN cl.cl_to LIKE '%_in_%' THEN
                        SUBSTRING_INDEX(SUBSTRING_INDEX(cl.cl_to, '_in_', 1), '_', -1)
                    ELSE SUBSTRING_INDEX(cl.cl_to, '_', -1)
                END AS UNSIGNED
            ), '0501000000')
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
    -- Specific patterns for 2013 (broader to catch all)
    OR cl.cl_to LIKE 'Images_from_WLE_2013%'
    OR cl.cl_to LIKE 'WLE_2013%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_%_2013'
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2013_in_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_2013_in_%'
    -- Specific patterns for 2014 (broader to catch all)
    OR cl.cl_to LIKE 'Images_from_WLE_2014%'
    OR cl.cl_to LIKE 'WLE_2014%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_%_2014'
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_2014_in_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_2014_in_%'
  )
  AND (
    -- Year at the end (most common pattern)
    (cl.cl_to REGEXP '[0-9]{4}$' 
     AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) IN (2013, 2014))
    -- OR year before "_in_" (for country-specific categories like "2013_in_Ukraine")
    OR (cl.cl_to LIKE '%_in_%' 
        AND CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(cl.cl_to, '_in_', 1), '_', -1) AS UNSIGNED) IN (2013, 2014))
  )
GROUP BY year
ORDER BY year DESC;

-- ============================================
-- NOTES:
-- ============================================
-- NEW UPLOADERS FIX:
-- - Changed from: May 1-31 only (0501000000 to 0531235959)
-- - Changed to: May 1 through Dec 31 (0501000000 to 1231235959)
-- - This matches the reference website's definition: "registered after competition start"
--
-- Expected results:
-- - 2013: ~275 new uploaders (was 98)
-- - 2014: ~2,364 new uploaders (was 1,928)
--
-- After running, save results as:
-- - earth_2013_fix.json
-- - earth_2014_fix.json
-- Then merge with complete dataset

