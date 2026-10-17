#!/usr/bin/env bash
# Setup script for a claude.ai/code cloud environment.
# Installs Game Studio and Playwright for every session in that environment.
# Failures only print a warning so a broken install never blocks the session from starting.
set -uo pipefail

warn() { echo "cloud-setup: $*" >&2; }

claude plugin marketplace add igorredikultsev-arch/skillsinst \
  || claude plugin marketplace update skillsinst \
  || warn "could not add the skillsinst marketplace (private repo outside this session?)"
claude plugin marketplace add anthropics/claude-plugins-official \
  || claude plugin marketplace update claude-plugins-official \
  || warn "could not add the claude-plugins-official marketplace"
claude plugin install game-studio@skillsinst || warn "game-studio not installed"
claude plugin install playwright@claude-plugins-official || warn "playwright not installed"

# The cloud container has Chromium, not Google Chrome, which Playwright MCP uses by default.
python3 - <<'PY' || warn "could not write Playwright settings"
import json, pathlib
path = pathlib.Path.home() / ".claude" / "settings.json"
settings = json.loads(path.read_text()) if path.exists() else {}
settings.setdefault("env", {}).update({
    "PLAYWRIGHT_MCP_BROWSER": "chromium",
    "PLAYWRIGHT_MCP_EXECUTABLE_PATH": "/opt/pw-browsers/chromium",
    "PLAYWRIGHT_MCP_HEADLESS": "true",
})
path.parent.mkdir(parents=True, exist_ok=True)
path.write_text(json.dumps(settings, indent=2) + "\n")
PY
exit 0
