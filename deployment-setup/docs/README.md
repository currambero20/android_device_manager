# 📱 Android Device Manager - Deployment Documentation

This directory contains all documentation for deploying the Android Device Manager to various platforms.

## 📁 Documentation Structure

```
docs/
├── README.md                 # This file
├── github-deployment.md     # GitHub deployment guide
├── vercel-deployment.md     # Vercel deployment guide
├── local-development.md     # Local development setup
├── environment-variables.md # Environment variables reference
├── troubleshooting.md       # Common issues and solutions
└── security.md             # Security best practices
```

## 🚀 Quick Start

Choose your deployment method:

### For Local Development
```bash
cd deployment-setup/local
./setup-local.sh
```

### For GitHub Deployment
```bash
cd deployment-setup/github
./setup-github.sh
```

### For Vercel Deployment
```bash
cd deployment-setup/vercel
./setup-vercel.sh
```

## 📋 Prerequisites

- Node.js 18+
- Git
- npm/yarn/pnpm
- PostgreSQL (for production)
- Vercel account (for Vercel deployment)

## 🔧 Environment Variables

See `environment-variables.md` for a complete reference of all required environment variables.

## 🐛 Troubleshooting

If you encounter issues, check `troubleshooting.md` for common solutions.

## 🔐 Security

Review `security.md` for security best practices and recommendations.
