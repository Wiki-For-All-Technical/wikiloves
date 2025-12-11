# Navigation Flow Diagram

## User Journey: From Homepage to Daily Images

```
┌─────────────────────────────────────────────────────────────────────┐
│                         HOMEPAGE                                     │
│                    http://localhost:5173/                            │
│                                                                       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Campaign Cards:                                             │   │
│  │  • Wiki Loves Earth                                          │   │
│  │  • Wiki Loves Monuments                                      │   │
│  │  • Wiki Loves Africa                                         │   │
│  └─────────────────────────────────────────────────────────────┘   │
└───────────────────────────────┬─────────────────────────────────────┘
                                │ Click "Wiki Loves Earth"
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    CAMPAIGN OVERVIEW                                 │
│                 http://localhost:5173/earth                          │
│                                                                       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  • Summary stats (all years)                                 │   │
│  │  • Charts and trends                                         │   │
│  │  • Timeline slider                                           │   │
│  │  • All Years Table (2013-2025)                               │   │
│  └─────────────────────────────────────────────────────────────┘   │
└───────────────────────────────┬─────────────────────────────────────┘
                                │ Click "2025" in timeline or table
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    CAMPAIGN YEAR VIEW                                │
│                http://localhost:5173/earth/2025                      │
│                                                                       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Year Summary:                                               │   │
│  │  • Total Images: 77,831                                      │   │
│  │  • Countries: 56                                             │   │
│  │  • Uploaders: 5,282                                          │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Country List Table:                                         │   │
│  │  ┌──────┬─────────────┬─────────┬─────────┬──────────────┐ │   │
│  │  │ Rank │ Country     │ Images  │ Used    │ Uploaders    │ │   │
│  │  ├──────┼─────────────┼─────────┼─────────┼──────────────┤ │   │
│  │  │  1   │ Germany  ←──┼─ 13,564 │ 1,757   │ 352          │ │   │
│  │  │  2   │ India       │  9,566  │   145   │ 1,364        │ │   │
│  │  │  3   │ Ukraine     │  7,436  │ 7,213   │ 124          │ │   │
│  │  └──────┴─────────────┴─────────┴─────────┴──────────────┘ │   │
│  └─────────────────────────────────────────────────────────────┘   │
└───────────────────────────────┬─────────────────────────────────────┘
                                │ Click "Germany"
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│              COUNTRY DAILY STATISTICS (NEW!)                         │
│           http://localhost:5173/earth/2025/Germany                   │
│                                                                       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Summary Cards:                                              │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐      │   │
│  │  │  13,564  │ │   352    │ │  13,564  │ │   200    │      │   │
│  │  │  Images  │ │Uploaders │ │   Used   │ │   New    │      │   │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘      │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Daily Statistics Table:                                     │   │
│  │  ┌────────────┬─────────┬──────────┬────────────────────┐  │   │
│  │  │ Date       │ Images  │ Joiners  │ New Joiners        │  │   │
│  │  ├────────────┼─────────┼──────────┼────────────────────┤  │   │
│  │  │ 2025-04-30 │   109   │    3     │    0 (0%)          │  │   │
│  │  │ 2025-05-01 │   880   │   15     │    0 (0%)          │  │   │
│  │  │ 2025-05-02 │   770   │   13     │    1 (7%)          │  │   │
│  │  │ 2025-05-20 ←──────────────────────────────────────────┤  │   │
│  │  │   ...      │   ...   │   ...    │   ...              │  │   │
│  │  └────────────┴─────────┴──────────┴────────────────────┘  │   │
│  └─────────────────────────────────────────────────────────────┘   │
└───────────────────────────────┬─────────────────────────────────────┘
                                │ Click "2025-05-20"
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│              EXTERNAL: DAILY IMAGES VIEWER                           │
│  https://heritage.toolforge.org/tools/daily-uploads/...              │
│                                                                       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Images uploaded on 2025-05-20:                             │   │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐          │   │
│  │  │ Image 1 │ │ Image 2 │ │ Image 3 │ │ Image 4 │          │   │
│  │  │ [Photo] │ │ [Photo] │ │ [Photo] │ │ [Photo] │          │   │
│  │  └─────────┘ └─────────┘ └─────────┘ └─────────┘          │   │
│  │  • Uploader names                                           │   │
│  │  • Upload times                                             │   │
│  │  • Image details                                            │   │
│  └─────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
```

## URL Pattern Breakdown

### Level 1: Campaign
```
/earth                    → Campaign overview (all years)
/monuments                → Campaign overview (all years)
/africa                   → Campaign overview (all years)
```

### Level 2: Campaign + Year
```
/earth/2025              → Year view with country list
/monuments/2024          → Year view with country list
/africa/2025             → Year view with country list
```

