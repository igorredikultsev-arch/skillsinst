# skillsinst

A personal Claude Code plugin marketplace.

| Plugin | What it is | Source |
| --- | --- | --- |
| `game-studio` | 9 skills for browser games: stack choice, Phaser 2D, Three.js, React Three Fiber, 3D asset pipeline, game UI, sprite pipeline, playtesting | Ported from [OpenAI Game Studio](https://github.com/openai/plugins/tree/main/plugins/game-studio) (MIT), see `plugins/game-studio/NOTICE.md` |
| `playwright` | Browser automation MCP server by Microsoft | Not copied here: comes from the official [`claude-plugins-official`](https://github.com/anthropics/claude-plugins-official) marketplace |

## Install in local Claude Code

```
/plugin marketplace add igorredikultsev-arch/skillsinst
/plugin install game-studio@skillsinst

/plugin marketplace add anthropics/claude-plugins-official
/plugin install playwright@claude-plugins-official
```

Restart Claude Code afterwards. Playwright needs Node.js (it runs `npx @playwright/mcp@latest`)
and a browser: Google Chrome, or run `npx playwright install chrome`.

## Cloud sessions (claude.ai/code)

Cloud containers start from scratch every session, and project settings alone do not install
plugins there. Install them from the cloud environment's **Setup script** instead (environment
menu in the session title bar → Edit → Setup script): paste the contents of
[`scripts/cloud-setup.sh`](scripts/cloud-setup.sh).

It installs both plugins at user scope, so they work in every repository that uses that
environment. It also points Playwright MCP at the Chromium preinstalled in the container
(`/opt/pw-browsers/chromium`), because the default Google Chrome is not installed there.

This repository must be readable from the session: either public, or attached to the session.
A cloud session only has GitHub access to its own repositories, so with a private `skillsinst`
the Game Studio install fails in sessions on other repositories (Playwright still installs).

## Known limitations

- `sprite-pipeline` hands image generation to an `imagegen` skill that exists in Codex but
  not in Claude. Its sprite normalization and preview scripts (`scripts/*.py`, need Pillow)
  work; generating new images needs a separate image-generation tool.
