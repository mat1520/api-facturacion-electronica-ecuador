# API de Facturación Electrónica para Ecuador

API RESTful para la generación, firma y autorización de facturas electrónicas según los requisitos del SRI de Ecuador. Este proyecto está alojado en [este repositorio de GitHub](https://github.com/mat1520/api-facturacion-electronica-ecuador).

## Características

- ✅ Generación de XML de facturas electrónicas según estándares SRI
- ✅ Cálculo automático de clave de acceso con módulo 11
- ✅ Firma electrónica con certificados P12 (implementación base)
- ✅ Simulación de comunicación con Web Services del SRI
- ✅ Arquitectura modular y escalable
- ✅ Autenticación por API Key
- ✅ Validación de datos de entrada
- ✅ Manejo de errores robusto
- ✅ Modo demo funcional sin certificado
- ✅ Lista para ser desplegada en contenedores Docker

## ⚠️ Modo Demo

La API actualmente funciona en **modo demostración** con las siguientes características:

- ✅ Generación completa de XML de facturas según estándares SRI
- ✅ Cálculo correcto de clave de acceso
- ✅ Estructura de datos completa y válida
- ⚠️ Firma digital simplificada (requiere implementación XMLDSig completa)
- ⚠️ Simulación de envío al SRI (no conecta a web services reales)
- ⚠️ Respuestas simuladas de autorización

Para **producción** se necesita:
1. Implementar firma XMLDSig completa
2. Integración real con web services del SRI
3. Certificado P12 válido del SRI
4. Manejo completo de respuestas del SRI

## Stack Tecnológico

- **Backend:** Node.js, Express.js
- **XML Processing:** xmlbuilder
- **Firma Digital:** node-forge
- **Web Services:** soap
- **Utilidades:** moment, uuid
- **Base de Datos:** PostgreSQL (preparado para conectar)
- **Autenticación:** API Key
- **Entorno:** Variables de entorno con dotenv

## Estructura del Proyecto

```
api-facturacion-electronica-ecuador/
├── app.js                     # Punto de entrada principal
├── package.json               # Dependencias y scripts
├── .env.example              # Plantilla de variables de entorno
├── .gitignore                # Archivos ignorados por Git
├── README.md                 # Documentación del proyecto
├── controllers/              # Controladores (lógica de rutas)
│   └── factura.controller.js
├── routes/                   # Definición de rutas
│   └── factura.routes.js
└── services/                 # Lógica de negocio
    └── sri.service.js
```

## Instalación y Uso Local

### 1. Clonar el repositorio

```bash
git clone https://github.com/mat1520/api-facturacion-electronica-ecuador.git
cd api-facturacion-electronica-ecuador
```

### 2. Instalar dependencias

```bash
npm install
```

### 3. Configurar variables de entorno

Crear un archivo `.env` a partir del `.env.example`:

```bash
cp .env.example .env
```

Llenar las variables de entorno necesarias:

```env
# Configuración del Servidor
PORT=3000

# Configuración de la Base de Datos (PostgreSQL)
DATABASE_URL=postgresql://user:password@localhost:5432/facturacion_db

# Configuración del SRI
SRI_ENVIRONMENT=PRUEBAS
EMISOR_RUC=1234567890001
EMISOR_RAZON_SOCIAL=MI EMPRESA S.A.
EMISOR_NOMBRE_COMERCIAL=MI EMPRESA
EMISOR_DIRECCION_MATRIZ=Av. Principal 123 y Secundaria

# Certificado de Firma Electrónica
P12_BASE64=BASE64_DEL_CERTIFICADO_P12
P12_PASSWORD=password_del_certificado

# API Key para seguridad
API_KEY=mi_api_key_super_secreta_2024
```

### 4. Ejecutar en modo de desarrollo

```bash
npm run dev
```

### 5. Ejecutar en modo producción

```bash
npm start
```

La API estará disponible en `http://localhost:3000`.

## Endpoints

### Health Check
- **GET** `/health` - Verificar estado de la API (sin autenticación)

### Facturas
- **GET** `/api/facturas` - Listar todas las facturas (modo desarrollo)
- **POST** `/api/facturas` - Crear y enviar una nueva factura
- **GET** `/api/facturas/:claveAcceso` - Consultar el estado de una factura

### Autenticación

Todas las solicitudes a los endpoints de `/api/facturas` deben incluir la cabecera `x-api-key` con la clave secreta definida en las variables de entorno.

```bash
curl -H "x-api-key: mi_api_key_super_secreta_2024" \
     -H "Content-Type: application/json" \
     http://localhost:3000/api/facturas
```

## Ejemplos de Uso

### Crear una factura (usando el archivo de ejemplo)

```bash
curl -X POST http://localhost:3000/api/facturas \
  -H "Content-Type: application/json" \
  -H "x-api-key: demo_api_key_2025_ecuador_sri" \
  -d @ejemplo-factura.json
```

### Crear una factura (con datos inline)

```bash
curl -X POST http://localhost:3000/api/facturas \
  -H "Content-Type: application/json" \
  -H "x-api-key: demo_api_key_2025_ecuador_sri" \
  -d '{
    "infoFactura": {
      "razonSocialComprador": "CLIENTE EJEMPLO S.A.",
      "identificacionComprador": "0987654321001",
      "totalSinImpuestos": "100.00",
      "totalConImpuestos": [
        {
          "codigo": "2",
          "codigoPorcentaje": "2",
          "baseImponible": "100.00",
          "valor": "12.00"
        }
      ],
      "importeTotal": "112.00"
    },
    "detalles": [
      {
        "codigoPrincipal": "001",
        "descripcion": "Producto de prueba",
        "cantidad": "1",
        "precioUnitario": "100.00",
        "descuento": "0.00",
        "precioTotalSinImpuesto": "100.00",
        "impuestos": [
          {
            "codigo": "2",
            "codigoPorcentaje": "2",
            "tarifa": "12",
            "baseImponible": "100.00",
            "valor": "12.00"
          }
        ]
      }
    ]
  }'
```

### Listar todas las facturas

```bash
curl -H "x-api-key: demo_api_key_2025_ecuador_sri" \
     http://localhost:3000/api/facturas
```

### Consultar una factura

```bash
curl -H "x-api-key: demo_api_key_2025_ecuador_sri" \
     http://localhost:3000/api/facturas/0807202501123456789000120010010000000011234567813
```

## Respuestas de la API

### Factura creada exitosamente

```json
{
  "mensaje": "Factura procesada exitosamente",
  "resultado": {
    "claveAcceso": "0807202501123456789000120010010000000011234567813",
    "estado": "AUTORIZADA",
    "fechaProceso": "2025-07-08T10:30:00.000Z",
    "autorizacion": {
      "numeroAutorizacion": "0807202501123456789000120010010000000011234567813",
      "fechaAutorizacion": "2025-07-08T10:30:00.000Z",
      "estado": "AUTORIZADO"
    }
  }
}
```

### Error en validación

```json
{
  "error": "Errores de validación en los datos de la factura",
  "errores": [
    "razonSocialComprador es requerido",
    "identificacionComprador es requerido"
  ],
  "codigo": "VALIDACION_FALLIDA"
}
```

## Variables de Entorno Requeridas

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `PORT` | Puerto del servidor | `3000` |
| `DATABASE_URL` | URL de conexión a PostgreSQL | `postgresql://user:pass@host:5432/db` |
| `SRI_ENVIRONMENT` | Entorno del SRI | `PRUEBAS` o `PRODUCCION` |
| `EMISOR_RUC` | RUC del emisor | `1234567890001` |
| `EMISOR_RAZON_SOCIAL` | Razón social del emisor | `MI EMPRESA S.A.` |
| `EMISOR_NOMBRE_COMERCIAL` | Nombre comercial | `MI EMPRESA` |
| `EMISOR_DIRECCION_MATRIZ` | Dirección matriz | `Av. Principal 123` |
| `P12_BASE64` | Certificado P12 en Base64 | `MIIKaAIBAzCCCi...` |
| `P12_PASSWORD` | Contraseña del certificado | `mi_password` |
| `API_KEY` | Clave de autenticación | `demo_api_key_2025_ecuador_sri` |

## Códigos de Error

| Código | Descripción |
|--------|-------------|
| `DATOS_REQUERIDOS` | El cuerpo de la solicitud está vacío |
| `VALIDACION_FALLIDA` | Errores en la validación de datos |
| `ERROR_PROCESAMIENTO` | Error al procesar la factura en el SRI |
| `CLAVE_REQUERIDA` | Clave de acceso no proporcionada |
| `FACTURA_NO_ENCONTRADA` | Factura no existe en el sistema |
| `ERROR_INTERNO` | Error interno del servidor |

## Desarrollo

### Scripts disponibles

- `npm start` - Ejecutar en producción
- `npm run dev` - Ejecutar en desarrollo con nodemon

### Estructura de directorios recomendada

```
├── controllers/    # Lógica de controladores
├── routes/        # Definición de rutas
├── services/      # Lógica de negocio
├── models/        # Modelos de base de datos (futuro)
├── middleware/    # Middlewares personalizados (futuro)
├── utils/         # Utilidades y helpers (futuro)
└── tests/         # Pruebas unitarias (futuro)
```

## Próximas Características

- [ ] Integración completa con PostgreSQL
- [ ] Autenticación JWT
- [ ] Rate limiting
- [ ] Logs estructurados
- [ ] Pruebas unitarias
- [ ] Documentación con Swagger
- [ ] Contenedorización con Docker
- [ ] CI/CD con GitHub Actions

## Contribuir

1. Fork del repositorio
2. Crear rama feature (`git checkout -b feature/nueva-caracteristica`)
3. Commit de cambios (`git commit -am 'Agregar nueva característica'`)
4. Push a la rama (`git push origin feature/nueva-caracteristica`)
5. Crear Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## Soporte

Para soporte técnico o preguntas, crear un issue en el repositorio de GitHub.

---

**Desarrollado con ❤️ para la comunidad ecuatoriana de desarrolladores**
