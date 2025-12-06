# Quick Reference Card - Daily Statistics Feature

## 🚀 Start Commands

```bash
# Backend (Terminal 1)
cd wikiloves-main/backend
python app.py

# Frontend (Terminal 2)
cd wikiloves-main/frontend/Wikiproject
npm run dev
```

## 🔗 URL Examples

| What You Want | URL | What You See |
|--------------|-----|--------------|
| Campaign overview | `http://localhost:5173/earth` | All years, charts, trends |
| Year with countries | `http://localhost:5173/earth/2025` | Country list table |
| **Daily statistics** | `http://localhost:5173/earth/2025/Germany` | **Day-by-day breakdown** |

## 📊 What's New

### Before (What You Had)
```
/earth/2025
  ├─ Shows country list
  └─ Click country → Goes to generic country page
```

### After (What You Have Now)
```
/earth/2025
  ├─ Shows country list
  └─ Click country → Goes to DAILY STATISTICS page
      ├─ Daily upload breakdown
      ├─ Daily uploader counts
      ├─ New joiners per day
      └─ Links to view actual images
```

## 🎯 Quick Test

1. **Start both servers** (see commands above)
2. **Open browser**: `http://localhost:5173/earth/2025`
3. **Click "Germany"** in the country table
4. **See daily statistics** with dates, uploads, uploaders
5. **Click any date** to view images on heritage.toolforge.org

## 📁 Files Changed

### New Files
- ✅ `frontend/Wikiproject/src/views/CampaignCountryView.vue`

### Modified Files
- ✅ `frontend/Wikiproject/src/router/index.js`
- ✅ `frontend/Wikiproject/src/stores/catalog.js`
- ✅ `frontend/Wikiproject/src/views/CompetitionView.vue`
- ✅ `backend/app.py`
- ✅ `backend/services/catalog.py`

## 🔍 API Endpoint

```
GET /api/campaigns/{campaign}/{year}/{country}

Example:
http://127.0.0.1:5000/api/campaigns/earth/2025/Germany
```

## 💡 Key Features

| Feature | Description |
|---------|-------------|
| **Daily Table** | Shows uploads, uploaders, new joiners per day |
| **Summary Cards** | Total images, uploaders, usage stats |
| **External Links** | Click date → View images on heritage.toolforge.org |
| **Commons Link** | Link to Wikimedia Commons category |
| **Total Row** | Highlighted row showing all totals |
| **Responsive** | Works on mobile, tablet, desktop |

## 🎨 Page Layout

```
┌─────────────────────────────────────┐
│  Wiki Loves Earth 2025 in Germany   │ ← Header
├─────────────────────────────────────┤
│  [13,564]  [352]  [13,564]  [200]   │ ← Summary Cards
│   Images  Upload   Used     New     │
├─────────────────────────────────────┤
│  Date       │ Images │ Joiners │... │ ← Daily Table
│  2025-05-01 │   880  │   15    │... │
│  2025-05-02 │   770  │   13    │... │
│  2025-05-03 │   416  │    7    │... │
│     ...     │   ...  │   ...   │... │
│  ═══════════════════════════════════ │
│  Total      │ 13,564 │  352    │... │ ← Total Row
└─────────────────────────────────────┘
```

## 🌐 Live Site Comparison

| Feature | Live Site | Your Project |
|---------|-----------|--------------|
| Daily statistics table | ✅ | ✅ |
| Summary cards | ✅ | ✅ |
| Date links to images | ✅ | ✅ |
| Commons category link | ✅ | ✅ |
| Total row | ✅ | ✅ |
| Percentage calculations | ✅ | ✅ |
| Professional styling | ✅ | ✅ |

## 🔧 Troubleshooting

| Problem | Solution |
|---------|----------|
| "Data not found" | Check country name matches exactly (case-sensitive) |
| Page won't load | Ensure backend is running on port 5000 |
| No data showing | Verify the campaign/year/country exists in your data |
| External links broken | Heritage tool requires exact Commons category name |

## 📚 Documentation Files

- `FEATURE_SUMMARY.md` - Overview and quick start
- `DAILY_STATS_GUIDE.md` - Detailed technical guide
- `NAVIGATION_FLOW.md` - Visual flow diagrams
- `QUICK_REFERENCE.md` - This file

## ✨ Example Countries to Try

```bash
# Germany (highest uploads)
http://localhost:5173/earth/2025/Germany

# India (most uploaders)
http://localhost:5173/earth/2025/India

# Ukraine (highest usage rate)
http://localhost:5173/earth/2025/Ukraine

# Senegal (Africa region)
http://localhost:5173/earth/2025/Senegal
```

## 🎉 Success Checklist

- [ ] Backend running on port 5000
- [ ] Frontend running on port 5173
- [ ] Navigate to `/earth/2025`
- [ ] See country list table
- [ ] Click "Germany"
- [ ] See daily statistics page
- [ ] See summary cards at top
- [ ] See daily table with dates
- [ ] Click a date
- [ ] External link opens heritage tool
- [ ] See total row at bottom

## 🚦 Status

**✅ COMPLETE AND READY TO USE**

All features implemented and tested. No additional setup required.

## 💬 Quick Commands Reference

```bash
# Start backend
cd wikiloves-main/backend && python app.py

# Start frontend
cd wikiloves-main/frontend/Wikiproject && npm run dev

# Test API
curl http://127.0.0.1:5000/api/campaigns/earth/2025/Germany

# Open in browser
open http://localhost:5173/earth/2025/Germany
```

---

**That's it! You're ready to go!** 🚀

Just start both servers and navigate to any campaign/year/country to see the daily statistics.

