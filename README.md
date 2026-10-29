# ubuntu-copilot-cli

Multi-arch (`linux/amd64`, `linux/arm64`) Docker image based on `ubuntu:latest` with [GitHub Copilot CLI](https://github.com/github/copilot-cli) and the [hve-core](https://github.com/microsoft/hve-core) plugin preinstalled.

- Installed: latest Copilot CLI, hve-core plugin (`hve-core@hve-core`), git, jq, ripgrep.
- Copilot CLI does not ask to trust the working directory (`trustedFolders: ["/"]`).
- All status line (footer) options are enabled.
- No startup banner, tips or app promo; the container starts a `bash` terminal, run `copilot` inside it.
- Runs as non-root user `ubuntu`, workdir `/workspace`.
- Rebuilt daily (no cache) by GitHub Actions and pushed to Docker Hub (`afrunt/ubuntu-copilot-cli`) as `latest` and `YYYYMMDD`.

## Usage

```bash
docker run -it --rm \
  -e COPILOT_GITHUB_TOKEN=<token> \
  -v "$PWD":/workspace \
  afrunt/ubuntu-copilot-cli
# then, inside the container:
copilot
```

`COPILOT_GITHUB_TOKEN` is a fine-grained PAT with the "Copilot Requests" permission.

## MCP settings

Mount only the MCP file, not the whole `~/.copilot`, so the baked-in settings and hve-core plugin stay intact:

```bash
docker run -it --rm \
  -e COPILOT_GITHUB_TOKEN=<token> \
  -v "$PWD":/workspace \
  -v "$PWD/mcp-config.json":/home/ubuntu/.copilot/mcp-config.json:ro \
  afrunt/ubuntu-copilot-cli
```

`docker-compose.yml` has the same setup (`docker compose run --rm copilot`). Project-level MCP config in the mounted workspace also works. Pass secrets used by MCP servers via `-e`.

## Local build

```bash
docker build -t ubuntu-copilot-cli .
```

## CI

GitHub Actions (`.github/workflows/docker.yml`) builds on push to `main`, daily at 03:17 UTC and on manual dispatch. Pull requests build without pushing.
