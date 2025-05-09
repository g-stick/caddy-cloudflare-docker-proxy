# Build stage (automatically matches target platform)
FROM --platform=$BUILDPLATFORM caddy:builder AS builder

# This automatically builds for the target architecture
RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2

# Final image (uses correct platform automatically)
FROM caddy:latest
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
