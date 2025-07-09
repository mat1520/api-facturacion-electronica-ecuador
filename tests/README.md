# 🧪 Scripts de Prueba

Scripts automatizados para probar la API de Facturación Electrónica Ecuador.

## 📋 **Scripts Disponibles**

### `test-api.ps1`
Script básico para probar funcionalidades principales:
- Health check
- Crear factura
- Listar facturas
- Consultar factura específica

### `test-api-completo.ps1`
Script intermedio con pruebas adicionales:
- Todas las funcionalidades básicas
- Validación de errores
- Pruebas de autenticación
- Manejo de datos inválidos

### `test-api-avanzado.ps1`
Script avanzado con pruebas exhaustivas:
- Todas las funcionalidades anteriores
- Pruebas de rendimiento
- Validación de XML generado
- Pruebas de límites y casos edge

## 🚀 **Cómo usar**

### Para pruebas locales:
```powershell
# Asegúrate de que la API esté corriendo en http://localhost:3000
npm start

# En otra terminal:
.\tests\test-api.ps1
```

### Para pruebas en producción:
```powershell
# Edita el script y cambia la URL base
$BASE_URL = "https://api-facturacion-electronica-ecuador.onrender.com"
.\tests\test-api-avanzado.ps1
```

## 📝 **Requisitos**

- PowerShell 5.1 o superior
- API ejecutándose (local o remota)
- Conexión a internet (para pruebas remotas)

## 🔧 **Configuración**

Los scripts usan por defecto:
- **API Key**: `demo_api_key_2025_ecuador_sri`
- **URL Local**: `http://localhost:3000`
- **URL Remota**: `https://api-facturacion-electronica-ecuador.onrender.com`

Puedes modificar estos valores editando las variables al inicio de cada script.
