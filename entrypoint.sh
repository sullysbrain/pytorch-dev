#!/bin/bash
set -e

echo "Starting ComfyUI Container..."

# Default flags
ARGS="--listen 0.0.0.0 --port 8188"

# Check if NVIDIA GPU is available
if command -v nvidia-smi &> /dev/null; then
    echo "NVIDIA GPU detected. Running with CUDA optimizations."
    # Optional: Add specific CUDA flags if ComfyUI needs them, usually auto-detected
else
    echo "No NVIDIA GPU detected. Switching to CPU mode."
    ARGS="$ARGS --cpu"
fi

# Run ComfyUI
echo "Executing: python3 ${COMFYUI_PATH}/main.py $ARGS"
exec python3 "${COMFYUI_PATH}/main.py" $ARGS