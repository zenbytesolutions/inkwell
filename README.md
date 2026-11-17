# Inkwell

The shared black-and-white UI used across Zenbyte apps. Extracted from Recall (`Sources/Recall/Theme.swift` and `site/index.html`).

**Principles**

- **Strictly monochrome.** White paper, black ink, and greys for hierarchy. No accent colours. State is shown with icons and copy, not colour.
- **Serif voice.** Headlines use Instrument Serif (SwiftUI: system serif) at weight 400, with an italic accent on the second phrase: "Plain words, *italic accent*".
- **Hairlines over shadows.** Use 1px `line` borders for structure, and save soft shadows for floating cards and screenshots.
- **One ink button per view.** Everything else should be ghost or icon buttons.
- **Rounded and soft.** Use 16–20px cards and pill-shaped buttons, chips and segmented controls.

## Contents

| Path | What |
| --- | --- |
| `tokens/tokens.json` | Source of truth: colours (light and dark), fonts, type scale, radii, shadows, layout, motion |
| `web/inkwell.css` | Drop-in stylesheet: tokens as CSS variables, plus component classes. Supports light and dark |
| `Package.swift`, `swift/Sources/Inkwell` | SwiftUI package: `Theme` plus components |
| `docs/index.html` | Visual reference page for every token and component |

## Web

```html
<link href="https://fonts.googleapis.com/css2?family=Instrument+Serif:ital@0;1&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="inkwell.css">

<span class="eyebrow">Your stats</span>
<h1 class="display-xl">Plain words, <em>italic accent</em></h1>
<button class="btn btn-dark">Primary</button>
<button class="btn btn-ghost">Secondary</button>
```

The theme follows the OS by default. Set `<html data-theme="light">` or `data-theme="dark"` to force one.

| Group | Classes |
| --- | --- |
| Type | `serif` `eyebrow` `display-xl` `display-l` `display-m` `title` `lede` `muted` |
| Buttons | `btn` + `btn-dark` / `btn-ghost` / `btn-icon`, sizes `btn-sm` `btn-xs` |
| Small bits | `chip` (with `<b>` badge), `tag`, `kbd`, `status` / `status ok` |
| Surfaces | `card` `card-lg` `shot` `panel` + `row` |
| Patterns | `grid` + `cell` + `ico`, `stats` + `stat`, `ticks`, `steps` + `step`, `inverse` |
| Controls | `tabs` (`aria-selected`), `field`, `search`, `toggle` |
| Chrome | `nav` `brand` `mark` `nav-links` `footer` `wrap` `reveal` |

## SwiftUI

```swift
.package(url: "https://github.com/zenbytesolutions/inkwell", branch: "main")
```

```swift
import Inkwell

VStack(alignment: .leading, spacing: 24) {
    Eyebrow("Settings")
    Headline("Make it ", accent: "yours")
    Panel("Permissions", subtitle: "Recall needs these to work.") {
        Row("Microphone", detail: "Granted") { StatusDot(ok: true) }
        Row("Accessibility", showsDivider: false) {
            Button("Allow") {}.buttonStyle(.primary)
        }
    }
    Button("Start recording") {}.buttonStyle(.ink)
}
.page()
```

Components: `Theme`, `Eyebrow`, `Headline`, `Card`, `Panel`, `Row`, `PillTabs`, `KeyCap`, `StatusDot`, `SearchField`, `ThemedField`, `.page()`, and the button styles `.primary`, `.ink`, `.ghost` and `.icon`.

> The SwiftUI theme is light-only, matching Recall today. Dark values are defined in `tokens.json` for when native dark mode is added.

## Colour tokens

| Token | Light | Dark | Use |
| --- | --- | --- | --- |
| `bg` / `paper` | `#fafaf9` / `#ffffff` | `#0b0b0b` | Page background |
| `bg-2` / `sidebar` | `#f2f2f0` / `#f6f6f6` | `#121212` | Recessed surfaces |
| `card` | `#ffffff` | `#151515` | Cards, inputs |
| `ink` | `#0a0a0a` | `#f4f4f2` | Text, primary fills |
| `ink-2` | `#3d3d3b` | `#c9c9c4` | Secondary copy |
| `muted` | `#6b6b6b` | `#8c8c86` | Labels, captions |
| `faint` | `#a8a8a8` | `#5c5c58` | Placeholders |
| `line` | `#e6e6e6` | `rgba(255,255,255,.09)` | Hairlines |
| `line-2` | `rgba(10,10,10,.16)` | `rgba(255,255,255,.18)` | Stronger borders |
| `fill` / `fill-deep` | `#ededed` / `#7a7a7a` | `#1f1f1f` / `#8c8c86` | Highlights, data series |
