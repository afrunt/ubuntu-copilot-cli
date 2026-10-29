# ubuntu-copilot-cli

Multi-arch (`linux/amd64`, `linux/arm64`) Docker image based on `ubuntu:latest` with [GitHub Copilot CLI](https://github.com/github/copilot-cli) and the [hve-core](https://github.com/microsoft/hve-core) plugin preinstalled.

- Copilot CLI does not ask to trust the working directory (`trustedFolders: ["/"]`).
- All status line (footer) options are enabled.
- Runs as non-root user `ubuntu`, workdir `/workspace`.
- Rebuilt daily (no cache) by GitHub Actions and pushed to Docker Hub as `latest` and `YYYYMMDD`.

## Usage

```bash
docker run -it --rm \
  -e COPILOT_GITHUB_TOKEN=<token> \
  -v "$PWD":/workspace \
  afrunt/ubuntu-copilot-cli
```

`COPILOT_GITHUB_TOKEN` is a fine-grained PAT with the "Copilot Requests" permission. Extra args go to `copilot`; use `--entrypoint bash` for a shell.

## Local build

```bash
docker build -t ubuntu-copilot-cli .
```

## CI setup

Repository secrets: `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN` (Docker Hub access token). Optional repository variable `DOCKERHUB_IMAGE` (default `<DOCKERHUB_USERNAME>/ubuntu-copilot-cli`). Pull requests build without pushing.
