#!/bin/bash

# 🚀 Android Device Manager - Script Maestro de Despliegue
# Este script permite configurar tu proyecto para diferentes plataformas de despliegue

# Configuración de bash
set -e  # Salir en caso de error (lo desactivaremos temporalmente para debugging)
set -u  # Salir si se usa una variable no definida (lo desactivaremos temporalmente)
set -o pipefail  # Salir si algún comando en un pipe falla

# Colores para la salida
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # Sin Color

# Función para imprimir mensajes de estado
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

# Función para imprimir advertencias
print_warning() {
    echo -e "${YELLOW}[ADVERTENCIA]${NC} $1"
}

# Función para imprimir errores
print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Función para imprimir encabezados
print_header() {
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================================${NC}"
}

# Función para imprimir pasos
print_step() {
    echo -e "${PURPLE}[PASO]${NC} $1"
}

# Función para pausar y continuar
pausar() {
    echo ""
    read -p "Presiona Enter para continuar..." dummy
    echo ""
}

# Función para verificar prerrequisitos
verificar_prerequisitos() {
    print_step "Verificando prerrequisitos del sistema..."
    
    local dependencias_faltantes=()
    
    # Verificar herramientas requeridas
    for cmd in git node npm; do
        if ! command -v $cmd &> /dev/null; then
            dependencias_faltantes+=($cmd)
        fi
    done
    
    if [ ${#dependencias_faltantes[@]} -gt 0 ]; then
        print_error "Faltan las siguientes dependencias: ${dependencias_faltantes[*]}"
        print_error "Por favor instala las dependencias faltantes y ejecuta este script nuevamente."
        return 1
    fi
    
    print_status "✅ Todos los prerrequisitos están satisfechos"
    return 0
}

# Función para mostrar el menú principal
mostrar_menu() {
    echo ""
    echo -e "${CYAN}🚀 ANDROID DEVICE MANAGER - SISTEMA DE DESPLIEGUE${NC}"
    echo -e "${CYAN}=================================================${NC}"
    echo ""
    echo "Elige tu opción de configuración:"
    echo ""
    echo -e "${GREEN}1${NC} 🏠 Configuración de Desarrollo Local"
    echo "   • Configura el entorno para desarrollo local"
    echo "   • Instala dependencias y configura base de datos"
    echo "   • Inicia servidores de desarrollo"
    echo ""
    echo -e "${GREEN}2${NC} 🐙 Configuración de Despliegue en GitHub"
    echo "   • Configura repositorio GitHub con CI/CD"
    echo "   • Configura GitHub Actions automático"
    echo "   • Configura secretos y variables de entorno"
    echo ""
    echo -e "${GREEN}3${NC} 🌐 Configuración de Despliegue en Vercel"
    echo "   • Configura despliegue optimizado en Vercel"
    echo "   • Configura serverless functions"
    echo "   • Optimiza para producción"
    echo ""
    echo -e "${GREEN}4${NC} 🔄 Configuración Completa (Todas las opciones)"
    echo "   • Configura desarrollo local"
    echo "   • Configura GitHub y Vercel"
    echo "   • Setup completo del sistema"
    echo ""
    echo -e "${GREEN}5${NC} 📚 Ver Documentación"
    echo "   • Abrir documentación completa"
    echo "   • Guías de solución de problemas"
    echo "   • Variables de entorno"
    echo ""
    echo -e "${GREEN}6${NC} 🚪 Salir"
    echo "   • Salir del script"
    echo ""
    return 0
}

# Función para obtener la elección del usuario
obtener_eleccion() {
    local choice=""
    while true; do
        read -p "Ingresa tu elección (1-6): " choice
        if [[ "$choice" =~ ^[1-6]$ ]]; then
            echo "$choice"
            return 0
        else
            print_warning "Opción inválida. Por favor elige un número entre 1 y 6."
        fi
    done
}

# Función para configurar desarrollo local
configurar_desarrollo_local() {
    print_header "🏠 CONFIGURACIÓN DE DESARROLLO LOCAL"
    
    print_step "Configurando entorno de desarrollo local..."
    
    # Verificar versión de Node.js
    local node_version=""
    if command -v node &> /dev/null; then
        node_version=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$node_version" -lt 18 ]; then
            print_warning "Se recomienda Node.js 18+. Versión actual: $(node --version)"
        else
            print_status "✅ Node.js versión: $(node --version)"
        fi
    else
        print_error "Node.js no está instalado"
        return 1
    fi
    
    # Instalar gestor de paquetes
    if ! command -v pnpm &> /dev/null; then
        print_status "Instalando pnpm..."
        if npm install -g pnpm; then
            print_status "✅ pnpm instalado correctamente"
        else
            print_warning "No se pudo instalar pnpm, pero puedes usar npm"
        fi
    else
        print_status "✅ pnpm ya está instalado"
    fi
    
    if ! command -v yarn &> /dev/null; then
        print_status "Instalando Yarn..."
        if npm install -g yarn; then
            print_status "✅ Yarn instalado correctamente"
        else
            print_warning "No se pudo instalar Yarn, pero puedes usar npm"
        fi
    else
        print_status "✅ Yarn ya está instalado"
    fi
    
    # Instalar dependencias
    print_status "Instalando dependencias del proyecto..."
    if [ -f "package.json" ]; then
        if command -v pnpm &> /dev/null; then
            pnpm install && print_status "✅ Dependencias instaladas con pnpm" || print_warning "Error instalando con pnpm"
        elif command -v yarn &> /dev/null; then
            yarn install && print_status "✅ Dependencias instaladas con yarn" || print_warning "Error instalando con yarn"
        elif command -v npm &> /dev/null; then
            npm install && print_status "✅ Dependencias instaladas con npm" || print_warning "Error instalando con npm"
        else
            print_error "No se encontró ningún gestor de paquetes"
            return 1
        fi
    else
        print_warning "No se encontró package.json, saltando instalación de dependencias"
    fi
    
    # Crear archivo de entorno
    if [ ! -f ".env" ]; then
        print_status "Creando archivo de configuración de entorno..."
        cat > .env << 'EOF'
# Configuración de Base de Datos
DATABASE_URL="postgresql://user:password@localhost:5432/android_device_manager"
DIRECT_URL="postgresql://user:password@localhost:5432/android_device_manager"

# Configuración de Autenticación
JWT_SECRET="tu_jwt_secret_super_seguro_minimo_32_caracteres"
NEXTAUTH_SECRET="tu_nextauth_secret_super_seguro_minimo_32_caracteres"
NEXTAUTH_URL="http://localhost:5173"

# Configuración de APIs (Opcional)
OPENAI_API_KEY="tu_openai_api_key"
GOOGLE_MAPS_API_KEY="tu_google_maps_api_key"

# URLs de Cliente
VITE_APP_URL="http://localhost:5173"
VITE_API_URL="http://localhost:3000"
VITE_WEBSOCKET_URL="ws://localhost:3001"

# Configuración de Desarrollo
NODE_ENV=development
EOF
        print_status "✅ Archivo .env creado"
        print_warning "Por favor actualiza las configuraciones en el archivo .env"
    else
        print_status "✅ El archivo .env ya existe"
    fi
    
    # Configurar base de datos local (si PostgreSQL está disponible)
    if command -v psql &> /dev/null; then
        print_status "Configurando base de datos local..."
        if createdb android_device_manager 2>/dev/null; then
            print_status "✅ Base de datos creada"
        else
            print_warning "La base de datos podría ya existir"
        fi
    else
        print_warning "PostgreSQL no está instalado, omitiendo configuración de base de datos"
    fi
    
    # Generar cliente de base de datos
    if [ -f "package.json" ]; then
        if grep -q "db:generate" package.json; then
            print_status "Generando cliente de base de datos..."
            if command -v pnpm &> /dev/null; then
                pnpm run db:generate && pnpm run db:push && print_status "✅ Base de datos configurada" || print_warning "Error configurando base de datos"
            elif command -v yarn &> /dev/null; then
                yarn db:generate && yarn db:push && print_status "✅ Base de datos configurada" || print_warning "Error configurando base de datos"
            elif command -v npm &> /dev/null; then
                npm run db:generate && npm run db:push && print_status "✅ Base de datos configurada" || print_warning "Error configurando base de datos"
            fi
        fi
    fi
    
    print_status "🎉 ¡Configuración de desarrollo local completada!"
    echo ""
    print_status "Para iniciar el desarrollo:"
    if command -v pnpm &> /dev/null; then
        echo "  pnpm run dev"
    elif command -v yarn &> /dev/null; then
        echo "  yarn dev"
    elif command -v npm &> /dev/null; then
        echo "  npm run dev"
    else
        echo "  npm run dev"
    fi
    echo ""
    print_status "URLs disponibles:"
    echo "  • Frontend: http://localhost:5173"
    echo "  • Backend: http://localhost:3000"
    echo "  • WebSocket: ws://localhost:3001"
    
    return 0
}

# Función para configurar GitHub
configurar_github() {
    print_header "🐙 CONFIGURACIÓN DE GITHUB"
    
    print_step "Configurando despliegue en GitHub..."
    
    # Verificar si ya es un repositorio git
    if [ ! -d ".git" ]; then
        print_status "Inicializando repositorio Git..."
        if git init; then
            print_status "✅ Repositorio Git inicializado"
        else
            print_error "Error inicializando repositorio Git"
            return 1
        fi
    else
        print_status "✅ Repositorio Git ya existe"
    fi
    
    # Crear .gitignore si no existe
    if [ ! -f ".gitignore" ]; then
        print_status "Creando archivo .gitignore..."
        cat > .gitignore << 'EOF'
# Dependencias
node_modules/
.pnpm-debug.log*
.yarn-integrity

# Variables de entorno
.env
.env.local
.env.production

# Builds
dist/
build/
.vite/

# Base de datos
*.db
*.sqlite

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
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
EOF
        print_status "✅ .gitignore creado"
    else
        print_status "✅ .gitignore ya existe"
    fi
    
    # Crear directorio de GitHub Actions
    print_status "Creando pipeline de CI/CD..."
    mkdir -p .github/workflows
    
    # Crear workflow de GitHub Actions
    cat > .github/workflows/deploy.yml << 'EOF'
name: 🚀 Desplegar a Producción

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
    - name: 📋 Obtener código
      uses: actions/checkout@v4

    - name: 🔧 Configurar Node.js
      uses: actions/setup-node@v4
      with:
        node-version: ${{ env.NODE_VERSION }}

    - name: 📦 Configurar pnpm
      uses: pnpm/action-setup@v2
      with:
        version: ${{ env.PNPM_VERSION }}

    - name: 📋 Obtener directorio de caché de pnpm
      shell: bash
      run: |
        echo "STORE_PATH=$(pnpm store path --silent)" >> $GITHUB_ENV

    - name: 📋 Configurar caché de pnpm
      uses: actions/cache@v3
      with:
        path: ${{ env.STORE_PATH }}
        key: ${{ runner.os }}-pnpm-store-${{ hashFiles('**/pnpm-lock.yaml') }}
        restore-keys: |
          ${{ runner.os }}-pnpm-store-

    - name: 📥 Instalar dependencias
      run: pnpm install --frozen-lockfile

    - name: 🔍 Lint de código
      run: pnpm run lint

    - name: 🧪 Ejecutar tests
      run: pnpm run test

  build-and-deploy:
    needs: lint-and-test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'

    steps:
    - name: 📋 Obtener código
      uses: actions/checkout@v4

    - name: 🔧 Configurar Node.js
      uses: actions/setup-node@v4
      with:
        node-version: ${{ env.NODE_VERSION }}

    - name: 📦 Configurar pnpm
      uses: pnpm/action-setup@v2
      with:
        version: ${{ env.PNPM_VERSION }}

    - name: 📥 Instalar dependencias
      run: pnpm install --frozen-lockfile

    - name: 🔨 Construir aplicación
      run: pnpm run build
      env:
        VITE_API_URL: ${{ secrets.VITE_API_URL }}
        VITE_WEBSOCKET_URL: ${{ secrets.VITE_WEBSOCKET_URL }}
        VITE_APP_URL: ${{ secrets.VITE_APP_URL }}

    - name: 🚀 Desplegar en Vercel
      uses: amondnet/vercel-action@v25
      with:
        vercel-token: ${{ secrets.VERCEL_TOKEN }}
        vercel-org-id: ${{ secrets.ORG_ID}}
        vercel-project-id: ${{ secrets.PROJECT_ID}}
        vercel-args: '--prod'
EOF
    
    print_status "✅ Pipeline de CI/CD creado"
    
    print_status "🎉 ¡Configuración de GitHub completada!"
    echo ""
    print_status "Próximos pasos:"
    echo "1. Crear repositorio en GitHub.com"
    echo "2. Configurar secretos en el repositorio:"
    echo "   - VERCEL_TOKEN"
    echo "   - ORG_ID"
    echo "   - PROJECT_ID"
    echo "3. Subir código: git add . && git commit -m 'Initial commit' && git push"
    
    return 0
}

# Función para configurar Vercel
configurar_vercel() {
    print_header "🌐 CONFIGURACIÓN DE VERCEL"
    
    print_step "Configurando despliegue en Vercel..."
    
    # Instalar Vercel CLI
    if ! command -v vercel &> /dev/null; then
        print_status "Instalando Vercel CLI..."
        if npm install -g vercel; then
            print_status "✅ Vercel CLI instalado"
        else
            print_error "Error instalando Vercel CLI"
            return 1
        fi
    else
        print_status "✅ Vercel CLI ya está instalado"
    fi
    
    # Crear configuración de Vercel
    print_status "Creando configuración de Vercel..."
    cat > vercel.json << 'EOF'
{
  "version": 2,
  "name": "android-device-manager",
  "builds": [
    {
      "src": "package.json",
      "use": "@vercel/static-build",
      "config": {
        "distDir": "dist"
      }
    },
    {
      "src": "api/**/*.js",
      "use": "@vercel/node"
    }
  ],
  "routes": [
    {
      "src": "/api/(.*)",
      "dest": "/api/$1"
    },
    {
      "src": "/(.*)",
      "dest": "/index.html"
    }
  ],
  "env": {
    "NODE_ENV": "production"
  },
  "functions": {
    "api/**/*.js": {
      "maxDuration": 30
    }
  },
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "Referrer-Policy",
          "value": "strict-origin-when-cross-origin"
        }
      ]
    }
  ]
}
EOF
    print_status "✅ vercel.json creado"
    
    # Crear variables de entorno de producción
    print_status "Creando configuración de variables de entorno..."
    cat > .env.production << 'EOF'
