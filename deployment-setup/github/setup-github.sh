#!/bin/bash

# 🚀 Android Device Manager - GitHub Deployment Script
# This script prepares and deploys your Android Device Manager to GitHub

set -e

echo "🚀 Starting GitHub deployment for Android Device Manager..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_error "Not a git repository. Please run this script from the project root."
    exit 1
fi

# Project configuration
PROJECT_NAME="android-device-manager"
REPO_URL="https://github.com/$(whoami)/${PROJECT_NAME}.git"

print_status "Project name: ${PROJECT_NAME}"
print_status "Repository URL: ${REPO_URL}"

# 1. Install dependencies
print_status "Installing project dependencies..."
if command -v pnpm &> /dev/null; then
    pnpm install
elif command -v yarn &> /dev/null; then
    yarn install
else
    npm install
fi

# 2. Check environment configuration
print_status "Checking environment configuration..."
if [ ! -f ".env.example" ]; then
    print_warning "Creating .env.example file..."
    cat > .env.example << 'EOF'
# Database Configuration
DATABASE_URL="your_database_connection_string"
DIRECT_URL="your_direct_database_url"

# Authentication
JWT_SECRET="your_jwt_secret_here"
NEXTAUTH_SECRET="your_nextauth_secret_here"
NEXTAUTH_URL="http://localhost:3000"

# API Keys
OPENAI_API_KEY="your_openai_api_key"
GOOGLE_MAPS_API_KEY="your_google_maps_api_key"

# WebSocket Configuration
WEBSOCKET_PORT=3001

# Client Configuration
VITE_APP_URL="http://localhost:5173"
VITE_API_URL="http://localhost:3000"
VITE_WEBSOCKET_URL="ws://localhost:3001"
EOF
fi

# 3. Setup GitHub Actions workflow
print_status "Setting up GitHub Actions workflow..."
mkdir -p .github/workflows

cat > .github/workflows/deploy.yml << 'EOF'
name: 🚀 Deploy to Production

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

env:
  PNPM_VERSION: '8.15.0'
  NODE_VERSION: '18'

jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    
    steps:
    - name: 📋 Checkout code
      uses: actions/checkout@v4

    - name: 🔧 Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: ${{ env.NODE_VERSION }}

    - name: 📦 Setup pnpm
      uses: pnpm/action-setup@v2
      with:
        version: ${{ env.PNPM_VERSION }}

    - name: 📋 Get pnpm store directory
      shell: bash
      run: |
        echo "STORE_PATH=$(pnpm store path --silent)" >> $GITHUB_ENV

    - name: 📋 Setup pnpm cache
      uses: actions/cache@v3
      with:
        path: ${{ env.STORE_PATH }}
        key: ${{ runner.os }}-pnpm-store-${{ hashFiles('**/pnpm-lock.yaml') }}
        restore-keys: |
          ${{ runner.os }}-pnpm-store-

    - name: 📥 Install dependencies
      run: pnpm install --frozen-lockfile

    - name: 🔍 Lint code
      run: pnpm run lint

    - name: 🧪 Run tests
      run: pnpm run test

  build-and-deploy:
    needs: lint-and-test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'

    steps:
    - name: 📋 Checkout code
      uses: actions/checkout@v4

    - name: 🔧 Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: ${{ env.NODE_VERSION }}

    - name: 📦 Setup pnpm
      uses: pnpm/action-setup@v2
      with:
        version: ${{ env.PNPM_VERSION }}

    - name: 📥 Install dependencies
      run: pnpm install --frozen-lockfile

    - name: 🔨 Build application
      run: pnpm run build
      env:
        VITE_API_URL: ${{ secrets.VITE_API_URL }}
        VITE_WEBSOCKET_URL: ${{ secrets.VITE_WEBSOCKET_URL }}
        VITE_APP_URL: ${{ secrets.VITE_APP_URL }}

    - name: 🚀 Deploy to Vercel
      uses: amondnet/vercel-action@v25
      with:
        vercel-token: ${{ secrets.VERCEL_TOKEN }}
        vercel-org-id: ${{ secrets.ORG_ID}}
        vercel-project-id: ${{ secrets.PROJECT_ID}}
        vercel-args: '--prod'
EOF

# 4. Create Docker configuration for GitHub Container Registry
print_status "Setting up Docker configuration..."
cat > Dockerfile << 'EOF'
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package.json pnpm-lock.yaml ./
RUN corepack enable && corepack prepare pnpm@latest --activate
RUN pnpm install --frozen-lockfile

# Copy source code
COPY . .

# Build application
RUN pnpm run build

# Production stage
FROM nginx:alpine

# Copy built application
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
EOF

