# Quarry Query Templates

This directory contains SQL query templates for extracting Wiki Loves campaign statistics from Wikimedia databases using [Quarry](https://quarry.wmcloud.org).

## Overview

Quarry is a web-based tool that allows running SQL queries against Wikimedia databases. These templates help extract statistics for all Wiki Loves campaigns.

## Usage

### 1. Access Quarry

1. Go to https://quarry.wmcloud.org
2. Log in with your Wikimedia account
3. Select the database: `commonswiki_p` (for Commons images)

### 2. Using Query Templates

The templates in `quarry_templates.py` can be formatted with campaign-specific parameters:

```python
from queries.quarry_templates import format_query, CATEGORY_BASED_QUERY

# Format a query for Wiki Loves Earth 2024
query = format_query(
    CATEGORY_BASED_QUERY,
    campaign_name="Wiki Loves Earth",
    campaign_category="earth",
    year=2024
)

print(query)
```

### 3. Running Queries

1. Copy the formatted query
2. Paste it into Quarry
3. Execute the query
4. Export results as CSV or JSON

### 4. Processing Results

Use `process_quarry_results.py` to convert Quarry exports into the catalog format:

```bash
# Process all Quarry exports in a directory
python backend/queries/process_quarry_results.py quarry_exports/ --output backend/data/catalog.py
```

Expected file naming: `campaign_year.ext` (e.g., `earth_2024.json`, `monuments_2023.csv`)

## Query Templates

### CATEGORY_BASED_QUERY
Most accurate - uses Commons categories to identify campaign images.

### UPLOAD_STATS_BY_COUNTRY
Extracts upload statistics grouped by country.

### CAMPAIGN_OVERVIEW_TEMPLATE
Overall campaign statistics (totals, averages).

### UPLOAD_TREND_TEMPLATE
Monthly upload trends for visualization.

## Campaign Categories

Campaigns are identified by their category/prefix:
- `monuments` - Wiki Loves Monuments
- `earth` - Wiki Loves Earth
- `africa` - Wiki Loves Africa
- `folklore` - Wiki Loves Folklore
- `science` - Wiki Science Competition
- `public_art` - Wiki Loves Public Art
- And many more (see `campaigns_metadata.py`)

## Data Structure

Quarry results should include:
- `country` or `name` - Country name
- `uploads` - Number of uploads
- `uploaders` - Number of unique uploaders
- `new_uploaders` - Number of newly registered uploaders
- `images_used` - Number of images used in articles

## Notes

- Quarry has query time limits - optimize queries for large datasets
- Some campaigns may use different category naming conventions
- Date ranges may vary by campaign (check `get_campaign_dates()`)
- Always verify results against official campaign data

## Example Workflow

1. Identify campaigns to update in `campaigns_metadata.py`
2. Format queries for each campaign/year combination
3. Run queries in Quarry and export results
4. Save exports as `campaign_year.json` in a directory
5. Run `process_quarry_results.py` to merge into catalog
6. Test the updated catalog with the Flask API









