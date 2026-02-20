"""
Toolforge Flask application for Wiki Loves campaign data fetching.
Main entry point for the web service.

Serves both the Vue SPA frontend (static files) and the /api/* JSON backend.
"""

from flask import Flask, send_from_directory, jsonify
from flask_cors import CORS
import os
import sys
import secrets

sys.path.insert(0, os.path.dirname(__file__))

from routes import register_routes
from config import Config
from auth import auth_bp
from campaign_admin import admin_bp

_src_dir = os.path.abspath(os.path.dirname(__file__))
_static_dir = os.path.join(_src_dir, 'static')

app = Flask(__name__, static_folder=_static_dir, static_url_path='')
CORS(app, supports_credentials=True)

app.config.from_object(Config)

_secret_file = Config.SHARED_STORAGE / 'flask_secret_key'
if _secret_file.is_file():
    app.secret_key = _secret_file.read_text().strip()
else:
    app.secret_key = secrets.token_hex(32)
    try:
        _secret_file.write_text(app.secret_key)
    except OSError:
        pass

register_routes(app)
app.register_blueprint(auth_bp)
app.register_blueprint(admin_bp)


@app.route('/api')
def api_info():
    """JSON API info for programmatic access."""
    return jsonify({
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
        }
    })


@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def serve_frontend(path):
    """Serve Vue SPA. Static assets are returned directly; all other
    paths get index.html so Vue Router can handle client-side routing."""
    if path and os.path.isfile(os.path.join(_static_dir, path)):
        return send_from_directory(_static_dir, path)
    index_file = os.path.join(_static_dir, 'index.html')
    if os.path.isfile(index_file):
        return send_from_directory(_static_dir, 'index.html')
    return (
        '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8">'
        '<meta name="viewport" content="width=device-width,initial-scale=1">'
        '<title>Wiki Loves Data</title></head><body style="'
        'font-family:system-ui,sans-serif;max-width:720px;margin:2rem auto;padding:0 1rem;'
        'background:#0f1419;color:#e6edf3;">'
        '<h1 style="font-size:1.5rem;">Wiki Loves Data</h1>'
        '<p style="color:#8b949e;">Frontend not yet deployed. '
        'API is available at <a href="/api" style="color:#58a6ff;">/api</a>.</p>'
        '</body></html>'
    ), 200, {'Content-Type': 'text/html; charset=utf-8'}


if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=8000)
