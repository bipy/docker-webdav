# build
FROM caddy:2.9.0-builder-alpine AS builder
RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/mholt/caddy-webdav

# image
FROM caddy:2.9.0-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

