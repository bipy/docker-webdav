# Docker WebDAV Server Image

This repo aims to build the latest WebDAV server docker image by [GitHub Actions](https://github.com/features/actions)

See [bipy/webdav - DockerHub](https://hub.docker.com/r/bipy/webdav)

## Dependency

**Base Server:** [Caddy](https://github.com/caddyserver/caddy)

**WebDAV Plugin:** [caddy-webdav](https://github.com/mholt/caddy-webdav)

**WebDAV Implementation:** [golang.org/x/net/webdav](https://github.com/golang/net) (Maybe the most powerful and easy-to-use WebDAV server implementation)

## Usage

Run in container

```bash
docker volume create webdav_data

docker run --name webdav -d \
-p 80:80 \
-p 443:443 \
-e CLOUDFLARE_API_TOKEN=AAAABBBBCCCC \
-v webdav_data:/data \
-v /path/to/log:/var/log/caddy \
-v /path/to/Caddyfile:/etc/caddy/Caddyfile \
-v /path/to/dav:/srv \
bipy/webdav:latest
```

## Caddyfile Example

**Mini Version:** [Caddyfile-Mini](Caddyfile-Mini)

**Pro Version:** [Caddyfile-Pro](Caddyfile-Pro)

## License

MIT License