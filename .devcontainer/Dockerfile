# Select base image at build time. Default is a plain Ubuntu image (CPU-only).
# To build a CUDA-enabled image, pass:
#   --build-arg BASE_IMAGE=nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04 \
#   --build-arg USE_CUDA=true
ARG BASE_IMAGE="ubuntu:22.04"
ARG USE_CUDA="false"
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy

# System packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl tini git build-essential libgl1 ca-certificates ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Tell uv to use our custom venv location
RUN curl -LsSf https://astral.sh/uv/install.sh | UV_INSTALL_DIR=/usr/local/bin sh \
 && uv --version 

ENV VENV_PATH=/opt/venv \
    UV_PROJECT_ENVIRONMENT=/opt/venv
RUN uv venv --python 3.12 /opt/venv
ENV VIRTUAL_ENV=/opt/venv
ENV PATH=/opt/venv/bin:$PATH

WORKDIR /workspace

# Copy dependency files
# COPY pyproject.toml* uv.lock* ./


# Install CUDA-enabled PyTorch (CUDA 12.1) into the uv venv
# Install PyTorch. For CUDA builds set `--build-arg USE_CUDA=true` and
# optionally `--build-arg BASE_IMAGE=nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04`.
# The conditional below installs CUDA wheels when USE_CUDA=true and falls back
# to the CPU wheels when false.
RUN if [ "${USE_CUDA}" = "true" ]; then \
            echo "Installing CUDA-enabled PyTorch (cu121)"; \
            uv pip install --no-cache --index-url https://download.pytorch.org/whl/cu121 torch torchvision torchaudio || true; \
        else \
            echo "Installing CPU PyTorch"; \
            uv pip install --no-cache torch torchvision torchaudio || true; \
        fi

# Clone ComfyUI and install its requirements in editable mode
RUN git clone --depth 1 https://github.com/comfyanonymous/ComfyUI.git /opt/ComfyUI && \
    if [ -f /opt/ComfyUI/requirements.txt ]; then uv pip install --no-cache -r /opt/ComfyUI/requirements.txt || true; \
    fi && \
    uv pip install --no-cache -e /opt/ComfyUI || true

# (Optional) PyTorch CUDA 12.1 wheels — uncomment if you need them here
# RUN uv pip install --no-cache --index-url https://download.pytorch.org/whl/cu121 \
#       torch torchvision torchaudio

# Copy repository files
COPY . .

# Create model and data mountpoints (named volumes will be mounted by compose)
RUN mkdir -p /models /data && chown -R root:root /models /data && chmod -R 777 /models /data

EXPOSE 8188
ENTRYPOINT ["/usr/bin/tini", "--"]

# Add a small launcher script and default to starting ComfyUI
RUN mkdir -p /usr/local/bin
COPY .devcontainer/scripts/start-comfyui.sh /usr/local/bin/start-comfyui.sh
RUN chmod +x /usr/local/bin/start-comfyui.sh

CMD ["/usr/local/bin/start-comfyui.sh"]
