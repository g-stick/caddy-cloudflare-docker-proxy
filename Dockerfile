FROM caddy:latest

# Install the Cloudflare DNS plugin
RUN caddy add github.com/caddy-dns/cloudflare

# Install the Docker Label plugin
RUN caddy add github.com/lucaslorentz/caddy-docker-proxy/plugin/labels

# You can add any other plugins you need here in a similar fashion
# For example:
# RUN caddy add github.com/other/plugin

# The base Caddy image already exposes ports 80 and 443
# You don't need to explicitly expose them again here.

# Define the default command to run Caddy
# You'll likely want to mount your Caddyfile into the container
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]

# You can optionally specify a working directory
# WORKDIR /app
