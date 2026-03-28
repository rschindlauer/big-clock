FROM nginx:alpine

# Bump this on each deploy (or pass --build-arg BUILD_VERSION=...) to trigger
# connected browsers to auto-reload when they detect a new version.
ARG BUILD_VERSION=dev

COPY index.html /usr/share/nginx/html/index.html

# A tiny version marker the client can poll with cache disabled.
RUN printf "%s" "$BUILD_VERSION" > /usr/share/nginx/html/version.txt

EXPOSE 80
