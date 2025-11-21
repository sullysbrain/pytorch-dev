# CUDA + cuDNN runtime (x86_64). Works CPU-only if no GPUs are present.
# FROM nvcr.io/nvidia/ai-workbench/pytorch:1.0.6
FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

# Base OS deps
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv git curl ffmpeg libgl1 ca-certificates 
#  && rm -rf /var/lib/apt/lists/* \
#  && ln -s /usr/bin/python3 /usr/bin/python

# 3) uv manager
FROM python:3.12-slim-trixie
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
# 4) Workdir
WORKDIR /workspace

COPY pyproject.toml  ./



# RUN test -f pyproject.toml && uv venv /opt/venv && . /opt/venv/bin/activate && uv sync --frozen --no-progress || true

# 6) App source LAST (bind mount will overlay, but this keeps image runnable)
# COPY ./src ./src


# PyTorch w/ CUDA wheels (falls back to CPU if no GPU is visible at runtime)
# RUN pip install --upgrade pip && \
#     pip install --index-url https://download.pytorch.org/whl/cu121 \
#         torch==2.4.0 torchvision==0.19.0 torchaudio==2.4.0 && \
#     pip install xformers==0.0.27.post2 --extra-index-url https://download.pytorch.org/whl/cu121

# ComfyUI
# WORKDIR /opt
# RUN git clone https://github.com/comfyanonymous/ComfyUI.git
# WORKDIR /opt/ComfyUI






# Expose ComfyUI (web) port
# EXPOSE 8188

# Default command: run the web UI
# CMD ["python", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
