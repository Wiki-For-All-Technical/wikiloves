#!/bin/bash
# Deploy updated Toolforge app (campaigns_metadata, routes, queries).
# Run from repo root. Replace USERNAME with your Toolforge shell username.

USERNAME="${TOOLFORGE_USER:-sanjesh200}"
SRC="wikiloves-main/toolforge/src"

echo "Deploying Toolforge updates (campaigns_metadata.py, routes.py, queries.py)..."

scp "$SRC/campaigns_metadata.py" "$SRC/routes.py" "$SRC/queries.py" "$USERNAME@login.toolforge.org:~/"

echo ""
echo "Files copied. SSH to Toolforge and run:"
echo "  ssh $USERNAME@login.toolforge.org"
echo "  # Copy into the TOOL's app dir (not your home). uwsgi loads from here:"
echo "  cp ~/campaigns_metadata.py ~/routes.py ~/queries.py /data/project/wikiloves-data/www/python/src/"
echo "  become wikiloves-data"
echo "  toolforge webservice python3.13 restart"
