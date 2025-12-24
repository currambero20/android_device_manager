# 📋 EJEMPLO DE CONFIGURACIÓN DE SECRETOS

## 🎯 **Archivo de Configuración de Ejemplo**

Este es un ejemplo de cómo se ve un archivo de configuración de secretos:

```txt
# CONFIGURACIÓN DE SECRETOS - ANDROID DEVICE MANAGER
# Fecha: 2025-12-25 06:07:23
# ===================================================

# SECRETOS PARA GITHUB ACTIONS
VERCEL_TOKEN=v1_1234567890abcdef1234567890abcdef12345678
ORG_ID=team_1234567890abcdef
PROJECT_ID=prj_1234567890abcdef

# INSTRUCCIONES PARA GITHUB:
# 1. Ve a Settings > Secrets and variables > Actions
# 2. Crea 3 secretos:
#    - VERCEL_TOKEN = v1_1234567890abcdef1234567890abcdef12345678
#    - ORG_ID = team_1234567890abcdef
#    - PROJECT_ID = prj_1234567890abcdef

# PRÓXIMOS PASOS:
# 1. ✅ Secretos configurados en GitHub
# 2. ✅ Subir código a GitHub
# 3. ✅ Verificar GitHub Actions
# 4. ✅ Confirmar deployment en Vercel

# IMPORTANTE:
# - Los tokens tienen expiración
# - Nunca compartas estos valores
# - Guarda este archivo en lugar seguro
```

---

## 🔧 **Formato de Cada Secreto**

### **1. VERCEL_TOKEN**
- **Formato**: `v1_[32+ caracteres alfanuméricos]`
- **Ejemplo**: `v1_1234567890abcdef1234567890abcdef12345678`
- **Dónde obtenerlo**: https://vercel.com/account/tokens

### **2. ORG_ID**
- **Formato**: `team_[16+ caracteres alfanuméricos]`
- **Ejemplo**: `team_1234567890abcdef`
- **Dónde obtenerlo**: Dashboard Vercel > Proyecto > Settings > General

### **3. PROJECT_ID**
- **Formato**: `prj_[16+ caracteres alfanuméricos]`
- **Ejemplo**: `prj_1234567890abcdef`
- **Dónde obtenerlo**: Dashboard Vercel > Proyecto > Settings > General

---

## 🚨 **Notas Importantes**

### ⚠️ **Seguridad**
- **NUNCA** compartas estos valores públicamente
- **NUNCA** los commits en Git
- **GUARDA** el archivo en lugar seguro
- **RENUEVA** los tokens periódicamente

### 🔄 **Renovación**
- Los tokens de Vercel pueden expirar
- Regenera nuevos tokens cuando sea necesario
- Actualiza los secretos en GitHub después de renovar

### 🔐 **Permisos**
- El VERCEL_TOKEN debe tener permisos de deployment
- El usuario debe tener permisos de administrador en Vercel
- El repositorio GitHub debe tener permisos de Actions

---

## 🛠️ **Verificación de Configuración**

Para verificar que todo esté configurado correctamente:

1. **Verifica en GitHub**:
   - Ve a Settings > Secrets and variables > Actions
   - Confirma que los 3 secretos están presentes

2. **Prueba el deployment**:
   - Haz un push a la rama main
   - Ve a Actions en GitHub
   - Verifica que se ejecute el workflow

3. **Verifica en Vercel**:
   - Ve al dashboard de Vercel
   - Confirma que el deployment fue exitoso

---

## 🎯 **Solución de Problemas Comunes**

### **Error: "VERCEL_TOKEN is invalid"**
- Verifica que copiaste el token completo
- Asegúrate de que no hay espacios extra
- Regenera el token en Vercel

### **Error: "ORG_ID not found"**
- Verifica que estás en la organización correcta
- Confirma que tienes permisos de administrador
- Revisa el formato del ORG_ID

### **Error: "PROJECT_ID not found"**
- Verifica que el proyecto existe en tu dashboard
- Confirma que tienes acceso al proyecto
- Revisa el formato del PROJECT_ID

### **Error: "Permission denied"**
- Verifica permisos en GitHub Actions
- Confirma permisos en Vercel
- Revisa que la organización permite deployments

---

## 📞 **Enlaces Útiles**

- **Vercel Tokens**: https://vercel.com/account/tokens
- **Vercel Dashboard**: https://vercel.com/dashboard
- **GitHub Actions**: https://github.com/features/actions
- **Vercel CLI**: https://vercel.com/docs/cli

---

## ✅ **Checklist Final**

- [ ] ✅ VERCEL_TOKEN obtenido y configurado
- [ ] ✅ ORG_ID obtenido y configurado  
- [ ] ✅ PROJECT_ID obtenido y configurado
- [ ] ✅ Los 3 secretos están en GitHub
- [ ] ✅ El código está subido a GitHub
- [ ] ✅ GitHub Actions se ejecuta
- [ ] ✅ Deployment en Vercel es exitoso

**🎉 ¡Configuración completada y verificada!**