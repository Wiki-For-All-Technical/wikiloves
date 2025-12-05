# Summary: Adding Data for Remaining Wiki Loves Campaigns

## Current Status

### ✅ Completed (6 campaigns)
- Wiki Loves Monuments (2010-2025) - Full data with countries
- Wiki Loves Earth (2013-2025) - Full data with countries
- Wiki Loves Africa (2014-2025) - Summary data
- Wiki Loves Folklore (2021-2025) - Summary data
- Wiki Science Competition (2011-2025) - Summary data
- Wiki Loves Public Art (2013) - Summary data

### 📋 Remaining (19+ campaigns)

Based on your category discovery, these campaigns **likely have data**:

1. **Wiki Loves Birds** - Category found: `Images_from_Wiki_Loves_Birds_2024`
2. **Wiki Loves Fashion** - Category found: `Wiki_Loves_Fashion_2024`
3. **Wiki Loves Film** - Category found: `Wiki_Loves_Film_2024`
4. **Wiki Loves Pride** - Category found: `Wiki_Loves_Pride_2024`
5. **Wiki Loves Onam** - Category found: `Images_from_Wiki_Loves_Onam_2024`

**Others to check**:
- Wiki Loves Food
- Wiki Loves Women
- Wiki Loves Sport
- Wiki Loves Heritage
- And 10+ more (see full list below)

## Quick Workflow

### Option 1: Discover First (Recommended)

1. **Run discovery query** in Quarry to see what exists:
   ```sql
   -- See: HOW_TO_ADD_REMAINING_CAMPAIGNS.md for full query
   ```

2. **For each campaign with data**:
   - Create multi-year query (use template)
   - Run in Quarry
   - Download and convert JSON
   - Process with script

### Option 2: Use Known Categories

For campaigns you know have data (Birds, Fashion, Film, Pride, Onam):

1. **Copy query template** from `quarry_multiyear_all_campaigns.sql`
2. **Replace category pattern** with known pattern
3. **Run in Quarry** and download
4. **Process**: `python backend/scripts/process_multiyear_quarry.py <file> <prefix>`

## Files Created to Help You

1. **`HOW_TO_ADD_REMAINING_CAMPAIGNS.md`** - Complete step-by-step guide
2. **`QUICK_START_REMAINING_CAMPAIGNS.md`** - Quick reference for known campaigns
3. **`backend/scripts/discover_campaign_data.py`** - Discovery script
4. **`backend/queries/campaign_discovery_queries.sql`** - Individual check queries

## Complete List of Remaining Campaigns

| Campaign | Prefix | Status | Action |
|----------|--------|--------|--------|
| Wiki Loves Birds | `birds` | ⚠️ Likely has data | Create query |
| Wiki Loves Fashion | `fashion` | ⚠️ Likely has data | Create query |
| Wiki Loves Film | `film` | ⚠️ Likely has data | Create query |
| Wiki Loves Pride | `pride` | ⚠️ Likely has data | Create query |
| Wiki Loves Onam | `onam` | ⚠️ Likely has data | Create query |
| Wiki Loves Food | `food` | ❓ Check first | Run discovery |
| Wiki Loves Women | `women` | ❓ Check first | Run discovery |
| Wiki Loves Sport | `sport` | ❓ Check first | Run discovery |
| Wiki Loves Heritage | `heritage` | ❓ Check first | Run discovery |
| Wiki Loves Libraries | `libraries` | ❓ Check first | Run discovery |
| Wiki Loves Dance | `dance` | ❓ Check first | Run discovery |
| Wiki Loves Music | `music` | ❓ Check first | Run discovery |
| Wiki Loves Books | `books` | ❓ Check first | Run discovery |
| Wiki Loves Maps | `maps` | ❓ Check first | Run discovery |
| Wiki Loves Design | `design` | ❓ Check first | Run discovery |
| Wiki Loves Peace | `peace` | ❓ Check first | Run discovery |
| Wiki Loves Love | `love` | ❓ Check first | Run discovery |
| Wiki Loves Democracy | `democracy` | ❓ Check first | Run discovery |
| Wiki Loves Sports | `sports` | ❓ Check first | Run discovery |
| Wiki Loves Trees | `trees` | ❓ Check first | Run discovery |
| Wiki Loves Rivers | `rivers` | ❓ Check first | Run discovery |
| Wiki Loves Mountains | `mountains` | ❓ Check first | Run discovery |
| Wiki Loves Coasts | `coasts` | ❓ Check first | Run discovery |
| Wiki Loves Biodiversity | `biodiversity` | ❓ Check first | Run discovery |

## Next Steps

1. **Start with known campaigns** (Birds, Fashion, Film, Pride, Onam)
2. **Run discovery query** to find others
3. **Process systematically** - one campaign at a time
4. **Add country breakdowns** for major campaigns later

## Commands Reference

```bash
# Discover campaigns
python backend/scripts/discover_campaign_data.py

# Generate check queries
python backend/scripts/discover_campaign_data.py --queries

# Convert Quarry exports
python backend/scripts/convert_quarry_export.py quarry_data/

# Process multi-year data
python backend/scripts/process_multiyear_quarry.py <file.json> <prefix>
```

Your tool is ready - campaigns without data will show "No statistics data available" until you add them!







