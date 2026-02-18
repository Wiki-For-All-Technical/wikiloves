from flask import Flask, jsonify
from flask_cors import CORS

from flask import request
import requests

from services.catalog import (
    build_competition_detail,
    build_competition_summaries,
    build_country_detail,
    build_country_summaries,
    build_navigation,
    build_overview_stats,
    build_cross_campaign_comparison,
    build_trend_analysis,
    build_campaign_country_detail,
    build_uploader_data,
)

app = Flask(__name__)
CORS(app)


@app.get("/api/health")
def healthcheck():
    return jsonify({"status": "ok"})


@app.get("/api/overview")
def overview():
    return jsonify(build_overview_stats())


@app.get("/api/navigation")
def navigation():
    return jsonify(build_navigation())


@app.get("/api/competitions")
def competitions():
    category = request.args.get("category")  # Filter by category: international, regional, local
    summaries = build_competition_summaries(category=category)
    return jsonify(summaries)


@app.get("/api/competitions/<string:slug>")
def competition_detail(slug: str):
    detail = build_competition_detail(slug)
    if not detail:
        return jsonify({"error": "Competition not found"}), 404
    return jsonify(detail)


@app.get("/api/countries")
def countries():
    return jsonify(build_country_summaries())


@app.get("/api/countries/<string:slug>")
def country_detail(slug: str):
    detail = build_country_detail(slug)
    if not detail:
        return jsonify({"error": "Country not found"}), 404
    return jsonify(detail)


@app.get("/api/statistics/comparison")
def comparison():
    """Cross-campaign comparison statistics."""
    year = request.args.get("year", type=int)
    return jsonify(build_cross_campaign_comparison(year=year))


@app.get("/api/statistics/trends")
def trends():
    """Trend analysis across campaigns."""
    campaigns = request.args.getlist("campaigns")  # Optional list of campaign slugs
    campaigns = campaigns if campaigns else None
    return jsonify(build_trend_analysis(campaign_slugs=campaigns))


@app.get("/api/campaigns/<string:campaign_slug>/<int:year>/<string:country>")
def campaign_country_detail(campaign_slug: str, year: int, country: str):
    """Get daily statistics for a specific country in a campaign year."""
    detail = build_campaign_country_detail(campaign_slug, year, country)
    if not detail:
        return jsonify({"error": "Data not found"}), 404
    return jsonify(detail)


@app.get("/api/campaigns/<string:campaign_slug>/<int:year>/<string:country>/users")
def campaign_country_users(campaign_slug: str, year: int, country: str):
    """
    Get uploader statistics for a specific country in a campaign year.
    Returns actual data if available, otherwise returns Quarry query instructions.
    """
    data = build_uploader_data(campaign_slug, year, country)
    if not data:
        return jsonify({"error": "Campaign not found"}), 404
    return jsonify(data)


@app.post("/api/toolforge/trigger-refresh")
def trigger_toolforge_refresh():
    """
    Trigger Toolforge data refresh.
    This endpoint can be called to manually trigger a data refresh on Toolforge.
    """
    import requests
    
    toolforge_url = request.args.get(
        'toolforge_url',
        'https://wikiloves-data.toolforge.org/api/fetch/all'
    )
    
    try:
        response = requests.post(toolforge_url, timeout=10)
        if response.status_code == 202:
            return jsonify({
                "status": "triggered",
                "message": "Data refresh started on Toolforge",
                "toolforge_response": response.json()
            })
        else:
            return jsonify({
                "status": "error",
                "message": f"Toolforge returned status {response.status_code}",
                "toolforge_response": response.text
            }), response.status_code
    except requests.exceptions.RequestException as e:
        return jsonify({
            "status": "error",
            "message": f"Failed to connect to Toolforge: {str(e)}"
        }), 500


@app.get("/api/toolforge/status")
def toolforge_status():
    """
    Get status from Toolforge data fetcher.
    """
    import requests
    
    toolforge_url = request.args.get(
        'toolforge_url',
        'https://wikiloves-data.toolforge.org/api/status'
    )
    
    try:
        response = requests.get(toolforge_url, timeout=10)
        if response.status_code == 200:
            return jsonify({
                "status": "ok",
                "toolforge_status": response.json()
            })
        else:
            return jsonify({
                "status": "error",
                "message": f"Toolforge returned status {response.status_code}"
            }), response.status_code
    except requests.exceptions.RequestException as e:
        return jsonify({
            "status": "error",
            "message": f"Failed to connect to Toolforge: {str(e)}"
        }), 500


@app.post("/api/toolforge/webhook")
def toolforge_webhook():
    """
    Webhook endpoint for Toolforge to notify when data updates complete.
    This can be called by Toolforge after successful data processing.
    """
    data = request.get_json() or {}
    
    campaign_slug = data.get('campaign_slug')
    status = data.get('status')
    message = data.get('message')
    
    # Log the webhook call
    # In production, you might want to:
    # - Update a status database
    # - Trigger cache invalidation
    # - Send notifications
    
    return jsonify({
        "status": "received",
        "message": "Webhook received successfully",
        "campaign": campaign_slug,
        "toolforge_status": status
    })


if __name__ == "__main__":
    app.run(debug=True)
