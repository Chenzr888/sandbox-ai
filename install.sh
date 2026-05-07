#!/usr/bin/env bash
# Sandbox AI installer — downloads the latest precompiled binary.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Chenzr888/sandbox-ai/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/Chenzr888/sandbox-ai/main/install.sh | bash -s -- --version v0.1.0
#
# What it does:
#   1. Detect OS / arch (linux-x64 / linux-arm64 / darwin-x64 / darwin-arm64).
#   2. Pull the matching tarball from GitHub Releases.
#   3. Drop the binary at ${SANDBOX_BIN_DIR:-$HOME/.local/bin}/sandbox.
#
# Override:
#   SANDBOX_BIN_DIR=/usr/local/bin curl ... | sudo bash
#
# Looking for dev mode (run from source via bun)? Use install-dev.sh.

set -euo pipefail

REPO="Chenzr888/sandbox-ai"
BIN_NAME="${SANDBOX_BIN_NAME:-sandbox}"
BIN_DIR="${SANDBOX_BIN_DIR:-$HOME/.local/bin}"
VERSION=""

say() { printf '\033[1;36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }
die() { printf '\033[1;31m!!\033[0m %s\n' "$*" >&2; exit 1; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    -v|--version) VERSION="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,17p' "$0" | sed 's/^# //;s/^#//'; exit 0 ;;
    *) die "unknown arg: $1" ;;
  esac
done

# Detect platform
OS=""; ARCH=""
case "$(uname -s)" in
  Linux)  OS=linux ;;
  Darwin) OS=darwin ;;
  *) die "Unsupported OS: $(uname -s). Try install-dev.sh from source." ;;
esac
case "$(uname -m)" in
  x86_64|amd64) ARCH=x64 ;;
  aarch64|arm64) ARCH=arm64 ;;
  *) die "Unsupported arch: $(uname -m). Try install-dev.sh from source." ;;
esac
TARGET="sandboxai-${OS}-${ARCH}"
say "Target: $TARGET"

# Resolve version
if [ -z "$VERSION" ]; then
  say "Resolving latest release..."
  VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | grep -E '"tag_name"' | head -1 | sed -E 's/.*"tag_name":[[:space:]]*"([^"]+)".*/\1/')
  [ -n "$VERSION" ] || die "Could not resolve latest version. Specify with --version v0.x.y."
fi
say "Version: $VERSION"

URL="https://github.com/${REPO}/releases/download/${VERSION}/${TARGET}.tar.gz"
say "Downloading $URL"

TMP=$(mktemp -d)
trap "rm -rf '$TMP'" EXIT

if ! curl -fsSL "$URL" -o "$TMP/${TARGET}.tar.gz"; then
  die "Download failed. Verify the release exists at https://github.com/${REPO}/releases/tag/${VERSION}"
fi

say "Extracting..."
tar -xzf "$TMP/${TARGET}.tar.gz" -C "$TMP"

# The tarball contains ${TARGET}/bin/opencode (binary name is opencode internally)
SRC_BINARY="$TMP/${TARGET}/bin/opencode"
[ -x "$SRC_BINARY" ] || die "Binary not found inside tarball at $SRC_BINARY"

mkdir -p "$BIN_DIR"
DEST="$BIN_DIR/$BIN_NAME"
install -m 755 "$SRC_BINARY" "$DEST"
say "Installed: $DEST"

# Smoke test
if "$DEST" --version >/dev/null 2>&1; then
  say "Smoke test passed: $($DEST --version)"
else
  warn "Smoke test failed (the binary is in place but didn't return --version)"
fi

# PATH check
if ! echo ":$PATH:" | grep -q ":$BIN_DIR:"; then
  warn "$BIN_DIR is NOT in your PATH."
  warn "Add this to your ~/.bashrc or ~/.zshrc:"
  warn "    export PATH=\"$BIN_DIR:\$PATH\""
  warn "Then run: source ~/.bashrc"
fi

echo
say "Done. Try:"
echo "  $BIN_NAME auth login --provider sandboxai     # paste your key from https://sandboxai.top"
echo "  $BIN_NAME                                     # launch TUI"
echo
say "Uninstall: rm $DEST"
