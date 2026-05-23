#!/usr/bin/env bash
# Download Upsonic doc indexes for offline grep / agent reference.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="${SCRIPT_DIR}/../references/cache"
mkdir -p "$CACHE_DIR"

BASE="https://docs.upsonic.ai"

echo "Fetching llms.txt (page index)..."
curl -fsSL --max-time 60 "${BASE}/llms.txt" -o "${CACHE_DIR}/llms.txt"

echo "Fetching llms-full.txt (full doc dump, ~2MB)..."
curl -fsSL --max-time 120 "${BASE}/llms-full.txt" -o "${CACHE_DIR}/llms-full.txt"

echo "Done:"
ls -lh "${CACHE_DIR}/llms.txt" "${CACHE_DIR}/llms-full.txt"
