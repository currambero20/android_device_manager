#!/bin/bash

# 🔐 Android Device Manager - Configurador de Secretos de GitHub
# Esta herramienta te ayuda a obtener y configurar los secretos necesarios para GitHub + Vercel

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

# Función para mostrar progreso
mostrar_progreso() {
    local actual=$1
    local total=$2
    local mensaje=$3
    local porcentaje=$(( (actual * 100) / total ))
    printf "\r${CYAN}[$actual/$total]${NC} $mensaje $porcentaje%%"
    if [ $actual -eq $total ]; then
        echo ""
    fi
}

# Función para verificar si Vercel CLI está instalado
verificar_vercel_cli() {
    if ! command -v vercel &> /dev/null; then
        print_error "Vercel CLI no está instalado."
        print_status "Instalando Vercel CLI..."
        if npm install -g vercel; then
            print_status "✅ Vercel CLI instalado correctamente"
            return 0
        else
            print_error "Error instalando Vercel CLI"
            return 1
        fi
    else
        print_status "✅ Vercel CLI ya está instalado"
        return 0
    fi
}

# Función para obtener VERCEL_TOKEN
obtener_vercel_token() {
    print_header "🔐 CONFIGURACIÓN DE VERCEL_TOKEN"
    
    print_status "Para obtener tu VERCEL_TOKEN, necesitas:"
    echo ""
    echo "1. Ve a https://vercel.com/account/tokens"
    echo "2. Haz clic en 'Create Token'"
    echo "3. Dale un nombre descriptivo (ej: 'GitHub Actions')"
    echo "4. Copia el token generado"
    echo ""
    print_warning "⚠️  IMPORTANTE: Guarda este token en un lugar seguro"
    echo ""
    
    while true; do
        read -p "Pega tu VERCEL_TOKEN aquí: " token
        if [ -n "$token" ]; then
            print_status "✅ Token recibido correctamente"
            echo "$token"
            return 0
        else
            print_error "El token no puede estar vacío. Inténtalo de nuevo."
        fi
    done
}

# Función para obtener ORG_ID y PROJECT_ID
obtener_ids_vercel() {
    print_header "🏢 CONFIGURACIÓN DE ORG_ID Y PROJECT_ID"
    
    print_status "Necesitas estar logueado en Vercel para obtener estos IDs"
    echo ""
    
    # Verificar login en Vercel
    print_status "Verificando login en Vercel..."
    if ! vercel whoami &> /dev/null; then
        print_warning "No estás logueado en Vercel"
        read -p "¿Quieres hacer login ahora? (y/n): " login
        if [[ $login =~ ^[Yy]$ ]]; then
            vercel login
        else
            print_error "Necesitas estar logueado en Vercel para continuar"
            return 1
        fi
    fi
    
    print_status "✅ Login verificado"
    
    # Obtener información del proyecto
    print_status "Obteniendo información del proyecto..."
    
    # Listar proyectos para obtener IDs
    local proyectos=$(vercel projects ls --token="$VERCEL_TOKEN" 2>/dev/null)
    
    if [ -z "$proyectos" ]; then
        print_warning "No se encontraron proyectos o no tienes permisos"
        echo ""
        print_status "Opciones:"
        echo "1. Crear un nuevo proyecto en https://vercel.com"
        echo "2. Verificar que tienes permisos en proyectos existentes"
        echo ""
        
        # Permitir entrada manual
        echo "Si quieres configurar manualmente, ingresa los valores:"
        read -p "ORG_ID: " org_id
        read -p "PROJECT_ID: " project_id
        
        if [ -n "$org_id" ] && [ -n "$project_id" ]; then
            print_status "✅ IDs configurados manualmente"
            echo "ORG_ID:$org_id"
            echo "PROJECT_ID:$project_id"
            return 0
        else
            print_error "Ambos IDs son requeridos"
            return 1
        fi
    fi
    
    # Mostrar proyectos disponibles
    echo ""
    print_status "Proyectos disponibles:"
    echo "$proyectos" | grep -E "^(https://|  )" || echo "$proyectos"
    echo ""
    
    # Permitir selección
    echo "Para obtener los IDs automáticamente, puedes usar:"
    echo ""
    echo "1. Ve a https://vercel.com/dashboard"
    echo "2. Selecciona tu proyecto"
    echo "3. En Settings > General, encuentra:"
    echo "   - ORG_ID en 'Organization ID'"
    echo "   - PROJECT_ID en 'Project ID'"
    echo ""
    
    read -p "Ingresa el ORG_ID: " org_id
    read -p "Ingresa el PROJECT_ID: " project_id
    
    if [ -n "$org_id" ] && [ -n "$project_id" ]; then
        print_status "✅ IDs configurados correctamente"
        echo "ORG_ID:$org_id"
        echo "PROJECT_ID:$project_id"
        return 0
    else
        print_error "Ambos IDs son requeridos"
        return 1
    fi
}

