-- ============================================
-- WIKI LOVES EARTH - COMPREHENSIVE UPLOADER DATA
-- ============================================
-- Gets uploader statistics for ALL years (2013-2025) and ALL countries
-- Database: commonswiki_p
-- 
-- This query fetches individual uploader data grouped by year and country
-- IMPORTANT: This query may take 15-30 minutes to execute
--
-- Copy this into Quarry: https://quarry.wmcloud.org
-- After completion, download as JSON: earth_all_uploaders.json
-- Then process with: python backend/scripts/process_all_uploaders.py earth_all_uploaders.json earth
--
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
    a.actor_name AS username,
    COUNT(DISTINCT i.img_name) AS images,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    DATE_FORMAT(u.user_registration, '%Y%m%d%H%i%s') AS user_registration,
    CASE 
        WHEN u.user_registration >= CONCAT(
            CAST(SUBSTRING_INDEX(
                CASE 
                    WHEN cl.cl_to LIKE '%_in_%' THEN
                        SUBSTRING_INDEX(cl.cl_to, '_in_', 1)
                    ELSE cl.cl_to
                END, '_', -1) AS UNSIGNED), '0501000000')
            AND u.user_registration <= CONCAT(
                CAST(SUBSTRING_INDEX(
                    CASE 
                        WHEN cl.cl_to LIKE '%_in_%' THEN
                            SUBSTRING_INDEX(cl.cl_to, '_in_', 1)
                        ELSE cl.cl_to
                    END, '_', -1) AS UNSIGNED), '0531235959')
        THEN 1
        ELSE 0
    END AS is_new_uploader
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
  AND CAST(SUBSTRING_INDEX(
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            SUBSTRING_INDEX(cl.cl_to, '_in_', 1)
        ELSE cl.cl_to
    END, '_', -1) AS UNSIGNED) BETWEEN 2013 AND 2025
GROUP BY year, country, a.actor_name, u.user_registration
ORDER BY year DESC, country, images DESC;

-- ============================================
-- NOTES:
-- ============================================
-- Output columns:
-- - year: Campaign year (2013-2025)
-- - country: Country name or 'Global'
-- - username: Actor name (uploader username)
-- - images: Number of images uploaded by this user in this country/year
-- - images_used: Number of images used in wikis
-- - user_registration: User registration timestamp
-- - is_new_uploader: 1 if registered during competition period (May 1-31), 0 otherwise
--
-- After running this query:
-- 1. Export as JSON: earth_all_uploaders.json
-- 2. Place in: quarry_data/uploaders/
-- 3. Process with: python backend/scripts/process_all_uploaders.py quarry_data/uploaders/earth_all_uploaders.json earth
-- 4. This will create individual files: earth_{year}_{country}_users.json
