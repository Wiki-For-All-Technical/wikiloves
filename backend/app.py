from flask import Flask, jsonify
from flask_cors import CORS

from services.catalog import (
    build_competition_detail,
    build_competition_summaries,
    build_country_detail,
    build_country_summaries,
    build_navigation,
    build_overview_stats,
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
    return jsonify(build_competition_summaries())


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


if __name__ == "__main__":
    app.run(debug=True)
