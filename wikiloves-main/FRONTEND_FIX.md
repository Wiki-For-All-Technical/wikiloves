# Frontend Connection Fix

## Issue
Frontend was showing "refused to connect" because Vite was only listening on IPv6 (`[::1]`) but browsers typically try IPv4 (`127.0.0.1`) first.

## Fix Applied
Updated `vite.config.js` to explicitly listen on `127.0.0.1` (IPv4).

## How to Access

1. **Make sure both servers are running:**
   - Backend: `http://127.0.0.1:5000` (should show "ok" at `/api/health`)
   - Frontend: `http://127.0.0.1:5173`

2. **Open in browser:**
   - Go to: `http://127.0.0.1:5173` or `http://localhost:5173`

3. **If still not working:**
   - Stop all Node processes
   - Restart frontend: `cd wikiloves-main\frontend\Wikiproject && npm run dev`
   - Check the terminal output for the exact URL

## Verify Backend is Running
```bash
curl http://127.0.0.1:5000/api/health
```
Should return: `{"status":"ok"}`

## Verify Frontend is Running
```bash
curl http://127.0.0.1:5173
```
Should return HTML content (not an error)



