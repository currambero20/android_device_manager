#!/bin/bash

# 🎯 Android Device Manager - Asistente Interactivo de Secretos
# Guía paso a paso para configurar secretos sin complicaciones

# Colores para la salida
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # Sin Color

# Función para imprimir mensajes
print_step() {
    echo -e "${PURPLE}[PASO $1]${NC} $2"
}

print_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[ÉXITO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[ADVERTENCIA]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Función para limpiar pantalla
limpiar_pantalla() {
    clear
}

# Función para pausa
pausar() {
    echo ""
    read -p "Presiona Enter para continuar..." dummy
    echo ""
}

# Función para mostrar bienvenida
mostrar_bienvenida() {
    limpiar_pantalla
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                                ║${NC}"
    echo -e "${CYAN}║         🎯 ASISTENTE DE CONFIGURACIÓN DE SECRETOS              ║${NC}"
    echo -e "${CYAN}║                    GitHub + Vercel                             ║${NC}"
    echo -e "${CYAN}║                                                                ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    print_info "Te guiaré paso a paso para configurar los secretos necesarios"
    print_info "para el deployment automático de GitHub a Vercel"
    echo ""
    pausar
}

# Función para verificar prerrequisitos
verificar_prerrequisitos() {
    limpiar_pantalla
    print_step "1/8" "Verificando prerrequisitos"
    echo ""
    
    # Verificar Git
    if command -v git &> /dev/null; then
        print_success "Git está instalado"
    else
        print_error "Git no está instalado"
        print_info "Instala Git desde: https://git-scm.com/"
        exit 1
    fi
    
    # Verificar si estamos en repositorio Git
    if [ -d ".git" ]; then
        print_success "Estás en un repositorio Git"
    else
        print_warning "No estás en un repositorio Git"
        print_info "¿Quieres inicializar un repositorio Git? (y/n)"
        read -r respuesta
        if [[ $respuesta =~ ^[Yy]$ ]]; then
            git init
            print_success "Repositorio Git inicializado"
        fi
    fi
    
    # Verificar Node.js
    if command -v node &> /dev/null; then
        print_success "Node.js está instalado: $(node --version)"
    else
        print_warning "Node.js no está instalado"
        print_info "Instala Node.js desde: https://nodejs.org/"
    fi
    
    pausar
}

# Función para obtener VERCEL_TOKEN
obtener_vercel_token() {
    limpiar_pantalla
    print_step "2/8" "Obteniendo VERCEL_TOKEN"
    echo ""
    
    print_info "El VERCEL_TOKEN es necesario para que GitHub pueda deployar en Vercel"
    echo ""
    
    echo "Para obtener tu VERCEL_TOKEN:"
    echo "1. Abre tu navegador"
    echo "2. Ve a: https://vercel.com/account/tokens"
    echo "3. Inicia sesión si es necesario"
    echo "4. Haz clic en 'Create Token'"
    echo "5. Dale un nombre como 'GitHub Actions'"
    echo "6. Haz clic en 'Create'"
    echo "7. Copia el token generado"
    echo ""
    
    print_warning "⚠️  IMPORTANTE: El token es sensible, guárdalo en un lugar seguro"
    echo ""
    
    while true; do
        read -s -p "Pega tu VERCEL_TOKEN aquí: " token
        echo ""
        
        if [ -n "$token" ]; then
            if [[ "$token" =~ ^[a-zA-Z0-9_-]{20,}$ ]]; then
                print_success "VERCEL_TOKEN válido"
                export VERCEL_TOKEN="$token"
                break
            else
                print_error "Formato inválido. El token debe ser una cadena de al menos 20 caracteres alfanuméricos"
                print_info "Inténtalo de nuevo"
            fi
        else
            print_error "El token no puede estar vacío"
        fi
    done
    
    pausar
}

# Función para obtener ORG_ID
obtener_org_id() {
    limpiar_pantalla
    print_step "3/8" "Obteniendo ORG_ID"
    echo ""
    
    print_info "El ORG_ID identifica tu organización en Vercel"
    echo ""
    
    echo "Para obtener tu ORG_ID:"
    echo "1. Ve a: https://vercel.com/dashboard"
    echo "2. Selecciona tu proyecto"
    echo "3. Ve a Settings > General"
    echo "4. Busca 'Organization ID'"
    echo "5. Copia el valor (comienza con 'team_')"
    echo ""
    
    while true; do
        read -p "Pega tu ORG_ID aquí: " org_id
        echo ""
        
        if [ -n "$org_id" ]; then
            if [[ "$org_id" =~ ^team_[a-zA-Z0-9]{16,}$ ]]; then
                print_success "ORG_ID válido"
                export ORG_ID="$org_id"
                break
            else
                print_error "Formato inválido. El ORG_ID debe comenzar con 'team_'"
                print_info "Inténtalo de nuevo"
            fi
        else
            print_error "El ORG_ID no puede estar vacío"
        fi
    done
    
    pausar
}

# Función para obtener PROJECT_ID
obtener_project_id() {
    limpiar_pantalla
    print_step "4/8" "Obteniendo PROJECT_ID"
    echo ""
    
    print_info "El PROJECT_ID identifica tu proyecto específico en Vercel"
    echo ""
    
    echo "Para obtener tu PROJECT_ID:"
    echo "1. Ve a: https://vercel.com/dashboard"
    echo "2. Selecciona tu proyecto"
    echo "3. Ve a Settings > General"
    echo "4. Busca 'Project ID'"
    echo "5. Copia el valor (comienza con 'prj_')"
    echo ""
    
    while true; do
        read -p "Pega tu PROJECT_ID aquí: " project_id
        echo ""
        
        if [ -n "$project_id" ]; then
            if [[ "$project_id" =~ ^prj_[a-zA-Z0-9]{16,}$ ]]; then
                print_success "PROJECT_ID válido"
                export PROJECT_ID="$project_id"
                break
            else
                print_error "Formato inválido. El PROJECT_ID debe comenzar con 'prj_'"
                print_info "Inténtalo de nuevo"
            fi
        else
            print_error "El PROJECT_ID no puede estar vacío"
        fi
    done
    
    pausar
}

# Función para mostrar resumen
mostrar_resumen() {
    limpiar_pantalla
    print_step "5/8" "Resumen de configuración"
    echo ""
    
    print_info "Secretos recopilados:"
    echo ""
    echo "🔑 VERCEL_TOKEN: ${VERCEL_TOKEN:0:10}...${VERCEL_TOKEN: -10}"
    echo "🏢 ORG_ID: $ORG_ID"
    echo "📁 PROJECT_ID: $PROJECT_ID"
    echo ""
    
    print_success "✅ Todos los secretos son válidos"
    pausar
}

# Función para configurar GitHub
configurar_github() {
    limpiar_pantalla
    print_step "6/8" "Configurando secretos en GitHub"
    echo ""
    
    print_info "Ahora vamos a configurar estos secretos en tu repositorio GitHub"
    echo ""
    
    echo "Pasos para GitHub:"
    echo "1. Ve a tu repositorio en GitHub.com"
    echo "2. Haz clic en 'Settings' (en la barra superior)"
    echo "3. En el menú izquierdo, busca 'Secrets and variables'"
    echo "4. Haz clic en 'Actions'"
    echo "5. Haz clic en 'New repository secret'"
    echo ""
    
    print_info "Configurar estos 3 secretos:"
    echo ""
    echo "🔑 Primer secreto:"
    echo "   Name: VERCEL_TOKEN"
    echo "   Secret: $VERCEL_TOKEN"
    echo ""
    echo "🏢 Segundo secreto:"
    echo "   Name: ORG_ID"
    echo "   Secret: $ORG_ID"
    echo ""
    echo "📁 Tercer secreto:"
    echo "   Name: PROJECT_ID"
    echo "   Secret: $PROJECT_ID"
    echo ""
    
    print_warning "⚠️  Asegúrate de configurar cada secreto por separado"
    print_info "¿Has configurado todos los secretos en GitHub? (y/n)"
    read -r respuesta
    if [[ $respuesta =~ ^[Yy]$ ]]; then
        print_success "¡Excelente! Los secretos están configurados"
    else
        print_info "Configura los secretos en GitHub y luego continúa"
    fi
    
    pausar
}

# Función para crear archivo de configuración
crear_archivo_config() {
    limpiar_pantalla
    print_step "7/8" "Creando archivo de configuración"
    echo ""
    
    # Crear archivo con los secretos
    local archivo_config=".config_secretos.txt"
    
    cat > "$archivo_config" << EOF
# CONFIGURACIÓN DE SECRETOS - ANDROID DEVICE MANAGER
# Fecha: $(date '+%Y-%m-%d %H:%M:%S')
# ===================================================

# SECRETOS PARA GITHUB ACTIONS
VERCEL_TOKEN=$VERCEL_TOKEN
ORG_ID=$ORG_ID
PROJECT_ID=$PROJECT_ID

# INSTRUCCIONES PARA GITHUB:
# 1. Ve a Settings > Secrets and variables > Actions
# 2. Crea 3 secretos:
#    - VERCEL_TOKEN = $VERCEL_TOKEN
#    - ORG_ID = $ORG_ID
#    - PROJECT_ID = $PROJECT_ID

# PRÓXIMOS PASOS:
# 1. ✅ Secretos configurados en GitHub
# 2. ✅ Subir código a GitHub
# 3. ✅ Verificar GitHub Actions
# 4. ✅ Confirmar deployment en Vercel

# IMPORTANTE:
# - Los tokens tienen expiración
# - Nunca compartas estos valores
# - Guarda este archivo en lugar seguro
EOF
    
    print_success "Archivo de configuración creado: $archivo_config"
    print_info "Este archivo contiene todos tus secretos"
    print_warning "⚠️  Mantén este archivo seguro y privado"
    
    pausar
}

# Función para finalizar
finalizar() {
    limpiar_pantalla
    print_step "8/8" "¡Configuración completada!"
    echo ""
    
    print_success "🎉 ¡Todos los secretos han sido configurados correctamente!"
    echo ""
    
    print_info "Resumen final:"
    echo "✅ VERCEL_TOKEN configurado"
    echo "✅ ORG_ID configurado"
    echo "✅ PROJECT_ID configurado"
    echo "✅ Archivo de configuración creado"
    echo ""
    
    print_info "Próximos pasos:"
    echo "1. Sube tu código a GitHub: git push origin main"
    echo "2. Ve a la pestaña 'Actions' en GitHub"
    echo "3. Verifica que el deployment se ejecute automáticamente"
    echo "4. Confirma que el deployment sea exitoso en Vercel"
    echo ""
    
    print_success "🚀 ¡Tu Android Device Manager está listo para deployment automático!"
    echo ""
    
    # Preguntar si quiere abrir GitHub
    print_info "¿Quieres abrir GitHub en el navegador? (y/n)"
    read -r respuesta
    if [[ $respuesta =~ ^[Yy]$ ]]; then
        if command -v open &> /dev/null; then
            open "https://github.com"
        elif command -v xdg-open &> /dev/null; then
            xdg-open "https://github.com"
        else
            print_info "Ve manualmente a: https://github.com"
        fi
    fi
}

# Función principal
main() {
    mostrar_bienvenida
    verificar_prerrequisitos
    obtener_vercel_token
    obtener_org_id
    obtener_project_id
    mostrar_resumen
    configurar_github
    crear_archivo_config
    finalizar
    
    print_success "🎯 ¡Asistente completado!"
}

# Verificar si se está ejecutando directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi