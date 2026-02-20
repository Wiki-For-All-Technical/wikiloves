"""
Wikimedia OAuth authentication for Toolforge.

Register an OAuth 1.0a consumer at:
  https://meta.wikimedia.org/wiki/Special:OAuthConsumerRegistration/propose

Set the callback URL to:
  https://wikiloves-data.toolforge.org/api/auth/callback

Store the consumer token/secret in:
  /data/project/wikiloves-data/shared/oauth_credentials.json
  {"consumer_key": "...", "consumer_secret": "..."}
"""

import json
import os
from functools import wraps
from pathlib import Path

from flask import Blueprint, redirect, request, session, jsonify

try:
    from mwoauth import ConsumerToken, Handshaker
    MWOAUTH_AVAILABLE = True
except ImportError:
    MWOAUTH_AVAILABLE = False

from config import Config

auth_bp = Blueprint('auth', __name__, url_prefix='/api/auth')

_CRED_FILE = Config.SHARED_STORAGE / 'oauth_credentials.json'
_MW_BASE = 'https://meta.wikimedia.org/w/index.php'

# Admins who can create/edit campaigns (Wikimedia usernames)
_ADMIN_FILE = Config.SHARED_STORAGE / 'admin_users.json'


def _load_consumer():
    """Load OAuth consumer token from credentials file."""
    if not MWOAUTH_AVAILABLE:
        return None
    if not _CRED_FILE.is_file():
        return None
    creds = json.loads(_CRED_FILE.read_text())
    return ConsumerToken(creds['consumer_key'], creds['consumer_secret'])


def _load_admins():
    """Load list of admin usernames."""
    if _ADMIN_FILE.is_file():
        try:
            return set(json.loads(_ADMIN_FILE.read_text()))
        except Exception:
            pass
    return set()


def _get_handshaker():
    consumer = _load_consumer()
    if not consumer:
        return None
    return Handshaker(_MW_BASE, consumer)


def get_current_user():
    """Return the currently logged-in user dict or None."""
    return session.get('user')


def is_admin():
    """Check if the current user is an admin."""
    user = get_current_user()
    if not user:
        return False
    return user.get('username') in _load_admins()


def login_required(f):
    """Decorator: require authenticated user."""
    @wraps(f)
    def wrapper(*args, **kwargs):
        if not get_current_user():
            return jsonify({'error': 'Authentication required'}), 401
        return f(*args, **kwargs)
    return wrapper


def admin_required(f):
    """Decorator: require authenticated admin user."""
    @wraps(f)
    def wrapper(*args, **kwargs):
        if not get_current_user():
            return jsonify({'error': 'Authentication required'}), 401
        if not is_admin():
            return jsonify({'error': 'Admin access required'}), 403
        return f(*args, **kwargs)
    return wrapper


@auth_bp.route('/login')
def login():
    """Start OAuth flow — redirect user to Wikimedia for authorisation."""
    handshaker = _get_handshaker()
    if not handshaker:
        return jsonify({'error': 'OAuth not configured'}), 503

    redirect_url, request_token = handshaker.initiate()
    session['oauth_request_token'] = dict(
        key=request_token.key, secret=request_token.secret
    )
    return redirect(redirect_url)


@auth_bp.route('/callback')
def callback():
    """Handle OAuth callback from Wikimedia."""
    handshaker = _get_handshaker()
    if not handshaker:
        return jsonify({'error': 'OAuth not configured'}), 503

    rt = session.get('oauth_request_token')
    if not rt:
        return redirect('/?auth=error')

    from mwoauth import AccessToken, RequestToken
    request_token = RequestToken(rt['key'], rt['secret'])

    try:
        access_token = handshaker.complete(request_token, request.query_string)
        identity = handshaker.identify(access_token)
    except Exception:
        return redirect('/?auth=error')

    session.pop('oauth_request_token', None)
    session['user'] = {
        'username': identity['username'],
        'sub': identity['sub'],
        'editcount': identity.get('editcount', 0),
        'confirmed_email': identity.get('confirmed_email', False),
    }
    session['oauth_access_token'] = dict(
        key=access_token.key, secret=access_token.secret
    )

    return redirect('/?auth=success')


@auth_bp.route('/logout', methods=['POST', 'GET'])
def logout():
    """Clear session and log user out."""
    session.clear()
    return redirect('/')


@auth_bp.route('/user')
def user_info():
    """Return current user info (or null if not logged in)."""
    user = get_current_user()
    if not user:
        return jsonify({'user': None, 'is_admin': False})
    return jsonify({
        'user': user,
        'is_admin': is_admin(),
    })
