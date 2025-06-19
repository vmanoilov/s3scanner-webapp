#!/bin/sh

# S3Scanner GitHub Sync Script (assumes repo already exists)
# Initializes git, commits files, and force-pushes to GitHub ONCE

set -e

# Colors
if [ -t 1 ]; then
    RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
else
    RED=''; GREEN=''; YELLOW=''; BLUE=''; NC=''
fi

print_status()  { printf "${BLUE}[INFO]${NC} %s\n" "$1"; }
print_success() { printf "${GREEN}[SUCCESS]${NC} %s\n" "$1"; }
print_warning() { printf "${YELLOW}[WARNING]${NC} %s\n" "$1"; }
print_error()   { printf "${RED}[ERROR]${NC} %s\n" "$1"; }

GITHUB_USERNAME="vmanoilov"
REPO_NAME="s3scanner-webapp"
REPO_URL="https://github.com/vmanoilov/s3scanner-webapp"

# Check git
if ! command -v git >/dev/null 2>&1; then
    print_error "Git is not installed. Exiting."
    exit 1
fi

# Docker/container safe config
if [ -f "/.dockerenv" ] || [ "$BOLT_ENV" = "true" ]; then
    print_warning "Container detected, applying safe git settings"
    git config --global --add safe.directory /home/project 2>/dev/null || true
    git config --global init.defaultBranch main 2>/dev/null || true
    [ -z "$(git config --global user.name)" ] && git config --global user.name "vmanoilov"
    [ -z "$(git config --global user.email)" ] && git config --global user.email "vmanoilov@users.noreply.github.com"
fi

# Init repo
print_status "Checking repo..."
if [ ! -d ".git" ]; then
    git init
    print_success "Initialized new git repo"
else
    print_status "Git repo already initialized"
fi

# Create .gitignore if needed
if [ ! -f ".gitignore" ]; then
    print_status "Creating .gitignore..."
    cat > .gitignore << 'EOF'
node_modules/
build/
dist/
.env*
.vscode/
.idea/
*.log
__pycache__/
*.db
*.pem
*.key
tmp/
EOF
    print_success ".gitignore created"
fi

# Stage and commit
print_status "Staging files..."
git add .

if git diff --staged --quiet; then
    print_warning "No changes to commit"
else
    git commit -m "Initial commit: S3Scanner WebApp setup"
    print_success "Committed changes"
fi

# Add remote if missing
if ! git remote | grep -q origin; then
    git remote add origin "$REPO_URL.git"
    print_status "Added origin: $REPO_URL"
fi

# One-time force push
print_warning "About to FORCE PUSH. This will overwrite GitHub with your local version."
printf "${YELLOW}Continue? (y/N): ${NC}"
read confirm
if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
    git branch -M main
    git push --force origin main
    print_success "Force push complete"
else
    print_status "Push cancelled"
fi

print_status "Done. Repo: $REPO_URL"

