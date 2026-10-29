FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        bash ca-certificates curl git jq ripgrep tar gzip openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Copilot CLI (latest release; install script picks amd64/arm64 and verifies checksums)
RUN curl -fsSL https://gh.io/copilot-install | PREFIX=/usr/local bash \
    && copilot --version

RUN mkdir -p /workspace

ENV HOME=/root

# hve-core plugin + statusline and folder-trust settings
COPY config /tmp/config
COPY scripts/configure-copilot.sh /tmp/configure-copilot.sh
RUN bash /tmp/configure-copilot.sh && rm -rf /tmp/config /tmp/configure-copilot.sh

# Authentication token for Copilot CLI; pass at runtime: docker run -e COPILOT_GITHUB_TOKEN=...
ENV COPILOT_GITHUB_TOKEN=""

WORKDIR /workspace
CMD ["sh"]
