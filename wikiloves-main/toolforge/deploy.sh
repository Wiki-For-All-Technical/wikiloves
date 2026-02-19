#!/bin/bash
# Deploy Toolforge app (front page, API, templates).
# Run from repo root: bash wikiloves-main/toolforge/deploy.sh

set -e
USERNAME="${TOOLFORGE_USER:-sanjesh200}"
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SRC="$REPO_ROOT/wikiloves-main/toolforge/src"

if [ ! -d "$SRC" ]; then
  echo "Error: $SRC not found. Run from repo root."
  exit 1
fi

echo "Deploying from $SRC to $USERNAME@login.toolforge.org..."
scp "$SRC/app.py" \
    "$SRC/config.py" \
    "$SRC/routes.py" \
    "$SRC/campaigns_metadata.py" \
    "$SRC/templates/index.html" \
    "$USERNAME@login.toolforge.org:~/"

echo ""
echo "Done. Now on Toolforge run:"
echo "  ssh $USERNAME@login.toolforge.org"
echo "  cp ~/app.py ~/config.py ~/routes.py ~/campaigns_metadata.py /data/project/wikiloves-data/www/python/src/"
echo "  cp ~/index.html /data/project/wikiloves-data/www/python/src/templates/"
echo "  become wikiloves-data"
echo "  toolforge webservice python3.13 restart"
