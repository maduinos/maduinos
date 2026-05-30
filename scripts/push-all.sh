#!/usr/bin/env bash
set -euo pipefail

workspace_root="${WORKSPACE_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"

repos=(
  c_duino_a7
  AutoTrading
  SlimePet
  macroKey
  macrokey_python
  turntable
)

for repo in "${repos[@]}"; do
  echo "== pushing ${repo} =="
  git -C "${workspace_root}/${repo}" push origin main
done

