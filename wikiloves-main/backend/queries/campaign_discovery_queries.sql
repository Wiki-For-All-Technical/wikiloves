-- ============================================
-- CAMPAIGN DATA DISCOVERY QUERIES
-- ============================================
-- Run these queries in Quarry to check which campaigns have data
-- Database: commonswiki_p


-- ============================================
-- CHECK: Wiki Loves Monuments (monuments)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%monuments%'
    OR cl.cl_to LIKE '%Wiki_Loves_Monuments%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Earth (earth)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%earth%'
    OR cl.cl_to LIKE '%Wiki_Loves_Earth%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Folklore (folklore)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%folklore%'
    OR cl.cl_to LIKE '%Wiki_Loves_Folklore%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Science Competition (science)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%science%'
    OR cl.cl_to LIKE '%Wiki_Science_Competition%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Public Art (public_art)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%public_art%'
    OR cl.cl_to LIKE '%Wiki_Loves_Public_Art%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Africa (africa)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%africa%'
    OR cl.cl_to LIKE '%Wiki_Loves_Africa%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Food (food)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%food%'
    OR cl.cl_to LIKE '%Wiki_Loves_Food%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Women (women)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%women%'
    OR cl.cl_to LIKE '%Wiki_Loves_Women%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Libraries (libraries)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%libraries%'
    OR cl.cl_to LIKE '%Wiki_Loves_Libraries%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Fashion (fashion)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%fashion%'
    OR cl.cl_to LIKE '%Wiki_Loves_Fashion%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Dance (dance)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%dance%'
    OR cl.cl_to LIKE '%Wiki_Loves_Dance%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Music (music)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%music%'
    OR cl.cl_to LIKE '%Wiki_Loves_Music%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Books (books)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%books%'
    OR cl.cl_to LIKE '%Wiki_Loves_Books%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Maps (maps)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%maps%'
    OR cl.cl_to LIKE '%Wiki_Loves_Maps%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Design (design)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%design%'
    OR cl.cl_to LIKE '%Wiki_Loves_Design%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Peace (peace)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%peace%'
    OR cl.cl_to LIKE '%Wiki_Loves_Peace%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Love (love)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%love%'
    OR cl.cl_to LIKE '%Wiki_Loves_Love%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Heritage (heritage)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%heritage%'
    OR cl.cl_to LIKE '%Wiki_Loves_Heritage%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Democracy (democracy)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%democracy%'
    OR cl.cl_to LIKE '%Wiki_Loves_Democracy%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Sports (sports)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%sports%'
    OR cl.cl_to LIKE '%Wiki_Loves_Sports%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Trees (trees)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%trees%'
    OR cl.cl_to LIKE '%Wiki_Loves_Trees%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Rivers (rivers)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%rivers%'
    OR cl.cl_to LIKE '%Wiki_Loves_Rivers%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Mountains (mountains)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%mountains%'
    OR cl.cl_to LIKE '%Wiki_Loves_Mountains%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Coasts (coasts)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%coasts%'
    OR cl.cl_to LIKE '%Wiki_Loves_Coasts%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;



-- ============================================
-- CHECK: Wiki Loves Biodiversity (biodiversity)
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%biodiversity%'
    OR cl.cl_to LIKE '%Wiki_Loves_Biodiversity%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;


