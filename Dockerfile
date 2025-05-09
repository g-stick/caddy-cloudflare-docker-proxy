# Stage 1: Build environment
FROM --platform=linux/arm64 golang:1.21-alpine AS builder

# Install dependencies
RUN apk add --no-cache git bash build-base

# Build xcaddy
RUN GOARCH=arm64 go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

# Build Caddy with plugins
RUN GOARCH=arm64 /go/bin/xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --output /caddy-arm64

# Stage 2: Runtime image
FROM --platform=linux/arm64 caddy:latest-alpine

# Copy binary
COPY --from=builder /caddy-arm64 /usr/bin/caddy

# Verify architecture
RUN [ "$(readelf -h /usr/bin/caddy | grep Machine | awk '{print $2}')" = "AArch64" ] || (echo "WRONG ARCHITECTURE"; exit 1)

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD ["/usr/bin/caddy", "validate", "--config", "/etc/caddy/Caddyfile"]
