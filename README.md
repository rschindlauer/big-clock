# Big Clock

A fullscreen, dark-mode clock with live weather, designed to run on a wall-mounted display. Single HTML file served by nginx inside Docker, deployed via Portainer on a home server.

## Features

- Large 12-hour clock with AM/PM indicator
- Current weather + 5-day forecast via [Open-Meteo](https://open-meteo.com/) (no API key required)
- Temperature accent colors: blue (cold) → green (mild) → amber (warm) → red (hot)
- Inline SVG weather icons (no external assets)
- Auto-reloads connected browsers when a new version is deployed

## URL parameters

All parameters are optional. Without any, the clock defaults to Seattle weather in imperial units.

| Parameter | Example | Effect |
|-----------|---------|--------|
| `lat` + `lon` | `?lat=47.6&lon=-122.3` | Weather for specific coordinates |
| `name` | `&name=Seattle,+WA` | Display name shown above the weather card |
| `city` | `?city=Berlin` | Geocode a city name via Open-Meteo |
| `tz` | `&tz=America/Los_Angeles` | Timezone for the coordinates |
| `units` | `?units=metric` | `metric` for °C/km/h, default is imperial (°F/mph) |
| `geo` | `?geo=1` | Use browser geolocation |

## Tech stack

- **Frontend:** Single `index.html` — no build step, no framework, no external JS
- **Fonts:** Inter via Google Fonts
- **Weather API:** Open-Meteo (free, no key)
- **Server:** nginx:alpine Docker image
- **Orchestration:** Docker Compose (`compose.yml`)
- **Deployment:** Portainer Git stack (see below)

## Local development

**Option 1 — Python (fastest, no Docker required):**
```bash
python3 -m http.server 8080
# Open http://localhost:8080
```

**Option 2 — Docker Compose (matches production):**
```bash
docker compose up --build
# Open http://localhost:8088
```

## Deployment

The app runs as a Portainer Git stack on a home server. Portainer polls this GitHub repo every **5 minutes**. When it detects a new commit on `main`, it pulls the repo and runs `docker compose up --build`.

### How a deploy flows end-to-end

1. Edit `index.html`
2. Update `build-version.txt` (e.g. `release-YYYYMMDD`) — this is the deploy trigger
3. Commit and push to `main`
4. Within 5 minutes, Portainer detects the new commit and rebuilds the Docker image
5. The Dockerfile copies `build-version.txt` into the image as `/version.txt`
6. The page polls `/version.txt` every 15 seconds; when the value changes, it auto-reloads all open browser tabs

### Why `build-version.txt` matters

Portainer rebuilds the image from scratch on each detected change, but Docker's layer cache would serve a stale `version.txt` if no tracked file changed in that layer. Updating `build-version.txt` busts the cache for the `COPY build-version.txt` layer, guaranteeing the new version string lands inside the container.

## File structure

```
index.html          — entire application (clock + weather + auto-reload logic)
build-version.txt   — bumped on each deploy to bust Docker cache and trigger client reload
Dockerfile          — copies index.html and build-version.txt into nginx:alpine
compose.yml         — Docker Compose config; used by Portainer as the Git stack entry point
```
