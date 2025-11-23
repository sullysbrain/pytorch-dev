FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy

# System packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl tini git build-essential libgl1 ca-certificates \
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
COPY pyproject.toml* uv.lock* ./

# Install + register + patch kernel in ONE layer (guaranteed to work)
RUN uv sync --no-cache && \
    uv pip install --no-cache jupyterlab ipykernel \
    && python -m ipykernel install \
      --name "python312-uv" \
      --display-name "Python 3.12 (uv)" \
      --prefix=/usr/local

# (Optional) PyTorch CUDA 12.1 wheels — uncomment if you need them here
# RUN uv pip install --no-cache --index-url https://download.pytorch.org/whl/cu121 \
#       torch torchvision torchaudio

# Copy your code
COPY . .

# Jupyter runtime dir
ENV JUPYTER_RUNTIME_DIR=/tmp/jupyter \
    JUPYTER_DATA_DIR=/usr/local/share/jupyter \
    JUPYTER_CONFIG_DIR=/etc/jupyter
RUN mkdir -p /tmp/jupyter /etc/jupyter && chmod -R 777 /tmp/jupyter

EXPOSE 8888
ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--ServerApp.root_dir=/workspace", "--ServerApp.token="]
