# 🐛 Troubleshooting Guide

This guide covers common issues and their solutions when deploying the Android Device Manager.

## 🚀 GitHub Deployment Issues

### Build Failures
**Problem**: GitHub Actions build fails
**Solutions**:
1. Check build logs in GitHub Actions tab
2. Verify all dependencies are in package.json
3. Ensure build command is correct
4. Check for TypeScript errors

**Command to test locally**:
```bash
pnpm run build
```

### Environment Variables Not Set
**Problem**: Application fails due to missing environment variables
**Solutions**:
1. Go to repository Settings > Secrets and variables > Actions
2. Add required secrets (see environment-variables.md)
3. Ensure variable names match exactly

### Database Connection Issues
**Problem**: Cannot connect to database
**Solutions**:
1. Verify DATABASE_URL format
2. Check database server is running
3. Ensure database exists and user has permissions
4. Test connection with database client

## 🌐 Vercel Deployment Issues

### Build Timeout
**Problem**: Build takes too long and times out
**Solutions**:
1. Optimize build process
2. Split build into multiple steps
3. Use Vercel's Build Cache
4. Check for memory-intensive operations

### Environment Variables Missing
**Problem**: Environment variables not available in Vercel
**Solutions**:
1. Go to Vercel project settings > Environment Variables
2. Add all required variables
3. Ensure variable names match exactly
4. Redeploy after adding variables

### Routing Issues
**Problem**: 404 errors on client-side routes
**Solutions**:
1. Check vercel.json routing configuration
2. Ensure catch-all route is configured: `"/(.*)" -> "/index.html"`
3. Verify SPA routing setup

### API Route Timeouts
**Problem**: API routes timeout during execution
**Solutions**:
1. Increase function timeout in vercel.json
2. Optimize database queries
3. Use connection pooling
4. Implement proper error handling

## 🏠 Local Development Issues

### Port Already in Use
**Problem**: Development server fails to start
**Solutions**:
1. Kill processes using the port: `lsof -ti:5173 | xargs kill`
2. Use different ports: `npm run dev -- --port 3001`
3. Check for running instances

### Dependencies Installation Fails
**Problem**: npm/yarn/pnpm install fails
**Solutions**:
1. Clear cache: `npm cache clean --force`
2. Delete node_modules and reinstall
3. Check Node.js version compatibility
4. Use different package manager

### Database Connection Fails
**Problem**: Cannot connect to local database
**Solutions**:
1. Start PostgreSQL service
2. Verify database exists
3. Check connection string format
4. Ensure user has proper permissions

## 🔧 General Issues

### TypeScript Errors
**Problem**: TypeScript compilation fails
**Solutions**:
1. Check all type imports
2. Verify type definitions
3. Update dependencies
4. Use type checking: `npm run type-check`

### WebSocket Connection Issues
**Problem**: Real-time features don't work
**Solutions**:
1. Check WebSocket URL configuration
2. Verify firewall settings
3. Test WebSocket connection manually
4. Check for CORS issues

### CORS Issues
**Problem**: Cross-origin requests blocked
**Solutions**:
1. Check CORS configuration in backend
2. Verify origin URLs match exactly
3. Add proper headers
4. Test with browser developer tools

## 📊 Performance Issues

### Slow Build Times
**Solutions**:
1. Use build cache
2. Optimize bundle size
3. Remove unused dependencies
4. Use code splitting

### Slow Database Queries
**Solutions**:
1. Add database indexes
2. Optimize query structure
3. Use connection pooling
4. Implement query caching

## 🔍 Debug Commands

### Check Application Status
```bash
# Check if server is running
curl http://localhost:3000/api/health

# Check if frontend is running
curl http://localhost:5173

# Check WebSocket connection
wscat -c ws://localhost:3001
```

### View Logs
```bash
# GitHub Actions logs
# Check in repository Actions tab

# Vercel logs
vercel logs

# Local development logs
# Check terminal where dev server is running
```

### Database Debug
```bash
# Test database connection
psql $DATABASE_URL

# Check database schema
pnpm run db:generate
```

## 📞 Getting Help

If you're still having issues:

1. Check the GitHub repository issues
2. Review the documentation
3. Check platform-specific logs
4. Contact support with detailed error messages

Remember to include:
- Error messages
- Steps to reproduce
- Environment details
- Log files
