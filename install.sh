#!/usr/bin/env bash
# Install nvtune (CLI/TUI) + nvtune-gui (GTK GUI) and their dependencies.
set -euo pipefail

src="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v nvidia-smi >/dev/null; then
    echo "warning: nvidia-smi not found — install the NVIDIA proprietary driver first." >&2
fi

echo "Installing dependencies…"
if command -v apt-get >/dev/null; then
    sudo apt-get install -y python3-rich mangohud \
        python3-gi python3-gi-cairo gir1.2-gtk-4.0 || true
elif command -v dnf >/dev/null; then
    sudo dnf install -y python3-rich mangohud python3-gobject gtk4 || true
elif command -v pacman >/dev/null; then
    sudo pacman -S --needed --noconfirm python-rich mangohud python-gobject gtk4 || true
else
    echo "  (unknown package manager — install python3-rich, mangohud, PyGObject+GTK4 yourself)"
fi

sudo install -m 0755 "$src/nvtune"     /usr/local/bin/nvtune
sudo install -m 0755 "$src/nvtune-gui" /usr/local/bin/nvtune-gui

# App-menu launcher for the GUI
if [ -w /usr/share/applications ] || sudo -n true 2>/dev/null; then
    sudo install -m 0644 "$src/nvtune.desktop" /usr/share/applications/nvtune.desktop
else
    install -Dm644 "$src/nvtune.desktop" "$HOME/.local/share/applications/nvtune.desktop"
fi

echo
echo "Installed:"
echo "  nvtune       — CLI + live TUI      (try:  nvtune monitor)"
echo "  nvtune-gui   — graphical tuner     (or launch 'nvtune' from the app menu)"
