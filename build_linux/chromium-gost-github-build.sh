#!/bin/bash
set -euo pipefail

# Build Chromium-Gost inside GitHub Actions on Linux

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

export CHROMIUM_TAG="$(cat "$REPO_ROOT/VERSION")"
export CHROMIUM_FLAGS="$(cat "$REPO_ROOT/FLAGS")"
export CHROMIUM_GOST_REPO="$REPO_ROOT"

export CHROMIUM_PATH="$REPO_ROOT/chromium/src"
export BORINGSSL_PATH="$CHROMIUM_PATH/third_party/boringssl/src"
export DEPOT_TOOLS_PATH="$REPO_ROOT/depot_tools"
export CHROMIUM_PRIVATE_ARGS=""

export PATH="$DEPOT_TOOLS_PATH:$DEPOT_TOOLS_PATH/python-bin:$PATH"

# Fetch depot_tools
if [ ! -d "$DEPOT_TOOLS_PATH" ]; then
  git clone --depth 1 https://chromium.googlesource.com/chromium/tools/depot_tools.git "$DEPOT_TOOLS_PATH"
fi

# Fetch Chromium sources
if [ ! -d "$CHROMIUM_PATH" ]; then
  mkdir -p "$(dirname "$CHROMIUM_PATH")"
  cd "$(dirname "$CHROMIUM_PATH")"
  fetch --nohooks chromium --revision "$CHROMIUM_TAG"
fi

cd "$CHROMIUM_GOST_REPO/build_linux"
./chromium-gost-prepare.sh
./chromium-gost-build-release.sh
