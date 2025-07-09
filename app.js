// app.js - Punto de entrada principal de la API

// 1. Importar los módulos necesarios
const express = require('express');
const dotenv = require('dotenv');

// 2. Cargar las variables de entorno desde el archivo .env
dotenv.config();

// 3. Crear una instancia de la aplicación Express
const app = express();

// 4. Definir el puerto del servidor
const PORT = process.env.PORT || 3000;

// 5. Aplicar el middleware express.json() para parsear los cuerpos de las solicitudes
app.use(express.json());

// 6. Crear un middleware simple para la autenticación de API Key
const authenticateApiKey = (req, res, next) => {
    // Leer la clave de la cabecera 'x-api-key'
    const apiKey = req.headers['x-api-key'];
    
    // Comparar con la variable de entorno API_KEY
    if (!apiKey || apiKey !== process.env.API_KEY) {
        return res.status(401).json({ 
            error: 'No autorizado. API Key inválida o faltante.' 
        });
    }
    
    // Si coincide, continuar con el siguiente middleware
    next();
};

// 7. Importar el router de facturas
const facturaRoutes = require('./routes/factura.routes');

// Ruta de health check (sin autenticación)
app.get('/health', (req, res) => {
    res.json({ 
        status: 'OK', 
        message: 'API de Facturación Electrónica Ecuador funcionando correctamente',
        timestamp: new Date().toISOString()
    });
});

// 8. Usar el router importado con el prefijo '/api/facturas', protegido por el middleware de API Key
app.use('/api/facturas', authenticateApiKey, facturaRoutes);

// Middleware para manejar rutas no encontradas
app.use('*', (req, res) => {
    res.status(404).json({
        error: 'Endpoint no encontrado'
    });
});

// Middleware global para manejo de errores
app.use((err, req, res, next) => {
    console.error('Error global:', err.stack);
    res.status(500).json({
        error: 'Error interno del servidor'
    });
});

// 9. Iniciar el servidor y escuchar en el puerto definido
app.listen(PORT, () => {
    console.log(`🚀 Servidor corriendo en puerto ${PORT}`);
    console.log(`🏥 Health check: http://localhost:${PORT}/health`);
    console.log(`📊 API Facturas: http://localhost:${PORT}/api/facturas`);
    console.log(`🌍 Entorno SRI: ${process.env.SRI_ENVIRONMENT || 'No configurado'}`);
});

module.exports = app;
