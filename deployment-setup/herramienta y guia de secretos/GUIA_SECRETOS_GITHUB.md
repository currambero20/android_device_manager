# 🔐 Guía Completa: Configurar Secretos de GitHub para Vercel

## 📋 **Secretos Requeridos**

Para configurar el deployment automático de GitHub a Vercel, necesitas configurar estos 3 secretos en tu repositorio GitHub:

### 1. **VERCEL_TOKEN** 🔑
### 2. **ORG_ID** 🏢  
### 3. **PROJECT_ID** 📁

---

## 🎯 **PASO A PASO DETALLADO**

### **PASO 1: Obtener VERCEL_TOKEN**

#### 🔗 **Acceder a la página de tokens de Vercel:**
1. Abre tu navegador
2. Ve a: **https://vercel.com/account/tokens**
3. Inicia sesión si no lo has hecho

#### 🎫 **Crear nuevo token:**
1. Haz clic en **"Create Token"**
2. Dale un nombre descriptivo:
   ```
   Nombre: GitHub Actions Deployment
   Descripción: Token para deployment automático desde GitHub
   ```
3. Haz clic en **"Create"**

#### 📋 **Copiar el token:**
1. Copia el token generado (comienza con `v1_`)
2. **⚠️ IMPORTANTE**: Guarda este token en un lugar seguro
3. No cierres esta ventana hasta completar la configuración

**Ejemplo de token:**
```
v1_1234567890abcdef1234567890abcdef12345678
```

---

### **PASO 2: Obtener ORG_ID y PROJECT_ID**

#### 🏢 **Opción A: Desde el Dashboard de Vercel**

1. **Ve a tu dashboard:**
   - Abre: **https://vercel.com/dashboard**

2. **Selecciona tu proyecto:**
   - Haz clic en el proyecto que quieres configurar

3. **Acceder a Settings:**
   - En la barra lateral, haz clic en **"Settings"**
   - Luego haz clic en **"General"**

4. **Encontrar los IDs:**
   - **ORG_ID**: Busca "Organization ID" en la sección "General"
   - **PROJECT_ID**: Busca "Project ID" en la sección "General"

**Ejemplo de IDs:**
```
ORG_ID: team_1234567890abcdef
PROJECT_ID: prj_1234567890abcdef
```

#### 🛠️ **Opción B: Usando Vercel CLI (Avanzado)**

Si tienes Vercel CLI instalado:

```bash
# Instalar Vercel CLI (si no lo tienes)
npm install -g vercel

# Login en Vercel
vercel login

# Listar proyectos
vercel projects

# Obtener información específica del proyecto
vercel inspect tu-proyecto
```

---

### **PASO 3: Configurar Secretos en GitHub**

#### 🌐 **Acceder al repositorio:**
1. Ve a tu repositorio en GitHub
2. Haz clic en **"Settings"** (en la barra superior del repositorio)

#### 🔐 **Navegar a Secrets:**
1. En el menú lateral izquierdo, busca **"Secrets and variables"**
2. Haz clic en **"Actions"**

#### ➕ **Agregar cada secreto:**

##### **Para VERCEL_TOKEN:**
1. Haz clic en **"New repository secret"**
2. **Name**: `VERCEL_TOKEN`
3. **Secret**: Pega tu token de Vercel
4. Haz clic en **"Add secret"**

##### **Para ORG_ID:**
1. Haz clic en **"New repository secret"**
2. **Name**: `ORG_ID`
3. **Secret**: Pega tu Organization ID
4. Haz clic en **"Add secret"**

##### **Para PROJECT_ID:**
1. Haz clic en **"New repository secret"**
2. **Name**: `PROJECT_ID`
3. **Secret**: Pega tu Project ID
4. Haz clic en **"Add secret"**

#### ✅ **Verificar configuración:**
- Ve a la sección **"Secrets"**
- Deberías ver los 3 secretos configurados:
  - ✅ VERCEL_TOKEN
  - ✅ ORG_ID
  - ✅ PROJECT_ID

---

## 🛠️ **HERRAMIENTAS AUTOMÁTICAS**

### **Opción 1: Script Automático**

Ejecuta el script automático que creé:

```bash
# Hacer el script ejecutable
chmod +x configurar-secretos-github.sh

# Ejecutar el script
./configurar-secretos-github.sh
```

**El script te ayudará con:**
- ✅ Instalación de Vercel CLI (si no lo tienes)
- ✅ Guía paso a paso para obtener cada secreto
- ✅ Validación de los valores ingresados
- ✅ Instrucciones específicas para GitHub

### **Opción 2: Verificación Automática**

