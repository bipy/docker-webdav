# build
FROM caddy:2-builder-alpine AS builder
RUN xcaddy build \
    --with github.com/mholt/caddy-webdav \
    --with github.com/mastercactapus/caddy2-proxyprotocol \
    --with github.com/caddy-dns/cloudflare

# image
FROM caddy:2-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

