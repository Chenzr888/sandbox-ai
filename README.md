# Sandbox AI

> Forked from [opencode](https://github.com/anomalyco/opencode) (MIT). Tailored for use with sandboxai.top.

A terminal-based AI agent.

## Install (one line — needs no bun, no clone)

```bash
curl -fsSL https://raw.githubusercontent.com/Chenzr888/sandbox-ai/sandbox-ai-main/install.sh | bash
```

That downloads the latest precompiled binary into `~/.local/bin/sandbox`. Then:

```bash
sandbox auth login --provider sandboxai     # paste your key from https://sandboxai.top
sandbox                                     # launch TUI
sandbox models | grep sandbox               # verify provider is wired
```

Supported platforms: `linux-x64`, `linux-arm64`, `darwin-x64`, `darwin-arm64`.
For Windows, use the dev mode below.

## Custom endpoint

Point `sandbox` at your own OpenAI-compatible gateway:

```bash
SANDBOXAI_BASE_URL=https://your-gateway.example.com/v1 sandbox
```

## Dev mode (run from source)

If you want to hack on the code, clone the repo and use the source-mode launcher:

```bash
git clone https://github.com/Chenzr888/sandbox-ai.git
cd sandbox-ai
./install-dev.sh        # installs bun + deps, points `sandbox` at the source tree
```

Or run dev directly:

```bash
bun install
bun run dev --help
```

## Build a binary locally

```bash
bun run --cwd packages/opencode script/build.ts --single --skip-embed-web-ui
# binary at packages/opencode/dist/opencode-<os>-<arch>/bin/opencode
```

## Uninstall

```bash
rm ~/.local/bin/sandbox
```

## License

MIT (see LICENSE).
