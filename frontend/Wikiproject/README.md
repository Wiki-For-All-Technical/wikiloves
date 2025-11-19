# Wiki Loves Atlas – Frontend

A Vue 3 SPA that reimagines the [Wiki Loves statistics tool](https://wikiloves.toolforge.org/) with rich dashboards, competition insights, and country spotlights. Data is served by the Flask API in `../../backend`.

## Getting Started

```bash
cd frontend/Wikiproject
npm install
npm run dev
```

The dev server expects the Flask API to run on `http://127.0.0.1:5000`. Override with `VITE_API_BASE`.

## Available Scripts

| Script | Description |
| --- | --- |
| `npm run dev` | Start Vite dev server with hot module reload |
| `npm run build` | Production build |
| `npm run preview` | Preview production build |
| `npm run lint` | ESLint (fix + cache) |
| `npm run test:unit` | Vitest unit tests |

## Tech Stack

- Vue 3 + `<script setup>` single-file components
- Pinia store for cached API responses
- Vue Router dynamic routes (`/competitions/:slug`, `/countries/:slug`)
- Axios-powered API client targeting the Flask backend
- Vitest for lightweight unit tests (`src/utils/__tests__/trend.spec.js`)

## Backend Pairing

1. Install deps once:  
   `cd ../../ && .venv/Scripts/python -m pip install -r backend/requirements.txt`
2. Run API:  
   `cd backend && ../.venv/Scripts/python app.py`

The API exposes `/api/overview`, `/api/competitions`, and `/api/countries` which drive the dashboard tiles and detail views.
