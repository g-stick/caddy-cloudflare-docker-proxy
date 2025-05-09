FROM caddy:builder AS builder

# Build Caddy with the required plugins
RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2

# Use the official Caddy image for the final image
FROM caddy:latest

# Copy the custom-built Caddy binary from the builder stage
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# Set the default command to run Caddy
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]

# Optional: Set the working directory
# WORKDIR /app
