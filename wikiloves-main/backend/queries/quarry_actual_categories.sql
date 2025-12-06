-- ============================================
-- Quarry Queries Using ACTUAL Category Names from 2024
-- ============================================
-- Based on real category discovery from Commons
-- Database: commonswiki_p
-- 
-- These use the exact category names that exist in Commons
-- ============================================

-- ============================================
-- QUERY 1: Wiki Loves Monuments 2024 - Complete Statistics
-- ============================================
-- Uses the actual category: Images_from_Wiki_Loves_Monuments_2024

SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240901000000'
            AND u.user_registration <= '20240930235959'
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN user u ON a.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024';

-- ============================================
-- QUERY 2: Wiki Loves Earth 2024 - Complete Statistics
-- ============================================
-- Uses the actual category: Images_from_Wiki_Loves_Earth_2024

SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240501000000'
            AND u.user_registration <= '20240531235959'
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN user u ON a.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Images_from_Wiki_Loves_Earth_2024';

-- ============================================
-- QUERY 3: Wiki Loves Africa 2024 - Complete Statistics
-- ============================================
-- Uses the actual category: Images_from_Wiki_Loves_Africa_2024

SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240301000000'
            AND u.user_registration <= '20240331235959'
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN user u ON a.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Images_from_Wiki_Loves_Africa_2024';

-- ============================================
-- QUERY 4: Wiki Loves Folklore 2024 - Complete Statistics
-- ============================================
-- Uses the actual category: Images_from_Wiki_Loves_Folklore_2024

SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240201000000'
            AND u.user_registration <= '20240228235959'
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN user u ON a.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Images_from_Wiki_Loves_Folklore_2024';

-- ============================================
-- QUERY 5: Wiki Loves Birds 2024 - Complete Statistics
-- ============================================
-- Uses the actual category: Images_from_Wiki_Loves_Birds_2024

SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240101000000'
            AND u.user_registration <= '20241231235959'
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN user u ON a.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Images_from_Wiki_Loves_Birds_2024';

-- ============================================
-- QUERY 6: Wiki Loves Fashion 2024 - Complete Statistics
-- ============================================
-- Uses the actual category: Wiki_Loves_Fashion_2024

SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240101000000'
            AND u.user_registration <= '20241231235959'
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN user u ON a.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Wiki_Loves_Fashion_2024';

-- ============================================
-- QUERY 7: Wiki Loves Film 2024 - Complete Statistics
-- ============================================
-- Uses the actual category: Wiki_Loves_Film_2024

SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240101000000'
            AND u.user_registration <= '20241231235959'
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN user u ON a.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Wiki_Loves_Film_2024';

-- ============================================
-- QUERY 8: Wiki Loves Pride 2024 - Complete Statistics
-- ============================================
-- Uses the actual category: Wiki_Loves_Pride_2024

SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240101000000'
            AND u.user_registration <= '20241231235959'
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN user u ON a.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Wiki_Loves_Pride_2024';

-- ============================================
-- QUERY 9: Wiki Loves Sport 2024 - Complete Statistics
-- ============================================
-- Uses the actual category: Wiki_Loves_Sport_2024 (check if this exists)
-- If not, try: Banner_Wiki_Loves_Sport_2024

SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240101000000'
            AND u.user_registration <= '20241231235959'
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN user u ON a.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (cl.cl_to = 'Wiki_Loves_Sport_2024' OR cl.cl_to LIKE '%Wiki_Loves_Sport%2024%');

-- ============================================
-- QUERY 10: Wiki Loves Onam 2024 - Complete Statistics
-- ============================================
-- Uses the actual category: Images_from_Wiki_Loves_Onam_2024

SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240101000000'
            AND u.user_registration <= '20241231235959'
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN user u ON a.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Images_from_Wiki_Loves_Onam_2024';

-- ============================================
-- QUERY 11: Wiki Loves Heritage Belgium 2024 - Complete Statistics
-- ============================================
-- Uses the actual category: Images_from_Wiki_Loves_Heritage_Belgium_in_2024

SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240101000000'
            AND u.user_registration <= '20241231235959'
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN user u ON a.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Images_from_Wiki_Loves_Heritage_Belgium_in_2024';

-- ============================================
-- QUERY 12: Generic Template - Use for any campaign
-- ============================================
-- Replace 'Images_from_Wiki_Loves_Monuments_2024' with your category name

SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240101000000'
            AND u.user_registration <= '20241231235959'
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN user u ON a.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024';

-- ============================================
-- NOTES:
-- ============================================
-- Main categories found in 2024:
--   - Images_from_Wiki_Loves_Monuments_2024
--   - Images_from_Wiki_Loves_Earth_2024
--   - Images_from_Wiki_Loves_Africa_2024
--   - Images_from_Wiki_Loves_Folklore_2024
--   - Images_from_Wiki_Loves_Birds_2024
--   - Images_from_Wiki_Loves_Onam_2024
--   - Wiki_Loves_Fashion_2024
--   - Wiki_Loves_Film_2024
--   - Wiki_Loves_Pride_2024
--   - Images_from_Wiki_Loves_Heritage_Belgium_in_2024
--
-- These queries use the working pattern:
--   categorylinks → page → image → actor_image
--
-- Export results as CSV, then process with:
--   python backend/queries/process_quarry_results.py <export_dir>

