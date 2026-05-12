#!/bin/bash

set -euo pipefail

omarchy_path="${OMARCHY_PATH:-$HOME/.local/share/omarchy}"
omarchy_bin_dir="$omarchy_path/bin"
elephant_menu_dir="$HOME/.config/elephant/menus"
omarchy_menu_extension="$HOME/.config/omarchy/extensions/menu.sh"

rm -f "$omarchy_bin_dir/omarchy-theme-marketplace"
rm -f "$omarchy_bin_dir/omarchy-theme-marketplace-refresh"
rm -f "$omarchy_bin_dir/omarchy-theme-marketplace-install"
rm -f "$omarchy_bin_dir/omarchy-theme-marketplace-setup"
rm -f "$elephant_menu_dir/omarchy_theme_marketplace.lua"

if [[ -f $omarchy_menu_extension ]]; then
  tmp_file=$(mktemp)
  awk '
    $0 == "# >>> omarchy-theme-marketplace" { skip = 1; next }
    $0 == "# <<< omarchy-theme-marketplace" { skip = 0; next }
    skip != 1 { print }
  ' "$omarchy_menu_extension" >"$tmp_file"
  mv "$tmp_file" "$omarchy_menu_extension"
fi

if command -v omarchy-restart-walker >/dev/null 2>&1; then
  omarchy-restart-walker >/dev/null 2>&1 || true
fi

echo "Uninstalled Omarchy Theme Marketplace."
echo "Cache left in place: $HOME/.cache/omarchy/theme-marketplace"
