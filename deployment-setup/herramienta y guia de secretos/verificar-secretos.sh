#!/bin/bash

# ✅ Android Device Manager - Verificador de Secretos
# Esta herramienta verifica que los secretos estén correctamente configurados

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
    echo -e "${GREEN}[✓]${NC} $1"
}

# Función para imprimir errores
print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Función para imprimir advertencias
print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Función para imprimir información
print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

# Función para imprimir encabezados
print_header() {
    echo -e "${CYAN}================================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}================================================${NC}"
}

# Función para verificar formato de tokens
verificar_formato_token() {
    local token="$1"
    local tipo="$2"
    
    case "$tipo" in
        "vercel_token")
            if [[ "$token" =~ ^[a-zA-Z0-9_-]{20,}$ ]]; then
                print_status "Formato de VERCEL_TOKEN válido"
                return 0
            else
                print_error "Formato de VERCEL_TOKEN inválido. Debe ser una cadena de al menos 20 caracteres alfanuméricos"
                return 1
            fi
            ;;
        "org_id")
            if [[ "$token" =~ ^team_[a-zA-Z0-9]{16,}$ ]]; then
                print_status "Formato de ORG_ID válido"
                return 0
            else
                print_error "Formato de ORG_ID inválido. Debe comenzar con 'team_'"
                return 1
            fi
            ;;
        "project_id")
            if [[ "$token" =~ ^prj_[a-zA-Z0-9]{16,}$ ]]; then
                print_status "Formato de PROJECT_ID válido"
                return 0
            else
                print_error "Formato de PROJECT_ID inválido. Debe comenzar con 'prj_'"
                return 1
            fi
            ;;
    esac
}

# Función para verificar Vercel CLI
verificar_vercel_cli() {
    print_header "VERIFICANDO HERRAMIENTAS"
    
    if command -v vercel &> /dev/null; then
        local version=$(vercel --version 2>/dev/null)
        print_status "Vercel CLI instalado: $version"
        return 0
    else
        print_error "Vercel CLI no está instalado"
        print_info "Instalar con: npm install -g vercel"
        return 1
    fi
}

# Función para verificar login en Vercel
verificar_login_vercel() {
    print_header "VERIFICANDO AUTENTICACIÓN"
    
    if vercel whoami &> /dev/null; then
        local user=$(vercel whoami 2>/dev/null | head -1)
        print_status "Conectado a Vercel como: $user"
        return 0
    else
        print_error "No estás autenticado en Vercel"
        print_info "Ejecuta: vercel login"
        return 1
    fi
}

# Función para obtener secretos del usuario
obtener_secretos_usuario() {
    print_header "CONFIGURACIÓN DE SECRETOS"
    
    echo ""
    print_info "Ingresa tus secretos para verificar la configuración:"
    echo ""
    
    # VERCEL_TOKEN
    while true; do
        read -s -p "VERCEL_TOKEN: " vercel_token
        echo ""
        if [ -n "$vercel_token" ]; then
            if verificar_formato_token "$vercel_token" "vercel_token"; then
                break
            fi
        else
            print_error "El token no puede estar vacío"
        fi
    done
    
    # ORG_ID
    while true; do
        read -p "ORG_ID: " org_id
        if [ -n "$org_id" ]; then
            if verificar_formato_token "$org_id" "org_id"; then
                break
            fi
        else
            print_error "El ORG_ID no puede estar vacío"
        fi
    done
    
    # PROJECT_ID
    while true; do
        read -p "PROJECT_ID: " project_id
        if [ -n "$project_id" ]; then
            if verificar_formato_token "$project_id" "project_id"; then
                break
            fi
        else
            print_error "El PROJECT_ID no puede estar vacío"
        fi
    done
    
    # Exportar para usar en otras funciones
    export VERCEL_TOKEN="$vercel_token"
    export ORG_ID="$org_id"
    export PROJECT_ID="$project_id"
}

# Función para verificar acceso a Vercel
verificar_acceso_vercel() {
    print_header "VERIFICANDO ACCESO A VERCEL"
    
    # Verificar token
    if vercel whoami --token="$VERCEL_TOKEN" &> /dev/null; then
        print_status "VERCEL_TOKEN válido y funcional"
    else
        print_error "VERCEL_TOKEN inválido o sin permisos"
        return 1
    fi
    
    # Verificar organización
    local org_info=$(vercel teams ls --token="$VERCEL_TOKEN" 2>/dev/null)
    if echo "$org_info" | grep -q "$ORG_ID"; then
        print_status "ORG_ID válido y accesible"
    else
        print_warning "ORG_ID no encontrado en tus organizaciones"
        print_info "Verifica que tienes acceso a esta organización"
    fi
    
    # Verificar proyecto
    local project_info=$(vercel projects ls --token="$VERCEL_TOKEN" 2>/dev/null)
    if echo "$project_info" | grep -q "$PROJECT_ID"; then
        print_status "PROJECT_ID válido y accesible"
    else
        print_warning "PROJECT_ID no encontrado en tus proyectos"
        print_info "Verifica que el proyecto existe y tienes acceso"
    fi
}

