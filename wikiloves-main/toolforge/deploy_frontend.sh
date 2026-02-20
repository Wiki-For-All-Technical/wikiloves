#!/bin/bash
# Build the Vue frontend and deploy to Toolforge.
#
# The built files land in src/static/ on Toolforge, served by Flask.
# Run from repo root:
#   bash wikiloves-main/toolforge/deploy_frontend.sh
#
# Prerequisites:
#   - Node.js >= 20 installed locally
#   - npm dependencies installed (cd frontend/Wikiproject && npm install)
#   - SSH access to login.toolforge.org

set -e

USERNAME="${TOOLFORGE_USER:-sanjesh200}"
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
FRONTEND_DIR="$REPO_ROOT/wikiloves-main/frontend/Wikiproject"
TOOLFORGE_APP_DIR="/data/project/wikiloves-data/www/python/src"

# ── 1. Build the Vue frontend ───────────────────────────────────────────────
echo "==> Building Vue frontend..."
if [ ! -d "$FRONTEND_DIR/node_modules" ]; then
  echo "    Installing npm dependencies..."
  (cd "$FRONTEND_DIR" && npm install)
fi
(cd "$FRONTEND_DIR" && npm run build)

DIST_DIR="$FRONTEND_DIR/dist"
if [ ! -f "$DIST_DIR/index.html" ]; then
  echo "Error: Build failed – $DIST_DIR/index.html not found."
  exit 1
fi
echo "    Build complete: $(du -sh "$DIST_DIR" | cut -f1)"

# ── 2. Upload to Toolforge ──────────────────────────────────────────────────
echo "==> Uploading dist/ to Toolforge..."
scp -r "$DIST_DIR/" "$USERNAME@login.toolforge.org:~/frontend_dist"

echo ""
echo "==> Files uploaded to ~/frontend_dist/ on Toolforge."
echo ""
echo "Now SSH in and copy them into the tool's static directory:"
echo ""
echo "  ssh $USERNAME@login.toolforge.org"
echo "  cp ~/app.py ~/config.py ~/routes.py ~/queries.py ~/campaigns_metadata.py $TOOLFORGE_APP_DIR/"
echo "  become wikiloves-data"
echo "  rm -rf $TOOLFORGE_APP_DIR/static"
echo "  cp -r ~/frontend_dist $TOOLFORGE_APP_DIR/static"
echo "  toolforge webservice python3.13 restart"
