# Weather Unified Strip — Design Spec

**Date:** 2026-04-04

## Summary

Replace the current disconnected weather card + separate forecast row with a single unified horizontal strip. The strip holds today's conditions on the left and the 4-day forecast inline to the right, separated by a subtle divider.

## Layout

```
┌─────────────────────────────────────────────────────────┐
│  [icon]  51°F          │ Sun  │ Mon  │ Tue  │ Wed  │
│          H 61° · L 39° │ [ic] │ [ic] │ [ic] │ [ic] │
│                        │  65° │  68° │  56° │  57° │
│                        │  43° │  46° │  42° │  42° │
└─────────────────────────────────────────────────────────┘
```

- Single `#weather-card` container: `display: flex`, `border-radius: 20px`, glassmorphism background, border tinted by today's temperature accent color
- `#weather-today`: left section with icon + current temp + H/L, `border-right` divider
- `#weather-forecast`: flex row of 4 day columns, each with day name + icon + high + low

## Typography (vw-based for full-screen scaling)

| Element | Size |
|---|---|
| Today current temp | `3.6vw` |
| Today high (H value) | `2.4vw` |
| Today low (L value) | `1.8vw` |
| Forecast day high | `2.8vw` |
| Forecast day low | `1.8vw` |
| Forecast day name | `1.3vw` |

## Colors

- Temperature accent colors retained: `t-cold` `t-mild` `t-warm` `t-hot`
- Strip border tinted by today's temperature accent via `color-mix`
- Day high: accent color. Day low: `rgba(255,255,255,0.28)`

## Removed

- `#weather-badges` element and all pill styles
- Wind and Precip pills
- Separate `#weather-forecast` below the card (now inline in strip)

## Files Changed

- `index.html`: HTML structure, CSS, JS `renderWeather()`
