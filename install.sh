#!/usr/bin/env bash
# Install nvtune to /usr/local/bin and its dependencies.
set -euo pipefail

src="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v nvidia-smi >/dev/null; then
    echo "warning: nvidia-smi not found — install the NVIDIA proprietary driver first." >&2
fi

echo "Installing dependencies (python3-rich for the TUI, mangohud for the OSD)…"
if command -v apt-get >/dev/null; then
    sudo apt-get install -y python3-rich mangohud || true
elif command -v dnf >/dev/null; then
    sudo dnf install -y python3-rich mangohud || true
elif command -v pacman >/dev/null; then
    sudo pacman -S --needed --noconfirm python-rich mangohud || true
else
    echo "  (unknown package manager — install python3-rich and mangohud yourself)"
fi

sudo install -m 0755 "$src/nvtune" /usr/local/bin/nvtune

echo
echo "Installed: /usr/local/bin/nvtune"
echo "Try:  nvtune monitor"
