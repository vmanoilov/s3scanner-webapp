#!/bin/sh

# S3Scanner GitHub Sync Script
# This script will initialize git, create a repo, and sync all files to GitHub
# Compatible with POSIX shell

set -e

# Colors for output (if supported)
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
fi

# Function to print colored output
print_status() {
    printf "${BLUE}[INFO]${NC} %s\n" "$1"
}

print_success() {
    printf "${GREEN}[SUCCESS]${NC} %s\n" "$1"
}

print_warning() {
    printf "${YELLOW}[WARNING]${NC} %s\n" "$1"
}

print_error() {
    printf "${RED}[ERROR]${NC} %s\n" "$1"
}

# Check if we're in the right environment
if ! command -v git >/dev/null 2>&1; then
    print_error "Git is not installed. Please install git first."
    exit 1
fi

# Try to detect if we're in a container or restricted environment
if [ -f "/.dockerenv" ] || [ "$BOLT_ENV" = "true" ]; then
    print_warning "Detected container/restricted environment"
    print_status "Setting up basic git configuration..."
    
    # Basic git setup for container environment
    git config --global --add safe.directory /home/project 2>/dev/null || true
    git config --global init.defaultBranch main 2>/dev/null || true
    
    if [ -z "$(git config --global user.name 2>/dev/null)" ]; then
        git config --global user.name "S3Scanner User"
    fi
    
    if [ -z "$(git config --global user.email 2>/dev/null)" ]; then
        git config --global user.email "user@s3scanner.local"
    fi
fi

# Check if gh CLI is available
if ! command -v gh >/dev/null 2>&1; then
    print_warning "GitHub CLI (gh) is not available in this environment."
    print_status "Creating manual setup instructions instead..."
    
    # Create manual setup script
    cat > manual-github-setup.sh << 'EOF'
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

EOF
    chmod +x manual-github-setup.sh
    
    print_status "Created manual-github-setup.sh for external setup"
fi

# Initialize git repository
print_status "Setting up git repository..."

if [ ! -d ".git" ]; then
    git init
    print_success "Git repository initialized"
else
    print_status "Git repository already exists"
fi

# Create comprehensive .gitignore
if [ ! -f ".gitignore" ]; then
    print_status "Creating .gitignore..."
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/
*/node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Build outputs
build/
dist/
*/build/
*/dist/

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
*.env

# IDE and editors
.vscode/
.idea/
*.swp
*.swo
*~

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Go specific
*.exe
*.exe~
*.dll
*.so
*.dylib
*.test
*.out
go.work

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
ENV/
env.bak/
venv.bak/

# Docker
.docker/

# Logs
*.log
logs/

# Database
*.db
*.sqlite
*.sqlite3

# SSL certificates
*.pem
*.key
*.crt

# Temporary files
tmp/
temp/
.tmp/

# Coverage reports
coverage/
*.cover
.coverage

# Test artifacts
.pytest_cache/
.tox/

# Backup files
*.backup
*.bak
*.orig
EOF
    print_success ".gitignore created"
fi

# Stage files
print_status "Staging files for commit..."
git add .

# Check if there are changes to commit
if git diff --staged --quiet; then
    print_warning "No changes to commit"
else
    # Commit files
    print_status "Committing files..."
    git commit -m "Initial commit: S3Scanner Web Application

Features:
- Go-based S3Scanner integration
- Docker containerization
- PostgreSQL database support
- RabbitMQ message queue
- Automated deployment scripts
- Multi-cloud provider support"

    print_success "Files committed successfully"
fi

# Try GitHub CLI operations if available
if command -v gh >/dev/null 2>&1; then
    print_status "GitHub CLI detected, proceeding with automated setup..."
    
    # Get user input
    printf "Enter your GitHub username: "
    read GITHUB_USERNAME
    printf "Enter repository name (default: s3scanner-web): "
    read REPO_NAME
    REPO_NAME=${REPO_NAME:-s3scanner-web}
    
    printf "Make repository private? (y/N): "
    read PRIVATE_REPO
    PRIVATE_FLAG=""
    if [ "$PRIVATE_REPO" = "y" ] || [ "$PRIVATE_REPO" = "Y" ]; then
        PRIVATE_FLAG="--private"
    fi
    
    # Authenticate with GitHub
    print_status "Checking GitHub authentication..."
    if ! gh auth status >/dev/null 2>&1; then
        print_status "Please authenticate with GitHub..."
        gh auth login
    fi
    
    # Create GitHub repository
    print_status "Creating GitHub repository..."
    if gh repo create "$GITHUB_USERNAME/$REPO_NAME" $PRIVATE_FLAG --description "S3Scanner Web Application - Advanced S3 bucket scanner" --source=. --remote=origin --push; then
        print_success "Repository created and code pushed successfully!"
        
        # Display success information
        echo ""
        echo "==================================="
        print_success "Repository Setup Complete!"
        echo "==================================="
        echo ""
        printf "Repository URL: https://github.com/%s/%s\n" "$GITHUB_USERNAME" "$REPO_NAME"
        printf "Clone URL: git clone https://github.com/%s/%s.git\n" "$GITHUB_USERNAME" "$REPO_NAME"
        echo ""
        echo "Next Steps:"
        echo "1. Visit your repository online"
        echo "2. Clone it elsewhere to work with it"
        echo "3. Set up development environment"
        echo ""
        
    else
        print_error "Failed to create repository"
        print_status "You can manually create the repository and add remote:"
        printf "git remote add origin https://github.com/%s/%s.git\n" "$GITHUB_USERNAME" "$REPO_NAME"
        echo "git branch -M main"
        echo "git push -u origin main"
    fi
else
    # Provide manual instructions
    echo ""
    echo "==================================="
    print_warning "Manual Setup Required"
    echo "==================================="
    echo ""
    print_status "Git repository has been initialized and files committed."
    print_status "To complete GitHub setup, run manual-github-setup.sh on a system with GitHub CLI."
    echo ""
    print_status "Or manually create repository on GitHub and run:"
    echo "git remote add origin https://github.com/YOUR_USERNAME/s3scanner-web.git"
    echo "git branch -M main"
    echo "git push -u origin main"
    echo ""
fi

print_success "Setup complete!"