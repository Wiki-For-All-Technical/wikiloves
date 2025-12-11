-- ============================================
-- SIMPLE QUERY: List All Wiki Loves Campaigns
-- ============================================
-- This simple query shows all distinct Wiki Loves campaign categories
-- Database: commonswiki_p
-- ============================================

-- Simple query: Just get distinct category names
SELECT DISTINCT
    cl.cl_to AS campaign_category
FROM categorylinks cl
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_%'
    OR cl.cl_to LIKE '%Wiki_Science%'
    OR cl.cl_to LIKE '%WikiScience%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
ORDER BY cl.cl_to;

-- ============================================
-- VERIFICATION QUERY: Campaigns with File Counts (ULTRA-FAST VERSION)
-- ============================================
-- This query counts files per campaign category
-- No JOIN needed - just counts categorylinks (cl_type='file' means it's a file)
-- Database: commonswiki_p
-- ============================================

SELECT 
    cl.cl_to AS campaign_category,
    COUNT(DISTINCT cl.cl_from) AS file_count
FROM categorylinks cl
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_%'
    OR cl.cl_to LIKE '%Wiki_Science%'
    OR cl.cl_to LIKE '%WikiScience%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 100;

-- ============================================
-- SUMMARY QUERY: Count Campaigns with Data
-- ============================================
-- This query shows how many campaigns have file data
-- Fast version: counts categories with file_count > 0
-- Database: commonswiki_p
-- ============================================

SELECT 
    COUNT(*) AS campaigns_with_data
FROM (
    SELECT 
        cl.cl_to,
        COUNT(DISTINCT cl.cl_from) AS file_count
    FROM categorylinks cl
    WHERE cl.cl_type = 'file'
      AND (
        cl.cl_to LIKE '%Wiki_Loves_%'
        OR cl.cl_to LIKE '%Wiki_Science%'
        OR cl.cl_to LIKE '%WikiScience%'
      )
      AND cl.cl_to REGEXP '[0-9]{4}$'
    GROUP BY cl.cl_to
    HAVING file_count > 0
) AS campaigns_with_files;

-- ============================================
-- CAMPAIGN NAMES WITH FILE COUNTS (FAST VERSION)
-- ============================================
-- This query extracts campaign names and shows total file counts per campaign
-- Groups all categories by campaign name (e.g., all Monuments years together)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CASE 
        -- Handle Wiki Science
        WHEN cl.cl_to LIKE '%Wiki_Science%' OR cl.cl_to LIKE '%WikiScience%' THEN 'Science'
        
        -- Extract from "Images_from_Wiki_Loves_[Campaign]_YYYY" or similar patterns
        WHEN cl.cl_to LIKE '%Wiki_Loves_%' THEN
            TRIM(
                SUBSTRING_INDEX(
                    SUBSTRING_INDEX(
                        SUBSTRING_INDEX(cl.cl_to, 'Wiki_Loves_', -1),
                        '_in_',
                        1
                    ),
                    CONCAT('_', SUBSTRING_INDEX(cl.cl_to, '_', -1)),
                    1
                )
            )
        
        ELSE 'Unknown'
    END AS campaign_name,
    COUNT(DISTINCT cl.cl_from) AS total_files,
    COUNT(DISTINCT cl.cl_to) AS category_count
FROM categorylinks cl
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_%'
    OR cl.cl_to LIKE '%Wiki_Science%'
    OR cl.cl_to LIKE '%WikiScience%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY campaign_name
HAVING campaign_name != '' 
   AND campaign_name IS NOT NULL 
   AND campaign_name != 'Unknown'
   AND total_files > 0
ORDER BY total_files DESC;

-- ============================================
-- SUMMARY: Total Campaigns with Data
-- ============================================
-- Shows total count of unique campaign names that have file data
-- Database: commonswiki_p
-- ============================================

SELECT 
    COUNT(*) AS total_campaigns_with_data
FROM (
    SELECT 
        CASE 
            WHEN cl.cl_to LIKE '%Wiki_Science%' OR cl.cl_to LIKE '%WikiScience%' THEN 'Science'
            WHEN cl.cl_to LIKE '%Wiki_Loves_%' THEN
                TRIM(
                    SUBSTRING_INDEX(
                        SUBSTRING_INDEX(
                            SUBSTRING_INDEX(cl.cl_to, 'Wiki_Loves_', -1),
                            '_in_',
                            1
                        ),
                        CONCAT('_', SUBSTRING_INDEX(cl.cl_to, '_', -1)),
                        1
                    )
                )
            ELSE 'Unknown'
        END AS campaign_name,
        COUNT(DISTINCT cl.cl_from) AS total_files
    FROM categorylinks cl
    WHERE cl.cl_type = 'file'
      AND (
        cl.cl_to LIKE '%Wiki_Loves_%'
        OR cl.cl_to LIKE '%Wiki_Science%'
        OR cl.cl_to LIKE '%WikiScience%'
      )
      AND cl.cl_to REGEXP '[0-9]{4}$'
    GROUP BY campaign_name
    HAVING campaign_name != '' 
       AND campaign_name IS NOT NULL 
       AND campaign_name != 'Unknown'
       AND total_files > 0
) AS campaigns;

