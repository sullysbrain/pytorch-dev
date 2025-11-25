#!/usr/bin/env bash
set -euo pipefail

# Activate uv venv
if [ -d "/opt/venv" ]; then
  source /opt/venv/bin/activate
fi

echo "Starting ComfyUI (if installed)"

# If ComfyUI was cloned into /opt/ComfyUI, run its main.py
if [ -f /opt/ComfyUI/main.py ]; then
  exec python /opt/ComfyUI/main.py --port 8188 --listen
else
  # Fall back to running jupyter lab if ComfyUI not present
  echo "ComfyUI not found under /opt/ComfyUI, starting Jupyter Lab instead"
  exec jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --ServerApp.root_dir=/workspace --ServerApp.token=
fi