# Variables de Entorno de Producción
NODE_ENV=production

# Configuración de Base de Datos
DATABASE_URL="tu_url_de_base_de_datos_de_produccion"
DIRECT_URL="tu_url_directa_de_base_de_datos"

# Configuración de Autenticación
JWT_SECRET="tu_jwt_secret_de_produccion_muy_seguro"
NEXTAUTH_SECRET="tu_nextauth_secret_de_produccion_muy_seguro"
NEXTAUTH_URL="https://tu-dominio-vercel.vercel.app"

# Configuración de APIs
OPENAI_API_KEY="tu_openai_api_key"
GOOGLE_MAPS_API_KEY="tu_google_maps_api_key"

# URLs de Cliente (Se configurarán automáticamente)
VITE_APP_URL="https://tu-dominio-vercel.vercel.app"
VITE_API_URL="https://tu-dominio-vercel.vercel.app/api"
VITE_WEBSOCKET_URL="wss://tu-dominio-vercel.vercel.app/ws"
EOF
    print_status "✅ .env.production creado"
    
    print_status "🎉 ¡Configuración de Vercel completada!"
    echo ""
    print_status "Próximos pasos:"
    echo "1. Hacer login en Vercel: vercel login"
    echo "2. Configurar variables de entorno en el dashboard de Vercel"
    echo "3. Desplegar: vercel --prod"
    
    return 0
}

