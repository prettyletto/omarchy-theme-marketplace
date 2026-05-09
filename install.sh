#!/bin/bash

set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
omarchy_path="${OMARCHY_PATH:-$HOME/.local/share/omarchy}"
omarchy_bin_dir="$omarchy_path/bin"
elephant_menu_dir="$HOME/.config/elephant/menus"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Error: required command not found: $1" >&2
    exit 1
  fi
}

if [[ ! -d $omarchy_path ]]; then
  echo "Error: Omarchy path not found: $omarchy_path" >&2
  echo "Set OMARCHY_PATH if your Omarchy install lives somewhere else." >&2
  exit 1
fi

require_command curl
require_command magick
require_command notify-send
require_command walker
require_command elephant

mkdir -p "$omarchy_bin_dir" "$elephant_menu_dir"

chmod +x \
  "$repo_dir/bin/omarchy-theme-marketplace" \
  "$repo_dir/bin/omarchy-theme-marketplace-refresh" \
  "$repo_dir/bin/omarchy-theme-marketplace-install"

ln -snf "$repo_dir/bin/omarchy-theme-marketplace" "$omarchy_bin_dir/omarchy-theme-marketplace"
ln -snf "$repo_dir/bin/omarchy-theme-marketplace-refresh" "$omarchy_bin_dir/omarchy-theme-marketplace-refresh"
ln -snf "$repo_dir/bin/omarchy-theme-marketplace-install" "$omarchy_bin_dir/omarchy-theme-marketplace-install"
ln -snf "$repo_dir/default/elephant/omarchy_theme_marketplace.lua" "$elephant_menu_dir/omarchy_theme_marketplace.lua"

if command -v omarchy-restart-walker >/dev/null 2>&1; then
  omarchy-restart-walker >/dev/null 2>&1 || true
fi

echo "Installed Omarchy Theme Marketplace."
echo "Run: omarchy-theme-marketplace"
echo "Route: omarchy theme marketplace"
