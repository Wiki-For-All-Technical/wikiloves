-- ============================================
-- Ready-to-Use Quarry Queries for Wiki Loves Campaigns
-- ============================================
-- Instructions:
-- 1. Go to https://quarry.wmcloud.org
-- 2. Login with your Wikimedia account
-- 3. Select database: commonswiki_p
-- 4. Copy and paste one of these queries
-- 5. Modify the year and category name as needed
-- 6. Run the query
-- 7. Export results as CSV or JSON
-- ============================================

-- ============================================
-- QUERY 1: Wiki Loves Monuments - Country Statistics
-- ============================================
-- Replace YEAR with the year (e.g., 2024, 2023)
-- This query gets uploads, uploaders, and usage by country

-- ============================================
-- QUERY 1: Wiki Loves Monuments - Country Statistics (FIXED)
-- ============================================
-- Replace 2024 with the actual year
-- This query gets uploads, uploaders, and usage statistics

SELECT 
    'All Countries' AS country,
    COUNT(*) AS uploads,
    COUNT(DISTINCT COALESCE(user.user_name, img.img_user)) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks 
            WHERE il_from = img.img_id
        ) THEN img.img_id 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN user.user_registration >= '20240901000000'
            AND user.user_registration <= '20240930235959'
        THEN COALESCE(user.user_name, img.img_user)
    END) AS new_uploaders
FROM image img
LEFT JOIN user ON img.img_user = user.user_id
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= '20240901000000'
  AND img.img_timestamp <= '20240930235959'
  AND (
    cl.cl_to LIKE '%Images_from_Wiki_Loves_Monuments_2024%'
    OR cl.cl_to LIKE '%Wiki_Loves_Monuments_2024%'
    OR cl.cl_to LIKE '%Images_from_Wiki_Loves_Monuments_2024_in_%'
  )
ORDER BY uploads DESC;

-- ============================================
-- QUERY 2: Wiki Loves Earth - Country Statistics
-- ============================================
-- Replace YEAR with the year (e.g., 2024, 2023)
-- Earth typically runs in May

SELECT 
    CASE 
        WHEN img.img_user_text REGEXP '^[^@]+@' THEN 'Unknown'
        ELSE COALESCE(
            (SELECT user_registration 
             FROM user 
             WHERE user.user_id = img.img_user 
             LIMIT 1),
            'Unknown'
        )
    END AS country_indicator,
    COUNT(*) AS uploads,
    COUNT(DISTINCT img.img_user_text) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks 
            WHERE il_from = img.img_id
        ) THEN img.img_id 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN user.user_registration >= CONCAT(YEAR, '0501000000')
            AND user.user_registration <= CONCAT(YEAR, '0531235959')
        THEN img.img_user_text 
    END) AS new_uploaders
FROM image img
LEFT JOIN user ON img.img_user = user.user_id
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= CONCAT(YEAR, '0501000000')
  AND img.img_timestamp <= CONCAT(YEAR, '0531235959')
  AND cl.cl_to IN (
    CONCAT('Images_from_Wiki_Loves_Earth_', YEAR),
    CONCAT('Images_from_Wiki_Loves_Earth_', YEAR, '_in_'),
    CONCAT('Wiki_Loves_Earth_', YEAR)
  )
GROUP BY country_indicator
ORDER BY uploads DESC;

-- ============================================
-- QUERY 3: Generic Campaign Query (Template)
-- ============================================
-- Replace:
--   CAMPAIGN_NAME with campaign name (e.g., 'Folklore', 'Africa')
--   YEAR with the year
--   START_MONTH with month number (01-12)
--   END_MONTH with month number (01-12)
--   START_DAY with day (01-31)
--   END_DAY with day (01-31)

SELECT 
    CASE 
        WHEN img.img_user_text REGEXP '^[^@]+@' THEN 'Unknown'
        ELSE COALESCE(
            (SELECT user_registration 
             FROM user 
             WHERE user.user_id = img.img_user 
             LIMIT 1),
            'Unknown'
        )
    END AS country_indicator,
    COUNT(*) AS uploads,
    COUNT(DISTINCT img.img_user_text) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks 
            WHERE il_from = img.img_id
        ) THEN img.img_id 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN user.user_registration >= CONCAT(YEAR, START_MONTH, START_DAY, '000000')
            AND user.user_registration <= CONCAT(YEAR, END_MONTH, END_DAY, '235959')
        THEN img.img_user_text 
    END) AS new_uploaders
FROM image img
LEFT JOIN user ON img.img_user = user.user_id
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= CONCAT(YEAR, START_MONTH, START_DAY, '000000')
  AND img.img_timestamp <= CONCAT(YEAR, END_MONTH, END_DAY, '235959')
  AND (
    cl.cl_to LIKE CONCAT('%Wiki_Loves_CAMPAIGN_NAME%', YEAR, '%')
    OR cl.cl_to LIKE CONCAT('%CAMPAIGN_NAME%', YEAR, '%')
    OR img.img_name LIKE CONCAT('%CAMPAIGN_NAME%', YEAR, '%')
  )
GROUP BY country_indicator
ORDER BY uploads DESC;

