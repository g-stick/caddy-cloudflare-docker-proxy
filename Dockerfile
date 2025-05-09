
# Install dependencies with cache optimization
RUN apk add --no-cache git bash build-base

# Build xcaddy with ARM64 support
RUN GOARCH=arm64 go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

# Build Caddy with plugins (explicit ARM64)
RUN GOARCH=arm64 /go/bin/xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --output /caddy-arm64

# Stage 2: Create final ARM64 image
FROM --platform=linux/arm64 caddy:latest-alpine

# Copy pre-built ARM64 binary
COPY --from=builder /caddy-arm64 /usr/bin/caddy

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD ["/usr/bin/caddy", "validate", "--config", "/etc/caddy/Caddyfile"]
