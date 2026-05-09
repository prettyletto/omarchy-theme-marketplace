#!/bin/bash

set -euo pipefail

omarchy_path="${OMARCHY_PATH:-$HOME/.local/share/omarchy}"
omarchy_bin_dir="$omarchy_path/bin"
elephant_menu_dir="$HOME/.config/elephant/menus"

rm -f "$omarchy_bin_dir/omarchy-theme-marketplace"
rm -f "$omarchy_bin_dir/omarchy-theme-marketplace-refresh"
rm -f "$omarchy_bin_dir/omarchy-theme-marketplace-install"
rm -f "$elephant_menu_dir/omarchy_theme_marketplace.lua"

if command -v omarchy-restart-walker >/dev/null 2>&1; then
  omarchy-restart-walker >/dev/null 2>&1 || true
fi

echo "Uninstalled Omarchy Theme Marketplace."
echo "Cache left in place: $HOME/.cache/omarchy/theme-marketplace"
