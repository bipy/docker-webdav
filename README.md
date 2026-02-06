# Docker WebDAV Server Image

This repo aims to build the latest WebDAV server docker image by [GitHub Actions](https://github.com/features/actions)

See [bipy/webdav - DockerHub](https://hub.docker.com/r/bipy/webdav)

## Features

- 🚀 **Automated Updates**: Daily checks for new Caddy releases with automatic PR creation
- 🔄 **CI/CD Pipeline**: Automatic Docker image builds and releases
- 🏗️ **Multi-platform**: Supports both amd64 and arm64 architectures
- 📦 **Latest Plugins**: Always builds with the latest Caddy plugins
- 🔐 **Cloudflare DNS**: Includes Cloudflare DNS plugin for automatic HTTPS

## Dependency

**Base Server:** [Caddy](https://github.com/caddyserver/caddy)

**WebDAV Plugin:** [caddy-webdav](https://github.com/mholt/caddy-webdav)

**DNS Plugin:** [caddy-dns/cloudflare](https://github.com/caddy-dns/cloudflare)

**WebDAV Implementation:** [golang.org/x/net/webdav](https://github.com/golang/net)

## Usage

Run in container

```bash
# when you just want to setup a simple WebDAV server
docker run --name webdav -d \
-p 80:80 \
-v /path/to/Caddyfile:/etc/caddy/Caddyfile \
-v /path/to/dav:/srv \
bipy/webdav:latest

# when you need more
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

## Automated Updates

This repository uses GitHub Actions to:
- **Daily**: Check for new Caddy releases and create PRs automatically
- **Weekly**: Monitor plugin updates and report status
- **Automatic**: Build and publish Docker images on version updates
- **Automatic**: Create GitHub releases with version information

See [Workflow Documentation](.github/workflows/README.md) for details.

## License

MIT License