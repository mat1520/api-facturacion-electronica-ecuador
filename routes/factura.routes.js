// routes/factura.routes.js - Define los endpoints para la facturación

// 1. Importar el Router de Express y los controladores necesarios
const express = require('express');
const { 
    crearFacturaController, 
    consultarFacturaController,
    listarFacturasController 
} = require('../controllers/factura.controller');

// 2. Crear una instancia del Router
const router = express.Router();

// Ruta para listar todas las facturas (útil para desarrollo)
router.get('/', listarFacturasController);

// 3. Definir la ruta POST / que llama a la función crearFacturaController
router.post('/', crearFacturaController);

// 4. Definir la ruta GET /:claveAcceso que llama a la función consultarFacturaController
router.get('/:claveAcceso', consultarFacturaController);

// 5. Exportar el router para ser usado en app.js
module.exports = router;
