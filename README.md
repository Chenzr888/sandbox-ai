# Sandbox AI

> Forked from [opencode](https://github.com/anomalyco/opencode) (MIT). Tailored for use with sandboxai.top.

A terminal-based AI agent.

## Quick start (one-shot install)

```bash
git clone https://github.com/ChenZR-ai/sandbox-ai.git
cd sandbox-ai
./install.sh
```

That puts a global `sandbox` command on your PATH (`~/.local/bin/sandbox`).
Then:

```bash
sandbox auth login --provider sandboxai     # paste your API key from https://sandboxai.top
sandbox                                     # launch TUI
sandbox models | grep sandbox               # verify provider is wired
```

## Custom endpoint

Point `sandbox` at your own OpenAI-compatible gateway:

```bash
SANDBOXAI_BASE_URL=https://your-gateway.example.com/v1 sandbox
```

## Dev (without installer)

```bash
bun install
bun run dev --help
```

## Build

```bash
bun run --cwd packages/opencode build
```

## Uninstall

```bash
rm ~/.local/bin/sandbox
```

## License

MIT (see LICENSE).
