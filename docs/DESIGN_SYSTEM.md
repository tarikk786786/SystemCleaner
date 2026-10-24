# Design System — SystemCleaner

## 1. Visual Language & CLI Console Palette
SystemCleaner provides a clean, modern, high-contrast terminal interface adhering to the Windows Terminal and PowerShell console standards:

| Element | Color | HEX / ANSI | Purpose |
|---|---|---|---|
| **Header Banner** | Cyan | `#00d8d6` | Tool title and stage banners |
| **Success State** | Green | `#2ecc71` | Successfully uninstalled or verified clean |
| **Warning / Notice** | Yellow | `#f1c40f` | Non-fatal skip or dry-run notice |
| **Error / Alert** | Crimson Red | `#e74c3c` | Failed uninstall code or process lock |
| **Metadata / Logs** | Gray / Muted | `#7f8c8d` | Timestamps, GUIDs, and file paths |
| **Action Prompts** | White / Bold | `#ffffff` | User prompts and status confirmations |

## 2. Status Indicators
- `[+]` : Information / Discovery
- `[*]` : In-Progress Operation
- `[✓]` : Successful Removal
- `[!]` : Warning / Elevation Note
- `[✗]` : Failure / Exit Code

## 3. Typography & Spacing
- Monospace font: Cascadia Code, Consolas, or JetBrains Mono.
- 2-space indented hierarchical logs.
- Horizontal dividers (`--------------------------------------------------`) between phases.
