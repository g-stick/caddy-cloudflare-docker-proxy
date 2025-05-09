FROM --platform=$BUILDPLATFORM caddy:builder AS builder

ARG TARGETARCH
RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --target=linux/$TARGETARCH

FROM caddy:latest

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