cat > nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    
    server {
        listen 80;
        server_name localhost;
        
        location / {
            root /usr/share/nginx/html;
            try_files $uri $uri/ /index.html;
        }
        
        # API proxy
        location /api/ {
            proxy_pass http://backend:3000/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
        
        # WebSocket proxy
        location /ws/ {
            proxy_pass http://backend:3001/;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
EOF

# 5. Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  frontend:
    build: .
    ports:
      - "80:80"
    depends_on:
      - backend
    environment:
      - VITE_API_URL=http://localhost:3000
      - VITE_WEBSOCKET_URL=ws://localhost:3001

  backend:
    image: node:18-alpine
    working_dir: /app
    volumes:
      - .:/app
    command: sh -c "npm install && npm run dev"
    ports:
      - "3000:3000"
      - "3001:3001"
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://user:password@postgres:5432/device_manager

  postgres:
    image: postgres:15-alpine
    environment:
      - POSTGRES_DB=device_manager
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  postgres_data:
EOF

# 6. Update README with deployment instructions
print_status "Creating enhanced README..."
cat > README.md << 'EOF'
# 📱 Android Device Manager

A comprehensive web-based solution for managing and monitoring Android devices remotely.

## ✨ Features

- 📊 **Real-time Dashboard** - Monitor device status and metrics
- 🗺️ **Device Mapping** - Geographic visualization of device locations
- 🔒 **Permission Management** - Granular control over device permissions
- 📱 **App Management** - Install, uninstall, and manage applications
- 🔍 **Advanced Monitoring** - System metrics and performance tracking
- 🌐 **Geofencing** - Location-based device control
- 🎮 **Remote Control** - Full device control capabilities
- 🔐 **Two-Factor Authentication** - Enhanced security
- 📋 **Audit Logs** - Complete activity tracking
- 🚨 **Real-time Notifications** - Instant alerts and updates

## 🚀 Quick Start

### Prerequisites

- Node.js 18+
- pnpm (recommended) or npm/yarn
- PostgreSQL database

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/android-device-manager.git
   cd android-device-manager
   ```

2. **Install dependencies**
   ```bash
   pnpm install
   ```

3. **Environment setup**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Database setup**
   ```bash
   pnpm run db:push
   pnpm run db:generate
   ```

5. **Start development server**
   ```bash
   pnpm run dev
   ```

## 🐳 Docker Deployment

```bash
docker-compose up -d
```

## ☁️ Cloud Deployment

### Vercel (Recommended for frontend)

1. Connect your GitHub repository to Vercel
2. Set environment variables in Vercel dashboard
3. Deploy automatically on push to main branch

### GitHub Actions

The project includes automatic deployment via GitHub Actions:
- Linting and testing on every PR
- Automatic deployment to production on main branch

## 📁 Project Structure

```
├── client/           # React frontend (Vite + TypeScript)
├── server/           # Node.js backend (TRPC + TypeScript)
├── shared/           # Shared types and utilities
├── drizzle/          # Database schema and migrations
├── .github/          # GitHub Actions workflows
├── docker/           # Docker configuration
└── docs/             # Documentation
```

## 🛠️ Tech Stack

### Frontend
- **React 18** with TypeScript
- **Vite** for fast development and building
- **Shadcn/ui** for beautiful components
- **TRPC** for type-safe API communication
- **WebSockets** for real-time updates

### Backend
- **Node.js** with TypeScript
- **TRPC** for type-safe APIs
- **Drizzle ORM** for database management
- **WebSocket** for real-time communication
- **JWT** for authentication

### Database
- **PostgreSQL** with Drizzle ORM
- **Real-time subscriptions**
- **Optimized queries and indexes**

## 🔧 Configuration

### Environment Variables

Create a `.env` file with the following variables:

```env
# Database
DATABASE_URL="postgresql://user:password@localhost:5432/device_manager"

# Authentication
JWT_SECRET="your-super-secret-jwt-key"
NEXTAUTH_SECRET="your-nextauth-secret"

# API Keys
OPENAI_API_KEY="your-openai-api-key"
GOOGLE_MAPS_API_KEY="your-google-maps-api-key"

# URLs
VITE_API_URL="http://localhost:3000"
VITE_WEBSOCKET_URL="ws://localhost:3001"
VITE_APP_URL="http://localhost:5173"
```

## 📚 Available Scripts

- `pnpm run dev` - Start development server
- `pnpm run build` - Build for production
- `pnpm run lint` - Lint code
- `pnpm run test` - Run tests
- `pnpm run db:push` - Push database schema
- `pnpm run db:generate` - Generate database client
- `pnpm run db:migrate` - Run migrations

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Shadcn/ui](https://ui.shadcn.com/) for the beautiful UI components
- [TRPC](https://trpc.io/) for type-safe APIs
- [Drizzle](https://orm.drizzle.team/) for the amazing ORM
- [Vite](https://vitejs.dev/) for the blazing fast development experience
EOF

# 7. Create GitHub issue templates
print_status "Setting up GitHub issue templates..."
mkdir -p .github/ISSUE_TEMPLATE

cat > .github/ISSUE_TEMPLATE/bug_report.yml << 'EOF'
name: 🐛 Bug Report
description: Report a bug in the Android Device Manager
title: "[BUG] "
labels: ["bug", "needs-triage"]
assignees: []

body:
  - type: markdown
    attributes:
      value: |
        Thanks for taking the time to fill out this bug report!

  - type: input
    id: what-happened
    attributes:
      label: What happened?
      description: Also tell us, what did you expect to happen?
      placeholder: Tell us what you see!
    validations:
      required: true

  - type: dropdown
    id: browsers
    attributes:
      label: What browsers are you seeing the problem on?
      multiple: true
      options:
        - Firefox
        - Chrome
        - Safari
        - Microsoft Edge

  - type: textarea
    id: logs
    attributes:
      label: Relevant log output
      description: Please copy and paste any relevant log output. This will be automatically formatted into code, so no need for backticks.
      render: shell
EOF

cat > .github/ISSUE_TEMPLATE/feature_request.yml << 'EOF'
name: 💡 Feature Request
description: Suggest a new feature for the Android Device Manager
title: "[FEATURE] "
labels: ["enhancement", "needs-triage"]
assignees: []

body:
  - type: markdown
    attributes:
      value: |
        Thanks for suggesting a new feature!

  - type: textarea
    id: feature-description
    attributes:
      label: Feature Description
      description: Describe the feature you'd like to see implemented.
      placeholder: What would you like this feature to do?
    validations:
      required: true

  - type: textarea
    id: use-case
    attributes:
      label: Use Case
      description: Describe a use case where this feature would be helpful.
      placeholder: Explain why this feature would be useful.
    validations:
      required: true

  - type: dropdown
    id: priority
    attributes:
      label: Priority
      description: How important is this feature to you?
      options:
        - Low
        - Medium
        - High
        - Critical
    validations:
      required: true
EOF

# 8. Setup git hooks
print_status "Setting up git hooks..."
mkdir -p .git/hooks

cat > .git/hooks/pre-commit << 'EOF'
#!/bin/sh
# Pre-commit hook for Android Device Manager

echo "🔍 Running pre-commit checks..."

# Run linting
pnpm run lint

# Run type checking
pnpm run type-check

# Run tests
pnpm run test

echo "✅ Pre-commit checks passed!"
EOF

chmod +x .git/hooks/pre-commit

# 9. Final setup
print_status "Finalizing GitHub setup..."

# Create .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/
.pnpm-debug.log*
.yarn-integrity

# Environment variables
.env
.env.local
.env.production

# Build outputs
dist/
build/
.vite/

# Database
*.db
*.sqlite

# IDE files
.vscode/
.idea/
*.swp
*.swo

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/
*.lcov

# nyc test coverage
.nyc_output

# Dependency directories
node_modules/
jspm_packages/

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Microbundle cache
.rpt2_cache/
.rts2_cache_cjs/
.rts2_cache_es/
.rts2_cache_umd/

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# dotenv environment variables file
.env
.env.test
.env*.local

# parcel-bundler cache (https://parceljs.org/)
.cache
.parcel-cache

# Next.js build output
.next

# Nuxt.js build / generate output
.nuxt
dist

# Storybook build outputs
.out
.storybook-out

# Temporary folders
tmp/
temp/

# Editor directories and files
.vscode/*
!.vscode/extensions.json
.idea
.DS_Store
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?

# Database
*.db
*.sqlite

# Uploads
uploads/
static/uploads/
EOF
fi

# 10. Create deployment status file
cat > DEPLOYMENT_STATUS.md << 'EOF'
# 🚀 Deployment Status

## ✅ Completed Setup

- [x] GitHub Actions workflow configured
- [x] Docker configuration created
- [x] Environment variables template
- [x] Git hooks configured
- [x] Issue templates created
- [x] README with deployment instructions
- [x] GitIgnore configured

## 📋 Next Steps

1. **Push to GitHub**
   ```bash
   git add .
   git commit -m "Initial setup for GitHub deployment"
   git remote add origin https://github.com/yourusername/android-device-manager.git
   git push -u origin main
   ```

2. **Configure Repository Secrets in GitHub**
   - `VERCEL_TOKEN` - Your Vercel API token
   - `ORG_ID` - Your Vercel organization ID
   - `PROJECT_ID` - Your Vercel project ID
   - `VITE_API_URL` - Production API URL
   - `VITE_WEBSOCKET_URL` - Production WebSocket URL
   - `VITE_APP_URL` - Production app URL

3. **Connect to Vercel**
   - Import your GitHub repository to Vercel
   - Configure environment variables
   - Set up custom domain (optional)

## 🔧 Configuration Files Created

- `.github/workflows/deploy.yml` - GitHub Actions deployment workflow
- `Dockerfile` - Container configuration
- `nginx.conf` - Web server configuration
- `docker-compose.yml` - Multi-service deployment
- `.env.example` - Environment variables template
- `README.md` - Enhanced project documentation
- `.github/ISSUE_TEMPLATE/` - Issue reporting templates
- `.git/hooks/pre-commit` - Pre-commit validation
- `.gitignore` - Git ignore patterns
EOF

print_status "🎉 GitHub deployment setup completed!"
print_status "📋 Review the generated files and follow the next steps in DEPLOYMENT_STATUS.md"
print_status "🚀 Your project is now ready for GitHub deployment!"

# Make script executable
chmod +x deploy-github.sh