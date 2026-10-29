#!/usr/bin/env bash
# Installs hve-core and merges the overlay settings into the Copilot CLI config.
set -euo pipefail

CONFIG_DIR="${HOME}/.copilot"
mkdir -p "${CONFIG_DIR}"

copilot plugin marketplace add microsoft/hve-core
copilot plugin install hve-core@hve-core

# Merge after plugin install: the CLI rewrites these files when installing plugins.
merge() { # <target> <overlay>
  local target="$1" overlay="$2" tmp
  [ -f "${target}" ] || echo '{}' > "${target}"
  tmp="$(mktemp)"
  # The CLI writes // comment headers; strip them before parsing.
  sed '/^[[:space:]]*\/\//d' "${target}" | jq -s '.[0] * .[1]' - "${overlay}" > "${tmp}"
  mv "${tmp}" "${target}"
}

merge "${CONFIG_DIR}/settings.json" /tmp/config/settings.overlay.json
merge "${CONFIG_DIR}/config.json" /tmp/config/config.overlay.json

jq -e '.enabledPlugins["hve-core@hve-core"] == true' "${CONFIG_DIR}/settings.json" >/dev/null \
  || { echo "hve-core plugin is not enabled" >&2; exit 1; }
copilot plugin list
