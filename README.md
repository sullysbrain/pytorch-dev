ComfyUI Devcontainer (GPU)
==========================

This workspace contains a VS Code devcontainer configured to run ComfyUI with GPU support (NVIDIA CUDA). It uses `uv` (Astral) for dependency management and places model files in a named volume mounted at `/models`, with outputs saved to `/data`.

Quick Start (local Docker Engine with NVIDIA Container Toolkit)

1. Ensure Docker Engine supports the NVIDIA Container Toolkit and you can run GPU containers (see NVIDIA docs).
2. Open this folder in VS Code and use "Reopen in Container" (Dev Containers extension). The container build uses `.devcontainer/Dockerfile` and `docker-compose.yml`.

Command-line (build & run):

```bash
# Build and start (compose will create named volumes `models` and `data`)
docker compose up --build -d

# Logs (view ComfyUI output)
docker compose logs -f

# Stop
docker compose down
```

Where to put models and outputs

- Place models / safetensors into the `models` named volume. To copy files from host into the volume:

```bash
# Example: copy local-model.safetensors into the models volume
docker run --rm -v "${PWD}:/tmp/src" -v pytorch-dev_models:/models alpine sh -c "cp /tmp/src/local-model.safetensors /models/"
```

- Generated images and videos will be saved into the `data` named volume mounted at `/data`.

Notes

- The Dockerfile installs `uv`, creates a Python 3.12 virtual environment under `/opt/venv`, and runs `uv sync` to install dependencies listed in `pyproject.toml`.
- CUDA PyTorch wheels are installed from the official PyTorch index for CUDA 12.1. Adjust the CUDA version in `.devcontainer/Dockerfile` if needed.
- ComfyUI is cloned into `/opt/ComfyUI` during the image build and installed in editable mode.

If you want me to also add a sample `uv.lock` or include specific ComfyUI community nodes, tell me which ones and I will add them to `pyproject.toml` (or commit an explicit `uv.lock`).
