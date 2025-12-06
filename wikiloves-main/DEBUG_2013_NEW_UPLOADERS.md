# Debug 2013 New Uploaders Issue

## Current Status
- ✅ Query is finding 2013 data (12,110 uploads, 394 uploaders)
- ❌ new_uploaders is only 101 (should be ~275)
- ❌ Date range fix (May 1 - Dec 31) only increased from 98 to 101

## The Problem

The reference website shows:
- **2013**: 346 uploaders, **275 new_uploaders** (79%)

Our query shows:
- **2013**: 394 uploaders, **101 new_uploaders** (25.6%)

We have MORE uploaders but FEWER new_uploaders, which suggests:
1. We might be counting different uploaders (different categories?)
2. The definition of "new uploaders" might be different
3. There might be NULL registration dates we're missing

## Diagnostic Queries

### Step 1: Check Registration Date Distribution

Run: `backend/queries/earth_2013_investigate_new_uploaders.sql`

This will show:
- How many uploaders registered before May 1, 2013
- How many registered May 1-31, 2013
- How many registered June 1 - Dec 31, 2013
- How many have NULL registration dates

### Step 2: Test Alternative Date Ranges

Run: `backend/queries/earth_2013_alternative_date_ranges.sql`

This will test:
- May 1-31 only: ~98-101
- May 1 - Dec 31: ~101 (current)
- April 1 - Dec 31: (maybe competition started earlier?)
- Jan 1 - Dec 31: (entire year)
- Total uploaders: (to see if we're missing any)

### Step 3: Check for NULL Registration Dates

Run: `backend/queries/earth_2013_debug_new_uploaders.sql`

This will show:
- Total uploaders
- Uploaders with NULL registration dates
- Uploaders registered before May 1
- Uploaders registered May 1 - Dec 31

## Possible Solutions

### Solution 1: Include NULL Registration Dates
Maybe the reference counts users with NULL registration dates as "new uploaders"? Try counting them:

```sql
COUNT(DISTINCT CASE
    WHEN u.user_registration IS NULL 
        OR (u.user_registration >= '20130501000000'
            AND u.user_registration <= '20131231235959')
    THEN a.actor_name
END) AS new_uploaders
```

### Solution 2: Different Date Range
Maybe "registered after competition start" means:
- April 1 - Dec 31 (competition might have started in April)
- Or the entire year (Jan 1 - Dec 31)

### Solution 3: Different Uploader Count
The reference shows 346 uploaders, but we have 394. Maybe we're including uploaders from different categories? Check if we need to filter more strictly.

## Next Steps

1. **Run the diagnostic queries** to understand the data distribution
2. **Check the reference website** to see if there's documentation about how "new uploaders" is calculated
3. **Try including NULL registration dates** in the count
4. **Test different date ranges** to see which one matches the reference

