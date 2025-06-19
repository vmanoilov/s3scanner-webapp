#!/bin/sh

# S3Scanner GitHub Sync Script (assumes repo already exists)
# Initializes git, commits files, and pushes to existing remote

set -e

# Colors (only if terminal)
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
else
    RED='' GREEN='' YELLOW='' BLUE='' NC=''
fi

print_status()  { printf "${BLUE}[INFO]${NC} %s\n" "$1"; }
print_success() { printf "${GREEN}[SUCCESS]${NC} %s\n" "$1"; }
print_warning() { printf "${YELLOW}[WARNING]${NC} %s\n" "$1"; }
print_error()   { printf "${RED}[ERROR]${NC} %s\n" "$1"; }

GITHUB_USERNAME="vmanoilov"
REPO_NAME="s3scanner-webapp"
REPO_URL="https://github.com/vmanoilov/s3scanner-webapp"

# Check git installed
if ! command -v git >/dev/null 2>&1; then
    print_error "Git is not installed. Please install it first."
    exit 1
fi

# Container env fallback config
if [ -f "/.dockerenv" ] || [ "$BOLT_ENV" = "true" ]; then
    print_warning "Container environment detected"
    git config --global --add safe.directory /home/project 2>/dev/null || true
    git config --global init.defaultBranch main 2>/dev/null || true
    [ -z "$(git config --global user.name)" ] && git config --global user.name "vmanoilov"
    [ -z "$(git config --global user.email)" ] && git config --global user.email "vmanoilov@users.noreply.github.com"
fi

# Initialize git
print_status "Initializing git repository..."
if [ ! -d ".git" ]; then
    git init
    print_success "Git repo initialized"
else
    print_status "Git repo already exists"
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
    print_status "Committing changes..."
    git commit -m "Initial commit: S3Scanner WebApp setup"
    print_success "Commit successful"
fi

# Add remote if missing
if ! git remote | grep -q origin; then
    print_status "Adding remote 'origin'..."
    git remote add origin "$REPO_URL.git"
    print_success "Remote added: $REPO_URL"
fi

# Push to GitHub
print_status "Pushing to GitHub..."
git branch -M main
git push -u origin main

print_success "Push complete!"
print_status "Repository URL: $REPO_URL"