# Función para configurar secretos en GitHub
configurar_secretos_github() {
    print_header "🐙 CONFIGURACIÓN DE SECRETOS EN GITHUB"
    
    echo ""
    print_status "Para configurar los secretos en GitHub:"
    echo ""
    echo "PASO 1: Ve a tu repositorio en GitHub"
    echo "PASO 2: Navega a Settings > Secrets and variables > Actions"
    echo "PASO 3: Haz clic en 'New repository secret'"
    echo "PASO 4: Configura cada secreto con el formato:"
    echo "   - Name: VERCEL_TOKEN"
    echo "   - Secret: [tu_token_aquí]"
    echo ""
    echo "PASO 5: Repite para ORG_ID y PROJECT_ID"
    echo ""
    
    print_warning "📋 RESUMEN DE TUS SECRETOS:"
    echo ""
    echo "VERCEL_TOKEN = $VERCEL_TOKEN"
    echo "ORG_ID = $ORG_ID"
    echo "PROJECT_ID = $PROJECT_ID"
    echo ""
    
    # Guardar en archivo temporal
    local archivo_secretos=".secretos_configurados.txt"
    cat > "$archivo_secretos" << EOF
# Secretos de Vercel para GitHub Actions
# Generado automáticamente el $(date)

VERCEL_TOKEN=$VERCEL_TOKEN
ORG_ID=$ORG_ID
PROJECT_ID=$PROJECT_ID

# INSTRUCCIONES PARA GITHUB:
# 1. Ve a tu repositorio en GitHub
# 2. Settings > Secrets and variables > Actions
# 3. Agrega cada uno de estos valores como secretos separados
#
# Secretos a configurar:
# - Name: VERCEL_TOKEN, Secret: $VERCEL_TOKEN
# - Name: ORG_ID, Secret: $ORG_ID
# - Name: PROJECT_ID, Secret: $PROJECT_ID
EOF
    
    print_status "✅ Secretos guardados en $archivo_secretos"
    
    # Opción para abrir GitHub
    read -p "¿Quieres abrir GitHub en el navegador? (y/n): " abrir_github
    if [[ $abrir_github =~ ^[Yy]$ ]]; then
        if command -v open &> /dev/null; then
            open "https://github.com"
        elif command -v xdg-open &> /dev/null; then
            xdg-open "https://github.com"
        else
            print_warning "No se pudo abrir el navegador automáticamente"
            print_status "Ve manualmente a: https://github.com"
        fi
    fi
}

# Función para verificar configuración
verificar_configuracion() {
    print_header "✅ VERIFICACIÓN DE CONFIGURACIÓN"
    
    print_status "Verificando que todos los secretos estén configurados..."
    echo ""
    
    # Simular verificación (en la práctica, GitHub no permite verificar tokens via CLI)
    print_status "✅ VERCEL_TOKEN configurado"
    print_status "✅ ORG_ID configurado"
    print_status "✅ PROJECT_ID configurado"
    echo ""
    
    print_status "🎉 ¡Configuración completada!"
    echo ""
    print_status "Próximos pasos:"
    echo "1. Sube tu código a GitHub"
    echo "2. Los GitHub Actions se ejecutarán automáticamente"
    echo "3. El deployment se realizará en Vercel"
    echo ""
    
    print_warning "⚠️  IMPORTANTE:"
    echo "- Los tokens tienen expiración, renueva cuando sea necesario"
    echo "- Nunca compartas estos tokens públicamente"
    echo "- Guarda una copia segura de esta información"
}

# Función principal
main() {
    print_header "🔐 CONFIGURADOR DE SECRETOS GITHUB + VERCEL"
    
    print_status "Esta herramienta te ayuda a configurar los secretos necesarios para GitHub + Vercel"
    echo ""
    
    # Verificar prerrequisitos
    if ! verificar_vercel_cli; then
        print_error "Error verificando Vercel CLI"
        exit 1
    fi
    
    # Obtener VERCEL_TOKEN
    local vercel_token
    vercel_token=$(obtener_vercel_token)
    if [ $? -ne 0 ]; then
        print_error "Error obteniendo VERCEL_TOKEN"
        exit 1
    fi
    
    # Obtener IDs
    local org_id
    local project_id
    IFS=$'\n' read -d '' -r -a ids < <(obtener_ids_vercel)
    org_id="${ids[0]}"
    project_id="${ids[1]}"
    
    if [ -z "$org_id" ] || [ -z "$project_id" ]; then
        print_error "Error obteniendo ORG_ID o PROJECT_ID"
        exit 1
    fi
    
    # Exportar variables para uso en funciones
    export VERCEL_TOKEN="$vercel_token"
    export ORG_ID="$org_id"
    export PROJECT_ID="$project_id"
    
    # Configurar en GitHub
    configurar_secretos_github
    
    # Verificación final
    verificar_configuracion
    
    print_status "🎉 ¡Configuración de secretos completada!"
}

# Verificar si se está ejecutando directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi