# Quick Start: Adding Remaining Campaigns

Based on your category discovery, here are campaigns that **likely have data** in Commons:

## Campaigns with Known Categories (From Your Discovery)

These campaigns were found in your category discovery JSON:

### 1. Wiki Loves Birds
- **Category**: `Images_from_Wiki_Loves_Birds_2024`
- **Prefix**: `birds`
- **Action**: Create multi-year query using this category pattern

### 2. Wiki Loves Fashion  
- **Category**: `Wiki_Loves_Fashion_2024`
- **Prefix**: `fashion`
- **Action**: Create multi-year query

### 3. Wiki Loves Film
- **Category**: `Wiki_Loves_Film_2024`
- **Prefix**: `film`
- **Action**: Create multi-year query

### 4. Wiki Loves Pride
- **Category**: `Wiki_Loves_Pride_2024`
- **Prefix**: `pride`
- **Action**: Create multi-year query

### 5. Wiki Loves Onam
- **Category**: `Images_from_Wiki_Loves_Onam_2024`
- **Prefix**: `onam`
- **Action**: Create multi-year query

### 6. Wiki Loves Heritage Belgium
- **Category**: `Images_from_Wiki_Loves_Heritage_Belgium_in_2024`
- **Prefix**: `heritage_belgium` (check if this exists in metadata)
- **Action**: May need special handling due to location-specific name

## Quick Process for Each Campaign

### Step 1: Create Multi-Year Query

Copy this template and customize:

```sql
-- Template for Wiki Loves [Campaign Name]
SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0101000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to LIKE '[YOUR_CATEGORY_PATTERN]%'  -- Replace this!
  AND cl.cl_to REGEXP '[YOUR_PATTERN][0-9]{4}$'  -- Replace this!
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2020 AND 2025
GROUP BY year
ORDER BY year DESC;
```

**Replace**:
- `[YOUR_CATEGORY_PATTERN]` with the category pattern (e.g., `Wiki_Loves_Fashion_`)
- Adjust year range based on when campaign started

### Step 2: Run in Quarry

1. Go to https://quarry.wmcloud.org
2. Select database: `commonswiki_p`
3. Paste and run query
4. Download as JSON

### Step 3: Convert Format

```bash
python backend/scripts/convert_quarry_export.py <file.json.json>
```

### Step 4: Process

```bash
python backend/scripts/process_multiyear_quarry.py <file_converted.json> <prefix>
```

## Example: Wiki Loves Fashion

Here's a complete example:

**1. Query:**
```sql
SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0101000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to LIKE 'Wiki_Loves_Fashion_%'
  AND cl.cl_to REGEXP 'Wiki_Loves_Fashion_[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2020 AND 2025
GROUP BY year
ORDER BY year DESC;
```

**2. Download as**: `fashion_multiyear.json.json`

**3. Convert:**
```bash
python backend/scripts/convert_quarry_export.py fashion_multiyear.json.json
```

**4. Process:**
```bash
python backend/scripts/process_multiyear_quarry.py fashion_multiyear_converted.json fashion
```

## Batch Processing

To process multiple campaigns at once:

```bash
# Convert all files
python backend/scripts/convert_quarry_export.py quarry_data/

# Process each campaign
python backend/scripts/process_multiyear_quarry.py quarry_data/fashion_multiyear_converted.json fashion
python backend/scripts/process_multiyear_quarry.py quarry_data/film_multiyear_converted.json film
python backend/scripts/process_multiyear_quarry.py quarry_data/pride_multiyear_converted.json pride
python backend/scripts/process_multiyear_quarry.py quarry_data/birds_multiyear_converted.json birds
# ... etc
```

## Need Help?

1. **Check discovery guide**: `HOW_TO_ADD_REMAINING_CAMPAIGNS.md`
2. **Run discovery script**: `python backend/scripts/discover_campaign_data.py`
3. **Generate check queries**: `python backend/scripts/discover_campaign_data.py --queries`

## Priority Order

Based on your category discovery, prioritize:

1. **Wiki Loves Birds** - Found in discovery
2. **Wiki Loves Fashion** - Found in discovery  
3. **Wiki Loves Film** - Found in discovery
4. **Wiki Loves Pride** - Found in discovery
5. **Wiki Loves Onam** - Found in discovery

Then check others with the discovery query!







