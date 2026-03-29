FROM nginx:alpine

# Version marker used by the page's auto-refresh logic.
# For manual deploys: update build-version.txt (commit + push), then Portainer rebuilds.
# This avoids relying on Portainer to pass build args.

COPY index.html /usr/share/nginx/html/index.html
COPY build-version.txt /usr/share/nginx/html/version.txt

EXPOSE 80
