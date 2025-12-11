# How to Start the Wiki Loves Frontend

## Step 1: Start the Backend (Flask API)

Open a terminal and run:

```bash
cd wikiloves-main/backend
python app.py
```

The backend should start on `http://127.0.0.1:5000`

**If you get an error about missing dependencies:**
```bash
cd wikiloves-main
python -m pip install -r backend/requirements.txt
```

## Step 2: Start the Frontend (Vue.js)

Open a **NEW** terminal window and run:

```bash
cd wikiloves-main/frontend/Wikiproject
npm install
npm run dev
```

The frontend should start on `http://localhost:5173` (or similar port)

## Troubleshooting

### Backend won't start
- Check if port 5000 is already in use
- Make sure you're in the `wikiloves-main/backend` directory
- Check for Python errors in the terminal

### Frontend won't start
- Make sure Node.js is installed: `node --version`
- Make sure npm is installed: `npm --version`
- Try deleting `node_modules` and running `npm install` again

### Frontend shows "Cannot connect to API"
- Make sure the backend is running first
- Check that backend is on `http://127.0.0.1:5000`
- Check browser console for errors

### No data showing
- Make sure `backend/data/catalog.py` exists and has data
- Check backend terminal for errors
- Try accessing `http://127.0.0.1:5000/api/competitions` directly in browser