# Función para configurar todo
configurar_completo() {
    print_header "🔄 CONFIGURACIÓN COMPLETA DEL SISTEMA"
    
    print_step "Ejecutando configuración completa..."
    
    # Configurar desarrollo local
    if ! configurar_desarrollo_local; then
        print_error "Error en configuración de desarrollo local"
        return 1
    fi
    echo ""
    
    pausar
    
    # Configurar GitHub
    if ! configurar_github; then
        print_error "Error en configuración de GitHub"
        return 1
    fi
    echo ""
    
    pausar
    
    # Configurar Vercel
    if ! configurar_vercel; then
        print_error "Error en configuración de Vercel"
        return 1
    fi
    echo ""
    
    print_status "🎉 ¡Configuración completa terminada!"
    echo ""
    print_status "Tu Android Device Manager está listo para:"
    echo "• Desarrollo local en http://localhost:5173"
    echo "• Despliegue automático en GitHub"
    echo "• Hosting optimizado en Vercel"
    
    return 0
}

# Función para ver documentación
ver_documentacion() {
    print_header "📚 DOCUMENTACIÓN"
    
    print_step "Mostrando información de documentación..."
    
    if [ -d "docs" ] && [ -f "docs/README.md" ]; then
        print_status "Encontrada documentación en docs/README.md"
        echo ""
        echo "📋 CONTENIDO DE LA DOCUMENTACIÓN:"
        echo "================================"
        echo ""
        if command -v open &> /dev/null; then
            open docs/README.md 2>/dev/null || cat docs/README.md
        elif command -v xdg-open &> /dev/null; then
            xdg-open docs/README.md 2>/dev/null || cat docs/README.md
        else
            cat docs/README.md
        fi
    else
        print_warning "Documentación no encontrada. Mostrando información local..."
        echo ""
        echo "📋 DOCUMENTACIÓN PRINCIPAL"
        echo "================================"
        echo ""
        echo "1. VARIABLES DE ENTORNO REQUERIDAS:"
        echo "   • DATABASE_URL - URL de base de datos"
        echo "   • JWT_SECRET - Secreto JWT (mínimo 32 chars)"
        echo "   • NEXTAUTH_SECRET - Secreto NextAuth (mínimo 32 chars)"
        echo "   • NEXTAUTH_URL - URL de la aplicación"
        echo ""
        echo "2. COMANDOS ÚTILES:"
        echo "   • pnpm install - Instalar dependencias"
        echo "   • pnpm run dev - Iniciar desarrollo"
        echo "   • pnpm run build - Construir para producción"
        echo "   • pnpm run lint - Verificar código"
        echo ""
        echo "3. SOLUCIÓN DE PROBLEMAS:"
        echo "   • Verificar Node.js versión 18+"
        echo "   • Verificar permisos de archivos"
        echo "   • Revisar variables de entorno"
        echo "   • Consultar logs de error"
        echo ""
        echo "4. CONFIGURACIÓN DE PLATAFORMAS:"
        echo "   • GitHub: Crear repositorio y configurar secretos"
        echo "   • Vercel: Login y configurar variables de entorno"
        echo "   • Local: Verificar Node.js y ejecutar pnpm install"
    fi
    
    return 0
}

