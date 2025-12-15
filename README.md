# Reflect 2025

Minimalist one-line-per-day calendars for reflection and journaling.

## Formats

| Format | File | Layout | Use Case |
|--------|------|--------|----------|
| **A4 Single** | `2025-Cal-A4.pdf` | 3 columns, 1 page | Compact yearly overview |
| **A4 Two-Page** | `2025-Cal-A4-2Page.pdf` | 6 columns, 2 pages | Half-year spreads |
| **A4 Four-Page** | `2025-Cal-A4-4Page.pdf` | 3 columns, 4 pages | Quarterly layouts |
| **A3 Single** | `2025-Cal-A3.pdf` | 3 columns, 1 page | Large wall calendar |

## Features

- One line per day for journaling
- Weekend highlighting (light blue background)
- Month names on first day of each month
- Zero margins for edge-to-edge printing
- Color theme: RGB(43,40,120)

## Usage

**Print:** Use PDFs in the `pdf/` folder  
**Customize:** Edit `.typ` files in `source/` folder and compile with [Typst](https://typst.app/)

```bash
typst compile source/2025-Cal-A4.typ pdf/2025-Cal-A4.pdf
```

## License

CC BY-SA 4.0 - https://hiran.in
