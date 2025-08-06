# Docker-First Development Setup

## Overview
The FlexLink Configurator now uses a Docker-first development approach with automatic fallback to local setup if Docker is unavailable.

## 🚀 **Quick Start**

### **Default Command (Recommended)**
```bash
./start.sh
```
This will:
1. **Check if Docker is available and running**
2. **Start Docker automatically** if installed but not running
3. **Use Docker environment** if available
4. **Fall back to local setup** if Docker fails or is unavailable

### **Docker Development Environment**
```bash
./start_dev.sh
```
- **PostgreSQL** database on port 5432
- **Redis** cache on port 6379
- **Rails** web server on port 3000
- **Guard** auto-reload on port 35729

### **Local Development (No Docker)**
```bash
./start_local.sh
```
- **SQLite** database (no PostgreSQL required)
- **Rails** web server on port 3000
- **Simpler setup** for development

## 🔧 **What Each Environment Provides**

### **Docker Environment** (`./start.sh` or `./start_dev.sh`)
- ✅ **Full production-like setup**
- ✅ **PostgreSQL database** with all features
- ✅ **Redis caching** for performance
- ✅ **Auto-reload** with Guard
- ✅ **Consistent environment** across team
- ✅ **Easy deployment** testing

### **Local Environment** (`./start_local.sh`)
- ✅ **No Docker required**
- ✅ **SQLite database** (simpler)
- ✅ **Faster startup**
- ✅ **Good for development**
- ❌ **Limited features** (no Redis, PostgreSQL)

## 📋 **Environment Detection Logic**

The `./start.sh` script automatically:

1. **Checks if Docker is installed**
2. **Checks if Docker daemon is running**
3. **Starts Docker** if needed
4. **Waits for Docker** to be ready
5. **Falls back** to local setup if Docker fails

## 🐳 **Docker Services**

When using Docker, you get:

### **PostgreSQL Database**
- **Port**: 5432
- **Database**: `flexlink_config`
- **User**: `flexlink_user`
- **Password**: `flexlink_password`

### **Redis Cache**
- **Port**: 6379
- **Purpose**: Session storage and caching
- **Persistence**: Data saved to volume

### **Rails Web Server**
- **Port**: 3000
- **Environment**: Development
- **Auto-reload**: Enabled
- **Asset compilation**: Automatic

### **Guard Auto-Reload**
- **Port**: 35729
- **Purpose**: Live browser reload
- **Watches**: All application files

## 🔄 **Development Workflow**

### **Starting Development**
```bash
# Always use this (Docker-first with fallback)
./start.sh

# Or explicitly choose environment
./start_dev.sh    # Docker only
./start_local.sh  # Local only
```

### **Stopping Services**
```bash
# Stop Docker containers
docker-compose down

# Or stop all services
Ctrl+C in the terminal
```

### **Viewing Logs**
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f web
docker-compose logs -f postgres
docker-compose logs -f redis
```

## 🛠️ **Troubleshooting**

### **Docker Not Starting**
```bash
# Check Docker status
docker info

# Start Docker manually
open -a Docker

# Wait for Docker to be ready
sleep 15
```

### **Port Conflicts**
```bash
# Check what's using ports
lsof -i :3000
lsof -i :5432
lsof -i :6379

# Stop conflicting services
docker-compose down
```

### **Database Issues**
```bash
# Reset Docker database
docker-compose down -v
docker-compose up --build

# Reset local database
./reset_db.sh
```

## 📊 **Performance Comparison**

| Feature                | Docker      | Local       |
| ---------------------- | ----------- | ----------- |
| **Startup Time**       | ~30 seconds | ~10 seconds |
| **Database**           | PostgreSQL  | SQLite      |
| **Caching**            | Redis       | None        |
| **Auto-reload**        | ✅           | ✅           |
| **Consistency**        | ✅           | ❌           |
| **Deployment Testing** | ✅           | ❌           |

## 🎯 **Recommendations**

### **Use Docker When:**
- **Team development** (consistent environment)
- **Testing deployment** scenarios
- **Using all features** (Redis, PostgreSQL)
- **Production-like** development

### **Use Local When:**
- **Quick development** (faster startup)
- **Docker issues** (troubleshooting)
- **Simple changes** (no caching needed)
- **Offline development**

## 🔄 **Migration from Local to Docker**

If you've been using local setup and want to switch to Docker:

1. **Stop local server** (Ctrl+C)
2. **Run Docker setup**: `./start.sh`
3. **Wait for containers** to start
4. **Access at**: http://localhost:3000

## 📚 **Additional Resources**

- **Docker Compose**: `docker-compose.dev.yml`
- **Local Setup**: `start_local.sh`
- **Database Reset**: `reset_db.sh`
- **Environment Variables**: `.env` file

---

**Last Updated**: December 2024  
**Status**: ✅ Docker-first setup configured 