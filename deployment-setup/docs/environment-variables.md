# 🔧 Environment Variables Reference

This document provides a complete reference of all environment variables used in the Android Device Manager.

## 📋 Required Variables

### Database Configuration
```env
DATABASE_URL="postgresql://user:password@localhost:5432/device_manager"
DIRECT_URL="postgresql://user:password@localhost:5432/device_manager"
```

### Authentication
```env
JWT_SECRET="your-super-secret-jwt-key-minimum-32-characters"
NEXTAUTH_SECRET="your-nextauth-secret-minimum-32-characters"
NEXTAUTH_URL="http://localhost:3000"
```

### API Keys
```env
OPENAI_API_KEY="sk-your-openai-api-key"
GOOGLE_MAPS_API_KEY="your-google-maps-api-key"
```

### Client Configuration
```env
VITE_APP_URL="http://localhost:5173"
VITE_API_URL="http://localhost:3000"
VITE_WEBSOCKET_URL="ws://localhost:3001"
```

## 🔐 Security Best Practices

1. **Use strong secrets**: Minimum 32 characters for JWT and NextAuth secrets
2. **Rotate secrets regularly**: Update API keys and secrets periodically
3. **Never commit secrets**: Use `.env` files and platform-specific secret management
4. **Use different secrets per environment**: Development, staging, and production

## 🌍 Environment-Specific Configuration

### Development
- Use localhost URLs
- Enable debug logging
- Use development database

### Production
- Use production URLs with HTTPS
- Disable debug logging
- Use production database with connection pooling
- Enable security headers
- Configure proper CORS origins

## 🔍 Variable Validation

The application validates environment variables at startup. Missing or invalid variables will cause the application to fail to start with clear error messages.

## 📝 Notes

- All VITE_ prefixed variables are exposed to the client-side code
- Database URLs should use connection pooling for production
- WebSocket URLs should use WSS in production (secure WebSocket)
