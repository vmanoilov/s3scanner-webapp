#!/bin/bash

# Manual GitHub Setup Script
# Run this on a system with GitHub CLI installed

echo "=== Manual GitHub Setup ==="
echo "Run these commands on a system with git and GitHub CLI:"
echo ""
echo "# 1. Install GitHub CLI (if needed)"
echo "curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg"
echo "echo \"deb [arch=\$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main\" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null"
echo "sudo apt update && sudo apt install gh"
echo ""
echo "# 2. Authenticate with GitHub"
echo "gh auth login"
echo ""
echo "# 3. Create repository"
read -p "Enter your GitHub username: " USERNAME
read -p "Enter repository name (default: s3scanner-web): " REPO_NAME
REPO_NAME=${REPO_NAME:-s3scanner-web}

echo "gh repo create $USERNAME/$REPO_NAME --public --description \"S3Scanner Web Application - Advanced S3 bucket scanner with web interface\""
echo ""
echo "# 4. Add remote and push"
echo "git remote add origin https://github.com/$USERNAME/$REPO_NAME.git"
echo "git branch -M main"
echo "git push -u origin main"

