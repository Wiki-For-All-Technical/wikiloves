-- ============================================
-- Schema Discovery Queries for Commons Database
-- ============================================
-- Run these in Quarry to understand the actual database structure
-- Database: commonswiki_p
-- ============================================

-- Check image table structure
DESCRIBE image;

-- Check user table structure (if it exists)
DESCRIBE user;

-- Check actor table (newer MediaWiki versions)
DESCRIBE actor;

-- Check revision table structure
DESCRIBE revision;

-- Get a sample row from image table
SELECT * FROM image LIMIT 1;

-- Check what columns are available in image table
SHOW COLUMNS FROM image;

-- Check if there's a way to link images to users
-- Try to find user-related columns
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'commonswiki_p'
  AND TABLE_NAME = 'image'
  AND COLUMN_NAME LIKE '%user%';

-- Check categorylinks structure
DESCRIBE categorylinks;

-- Check imagelinks structure  
DESCRIBE imagelinks;

-- Find all tables that might contain user information
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'commonswiki_p'
  AND (TABLE_NAME LIKE '%user%' OR TABLE_NAME LIKE '%actor%')
ORDER BY TABLE_NAME;

