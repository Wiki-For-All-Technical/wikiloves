# Wiki Loves Atlas - Expansion Guide

This guide explains how the tool has been expanded to support ALL Wiki Loves campaigns.

## What Changed

### 1. Comprehensive Campaign Metadata

**File**: `backend/data/campaigns_metadata.py`

- Added metadata for 25+ Wiki Loves campaigns
- Campaigns categorized as: international, regional, or local
- Each campaign includes: slug, name, tagline, colors, logos, etc.

### 2. Quarry Integration

**Directory**: `backend/queries/`

- SQL query templates for extracting statistics from Wikimedia databases
- Scripts to process Quarry export files (CSV/JSON)
- Support for category-based and upload-based queries

### 3. Enhanced Data Processing

**File**: `backend/convert_full_data.py`

- Now imports campaign metadata from `campaigns_metadata.py`
- Supports processing data from multiple sources (db.json, Quarry exports)

**File**: `backend/queries/process_quarry_results.py`

- New script to merge Quarry query results into catalog format
- Handles both CSV and JSON exports
- Automatically ranks countries and calculates statistics

### 4. Enhanced API

**File**: `backend/app.py`

New endpoints:
- `GET /api/competitions?category=international` - Filter competitions by category
- `GET /api/statistics/comparison?year=2024` - Cross-campaign comparison
- `GET /api/statistics/trends?campaigns=wiki-loves-earth,wiki-loves-monuments` - Trend analysis

**File**: `backend/services/catalog.py`

New functions:
- `build_competition_summaries(category=None)` - Category filtering
- `build_cross_campaign_comparison(year=None)` - Comparison statistics
- `build_trend_analysis(campaign_slugs=None)` - Trend data

### 5. Frontend Enhancements

**File**: `frontend/Wikiproject/src/views/HomeView.vue`

- Added category filter dropdown
- Filter by: All, International, Regional, Local

**File**: `frontend/Wikiproject/src/views/ComparisonView.vue`

- New comparison view for cross-campaign statistics
- Year-based filtering
- Sortable table with rankings

**File**: `frontend/Wikiproject/src/services/api.js`

- Added `fetchCompetitions(category)`
- Added `fetchComparison(year)`
- Added `fetchTrends(campaigns)`

**File**: `frontend/Wikiproject/src/stores/catalog.js`

- Enhanced store with category filtering support
- Added comparison and trends loading methods

## Adding New Campaigns

### Step 1: Add Campaign Metadata

Edit `backend/data/campaigns_metadata.py`:

```python
"new_campaign": {
    "slug": "wiki-loves-new",
    "name": "Wiki Loves New",
    "short_label": "WL New",
    "tagline": "Description here.",
    "accent_color": "#hexcolor",
    "hero_image": "url",
    "logo": "url",
    "category": "international",  # or "regional" or "local"
    "path_segment": "new",
    "quarry_category": "new",
}
```

### Step 2: Get Data

Option A: Use Quarry
1. Format a query using `queries/quarry_templates.py`
2. Run in https://quarry.wmcloud.org
3. Export as JSON/CSV
4. Save as `new_2024.json` (or appropriate year)

Option B: Use existing db.json
- Add data in format: `new2024: { "Country": { "count": ..., "usage": ..., ... } }`

### Step 3: Process Data

```bash
# If using Quarry exports
python backend/queries/process_quarry_results.py quarry_exports/ --output backend/data/catalog.py

# If using db.json
python backend/convert_full_data.py
```

### Step 4: Test

1. Start backend: `python backend/app.py`
2. Check API: `http://127.0.0.1:5000/api/competitions`
3. Verify campaign appears in frontend

## Data Sources

### Current Data
- Existing campaigns use `db.json` format
- Processed via `convert_full_data.py`

### Quarry Data
- New campaigns can use Quarry queries
- Processed via `process_quarry_results.py`
- More accurate for recent campaigns

### Mixed Approach
- Can combine both sources
- Quarry data takes precedence if both exist

## Campaign Categories

- **International**: Major global campaigns (Monuments, Earth, Folklore, Science, Public Art)
- **Regional**: Regional campaigns (Africa, Food, Women, etc.)
- **Local**: Country or city-specific campaigns

## API Usage Examples

### Filter by Category
```bash
curl "http://127.0.0.1:5000/api/competitions?category=international"
```

### Get Comparison
```bash
curl "http://127.0.0.1:5000/api/statistics/comparison?year=2024"
```

### Get Trends
```bash
curl "http://127.0.0.1:5000/api/statistics/trends?campaigns=wiki-loves-earth,wiki-loves-monuments"
```

## Frontend Routes

- `/` - Home with all campaigns (filterable)
- `/comparison` - Cross-campaign comparison
- `/:segment` - Campaign detail (e.g., `/earth`)
- `/:segment/:year` - Campaign year detail (e.g., `/earth/2024`)
- `/country/:slug` - Country detail

## Next Steps

1. **Add More Campaigns**: Use Quarry to extract data for additional campaigns
2. **Improve Queries**: Refine SQL queries for better accuracy
3. **Add Visualizations**: Create charts for comparison and trends
4. **Performance**: Consider database migration for very large datasets
5. **Automation**: Set up scheduled jobs to refresh data from Quarry

## Troubleshooting

### Campaign Not Appearing
- Check `campaigns_metadata.py` has the campaign
- Verify data exists in catalog
- Check API response: `/api/competitions`

### Quarry Query Issues
- Verify database selection (`commonswiki_p`)
- Check category names match Commons categories
- Adjust date ranges if needed

### Frontend Filtering Not Working
- Check API supports category parameter
- Verify store is calling `fetchCompetitions(category)`
- Check browser console for errors









