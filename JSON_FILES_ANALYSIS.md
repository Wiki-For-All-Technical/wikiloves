# Analysis of Earth JSON Files

## Files Analyzed
1. `query19.json` - Year summary data (one row per year)
2. `earth_complete_with_countries.json` - Country breakdown data (multiple rows per year)

## Comparison with Reference Data

| Year | query19.json | earth_complete.json | Reference | Difference | Status |
|------|--------------|---------------------|-----------|------------|--------|
| 2013 | **0** | **N/A** | 275 | +275 (100%) | ✗ **ERROR** |
| 2014 | 2,417 | 2,417 | 2,364 | -53 (2.2%) | ✓ OK |
| 2015 | 7,662 | 7,661 | 7,700 | +38 (0.5%) | ✓ OK |
| 2016 | 11,892 | 11,890 | 11,654 | -238 (2.0%) | ✓ OK |
| 2017 | 13,241 | 13,241 | 13,629 | +388 (2.8%) | ✓ OK |
| 2018 | 6,139 | 6,139 | 6,276 | +137 (2.2%) | ✓ OK |
| 2019 | 8,328 | 8,327 | 8,314 | -14 (0.2%) | ✓ OK |
| 2020 | 7,650 | 7,650 | 7,541 | -109 (1.4%) | ✓ OK |
| 2021 | 3,502 | 3,502 | 3,512 | +10 (0.3%) | ✓ OK |
| 2022 | 3,062 | 3,062 | 3,222 | +160 (5.0%) | ⚠ WARNING |
| 2023 | 2,482 | 2,481 | 2,376 | -106 (4.5%) | ✓ OK |
| 2024 | 2,726 | 2,726 | 2,726 | 0 (0.0%) | ✓ OK |
| 2025 | 4,025 | 4,025 | 3,680 | -345 (9.4%) | ⚠ WARNING |

## Critical Issues

### 1. 2013 Data Missing/Incorrect
- **query19.json**: Shows 0 new_uploaders for 2013
- **earth_complete_with_countries.json**: Has no Global row for 2013 (only Ukraine with 100)
- **Expected**: ~275 new_uploaders
- **Action Required**: Re-query 2013 data with fixed date range

### 2. 2022 and 2025 Discrepancies
- **2022**: 5% difference (3,062 vs 3,222)
- **2025**: 9.4% difference (4,025 vs 3,680)
- **Action Required**: Verify these years with fixed queries

## Observations

1. **Most years are accurate**: 2014-2024 are within 0-5% of reference, suggesting the date range might already be correct for most years.

2. **2013 is the main problem**: Complete absence of correct data for 2013.

3. **Data consistency**: The two files show very similar values for years where both have data, indicating they're from the same source.

## Recommended Actions

### Option 1: Fix 2013 Only (Quick Fix)
1. Run `earth_2013_2014_fix_new_uploaders.sql` in Quarry
2. Download results for 2013
3. Update `query19.json` with 2013 data
4. Add Global row for 2013 to `earth_complete_with_countries.json`

### Option 2: Complete Re-query (Thorough Fix)
1. Run `earth_complete_fixed_new_uploaders.sql` in Quarry (all years with country breakdown)
2. Download results
3. Replace `earth_complete_with_countries.json`
4. Run `earth_multiyear_summary_fixed.sql` for year totals
5. Replace `query19.json`

### Option 3: Verify Date Range
The fact that most years are already close to reference suggests:
- Either the files were already updated with a broader date range
- Or the reference website uses a different definition than expected
- Consider checking if the current date range is actually May 1 - Dec 31 already

## Next Steps

1. **Immediate**: Fix 2013 data (highest priority)
2. **Secondary**: Verify 2022 and 2025 data
3. **Verify**: Check what date range was actually used in these queries



