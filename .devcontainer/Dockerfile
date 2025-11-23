# CUDA + cuDNN runtime (x86_64). Works CPU-only if no GPUs are present.
# FROM nvcr.io/nvidia/ai-workbench/pytorch:1.0.6
FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

# Base OS deps
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv git curl ffmpeg libgl1 ca-certificates

# 3) uv manager
FROM python:3.12-slim-trixie
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
# 4) Workdir
WORKDIR /workspace
EXPOSE 8888
COPY pyproject.toml  ./
CMD ["uv", "run", "--", "jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--ServerApp.token=","--ServerApp.password=", "--ServerApp.root_dir=/workspace"]

