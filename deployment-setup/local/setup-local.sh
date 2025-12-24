#!/bin/bash

# 🏠 Android Device Manager - Local Development Setup

echo "🏠 Setting up local development environment..."

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check Node.js version
NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    print_warning "Node.js 18+ recommended. Current version: $(node --version)"
fi

# Install package manager
if ! command -v pnpm &> /dev/null; then
    print_status "Installing pnpm..."
    npm install -g pnpm
fi

if ! command -v yarn &> /dev/null; then
    print_status "Installing Yarn..."
    npm install -g yarn
fi

# Install dependencies
print_status "Installing project dependencies..."
if command -v pnpm &> /dev/null; then
    pnpm install
elif command -v yarn &> /dev/null; then
    yarn install
else
    npm install
fi

# Create environment file
if [ ! -f ".env" ]; then
    print_status "Creating .env file..."
    cp .env.example .env
    
    # Generate random secrets
    JWT_SECRET=$(openssl rand -base64 32)
    NEXTAUTH_SECRET=$(openssl rand -base64 32)
    
    # Update .env with generated secrets
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/your_jwt_secret_here/$JWT_SECRET/" .env
        sed -i '' "s/your_nextauth_secret_here/$NEXTAUTH_SECRET/" .env
    else
        # Linux
        sed -i "s/your_jwt_secret_here/$JWT_SECRET/" .env
        sed -i "s/your_nextauth_secret_here/$NEXTAUTH_SECRET/" .env
    fi
    
    print_warning "Please update the database URL and API keys in .env file"
fi

# Setup database (if using local PostgreSQL)
if command -v psql &> /dev/null; then
    print_status "Setting up local PostgreSQL database..."
    createdb android_device_manager 2>/dev/null || print_warning "Database might already exist"
fi

# Run database migrations
if [ -f "package.json" ]; then
    if grep -q "db:generate" package.json; then
        print_status "Generating database client..."
        if command -v pnpm &> /dev/null; then
            pnpm run db:generate
        elif command -v yarn &> /dev/null; then
            yarn db:generate
        else
            npm run db:generate
        fi
    fi
    
    if grep -q "db:push" package.json; then
        print_status "Pushing database schema..."
        if command -v pnpm &> /dev/null; then
            pnpm run db:push
        elif command -v yarn &> /dev/null; then
            yarn db:push
        else
            npm run db:push
        fi
    fi
fi

# Start development servers
print_status "Starting development servers..."
print_status "Frontend will be available at http://localhost:5173"
print_status "Backend API will be available at http://localhost:3000"

if command -v pnpm &> /dev/null; then
    pnpm run dev
elif command -v yarn &> /dev/null; then
    yarn dev
else
    npm run dev
fi