Usa el script de verificación:

```bash
bash verificar-secretos.sh
```

**Funciones del verificador:**
- ✅ Verifica que los secretos estén configurados
- ✅ Valida formato de los IDs
- ✅ Simula conexión con Vercel
- ✅ Genera reporte de configuración

---

## 📸 **CAPTURAS DE PANTALLA GUIADAS**

### **Vercel - Crear Token:**
```
┌─────────────────────────────────────────────┐
│ VERCEL TOKENS                              │
├─────────────────────────────────────────────┤
│ [Create Token] ← Click aquí                │
│                                             │
│ Token Name: GitHub Actions Deployment      │
│ Description: Token para deployment auto    │
│                                             │
│ [Create] ← Click para generar              │
└─────────────────────────────────────────────┘
```

### **Vercel - Obtener IDs:**
```
┌─────────────────────────────────────────────┐
│ PROJECT SETTINGS                            │
├─────────────────────────────────────────────┤
│ General                                     │
│                                             │
│ Organization ID: team_1234567890abcdef      ← COPIA ESTO │
│ Project ID: prj_1234567890abcdef            ← COPIA ESTO │
│                                             │
└─────────────────────────────────────────────┘
```

### **GitHub - Configurar Secrets:**
```
┌─────────────────────────────────────────────┐
│ REPOSITORY SECRETS                          │
├─────────────────────────────────────────────┤
│ [New repository secret] ← Click aquí       │
│                                             │
│ Name: VERCEL_TOKEN                          │
│ Secret: v1_1234567890abcdef...             │
│ [Add secret]                               │
│                                             │
│ ORG_ID      [Update] [Delete]             │
│ PROJECT_ID  [Update] [Delete]             │
└─────────────────────────────────────────────┘
```

---

## 🔍 **VERIFICACIÓN FINAL**

### **Checklist de Configuración:**

- [ ] ✅ **VERCEL_TOKEN obtenido** de vercel.com/account/tokens
- [ ] ✅ **ORG_ID obtenido** del dashboard de Vercel
- [ ] ✅ **PROJECT_ID obtenido** del dashboard de Vercel
- [ ] ✅ **VERCEL_TOKEN configurado** en GitHub Secrets
- [ ] ✅ **ORG_ID configurado** en GitHub Secrets
- [ ] ✅ **PROJECT_ID configurado** en GitHub Secrets

### **Prueba de Funcionamiento:**

1. **Sube código a GitHub:**
   ```bash
   git add .
   git commit -m "Test deployment configuration"
   git push origin main
   ```

2. **Verifica GitHub Actions:**
   - Ve a la pestaña **"Actions"** en tu repositorio
   - Deberías ver una acción ejecutándose
   - El log debería mostrar deployment exitoso en Vercel

---

## 🆘 **SOLUCIÓN DE PROBLEMAS**

### **Error: "VERCEL_TOKEN is invalid"**
**Solución:**
- Verifica que copiaste el token completo
- Asegúrate de que no hay espacios extra
- Regenera el token si es necesario

### **Error: "ORG_ID not found"**
**Solución:**
- Verifica que estás en el proyecto correcto
- Revisa que tienes permisos de administrador
- Confirma que el ORG_ID es correcto

### **Error: "PROJECT_ID not found"**
**Solución:**
- Verifica que el proyecto existe en tu dashboard
- Confirma que tienes acceso al proyecto
- Revisa el formato del PROJECT_ID

### **Error: "Permission denied"**
**Solución:**
- Verifica que tienes permisos de administrador en GitHub
- Confirma que el token de Vercel tiene los permisos correctos
- Revisa que la organización permite deployments

---

## 📞 **SOPORTE ADICIONAL**

### **Enlaces Útiles:**
- **Vercel Tokens**: https://vercel.com/account/tokens
- **Vercel Dashboard**: https://vercel.com/dashboard
- **GitHub Actions**: https://github.com/features/actions
- **Vercel CLI Docs**: https://vercel.com/docs/cli

### **Comandos Útiles:**
```bash
# Verificar Vercel CLI
vercel --version

# Login en Vercel
vercel login

# Listar proyectos
vercel projects

# Ver configuración actual
vercel whoami
```

---

## 🎉 **¡CONFIGURACIÓN COMPLETADA!**

Una vez configurados los secretos, tu proyecto tendrá:

✅ **Deployment automático** desde GitHub a Vercel  
✅ **CI/CD pipeline** completo  
✅ **Builds optimizados** en cada push  
✅ **Despliegue automático** en producción  

**🚀 ¡Tu Android Device Manager está listo para deployment automático!**