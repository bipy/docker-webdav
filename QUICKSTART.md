# Quick Start Guide for Automated Workflows

This guide helps you quickly get started with the automated CI/CD workflows for the docker-webdav project.

## Prerequisites

Before the workflows can run successfully, you need to configure the following secrets in your GitHub repository settings:

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Add the following repository secrets:

### Required Secrets

| Secret Name | Description | How to Get It |
|-------------|-------------|---------------|
| `DOCKER_HUB_USERNAME` | Your Docker Hub username | Your Docker Hub account username |
| `DOCKER_HUB_ACCESS_TOKEN` | Docker Hub access token | Create at [Docker Hub → Account Settings → Security](https://hub.docker.com/settings/security) |

**Note**: `GITHUB_TOKEN` is automatically provided by GitHub Actions and does not need to be configured.

## Workflow Overview

Once configured, the following workflows will run automatically:

### 1. Daily Version Checks (check-updates.yml)
- **When**: Every day at 00:00 UTC
- **What**: Checks if a new Caddy version is available
- **Result**: Creates a pull request if an update is found

### 2. Weekly Plugin Monitoring (check-plugin-updates.yml)
- **When**: Every Monday at 00:00 UTC
- **What**: Checks for updates to caddy-webdav and caddy-dns/cloudflare plugins
- **Result**: Creates a GitHub issue with plugin status

### 3. Automated Builds (docker-publish.yml)
- **When**: On push to main branch (when version.txt, Dockerfile, or Caddyfile-* change)
- **What**: Builds Docker images for multiple platforms
- **Result**: Pushes to Docker Hub and creates GitHub releases

## Manual Testing

You can manually trigger any workflow to test it:

### Option 1: Using GitHub Web UI
1. Go to **Actions** tab in your repository
2. Select the workflow you want to run
3. Click **Run workflow** button
4. Select the branch (usually main)
5. Click **Run workflow**

### Option 2: Using GitHub CLI
```bash
# Check for Caddy updates
gh workflow run check-updates.yml

# Check plugin status
gh workflow run check-plugin-updates.yml

# Build and publish Docker image
gh workflow run docker-publish.yml
```

## Expected Workflow Behavior

### When a New Caddy Version is Released

1. **Daily Check Runs** (00:00 UTC)
   ```
   check-updates.yml runs
   ↓
   Detects new version (e.g., 2.9.2)
   ↓
   Creates PR: "chore: update Caddy to 2.9.2"
   ```

2. **Review and Merge**
   - Review the automatically created PR
   - Check the release notes link in the PR description
   - Merge the PR when ready

3. **Automatic Build Triggers**
   ```
   PR merged to main
   ↓
   docker-publish.yml runs automatically
   ↓
   Builds images for amd64 and arm64
   ↓
   Pushes to Docker Hub:
     - bipy/webdav:2.9.2
     - bipy/webdav:latest
   ↓
   Creates GitHub Release v2.9.2
   ```

### Plugin Status Check (Weekly)

1. **Monday Check Runs** (00:00 UTC)
   ```
   check-plugin-updates.yml runs
   ↓
   Checks plugin repositories
   ↓
   Creates/updates GitHub issue with status
   ```

2. **Review Issue**
   - Check the created issue for plugin updates
   - No action required unless noted
   - Issue is informational only

## Troubleshooting

### Workflow Fails with Docker Hub Error

**Problem**: `Error: Cannot perform an interactive login from a non TTY device`

**Solution**: 
- Verify `DOCKER_HUB_USERNAME` is set correctly
- Verify `DOCKER_HUB_ACCESS_TOKEN` is a valid token (not your password)
- Regenerate access token if needed

### PR Creation Fails

**Problem**: `Error: Resource not accessible by integration`

**Solution**: 
- Check that GitHub Actions has write permissions
- Go to **Settings** → **Actions** → **General**
- Under "Workflow permissions", select "Read and write permissions"

### Build Fails with "Platform not supported"

**Problem**: Build fails for arm64 platform

**Solution**: 
- This is expected in some runners
- The workflow is configured to continue on error
- At least amd64 build should succeed

### No Automatic PRs Created

**Problem**: New Caddy version released but no PR created

**Solution**: 
- Manually run the workflow from Actions tab
- Check workflow run logs for errors
- Verify GitHub API rate limits haven't been exceeded

## Monitoring

### Check Workflow Status
```bash
# List recent workflow runs
gh run list --workflow=check-updates.yml --limit 5

# View specific run details
gh run view <run-id>

# View run logs
gh run view <run-id> --log
```

### Check Docker Hub
Visit https://hub.docker.com/r/bipy/webdav/tags to see published images

### Check GitHub Releases
Visit your repository's **Releases** page to see created releases

## Customization

### Change Check Frequency

Edit the cron schedule in the workflow file:

```yaml
on:
  schedule:
    - cron: '0 0 * * *'  # Daily at midnight UTC
```

Common cron patterns:
- `0 */6 * * *` - Every 6 hours
- `0 0 * * 1` - Weekly on Monday
- `0 0 1 * *` - Monthly on the 1st

### Add More Plugins

1. Update `Dockerfile` to include new plugin:
   ```dockerfile
   RUN xcaddy build \
       --with github.com/caddy-dns/cloudflare \
       --with github.com/mholt/caddy-webdav \
       --with github.com/your-org/your-plugin
   ```

2. Update `check-plugin-updates.yml` to monitor it:
   ```yaml
   - name: Check your-plugin
     run: |
       # Add similar check as other plugins
   ```

## Best Practices

1. **Review PRs Promptly**: Automated PRs should be reviewed within a few days
2. **Monitor Issues**: Check plugin status issues for potential breaking changes
3. **Test Updates**: Consider testing new versions in a staging environment first
4. **Keep Secrets Updated**: Rotate Docker Hub tokens periodically
5. **Monitor Rate Limits**: GitHub API has rate limits; don't trigger workflows too frequently

## Support

For issues or questions:
1. Check [IMPLEMENTATION.md](IMPLEMENTATION.md) for detailed technical documentation
2. Review [.github/workflows/README.md](.github/workflows/README.md) for workflow details
3. Open an issue in the repository

## Next Steps

1. Configure the required secrets
2. Manually trigger `check-updates.yml` to test the setup
3. Monitor the Actions tab for successful runs
4. Review and merge any created PRs
5. Verify Docker images are published correctly

Enjoy your automated Docker WebDAV builds! 🚀
