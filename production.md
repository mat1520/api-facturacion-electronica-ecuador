# production.md - Checklist para producción

## 🔐 SEGURIDAD

### Autenticación y Autorización
- [ ] Implementar JWT en lugar de API Key simple
- [ ] Rate limiting (express-rate-limit)
- [ ] Validación de origen (CORS configurado)
- [ ] Sanitización de inputs
- [ ] Encriptación de datos sensibles en BD

### Certificados y Claves
- [ ] Certificado P12 válido del SRI
- [ ] Rotación de API Keys
- [ ] Variables de entorno en vault/secrets manager
- [ ] HTTPS obligatorio (SSL/TLS)

## 📊 MONITOREO Y LOGS

### Logging Estructurado
- [ ] Winston o similar para logs
- [ ] Levels: ERROR, WARN, INFO, DEBUG
- [ ] Correlación de requests (request-id)
- [ ] Logs centralizados (ELK Stack)

### Métricas y Monitoreo
- [ ] Prometheus/Grafana
- [ ] Health checks avanzados
- [ ] Alertas automáticas
- [ ] Métricas de negocio (facturas/min, errores SRI)

## 🚀 INFRAESTRUCTURA

### Base de Datos
- [ ] PostgreSQL en cluster
- [ ] Backups automáticos
- [ ] Connection pooling
- [ ] Réplicas de lectura

### Servidor y Despliegue
- [ ] Docker + Kubernetes
- [ ] Load balancer
- [ ] Auto-scaling
- [ ] Blue-green deployment
- [ ] CI/CD pipeline

### Variables de Entorno Producción
```env
NODE_ENV=production
PORT=3000
DATABASE_URL=postgresql://user:pass@prod-db:5432/facturacion
REDIS_URL=redis://prod-redis:6379

# SRI Producción
SRI_ENVIRONMENT=PRODUCCION
EMISOR_RUC=TU_RUC_REAL
P12_BASE64=CERTIFICADO_REAL_BASE64
P12_PASSWORD=PASSWORD_REAL

# Seguridad
JWT_SECRET=super_secret_jwt_key_production
API_RATE_LIMIT=100
CORS_ORIGIN=https://tu-frontend.com

# Monitoreo
LOG_LEVEL=info
SENTRY_DSN=https://tu-sentry-dsn
```

## 🧪 TESTING

### Pruebas
- [ ] Tests unitarios (Jest)
- [ ] Tests de integración
- [ ] Tests E2E
- [ ] Load testing
- [ ] Security testing

### Calidad de Código
- [ ] ESLint + Prettier
- [ ] Husky (pre-commit hooks)
- [ ] SonarQube
- [ ] Dependency checking

## 📋 COMPLIANCE Y LEGAL

### SRI Ecuador
- [ ] Certificado homologado
- [ ] Pruebas con SRI en ambiente de certificación
- [ ] Documentación de cumplimiento
- [ ] Respaldo legal del XML generado

### Datos
- [ ] GDPR/LOPDP compliance
- [ ] Auditoría de accesos
- [ ] Retención de datos
- [ ] Anonimización
