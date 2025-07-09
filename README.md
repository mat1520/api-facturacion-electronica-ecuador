# 🇪🇨 API de Facturación Electrónica para Ecuador

<div align="center">

![Ecuador](https://img.shields.io/badge/🇪🇨_Ecuador-SRI_Compatible-blue?style=for-the-badge)
![Version](https://img.shields.io/badge/version-1.0.0-green?style=for-the-badge)
![License](https://img.shields.io/badge/license-MIT-yellow?style=for-the-badge)
![Node](https://img.shields.io/badge/Node.js-18+-339933?style=for-the-badge&logo=node.js&logoColor=white)
![Status](https://img.shields.io/badge/status-🟢_LIVE-brightgreen?style=for-the-badge)

**🚀 API RESTful para la generación, firma y autorización de facturas electrónicas según los requisitos del SRI de Ecuador**

[🌐 **DEMO EN VIVO**](https://api-facturacion-electronica-ecuador.onrender.com) | [📖 **DOCUMENTACIÓN**](#-documentación-de-la-api) | [🤝 **CONTRIBUIR**](#-contribuir) | [💝 **DONAR**](#-apoya-el-proyecto)

---

### 🎯 **Prueba la API ahora mismo:**

```bash
curl https://api-facturacion-electronica-ecuador.onrender.com/health
```

[![Deploy to Render](https://img.shields.io/badge/Deploy%20to-Render-46E3B7?style=for-the-badge&logo=render&logoColor=white)](https://render.com/deploy?repo=https://github.com/mat1520/api-facturacion-electronica-ecuador)
[![Deploy to Railway](https://img.shields.io/badge/Deploy%20to-Railway-0B0D0E?style=for-the-badge&logo=railway&logoColor=white)](https://railway.app)

</div>

---

## 🌟 **Características Principales**

<table>
<tr>
<td width="50%">

### ✅ **Funcionalidades Implementadas**
- 🎯 **Generación de XML** según estándares SRI
- 🔢 **Cálculo automático** de clave de acceso
- 🛡️ **Autenticación** por API Key
- ✅ **Validación completa** de datos
- 📊 **API RESTful** profesional
- 🔄 **Manejo robusto** de errores
- 📱 **Respuestas estructuradas** JSON

</td>
<td width="50%">

### ⚠️ **Modo Demostración**
- 🟢 **XML válido** según SRI
- 🟢 **Clave de acceso** calculada
- 🟢 **Estructura completa** de datos
- 🟡 **Firma digital** simplificada
- 🟡 **Envío al SRI** simulado
- 🟡 **Autorización** simulada

</td>
</tr>
</table>

---

## 🚀 **Demo en Vivo**

### 🌐 **API Desplegada**: https://api-facturacion-electronica-ecuador.onrender.com

<div align="center">

| Endpoint | Método | Descripción | Auth |
|----------|--------|-------------|------|
| `/health` | GET | Health check | ❌ |
| `/` | GET | Página demo | ❌ |
| `/api/facturas` | GET | Listar facturas | ✅ |
| `/api/facturas` | POST | Crear factura | ✅ |
| `/api/facturas/:id` | GET | Consultar factura | ✅ |

**🔑 API Key para pruebas:** `render_demo_api_key_2025_ecuador_sri`

</div>

### 🧪 **Prueba Rápida con cURL:**

```bash
# Health Check
curl https://api-facturacion-electronica-ecuador.onrender.com/health

# Crear Factura
curl -X POST https://api-facturacion-electronica-ecuador.onrender.com/api/facturas \
  -H "Content-Type: application/json" \
  -H "x-api-key: render_demo_api_key_2025_ecuador_sri" \
  -d '{
    "infoFactura": {
      "razonSocialComprador": "CLIENTE DEMO S.A.",
      "identificacionComprador": "0987654321001",
      "totalSinImpuestos": "100.00",
      "importeTotal": "112.00"
    },
    "detalles": [{
      "descripcion": "Producto de prueba",
      "cantidad": "1",
      "precioUnitario": "100.00",
      "precioTotalSinImpuesto": "100.00"
    }]
  }'

# Listar Facturas
curl -H "x-api-key: render_demo_api_key_2025_ecuador_sri" \
     https://api-facturacion-electronica-ecuador.onrender.com/api/facturas
```

### 🔥 **Prueba con JavaScript:**

```javascript
// Crear una factura
const response = await fetch('https://api-facturacion-electronica-ecuador.onrender.com/api/facturas', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'render_demo_api_key_2025_ecuador_sri'
    },
    body: JSON.stringify({
        "infoFactura": {
            "razonSocialComprador": "CLIENTE DEMO S.A.",
            "identificacionComprador": "0987654321001",
            "totalSinImpuestos": "100.00",
            "importeTotal": "112.00"
        },
        "detalles": [{
            "descripcion": "Producto de prueba",
            "cantidad": "1",
            "precioUnitario": "100.00",
            "precioTotalSinImpuesto": "100.00"
        }]
    })
});

const factura = await response.json();
console.log('Factura creada:', factura);
```

---

## 📦 **Stack Tecnológico**

<div align="center">

![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)
![Express](https://img.shields.io/badge/Express-000000?style=for-the-badge&logo=express&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Render](https://img.shields.io/badge/Render-46E3B7?style=for-the-badge&logo=render&logoColor=white)

</div>

| Categoría | Tecnología | Propósito |
|-----------|------------|-----------|
| **Backend** | Node.js + Express.js | Servidor web y API REST |
| **XML Processing** | xmlbuilder | Generación de XML según SRI |
| **Firma Digital** | node-forge | Manejo de certificados P12 |
| **Web Services** | soap | Comunicación con SRI |
| **Base de Datos** | PostgreSQL | Persistencia (preparado) |
| **Seguridad** | API Key + Helmet | Autenticación y protección |
| **Deploy** | Render/Railway | Hosting en la nube |

---

## 🏗️ **Estructura del Proyecto**

```
api-facturacion-electronica-ecuador/
├── 📂 controllers/          # Lógica de controladores
│   └── factura.controller.js
├── 📂 routes/              # Definición de rutas API
│   └── factura.routes.js
├── 📂 services/            # Lógica de negocio
│   ├── sri.service.js
│   └── sri-webservices.js
├── 📂 utils/               # Utilidades y helpers
│   └── xmldsig.js
├── 📂 database/            # Esquemas de base de datos
│   └── schema.sql
├── 📂 public/              # Archivos estáticos
│   └── index.html
├── 📄 app.js               # Punto de entrada principal
├── 📄 package.json         # Dependencias y scripts
├── 📄 Dockerfile           # Containerización
├── 📄 ejemplo-factura.json # Datos de prueba
└── 📄 README.md           # Este archivo
```

---

## 🚀 **Instalación y Uso Local**

### **⚡ Inicio Rápido:**

```bash
# 1. Clonar el repositorio
git clone https://github.com/mat1520/api-facturacion-electronica-ecuador.git
cd api-facturacion-electronica-ecuador

# 2. Instalar dependencias
npm install

# 3. Configurar variables de entorno
cp .env.example .env

# 4. Ejecutar en desarrollo
npm run dev

# 5. ¡Listo! API corriendo en http://localhost:3000
```

### **🔧 Variables de Entorno:**

```env
# Configuración del Servidor
PORT=3000

# Configuración del SRI
SRI_ENVIRONMENT=PRUEBAS
EMISOR_RUC=1234567890001
EMISOR_RAZON_SOCIAL=MI EMPRESA S.A.
EMISOR_NOMBRE_COMERCIAL=MI EMPRESA
EMISOR_DIRECCION_MATRIZ=Av. Principal 123 y Secundaria

# API Key para seguridad
API_KEY=demo_api_key_2025_ecuador_sri

# Certificado P12 (opcional para demo)
P12_BASE64=
P12_PASSWORD=
```

---

## 📖 **Documentación de la API**

### **🔐 Autenticación**

Todas las solicitudes a `/api/facturas` requieren el header:
```
x-api-key: render_demo_api_key_2025_ecuador_sri
```

### **📋 Endpoints Disponibles**

#### **🏥 Health Check**
```http
GET /health
```
**Respuesta:**
```json
{
  "status": "OK",
  "message": "API de Facturación Electrónica Ecuador funcionando correctamente",
  "timestamp": "2025-07-09T03:45:21.123Z"
}
```

#### **📄 Crear Factura**
```http
POST /api/facturas
Content-Type: application/json
x-api-key: render_demo_api_key_2025_ecuador_sri
```

**Body de ejemplo:**
```json
{
  "infoFactura": {
    "fechaEmision": "08/07/2025",
    "razonSocialComprador": "EMPRESA DEMO S.A.",
    "identificacionComprador": "0987654321001",
    "tipoIdentificacionComprador": "04",
    "totalSinImpuestos": "100.00",
    "totalDescuento": "0.00",
    "totalConImpuestos": [
      {
        "codigo": "2",
        "codigoPorcentaje": "2",
        "baseImponible": "100.00",
        "valor": "12.00"
      }
    ],
    "importeTotal": "112.00",
    "moneda": "DOLAR"
  },
  "detalles": [
    {
      "codigoPrincipal": "PROD001",
      "descripcion": "Producto de prueba",
      "cantidad": "1.00",
      "precioUnitario": "100.00",
      "descuento": "0.00",
      "precioTotalSinImpuesto": "100.00",
      "impuestos": [
        {
          "codigo": "2",
          "codigoPorcentaje": "2",
          "tarifa": "12.00",
          "baseImponible": "100.00",
          "valor": "12.00"
        }
      ]
    }
  ]
}
```

**Respuesta exitosa:**
```json
{
  "mensaje": "Factura procesada exitosamente",
  "resultado": {
    "claveAcceso": "0807202501123456789000110010010316726391234567814",
    "estado": "AUTORIZADA",
    "fechaProceso": "2025-07-08T10:30:00.000Z",
    "autorizacion": {
      "numeroAutorizacion": "0807202501123456789000110010010316726391234567814",
      "fechaAutorizacion": "2025-07-08T10:30:00.000Z",
      "estado": "AUTORIZADO"
    }
  }
}
```

#### **📋 Listar Facturas**
```http
GET /api/facturas
x-api-key: render_demo_api_key_2025_ecuador_sri
```

#### **🔍 Consultar Factura**
```http
GET /api/facturas/{claveAcceso}
x-api-key: render_demo_api_key_2025_ecuador_sri
```

---

## 🛠️ **Despliegue**

### **🌐 Deploy en Render (Recomendado)**

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/mat1520/api-facturacion-electronica-ecuador)

1. Haz clic en el botón "Deploy to Render"
2. Conecta tu cuenta de GitHub
3. ¡Automáticamente se desplegará!

### **🚄 Deploy en Railway**

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/deploy)

### **🐳 Deploy con Docker**

```bash
# Construir imagen
docker build -t api-facturacion-ecuador .

# Ejecutar contenedor
docker run -p 3000:3000 \
  -e API_KEY=tu_api_key \
  -e SRI_ENVIRONMENT=PRUEBAS \
  api-facturacion-ecuador
```

---

## 📊 **Estado del Proyecto**

### **✅ Implementado:**
- [x] Generación de XML según estándares SRI
- [x] Cálculo de clave de acceso con módulo 11
- [x] API RESTful completa
- [x] Autenticación por API Key
- [x] Validación de datos de entrada
- [x] Manejo de errores robusto
- [x] Despliegue en la nube
- [x] Documentación completa

### **🚧 En Desarrollo:**
- [ ] Firma XMLDSig real (requiere certificado P12)
- [ ] Integración con web services reales del SRI
- [ ] Base de datos PostgreSQL
- [ ] Sistema de logs avanzado
- [ ] Tests unitarios y de integración

### **🔮 Roadmap:**
- [ ] Autenticación JWT
- [ ] Rate limiting
- [ ] Dashboard web
- [ ] Notificaciones automáticas
- [ ] Exportación a PDF
- [ ] API versioning

---

## 🤝 **Contribuir**

¡Las contribuciones son bienvenidas! 🎉

### **🔄 Proceso:**
1. **Fork** el repositorio
2. **Crea** una rama feature (`git checkout -b feature/nueva-caracteristica`)
3. **Commit** tus cambios (`git commit -m 'feat: nueva característica'`)
4. **Push** a la rama (`git push origin feature/nueva-caracteristica`)
5. **Abre** un Pull Request

### **🐛 Reportar Bugs:**
Abre un [issue en GitHub](https://github.com/mat1520/api-facturacion-electronica-ecuador/issues) con:
- Descripción del bug
- Pasos para reproducir
- Comportamiento esperado vs actual
- Screenshots (si aplica)

### **💡 Sugerir Features:**
¡Todas las ideas son bienvenidas! Abre un issue con la etiqueta `enhancement`.

---

## 📞 **Soporte y Contacto**

<div align="center">

### **🔧 Soporte Técnico**

[![Telegram](https://img.shields.io/badge/Telegram-@MAT3810-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/MAT3810)
[![GitHub Issues](https://img.shields.io/badge/GitHub-Issues-black?style=for-the-badge&logo=github&logoColor=white)](https://github.com/mat1520/api-facturacion-electronica-ecuador/issues)

**Para dudas técnicas, contacta por Telegram: [@MAT3810](https://t.me/MAT3810)**

</div>

### **📚 Recursos Adicionales:**
- [Documentación oficial del SRI](http://www.sri.gob.ec/)
- [Especificaciones técnicas SRI](http://www.sri.gob.ec/web/guest/facturacion-electronica)
- [Esquemas XSD del SRI](http://www.sri.gob.ec/web/guest/facturacion-electronica)

---

## 💝 **Apoya el Proyecto**

<div align="center">

### **☕ ¿Te gusta este proyecto?**

**¡Ayúdanos a mantenerlo y mejorarlo!**

[![PayPal](https://img.shields.io/badge/PayPal-Donar-blue?style=for-the-badge&logo=paypal&logoColor=white)](https://www.paypal.com/paypalme/ArielMelo200?country.x=EC&locale.x=es_XC)

**Tu donación nos ayuda a:**
- 🚀 Mantener la API funcionando 24/7
- 🔧 Desarrollar nuevas características
- 🐛 Corregir bugs y mejorar la calidad
- 📚 Crear mejor documentación
- 🆓 Mantener el proyecto gratuito y open source

[![PayPal Donation](https://www.paypalobjects.com/es_XC/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/paypalme/ArielMelo200?country.x=EC&locale.x=es_XC)

</div>

### **🌟 Otras formas de apoyar:**
- ⭐ **Dale una estrella** a este repositorio
- 🐦 **Comparte** el proyecto en redes sociales
- 📢 **Recomienda** la API a otros desarrolladores
- 🤝 **Contribuye** con código o documentación

---

## 📄 **Licencia**

<div align="center">

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](https://choosealicense.com/licenses/mit/)

**Este proyecto está bajo la Licencia MIT**

Ver el archivo [LICENSE](LICENSE) para más detalles.

</div>

---

## 🏆 **Reconocimientos**

### **💎 Desarrollado por:**
- **[@mat1520](https://github.com/mat1520)** - *Creador y desarrollador principal*

### **🙏 Agradecimientos especiales:**
- Comunidad de desarrolladores ecuatorianos 🇪🇨
- Servicio de Rentas Internas (SRI) por las especificaciones técnicas
- Contribuidores del proyecto open source

### **🎯 Inspiración:**
Este proyecto nace de la necesidad de democratizar la facturación electrónica en Ecuador, proporcionando herramientas gratuitas y de calidad para todos los desarrolladores.

---

<div align="center">

## 🇪🇨 **Hecho con ❤️ para Ecuador**

**Desarrollado con pasión para la comunidad ecuatoriana de desarrolladores**

[![Ecuador](https://img.shields.io/badge/🇪🇨-Hecho_en_Ecuador-blue?style=for-the-badge)](https://github.com/mat1520)
[![Open Source](https://img.shields.io/badge/❤️-Open_Source-red?style=for-the-badge)](https://github.com/mat1520/api-facturacion-electronica-ecuador)

**⭐ Si este proyecto te ayudó, ¡dale una estrella! ⭐**

---

**© 2025 [@mat1520](https://github.com/mat1520) - Todos los derechos reservados**

</div>
