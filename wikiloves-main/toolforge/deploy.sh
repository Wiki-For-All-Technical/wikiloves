#!/bin/bash
# Deploy Toolforge backend (Flask API + app.py that serves the Vue SPA).
# Run from repo root: bash wikiloves-main/toolforge/deploy.sh
#
# To deploy the Vue frontend, run deploy_frontend.sh separately.

set -e
USERNAME="${TOOLFORGE_USER:-sanjesh200}"
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SRC="$REPO_ROOT/wikiloves-main/toolforge/src"
TOOLFORGE_APP_DIR="/data/project/wikiloves-data/www/python/src"

if [ ! -d "$SRC" ]; then
  echo "Error: $SRC not found. Run from repo root."
  exit 1
fi

echo "Deploying backend from $SRC to $USERNAME@login.toolforge.org..."
scp "$SRC/app.py" \
    "$SRC/config.py" \
    "$SRC/routes.py" \
    "$SRC/queries.py" \
    "$SRC/campaigns_metadata.py" \
    "$SRC/auth.py" \
    "$SRC/campaign_admin.py" \
    "$SRC/requirements.txt" \
    "$USERNAME@login.toolforge.org:~/"

echo ""
echo "Done. Now on Toolforge run:"
echo "  ssh $USERNAME@login.toolforge.org"
echo "  cp ~/app.py ~/config.py ~/routes.py ~/queries.py ~/campaigns_metadata.py ~/auth.py ~/campaign_admin.py ~/requirements.txt $TOOLFORGE_APP_DIR/"
echo "  become wikiloves-data"
echo "  toolforge webservice python3.13 restart"
echo ""
echo "To deploy the frontend, run: bash wikiloves-main/toolforge/deploy_frontend.sh"
