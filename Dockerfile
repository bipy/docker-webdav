# build
FROM caddy:null-builder-alpine AS builder
RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/mholt/caddy-webdav

# image
FROM caddy:null-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

