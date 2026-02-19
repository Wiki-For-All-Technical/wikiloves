"""
Toolforge Flask application for Wiki Loves campaign data fetching.
Main entry point for the web service.
"""

from flask import Flask, render_template
from flask_cors import CORS
import os
import sys

# Add src directory to path for imports
sys.path.insert(0, os.path.dirname(__file__))

from routes import register_routes
from config import Config

_src_dir = os.path.abspath(os.path.dirname(__file__))
_template_dir = os.path.join(_src_dir, 'templates')
app = Flask(__name__, template_folder=_template_dir)
CORS(app)

# Load configuration
app.config.from_object(Config)

# Register routes
register_routes(app)


def _index_html():
    """Render landing page; fallback to minimal HTML if template is missing."""
    try:
        return render_template('index.html', version='1.0.0')
    except Exception as e:
        # Log so we can see why template failed (check: toolforge webservice python3.13 logs)
        import logging
        logging.warning('Index template failed, using fallback: %s', e)
        # Fallback if templates/ not deployed or template fails
        return (
            '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8">'
            '<meta name="viewport" content="width=device-width,initial-scale=1">'
            '<title>Wiki Loves Data Fetcher</title></head><body style="'
            'font-family:system-ui,sans-serif;max-width:720px;margin:2rem auto;padding:0 1rem;'
            'background:#0f1419;color:#e6edf3;">'
            '<h1 style="font-size:1.5rem;">Wiki Loves Data Fetcher</h1>'
            '<p style="color:#8b949e;">Campaign statistics from Wikimedia Commons.</p>'
            '<p><span style="color:#3fb950;">●</span> Running · Version 1.0.0</p>'
            '<p><a href="/api/health" style="color:#58a6ff;">Health</a> · '
            '<a href="/api/campaigns" style="color:#58a6ff;">Campaigns</a> · '
            '<a href="/api/status" style="color:#58a6ff;">Status</a> · '
            '<a href="/api" style="color:#58a6ff;">API (JSON)</a></p>'
            '</body></html>'
        ), 200, {'Content-Type': 'text/html; charset=utf-8'}


@app.route('/')
def index():
    """Landing page with service info and API endpoints."""
    return _index_html()


@app.route('/api')
def api_info():
    """JSON API info for programmatic access."""
    return {
        "service": "Wiki Loves Data Fetcher",
        "version": "1.0.0",
        "status": "running",
        "endpoints": {
            "health": "/api/health",
            "status": "/api/status",
            "campaigns": "/api/campaigns",
            "data_list": "/api/data",
            "data_campaign": "/api/data/<campaign_slug>",
            "data_campaign_summary": "/api/data/<campaign_slug>/summary",
            "fetch_all": "/api/fetch/all",
            "fetch_campaign": "/api/fetch/<campaign_slug>",
            "fetch_campaign_year": "/api/fetch/<campaign_slug>/<year>",
            "prebuild": "/api/prebuild (POST - warm country + uploaders cache)",
            "logs": "/api/logs",
            "test_earth_2025_germany": "/api/test/earth-2025-germany (GET - run Earth 2025 Germany queries)"
        }
    }


if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=8000)
