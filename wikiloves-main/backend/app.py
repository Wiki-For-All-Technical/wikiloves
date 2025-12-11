from flask import Flask, jsonify
from flask_cors import CORS

from flask import request

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


if __name__ == "__main__":
    app.run(debug=True)
