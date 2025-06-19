# 🚀 GitHub Repository Setup Guide

This guide will help you sync your S3Scanner Web Application to GitHub in just a few commands.

## 📋 Prerequisites

- Git installed on your system
- GitHub account
- GitHub CLI (will be installed automatically if missing)

## 🎯 One-Command Setup

```bash
chmod +x sync-to-github.sh
./sync-to-github.sh
```

The script will:
1. ✅ Install GitHub CLI if needed
2. ✅ Initialize git repository
3. ✅ Set up proper .gitignore
4. ✅ Commit all files
5. ✅ Create GitHub repository
6. ✅ Push code to GitHub
7. ✅ Set up repository settings
8. ✅ Create initial project issues

## 📝 Manual Setup (Alternative)

If you prefer manual setup:

### 1. Initialize Git
```bash
git init
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

### 2. Install GitHub CLI
```bash
# Ubuntu/Debian
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install gh

# macOS
brew install gh

# Windows
winget install GitHub.cli
```

### 3. Authenticate with GitHub
```bash
gh auth login
```

### 4. Create Repository
```bash
# Stage files
git add .

# Commit
git commit -m "Initial commit: S3Scanner Web Application"

# Create GitHub repository
gh repo create your-username/s3scanner-web --public --source=. --remote=origin --push
```

## 🎨 Repository Customization

### Repository Settings
- **Description**: "S3Scanner Web Application - Advanced S3 bucket scanner with web interface"
- **Topics**: s3-scanner, security, aws, bucket-scanner, docker, react, fastapi, cybersecurity
- **License**: MIT
- **GitHub Pages**: Enabled (for public repos)

### Branch Protection
```bash
# Set up branch protection
gh api repos/your-username/s3scanner-web/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":[]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":1}' \
  --field restrictions=null
```

## 🔧 GitHub Actions Setup

The repository includes pre-configured GitHub Actions:

### 1. **Docker Build & Push** (`.github/workflows/docker-build.yml`)
- Builds Docker images on every push
- Pushes to GitHub Container Registry
- Multi-platform builds (amd64, arm64)

### 2. **Release Management** (`.github/workflows/release.yml`)
- Creates releases on tag push
- Builds and attaches binaries
- Generates changelog

### Trigger GitHub Actions
```bash
# Create a tag to trigger release
git tag v1.0.0
git push origin v1.0.0
```

## 📊 Repository Structure

After setup, your repository will have:

```
s3scanner-web/
├── .github/
│   └── workflows/           # CI/CD pipelines
├── backend/                 # FastAPI backend
├── frontend/                # React frontend
├── nginx/                   # Reverse proxy config
├── scripts/                 # Utility scripts
├── docs/                    # Documentation
├── docker-compose.yml       # Main compose file
├── start.sh                # Deployment script
├── sync-to-github.sh       # This setup script
└── README.md               # Main documentation
```

## 🌟 Post-Setup Tasks

### 1. Update Repository Settings
- [ ] Add repository description
- [ ] Set up repository topics
- [ ] Configure branch protection rules
- [ ] Enable GitHub Pages (if desired)

### 2. Team Collaboration
```bash
# Add collaborators
gh api repos/your-username/s3scanner-web/collaborators/collaborator-username \
  --method PUT \
  --field permission=push
```

### 3. Issue Templates
The script creates initial issues for:
- 🚀 Development Environment Setup
- 🔧 Production Deployment Tasks
- ✨ Feature Enhancement Ideas

### 4. Project Board
```bash
# Create project board
gh project create --title "S3Scanner Development" --body "Project management for S3Scanner Web Application"
```

## 🔐 Security Configuration

### 1. Repository Secrets
Add these secrets for GitHub Actions:

```bash
# Add Docker registry credentials
gh secret set DOCKER_USERNAME --body "your-docker-username"
gh secret set DOCKER_TOKEN --body "your-docker-token"

# Add deployment keys
gh secret set DEPLOY_KEY --body "$(cat ~/.ssh/deploy_key)"
```

### 2. Environment Protection
- Set up environment protection rules
- Require reviews for production deployments
- Add deployment secrets

## 📈 Monitoring & Analytics

### Repository Insights
- **Traffic**: Monitor repository visits and clones
- **Community**: Track issues, PRs, and discussions
- **Security**: Vulnerability alerts and dependency updates

### GitHub Packages
- Docker images automatically published
- Version tagging and semantic releases
- Multi-architecture support

## 🎯 Next Steps

1. **Clone your repository elsewhere:**
   ```bash
   git clone https://github.com/your-username/s3scanner-web.git
   cd s3scanner-web
   chmod +x start.sh && ./start.sh
   ```

2. **Invite collaborators:**
   ```bash
   gh repo edit --add-collaborator username1,username2
   ```

3. **Set up webhooks:**
   ```bash
   gh api repos/your-username/s3scanner-web/hooks --method POST \
     --field name=web \
     --field config.url=https://your-webhook.com/github \
     --field events='["push","pull_request"]'
   ```

## 🆘 Troubleshooting

### Common Issues

**Authentication Failed:**
```bash
gh auth logout
gh auth login
```

**Permission Denied:**
```bash
# Check SSH key
ssh -T git@github.com

# Or use HTTPS
git remote set-url origin https://github.com/your-username/s3scanner-web.git
```

**Large Files:**
```bash
# Use Git LFS for large files
git lfs track "*.zip"
git lfs track "*.tar.gz"
git add .gitattributes
```

## 📞 Support

- **GitHub CLI Documentation**: https://cli.github.com/manual/
- **Git Documentation**: https://git-scm.com/doc
- **GitHub Actions**: https://docs.github.com/en/actions

---

<p align="center">
<strong>🎉 Your S3Scanner Web Application is now ready for GitHub! 🎉</strong>
</p>