# Función para generar reporte
generar_reporte() {
    print_header "GENERANDO REPORTE DE CONFIGURACIÓN"
    
    local fecha=$(date '+%Y-%m-%d %H:%M:%S')
    local archivo_reporte="reporte_secretos_$fecha.txt"
    
    cat > "$archivo_reporte" << EOF
# REPORTE DE CONFIGURACIÓN DE SECRETOS
# Generado el $fecha
# ====================================

## VERIFICACIÓN DE HERRAMIENTAS
$(verificar_vercel_cli > /dev/null 2>&1 && echo "✅ Vercel CLI: Instalado" || echo "❌ Vercel CLI: No instalado")

## VERIFICACIÓN DE AUTENTICACIÓN
$(vercel whoami > /dev/null 2>&1 && echo "✅ Vercel Login: Activo" || echo "❌ Vercel Login: No activo")

## SECRETOS CONFIGURADOS

### VERCEL_TOKEN
Estado: $(verificar_formato_token "$VERCEL_TOKEN" "vercel_token" > /dev/null 2>&1 && echo "✅ Válido" || echo "❌ Inválido")
Formato: $VERCEL_TOKEN
Longitud: ${#VERCEL_TOKEN} caracteres

### ORG_ID
Estado: $(verificar_formato_token "$ORG_ID" "org_id" > /dev/null 2>&1 && echo "✅ Válido" || echo "❌ Inválido")
Formato: $ORG_ID
Longitud: ${#ORG_ID} caracteres

### PROJECT_ID
Estado: $(verificar_formato_token "$PROJECT_ID" "project_id" > /dev/null 2>&1 && echo "✅ Válido" || echo "❌ Inválido")
Formato: $PROJECT_ID
Longitud: ${#PROJECT_ID} caracteres

## INSTRUCCIONES PARA GITHUB

Para configurar estos secretos en GitHub:

1. Ve a tu repositorio en GitHub
2. Settings > Secrets and variables > Actions
3. Haz clic en "New repository secret"

Configura estos secretos:

VERCEL_TOKEN
- Name: VERCEL_TOKEN
- Secret: $VERCEL_TOKEN

ORG_ID
- Name: ORG_ID
- Secret: $ORG_ID

PROJECT_ID
- Name: PROJECT_ID
- Secret: $PROJECT_ID

## PRÓXIMOS PASOS

1. ✅ Configurar secretos en GitHub (arriba)
2. ✅ Subir código a GitHub
3. ✅ Verificar que GitHub Actions se ejecute
4. ✅ Confirmar deployment exitoso en Vercel

## NOTAS IMPORTANTES

- Los tokens tienen expiración, renueva cuando sea necesario
- Nunca compartas estos tokens públicamente
- Guarda una copia segura de esta información
- Revisa periódicamente los permisos de acceso

---
Reporte generado automáticamente
EOF
    
    print_status "Reporte guardado en: $archivo_reporte"
    echo ""
    print_info "Contenido del reporte:"
    cat "$archivo_reporte"
}

# Función para verificar configuración de GitHub
verificar_configuracion_github() {
    print_header "VERIFICACIÓN DE GITHUB"
    
    # Verificar si estamos en un repositorio Git
    if [ ! -d ".git" ]; then
        print_warning "No estás en un repositorio Git"
        print_info "Ve a tu repositorio y ejecuta este script desde ahí"
        return 1
    fi
    
    # Verificar remote origin
    local remote_origin=$(git remote get-url origin 2>/dev/null)
    if [ -n "$remote_origin" ]; then
        print_status "Repositorio Git detectado: $remote_origin"
    else
        print_warning "No se encontró remote origin"
        print_info "Configura el remote con: git remote add origin <url>"
    fi
    
    # Verificar GitHub Actions
    if [ -d ".github/workflows" ]; then
        print_status "GitHub Actions configurado"
        local workflows=$(ls .github/workflows/*.yml .github/workflows/*.yaml 2>/dev/null | wc -l)
        print_info "Workflows encontrados: $workflows"
    else
        print_warning "GitHub Actions no configurado"
        print_info "Crea el directorio: .github/workflows/"
    fi
}

# Función principal
main() {
    print_header "🔐 VERIFICADOR DE SECRETOS GITHUB + VERCEL"
    
    echo ""
    print_info "Esta herramienta verifica que tus secretos estén correctamente configurados"
    echo ""
    
    # Verificar herramientas
    if ! verificar_vercel_cli; then
        print_error "Por favor instala Vercel CLI primero"
        exit 1
    fi
    
    # Verificar autenticación
    if ! verificar_login_vercel; then
        print_error "Por favor autentícate en Vercel primero"
        print_info "Ejecuta: vercel login"
        exit 1
    fi
    
    # Obtener secretos del usuario
    obtener_secretos_usuario
    
    # Verificar acceso a Vercel
    echo ""
    if verificar_acceso_vercel; then
        print_status "✅ Todos los secretos son válidos"
    else
        print_error "❌ Hay problemas con los secretos"
    fi
    
    # Verificar configuración de GitHub
    echo ""
    verificar_configuracion_github
    
    # Generar reporte
    echo ""
    generar_reporte
    
    echo ""
    print_status "🎉 ¡Verificación completada!"
    print_info "Revisa el reporte generado para instrucciones detalladas"
}

# Verificar si se está ejecutando directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi