#!/usr/bin/env bash
set -euo pipefail

if ! command -v sudo >/dev/null; then
  echo "sudo is required for this installer." >&2
  exit 1
fi

sudo apt-get update
sudo apt-get install -y iverilog curl ca-certificates

if ! command -v arduino-cli >/dev/null; then
  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "${tmp_dir}"' EXIT
  curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh -o "${tmp_dir}/install-arduino-cli.sh"
  sh "${tmp_dir}/install-arduino-cli.sh"
  sudo install -m 0755 bin/arduino-cli /usr/local/bin/arduino-cli
  rm -rf bin
fi

arduino-cli core update-index
arduino-cli core install arduino:avr
arduino-cli lib install MsTimer2

iverilog -V | head -n 1
arduino-cli version