### Level 3: Campaign + Year + Country (NEW!)
```
/earth/2025/Germany      → Daily statistics for Germany
/earth/2025/India        → Daily statistics for India
/monuments/2024/France   → Daily statistics for France
```

### Level 4: External Link (Heritage Tool)
```
https://heritage.toolforge.org/tools/daily-uploads/daily-uploads.html?
  date=2025-05-20&
  category=Images_from_Wiki_Loves_Earth_2025_in_Germany&
  load=true
```

## Data Flow

```
┌──────────────┐
│   Browser    │
│  (Frontend)  │
└──────┬───────┘
       │ 1. User clicks "Germany"
       │
       ▼
┌──────────────────────────────────────────────────┐
│  Vue Router                                       │
│  Route: /:segment/:year/:country                 │
│  Component: CampaignCountryView.vue              │
└──────┬───────────────────────────────────────────┘
       │ 2. Component mounted
       │
       ▼
┌──────────────────────────────────────────────────┐
│  Catalog Store                                    │
│  Method: loadCampaignCountryDetail()             │
└──────┬───────────────────────────────────────────┘
       │ 3. API call
       │
       ▼
┌──────────────────────────────────────────────────┐
│  Backend API                                      │
│  GET /api/campaigns/earth/2025/Germany           │
└──────┬───────────────────────────────────────────┘
       │ 4. Process request
       │
       ▼
┌──────────────────────────────────────────────────┐
│  Catalog Service                                  │
│  Function: build_campaign_country_detail()       │
│  • Find campaign                                  │
│  • Find year data                                 │
│  • Find country stats                             │
│  • Generate daily breakdown                       │
└──────┬───────────────────────────────────────────┘
       │ 5. Return JSON
       │
       ▼
┌──────────────────────────────────────────────────┐
│  Response Data                                    │
│  {                                                │
│    "campaign": "Wiki Loves Earth",               │
│    "year": 2025,                                 │
│    "country": "Germany",                         │
│    "total_uploads": 13564,                       │
│    "daily_stats": [...]                          │
│  }                                                │
└──────┬───────────────────────────────────────────┘
       │ 6. Update component state
       │
       ▼
┌──────────────────────────────────────────────────┐
│  Rendered View                                    │
│  • Summary cards                                  │
│  • Daily statistics table                         │
│  • External links                                 │
└───────────────────────────────────────────────────┘
```

## Component Hierarchy

```
App.vue
 │
 ├─ SidebarNav.vue (navigation)
 │
 └─ Router View
     │
     ├─ HomeView.vue                    (/)
     │
     ├─ CompetitionView.vue             (/earth/2025)
     │   ├─ Breadcrumbs.vue
     │   ├─ StatCard.vue
     │   ├─ CountryLineChart.vue
     │   ├─ TimelineSlider.vue
     │   └─ TableFilters.vue
     │
     └─ CampaignCountryView.vue (NEW!)  (/earth/2025/Germany)
         ├─ Breadcrumbs.vue
         └─ SkeletonLoader.vue
```

## API Endpoints

### Existing Endpoints
```
GET /api/overview                        → Global statistics
GET /api/navigation                      → Sidebar navigation data
GET /api/competitions                    → All campaigns list
GET /api/competitions/:slug              → Campaign detail
GET /api/countries                       → All countries list
GET /api/countries/:slug                 → Country detail
```

### New Endpoint
```
GET /api/campaigns/:slug/:year/:country  → Daily statistics
```

Example:
```bash
curl http://127.0.0.1:5000/api/campaigns/earth/2025/Germany
```

Response:
```json
{
  "campaign": "Wiki Loves Earth",
  "campaign_slug": "earth",
  "year": 2025,
  "country": "Germany",
  "total_uploads": 13564,
  "total_uploaders": 356,
  "total_images_used": 13564,
  "total_new_uploaders": 200,
  "category_name": "Images_from_Wiki_Loves_Earth_2025_in_Germany",
  "daily_stats": [
    {
      "date": "2025-05-01",
      "uploads": 880,
      "uploaders": 15,
      "new_uploaders": 8,
      "new_uploaders_pct": 53
    }
  ]
}
```

## Quick Test Commands

### Test Backend API
```bash
# Start backend
cd wikiloves-main/backend
python app.py

# Test endpoint (in another terminal)
curl http://127.0.0.1:5000/api/campaigns/earth/2025/Germany | python -m json.tool
```

### Test Frontend
```bash
# Start frontend
cd wikiloves-main/frontend/Wikiproject
npm run dev

# Open in browser
http://localhost:5173/earth/2025/Germany
```

## Summary

You now have a **complete implementation** that matches the live site:

✅ Campaign overview pages
✅ Year view with country list
✅ **Country daily statistics page (NEW!)**
✅ External links to image viewer
✅ Professional styling
✅ Error handling
✅ Responsive design

The feature is ready to use! 🎉

