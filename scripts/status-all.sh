#!/usr/bin/env bash
set -euo pipefail

workspace_root="${WORKSPACE_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"

repos=(
  c_duino_a7
  AutoTrading
  SlimePet
  Codex_pet
  macroKey
  turntable
  Burndori
  GIFtoRGB565
  KiCAD_LIB
  maduinos
)

for repo in "${repos[@]}"; do
  echo "== ${repo} =="
  git -C "${workspace_root}/${repo}" status --short --branch
  git -C "${workspace_root}/${repo}" log -1 --oneline
  echo
done
