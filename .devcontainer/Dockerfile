# ---- Minimal, reliable Jupyter + UV dev container ----
FROM python:3.12-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    tini curl git build-essential libgl1 ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# ---- Install uv (official installer) ----
# Install to /usr/local/bin so it’s globally available
RUN curl -LsSf https://astral.sh/uv/install.sh | \
    UV_INSTALL_DIR=/usr/local/bin sh

RUN uv --version

# ---- Create UV-managed virtual environment ----
ENV VENV_PATH=/opt/venv
ENV UV_PROJECT_ENVIRONMENT=$VENV_PATH

# Create venv using uv (NOT python -m venv)
RUN uv venv --python 3.12 $VENV_PATH

# Activate venv globally for all subsequent RUN and CMD
ENV PATH="$VENV_PATH/bin:$PATH"
ENV VIRTUAL_ENV="$VENV_PATH"

WORKDIR /workspace

# ---- Optional: install dependencies from requirements.txt using uv ----
COPY pyproject.toml* ./

# ---- Install Jupyter + IPykernel using uv ----
# RUN uv pip install --system --no-cache jupyterlab ipykernel \
RUN uv sync && uv pip install --no-cache jupyterlab ipykernel \
 && /opt/venv/bin/python -m ipykernel install \
      --name "python312-uv" \
      --display-name "Python 3.12 (uv)" \
      --prefix=/usr/local

# ---- Writable Jupyter runtime dirs ----
ENV JUPYTER_RUNTIME_DIR=/tmp/jupyter \
    JUPYTER_DATA_DIR=/usr/local/share/jupyter \
    JUPYTER_CONFIG_DIR=/etc/jupyter

RUN mkdir -p /tmp/jupyter /etc/jupyter && chmod -R 777 /tmp/jupyter

EXPOSE 8888

ENTRYPOINT ["/usr/bin/tini", "--"]

# ---- Auto-start Jupyter Lab (token disabled) ----
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--ServerApp.root_dir=/workspace",     "--ServerApp.token="]
