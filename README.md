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
