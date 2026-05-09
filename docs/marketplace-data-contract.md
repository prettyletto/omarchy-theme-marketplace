# Marketplace Data Contract

This document defines the first data shape for the Omarchy theme marketplace.
It is intentionally small: the marketplace should discover themes and hand
installation off to Omarchy's existing theme install command.

## Source

The first marketplace source is the Omarchy manual extra themes page:

```text
https://learn.omacom.io/2/the-omarchy-manual/90/extra-themes.md
```

The Markdown version is preferred over the HTML page because it exposes each
theme as a simple image/link pair:

```markdown
![aetheria.png](https://learn.omacom.io/u/aetheria-jaDcHN.png)
[Aetheria](https://github.com/JJDizz1L/aetheria)
```

## Theme Record

Each scraped marketplace item should produce one theme record:

```json
{
  "name": "Aetheria",
  "repo_url": "https://github.com/JJDizz1L/aetheria",
  "image_url": "https://learn.omacom.io/u/aetheria-jaDcHN.png",
  "theme_name": "aetheria",
  "preview_path": "~/.cache/omarchy/theme-marketplace/aetheria.png",
  "installed": false
}
```

## Fields

- `name`: Human-readable theme name shown in Walker.
- `repo_url`: GitHub repository URL passed to `omarchy-theme-install`.
- `image_url`: Remote thumbnail URL from the marketplace source.
- `theme_name`: Normalized Omarchy theme directory name.
- `preview_path`: Local cached thumbnail path for Elephant's `Preview` field.
- `installed`: Whether the theme is already available locally.

## Theme Name Normalization

The marketplace should use the same naming convention as `omarchy-theme-install`:

```bash
theme_name=$(basename "$repo_url" .git | sed -E 's/^omarchy-//; s/-theme$//' | tr '[:upper:]' '[:lower:]')
```

Examples:

```text
https://github.com/JJDizz1L/aetheria                  -> aetheria
https://github.com/bjarneo/omarchy-aura-theme         -> aura
https://github.com/tahayvr/omarchy-sunset-drive-theme -> sunset-drive
```

## Installed Detection

A theme should be marked installed when its normalized `theme_name` exists in
one of Omarchy's theme directories:

```text
~/.config/omarchy/themes/<theme-name>
$OMARCHY_PATH/themes/<theme-name>
```

Installed themes can be displayed with a tag such as:

```text
Aetheria  [installed]
```

## Runtime Boundary

The scraper/cache step should produce the marketplace data.

The Elephant provider should only read cached data and return Walker entries.

Theme installation should remain delegated to:

```bash
omarchy-theme-install <repo-url>
```

