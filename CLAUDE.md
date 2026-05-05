# CLAUDE.md

## Project overview

Fullscreen dark-mode clock with live weather. Single `index.html` served by nginx in Docker, deployed via Portainer on a home server. No build step, no framework, no bundler.

## Key architectural facts

- **Everything lives in `index.html`.** CSS, JS, and SVG icons are all inline. Do not split into separate files unless the user explicitly asks.
- **No build pipeline.** Changes to `index.html` are live after a Docker rebuild. There is no transpilation, minification, or asset pipeline.
- **Weather data** comes from Open-Meteo (free, no API key). Geocoding and forecast endpoints are both in the JS.

## Deploy pipeline

```
edit index.html
  → bump build-version.txt
  → git commit + push to main
  → Portainer polls GitHub every 5 minutes
  → detects new commit → docker compose up --build
  → new image contains updated /version.txt
  → page polls /version.txt every 15s → auto-reloads open tabs
```

**Always bump `build-version.txt` when pushing a change that should reach the display.** Without it, Portainer may still rebuild but Docker layer cache will serve the old `version.txt`, and the page won't auto-reload. Convention is `release-YYYYMMDD`.

## Key DOM elements

| ID | Role |
|----|------|
| `#time` | Clock digits (e.g. `10:42`) |
| `#period` | AM/PM string |
| `#weather-line` | Place name above the weather card |
| `#weather-card` | Unified weather strip; hidden until data loads (`data-ready="0"`) |
| `#weather-icon` | Large inline SVG for current conditions |
| `#weather-now` | Current temperature |
| `#weather-hilo` | Today's high / low |
| `#weather-forecast` | 4-day forecast columns |

## CSS custom properties

```css
--bg             background color
--fg             primary text
--muted          secondary/dimmed text
--weather-fg     weather card text
--weather-muted  weather card secondary text
```

Temperature accent classes (`t-cold`, `t-mild`, `t-warm`, `t-hot`) are applied to `#weather-card` and cascade to temperature values via `--acc`.

## Local dev

```bash
python3 -m http.server 8080   # fastest — no Docker needed
docker compose up --build     # matches production (port 8088)
```

## Things to avoid

- Don't add external JS dependencies — the whole point is a single self-contained file.
- Don't add a build step without discussing it first.
- Don't forget to bump `build-version.txt` when the user wants the change deployed.
