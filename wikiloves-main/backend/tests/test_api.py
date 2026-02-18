import json
import os
import sys

sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from app import app


def test_overview_endpoint():
    client = app.test_client()
    response = client.get("/api/overview")
    assert response.status_code == 200
    payload = response.get_json()
    assert "total_uploads" in payload
    assert payload["total_uploads"] > 0


def test_competitions_list():
    client = app.test_client()
    response = client.get("/api/competitions")
    data = response.get_json()
    assert response.status_code == 200
    assert isinstance(data, list)
    assert any(comp["slug"] == "wiki-loves-earth" for comp in data)


def test_navigation_has_competitions():
    client = app.test_client()
    response = client.get("/api/navigation")
    assert response.status_code == 200
    entries = response.get_json()
    assert entries[0]["type"] == "home"
    assert any(entry["slug"] == "wiki-loves-monuments" for entry in entries)

def test_competition_detail_not_found():
    client = app.test_client()
    response = client.get("/api/competitions/missing")
    assert response.status_code == 404


def test_country_detail_shape():
    client = app.test_client()
    response = client.get("/api/countries/india")
    assert response.status_code == 200
    payload = json.loads(response.data)
    assert payload["slug"] == "india"
    assert "trend" in payload