-- ============================================
-- QUERY 4: Overall Campaign Statistics (No Country Breakdown)
-- ============================================
-- Use this to get total stats for a campaign/year
-- Replace CAMPAIGN_NAME and YEAR

SELECT 
    COUNT(*) AS total_uploads,
    COUNT(DISTINCT img.img_user_text) AS total_uploaders,
    COUNT(DISTINCT CASE 
        WHEN user.user_registration >= CONCAT(YEAR, '0101000000')
            AND user.user_registration <= CONCAT(YEAR, '1231235959')
        THEN img.img_user_text 
    END) AS new_uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks 
            WHERE il_from = img.img_id
        ) THEN img.img_id 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN cl.cl_to LIKE CONCAT('%', YEAR, '%')
        THEN cl.cl_to 
    END) AS categories_used
FROM image img
LEFT JOIN user ON img.img_user = user.user_id
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= CONCAT(YEAR, '0101000000')
  AND img.img_timestamp <= CONCAT(YEAR, '1231235959')
  AND (
    cl.cl_to LIKE CONCAT('%Wiki_Loves_CAMPAIGN_NAME%', YEAR, '%')
    OR cl.cl_to LIKE CONCAT('%CAMPAIGN_NAME%', YEAR, '%')
  );

-- ============================================
-- QUERY 5: Find Available Campaign Categories
-- ============================================
-- Use this to discover what categories exist for a campaign
-- Replace CAMPAIGN_NAME and YEAR

SELECT DISTINCT cl.cl_to AS category_name
FROM categorylinks cl
WHERE cl.cl_to LIKE CONCAT('%Wiki_Loves%', YEAR, '%')
   OR cl.cl_to LIKE CONCAT('%CAMPAIGN_NAME%', YEAR, '%')
ORDER BY cl.cl_to;

-- ============================================
-- QUERY 6: Wiki Loves Folklore - Country Statistics
-- ============================================
-- Folklore typically runs in February

SELECT 
    CASE 
        WHEN img.img_user_text REGEXP '^[^@]+@' THEN 'Unknown'
        ELSE COALESCE(
            (SELECT user_registration 
             FROM user 
             WHERE user.user_id = img.img_user 
             LIMIT 1),
            'Unknown'
        )
    END AS country_indicator,
    COUNT(*) AS uploads,
    COUNT(DISTINCT img.img_user_text) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks 
            WHERE il_from = img.img_id
        ) THEN img.img_id 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN user.user_registration >= CONCAT(YEAR, '0201000000')
            AND user.user_registration <= CONCAT(YEAR, '0228235959')
        THEN img.img_user_text 
    END) AS new_uploaders
FROM image img
LEFT JOIN user ON img.img_user = user.user_id
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= CONCAT(YEAR, '0201000000')
  AND img.img_timestamp <= CONCAT(YEAR, '0228235959')
  AND cl.cl_to IN (
    CONCAT('Images_from_Wiki_Loves_Folklore_', YEAR),
    CONCAT('Images_from_Wiki_Loves_Folklore_', YEAR, '_in_'),
    CONCAT('Wiki_Loves_Folklore_', YEAR)
  )
GROUP BY country_indicator
ORDER BY uploads DESC;

-- ============================================
-- QUERY 7: Wiki Loves Africa - Country Statistics
-- ============================================
-- Africa typically runs in March

SELECT 
    CASE 
        WHEN img.img_user_text REGEXP '^[^@]+@' THEN 'Unknown'
        ELSE COALESCE(
            (SELECT user_registration 
             FROM user 
             WHERE user.user_id = img.img_user 
             LIMIT 1),
            'Unknown'
        )
    END AS country_indicator,
    COUNT(*) AS uploads,
    COUNT(DISTINCT img.img_user_text) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks 
            WHERE il_from = img.img_id
        ) THEN img.img_id 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN user.user_registration >= CONCAT(YEAR, '0301000000')
            AND user.user_registration <= CONCAT(YEAR, '0331235959')
        THEN img.img_user_text 
    END) AS new_uploaders
FROM image img
LEFT JOIN user ON img.img_user = user.user_id
INNER JOIN categorylinks cl ON img.img_id = cl.cl_from
WHERE img.img_timestamp >= CONCAT(YEAR, '0301000000')
  AND img.img_timestamp <= CONCAT(YEAR, '0331235959')
  AND cl.cl_to IN (
    CONCAT('Images_from_Wiki_Loves_Africa_', YEAR),
    CONCAT('Images_from_Wiki_Loves_Africa_', YEAR, '_in_'),
    CONCAT('Wiki_Loves_Africa_', YEAR)
  )
GROUP BY country_indicator
ORDER BY uploads DESC;

-- ============================================
-- NOTES:
-- ============================================
-- 1. Country detection in Commons is complex - the queries above use
--    user registration as a proxy, but actual country data may need
--    to come from campaign-specific tracking or user profiles
--
-- 2. Category names vary - always run QUERY 5 first to see what
--    categories actually exist for a campaign
--
-- 3. Date ranges vary by campaign - check the official campaign page
--    for exact dates
--
-- 4. Some campaigns may use different naming conventions - adjust
--    the category patterns as needed
--
-- 5. After running queries, export as CSV with headers, then use:
--    python backend/queries/process_quarry_results.py <export_dir>

