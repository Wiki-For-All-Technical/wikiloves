# All Wiki Loves Campaigns Added

## Summary

✅ **All 25 Wiki Loves campaigns have been added to the tool!**

- **Total Campaigns**: 25
- **Campaigns with Data**: 6 (existing campaigns)
- **Campaigns without Data**: 19 (newly added, will show "no data" message)

## Campaigns with Data

These campaigns have statistics data and will display full information:

1. Wiki Loves Earth
2. Wiki Loves Monuments
3. Wiki Loves Africa
4. Wiki Loves Folklore
5. Wiki Science Competition
6. Wiki Loves Public Art

## Campaigns Added (Without Data Yet)

These campaigns are now in the tool but need data to be added:

1. Wiki Loves Biodiversity
2. Wiki Loves Books
3. Wiki Loves Coasts
4. Wiki Loves Dance
5. Wiki Loves Democracy
6. Wiki Loves Design
7. Wiki Loves Fashion
8. Wiki Loves Food
9. Wiki Loves Heritage
10. Wiki Loves Libraries
11. Wiki Loves Love
12. Wiki Loves Maps
13. Wiki Loves Mountains
14. Wiki Loves Music
15. Wiki Loves Peace
16. Wiki Loves Rivers
17. Wiki Loves Sports
18. Wiki Loves Trees
19. Wiki Loves Women

## What Changed

1. **Catalog Updated**: All 25 campaigns are now in `backend/data/catalog.py`
2. **Frontend Updated**: Campaigns without data show a friendly "no data" message
3. **Navigation Updated**: All campaigns appear in navigation and can be filtered by category
4. **API Updated**: All campaigns are accessible via the API, even without data

## Adding Data to Campaigns

To add data for campaigns without statistics:

### Option 1: Using Quarry
1. Go to https://quarry.wmcloud.org
2. Use queries from `backend/queries/quarry_templates.py`
3. Export results as JSON/CSV
4. Run: `python backend/queries/process_quarry_results.py quarry_exports/`

### Option 2: Using db.json
1. Add data to `db.json` in format: `campaignname2024: { "Country": {...} }`
2. Run: `python backend/convert_full_data.py`

### Option 3: Manual Entry
1. Edit `backend/data/catalog.py` directly
2. Add year entries to the campaign's `years` array

## Testing

1. Start the backend: `python backend/app.py`
2. Start the frontend: `cd frontend/Wikiproject && npm run dev`
3. Visit the home page - you should see all 25 campaigns
4. Use the category filter to see campaigns by type (International, Regional, Local)
5. Campaigns without data will show a "No statistics data available" message

## Next Steps

- Add data for the 19 campaigns without statistics using Quarry or other data sources
- Verify all campaign metadata (logos, colors, taglines) are correct
- Add more campaigns if needed by updating `backend/data/campaigns_metadata.py`









