"""
Admin endpoints for managing campaigns.

Custom campaigns are stored in shared/custom_campaigns.json and merged
with the hardcoded ALL_CAMPAIGNS at runtime.
"""

import json
import re
from pathlib import Path

from flask import Blueprint, jsonify, request
from auth import admin_required
from config import Config

admin_bp = Blueprint('admin', __name__, url_prefix='/api/admin')

_CUSTOM_FILE = Config.SHARED_STORAGE / 'custom_campaigns.json'

CAMPAIGN_MONTHS = {
    'january': 1, 'february': 2, 'march': 3, 'april': 4,
    'may': 5, 'june': 6, 'july': 7, 'august': 8,
    'september': 9, 'october': 10, 'november': 11, 'december': 12,
}


def _load_custom():
    if _CUSTOM_FILE.is_file():
        try:
            return json.loads(_CUSTOM_FILE.read_text())
        except Exception:
            pass
    return {}


def _save_custom(data):
    _CUSTOM_FILE.write_text(json.dumps(data, indent=2))


def get_all_campaigns():
    """Return hardcoded + custom campaigns merged."""
    try:
        from campaigns_metadata import ALL_CAMPAIGNS
        merged = dict(ALL_CAMPAIGNS)
    except ImportError:
        merged = {}
    merged.update(_load_custom())
    return merged


def _validate_slug(slug):
    return bool(re.match(r'^[a-z][a-z0-9_]{1,30}$', slug))


@admin_bp.route('/campaigns', methods=['GET'])
@admin_required
def list_campaigns():
    """List all campaigns (hardcoded + custom) for admin."""
    all_c = get_all_campaigns()
    custom_keys = set(_load_custom().keys())
    result = []
    for key, val in all_c.items():
        result.append({
            **val,
            'key': key,
            'is_custom': key in custom_keys,
        })
    return jsonify(result)


@admin_bp.route('/campaigns', methods=['POST'])
@admin_required
def create_campaign():
    """Create a new custom campaign."""
    body = request.get_json(silent=True) or {}

    key = body.get('key', '').strip().lower()
    if not _validate_slug(key):
        return jsonify({'error': 'Invalid key. Use lowercase letters, numbers, underscores (2-31 chars).'}), 400

    all_c = get_all_campaigns()
    if key in all_c:
        return jsonify({'error': f'Campaign "{key}" already exists.'}), 409

    name = body.get('name', '').strip()
    if not name:
        return jsonify({'error': 'Name is required.'}), 400

    campaign = {
        'slug': body.get('slug', f'wiki-loves-{key}').strip(),
        'name': name,
        'path_segment': key,
        'quarry_category': body.get('quarry_category', key).strip(),
    }

    start_month = body.get('start_month')
    if start_month:
        campaign['start_month'] = int(start_month)

    custom = _load_custom()
    custom[key] = campaign
    _save_custom(custom)

    return jsonify({'ok': True, 'campaign': campaign}), 201


@admin_bp.route('/campaigns/<key>', methods=['PUT'])
@admin_required
def update_campaign(key):
    """Update a custom campaign."""
    custom = _load_custom()
    if key not in custom:
        return jsonify({'error': 'Only custom campaigns can be edited.'}), 403

    body = request.get_json(silent=True) or {}
    entry = custom[key]

    if 'name' in body and body['name'].strip():
        entry['name'] = body['name'].strip()
    if 'quarry_category' in body:
        entry['quarry_category'] = body['quarry_category'].strip()
    if 'start_month' in body:
        entry['start_month'] = int(body['start_month'])

    custom[key] = entry
    _save_custom(custom)
    return jsonify({'ok': True, 'campaign': entry})


@admin_bp.route('/campaigns/<key>', methods=['DELETE'])
@admin_required
def delete_campaign(key):
    """Delete a custom campaign."""
    custom = _load_custom()
    if key not in custom:
        return jsonify({'error': 'Only custom campaigns can be deleted.'}), 403

    del custom[key]
    _save_custom(custom)
    return jsonify({'ok': True})
