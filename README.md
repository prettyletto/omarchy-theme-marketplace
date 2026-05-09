# Omarchy Theme Marketplace

Browse and install extra Omarchy themes from the Omarchy manual using a Walker
and Elephant menu that feels like the built-in theme selector.

The marketplace source is:

```text
https://learn.omacom.io/2/the-omarchy-manual/90/extra-themes.md
```

## Demo

[![Omarchy Theme Marketplace demo](https://github.com/prettyletto/omarchy-theme-marketplace/releases/download/readme-demo/screenrecording-2026-05-09_12-25-10.gif)](https://github.com/prettyletto/omarchy-theme-marketplace/releases/download/readme-demo/screenrecording-2026-05-09_12-25-10.960p.mp4)

The animated demo is hosted as a GitHub Release asset so regular clones do not
download it. Click it to open the smaller MP4 version.

## What It Does

- Fetches the Omarchy manual extra-themes Markdown page.
- Parses each theme name, GitHub repository URL, and preview image URL.
- Caches marketplace data locally as TSV.
- Downloads and compresses preview images into small local JPEG thumbnails.
- Shows the themes in a hidden Elephant provider opened by Walker.
- Marks themes already installed as `[installed]`.
- Installs new themes by handing off to Omarchy's existing `omarchy-theme-install`.

## Install

From this repository:

```bash
./install.sh
```

Then run:

```bash
omarchy-theme-marketplace
```

The Omarchy route is also available as:

```bash
omarchy theme marketplace
```

## Uninstall

```bash
./uninstall.sh
```

The uninstall script removes the Omarchy bin links and Elephant provider link.
It leaves the cache in place:

```text
~/.cache/omarchy/theme-marketplace
```

Remove that directory manually if you want to clear cached marketplace data and
previews.

## Files Installed

The installer creates symlinks into the local Omarchy and Elephant locations:

```text
~/.local/share/omarchy/bin/omarchy-theme-marketplace
~/.local/share/omarchy/bin/omarchy-theme-marketplace-refresh
~/.local/share/omarchy/bin/omarchy-theme-marketplace-install
~/.config/elephant/menus/omarchy_theme_marketplace.lua
```

If your Omarchy install is not in `~/.local/share/omarchy`, set `OMARCHY_PATH`
before running the installer:

```bash
OMARCHY_PATH=/path/to/omarchy ./install.sh
```

## Commands

```bash
omarchy-theme-marketplace
```

Starts a background refresh, waits until preview thumbnails are ready when the
cache is cold, then opens Walker:

```bash
walker --width 800 --minheight 400 --maxheight 400 -m menus:omarchyThemeMarketplace
```

```bash
omarchy-theme-marketplace-refresh
```

Fetches the remote Markdown, checks whether it changed with SHA-256, updates the
local TSV cache, and generates compressed preview thumbnails.

```bash
omarchy-theme-marketplace-install <git-repo-url> [theme-name]
```

Shows an install notification and opens Omarchy's floating presentation terminal
to run:

```bash
omarchy-theme-install <git-repo-url>
```

## Cache

Marketplace cache lives at:

```text
~/.cache/omarchy/theme-marketplace
```

Important files:

```text
themes.tsv
source.md
source.sha256
previews/<theme-name>.jpg
```

`themes.tsv` has five tab-separated fields:

```text
theme_name<TAB>name<TAB>repo_url<TAB>image_url<TAB>preview_path
```

Example:

```text
aetheria	Aetheria	https://github.com/JJDizz1L/aetheria	https://learn.omacom.io/u/aetheria-jaDcHN.png	/home/user/.cache/omarchy/theme-marketplace/previews/aetheria.jpg
```

## Preview Handling

The manual images are large preview images, not small thumbnails. Downloading
them as-is produced a cache around 217 MB during testing.

This project converts them locally with ImageMagick:

```text
max size: 1000x1000>
quality: 82
format: JPEG
```

That reduced the preview cache to about 9 MB for 108 themes on the test system.

Cold first-run refresh took about 9 seconds on the test system. Normal unchanged
refreshes took about 0.2 seconds because only the Markdown source is checked.

## Runtime Flow

First launch with a cold cache:

```text
omarchy-theme-marketplace
-> starts omarchy-theme-marketplace-refresh
-> sends a "Fetching themes" notification
-> waits until thumbnails are ready
-> opens Walker marketplace menu
```

Selecting an uninstalled theme:

```text
Walker action
-> omarchy-theme-marketplace-install <repo-url> <name>
-> notify-send "Installing theme"
-> floating Omarchy terminal
-> omarchy-theme-install <repo-url>
-> omarchy-theme-set <theme-name>
```

Selecting an installed theme:

```text
Walker action
-> omarchy-theme-set <theme-name>
```

## Dependencies

Expected from an Omarchy system:

- `bash`
- `curl`
- `elephant`
- `walker`
- `notify-send`
- `xdg-terminal-exec`
- `uwsm-app`
- `omarchy-theme-install`
- `omarchy-theme-set`
- `omarchy-show-logo`
- `omarchy-show-done`

Additional required tool:

- `magick` from ImageMagick

## Technical Notes

The Elephant provider intentionally does not scrape the network. It only reads
the local TSV cache and local preview files. Network and image work stay in the
refresh command so Walker stays responsive.

Installed detection scans:

```text
~/.config/omarchy/themes
$OMARCHY_PATH/themes
```

The theme name normalization follows `omarchy-theme-install`:

```bash
basename "$repo_url" .git | sed -E 's/^omarchy-//; s/-theme$//' | tr '[:upper:]' '[:lower:]'
```

## Troubleshooting

If the menu does not appear after install, restart Walker and Elephant:

```bash
omarchy-restart-walker
```

If previews look stale or missing, clear the cache and launch again:

```bash
rm -rf ~/.cache/omarchy/theme-marketplace/previews
rm -f ~/.cache/omarchy/theme-marketplace/source.sha256
omarchy-theme-marketplace
```

If `magick` is missing, install ImageMagick with your system package manager.
