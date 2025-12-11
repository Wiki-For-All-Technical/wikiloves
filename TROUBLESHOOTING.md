# Troubleshooting Guide

## Frontend Not Opening

### 1. Check if Backend is Running

First, make sure the backend is running:
- Open a terminal
- Run: `cd wikiloves-main/backend && python app.py`
- You should see: `Running on http://127.0.0.1:5000`

### 2. Check if Frontend Dependencies are Installed

```bash
cd wikiloves-main/frontend/Wikiproject
npm install
```

### 3. Start Frontend

```bash
npm run dev
```

You should see output like:
```
  VITE v7.x.x  ready in xxx ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
```

### 4. Common Issues

#### Issue: "Cannot connect to API" or "Network Error"
**Solution:**
- Make sure backend is running on `http://127.0.0.1:5000`
- Check browser console (F12) for specific error messages
- Try accessing `http://127.0.0.1:5000/api/health` directly in browser - should return `{"status":"ok"}`

#### Issue: "Port already in use"
**Solution:**
- Backend: Change port in `backend/app.py` line 80: `app.run(debug=True, port=5001)`
- Frontend: Vite will automatically use next available port

#### Issue: "Module not found" errors
**Solution:**
```bash
cd wikiloves-main/frontend/Wikiproject
rm -rf node_modules
npm install
```

#### Issue: "Python module not found" (backend)
**Solution:**
```bash
cd wikiloves-main
python -m pip install -r backend/requirements.txt
```

#### Issue: No data showing on frontend
**Solution:**
- Check if `backend/data/catalog.py` exists and has 77 campaigns
- Check backend terminal for errors
- Try: `http://127.0.0.1:5000/api/competitions` - should return JSON with all campaigns

### 5. Quick Test

Test the backend API directly:
```bash
# In browser or using curl:
http://127.0.0.1:5000/api/health
http://127.0.0.1:5000/api/competitions
http://127.0.0.1:5000/api/navigation
```

All should return JSON data without errors.

### 6. Check Browser Console

Open browser developer tools (F12) and check:
- Console tab for JavaScript errors
- Network tab to see if API calls are failing
- Look for CORS errors (shouldn't happen, but check)

### 7. Verify Catalog Data

```bash
python wikiloves-main/verify_catalog.py
```

Should show: "Total competitions: 77"



