# Instrucciones de Despliegue

## Ambiente de Desarrollo

1. **Instalar Node.js 16 o superior**
2. **Clonar el repositorio**
3. **Instalar dependencias:** `npm install`
4. **Configurar variables de entorno:** Copiar `.env.example` a `.env`
5. **Ejecutar:** `npm run dev`

## Ambiente de Producción

### Preparación
1. Obtener certificado P12 válido del SRI
2. Configurar todas las variables de entorno
3. Implementar conexión real a PostgreSQL
4. Configurar servidor web (Nginx/Apache)

### Variables de Entorno Críticas
```
SRI_ENVIRONMENT=PRODUCCION
EMISOR_RUC=tu_ruc_real
P12_BASE64=certificado_base64_real
P12_PASSWORD=password_real
API_KEY=clave_super_secreta_produccion
```

## Próximos Pasos para Producción

1. **Implementar firma XMLDSig completa**
2. **Conectar a web services reales del SRI**
3. **Integrar base de datos PostgreSQL**
4. **Implementar rate limiting**
5. **Agregar logs estructurados**
6. **Configurar monitoreo**
7. **Implementar tests unitarios**
8. **Configurar CI/CD**
