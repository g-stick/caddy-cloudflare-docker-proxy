# Build stage (ARM64 only)
FROM --platform=linux/arm64 caddy:builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2

# Final image (ARM64 only)
FROM --platform=linux/arm64 caddy:latest
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
