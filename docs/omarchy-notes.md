# Omarchy Theme Marketplace Notes

These notes summarize the local Omarchy scripts inspected before starting this project.

## Existing Theme Install Flow

`omarchy-theme-install` accepts a git repository URL, derives a theme name from the repo basename, clones the repo into:

```text
~/.config/omarchy/themes/<theme-name>
```

Then it applies the theme by calling:

```text
omarchy-theme-set <theme-name>
```

This makes it a good integration target for a marketplace command: the marketplace only needs to discover and present theme repos, then pass the selected repo URL to `omarchy-theme-install`.

## Existing Theme Selector

`default/elephant/omarchy_themes.lua` defines a hidden Elephant provider named `omarchythemes`.

It scans:

```text
~/.config/omarchy/themes
$OMARCHY_PATH/themes
```

For each theme, it finds `preview.png`, `preview.jpg`, or a fallback image in `backgrounds/`. Each entry includes:

```lua
Text = display_name
Preview = preview_path
PreviewType = "file"
Actions.activate = "omarchy-theme-set " .. theme_name
```

The Omarchy menu opens this provider through Walker with:

```text
omarchy-launch-walker -m menus:omarchythemes --width 800 --minheight 400
```

## Walker And Elephant Integration

`omarchy-launch-walker` ensures `elephant` is running, ensures the Walker gapplication service is running, then executes `walker` with Omarchy's default sizing.

For a marketplace, the native-feeling approach is likely another hidden Elephant provider plus a small bin/menu entry that opens it with `omarchy-launch-walker`.

## Bin Metadata Convention

Omarchy bins use top-of-file comments consumed by the `omarchy` dispatcher. `omarchy-dev-bin-metadata` documents the supported fields.

The only required field is:

```bash
# omarchy:summary=<one-line description>
```

Common optional fields:

```bash
# omarchy:args=<args>
# omarchy:examples=<example command>
# omarchy:aliases=<alternate route>
```

For a future command named `omarchy-theme-marketplace`, the default route would be:

```text
omarchy theme marketplace
```

## Open Design Decisions

- Provider configuration format and location.
- Whether provider data is GitHub search, a curated index, or both.
- How repository metadata maps to Walker text, preview images, and install action.
- Whether previews come from GitHub repository files, cached images, or provider metadata.
- Whether the marketplace command should be a bin only, an Elephant provider only, or both.