# Función principal
main() {
    # Desactivar salida automática en caso de error para el debugging
    set +e
    set +u
    
    print_header "🚀 ANDROID DEVICE MANAGER - SISTEMA DE DESPLIEGUE"
    
    # Verificar prerrequisitos
    if ! verificar_prerequisitos; then
        print_error "Error en verificación de prerrequisitos"
        return 1
    fi
    
    # Loop principal
    while true; do
        # Limpiar pantalla (opcional)
        clear
        
        print_header "🚀 ANDROID DEVICE MANAGER - SISTEMA DE DESPLIEGUE"
        
        # Mostrar menú
        if ! mostrar_menu; then
            print_error "Error mostrando menú"
            break
        fi
        
        # Obtener elección
        local eleccion
        eleccion=$(obtener_eleccion)
        
        # Procesar elección
        case $eleccion in
            1)
                clear
                configurar_desarrollo_local
                pausar
                ;;
            2)
                clear
                configurar_github
                pausar
                ;;
            3)
                clear
                configurar_vercel
                pausar
                ;;
            4)
                clear
                configurar_completo
                pausar
                ;;
            5)
                clear
                ver_documentacion
                pausar
                ;;
            6)
                print_status "👋 ¡Hasta luego!"
                return 0
                ;;
            *)
                print_warning "Opción inválida. Por favor elige 1-6."
                sleep 2
                ;;
        esac
    done
    
    return 0
}

# Verificar si el script se está ejecutando directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Ejecutar función principal
    main "$@"
fi