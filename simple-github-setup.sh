#!/bin/sh

# Simple GitHub Setup Script for S3Scanner WebApp
# Minimal version for restricted environments

set -e

echo "=== Simple GitHub Setup for S3Scanner WebApp ==="
echo ""

# Pre-configured repository settings
GITHUB_USERNAME="vmanoilov"
REPO_NAME="s3scanner-webapp"
REPO_URL="https://github.com/vmanoilov/s3scanner-webapp"

# Basic git setup
echo "Setting up git repository..."

if [ ! -d ".git" ]; then
    git init
    echo "✓ Git repository initialized"
else
    echo "✓ Git repository already exists"
fi

# Set basic git config if not set
if [ -z "$(git config user.name 2>/dev/null)" ]; then
    git config user.name "vmanoilov"
    echo "✓ Git username set to vmanoilov"
fi

if [ -z "$(git config user.email 2>/dev/null)" ]; then
    git config user.email "vmanoilov@users.noreply.github.com"
    echo "✓ Git email set"
fi

# Create basic .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    cat > .gitignore << 'EOF'
# Build outputs
build/
dist/
*.exe
*.dll
*.so
*.dylib

# Environment files
.env
*.env

# Logs
*.log
logs/

# IDE
.vscode/
.idea/

# OS files
.DS_Store
Thumbs.db

# Dependencies
node_modules/
vendor/

# Temporary files
tmp/
temp/
EOF
    echo "✓ .gitignore created"
fi

# Stage and commit files
echo "Staging files..."
git add .

if ! git diff --staged --quiet; then
    echo "Committing files..."
    git commit -m "Initial commit: S3Scanner WebApp

Repository: $REPO_URL"
    echo "✓ Files committed"
else
    echo "✓ No changes to commit"
fi

# Create manual instructions
cat > GITHUB-SETUP-INSTRUCTIONS.md << EOF
# GitHub Setup Instructions for S3Scanner WebApp

## Repository Information
- **Repository URL**: $REPO_URL
- **Repository Name**: $REPO_NAME
- **GitHub Username**: $GITHUB_USERNAME

## Method 1: Using GitHub CLI (Recommended)

1. **Install GitHub CLI** (on your local machine):
   \`\`\`bash
   # Ubuntu/Debian
   curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
   echo "deb [arch=\$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
   sudo apt update && sudo apt install gh
   
   # macOS
   brew install gh
   
   # Windows
   winget install GitHub.cli
   \`\`\`

2. **Authenticate with GitHub**:
   \`\`\`bash
   gh auth login
   \`\`\`

3. **Create repository and push**:
   \`\`\`bash
   gh repo create $GITHUB_USERNAME/$REPO_NAME --public --source=. --remote=origin --push
   \`\`\`

## Method 2: Manual GitHub Setup

1. **Go to GitHub.com** and create a new repository named \`$REPO_NAME\`

2. **Add remote and push**:
   \`\`\`bash
   git remote add origin $REPO_URL.git
   git branch -M main
   git push -u origin main
   \`\`\`

## Method 3: Upload Zip File

1. Create a zip file of your project (excluding .git folder)
2. Go to GitHub.com and create a new repository named \`$REPO_NAME\`
3. Upload the zip file using GitHub's web interface

## After Setup

Your repository will be available at:
\`$REPO_URL\`

You can then clone it anywhere:
\`\`\`bash
git clone $REPO_URL.git
\`\`\`

## Project Description
S3Scanner Web Application - Advanced S3 bucket scanner with web interface, supporting multiple cloud providers and featuring Docker containerization.
EOF

echo ""
echo "✓ Git repository is ready!"
echo "✓ Created GITHUB-SETUP-INSTRUCTIONS.md with detailed steps"
echo ""
echo "Target Repository: $REPO_URL"
echo "Next: Follow the instructions in GITHUB-SETUP-INSTRUCTIONS.md"
echo "      to complete the GitHub setup."