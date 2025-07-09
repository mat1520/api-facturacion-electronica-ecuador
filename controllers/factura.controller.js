// controllers/factura.controller.js - Orquesta las solicitudes de facturación.

// 1. Importar el servicio del SRI
const { generarYProcesarFactura, validarEstructuraFactura } = require('../services/sri.service');

// Simulación de base de datos en memoria (en producción usar PostgreSQL)
const facturasBD = new Map();

// 2. Crear una función asíncrona crearFacturaController
async function crearFacturaController(req, res) {
    try {
        // Validar que el req.body no esté vacío
        if (!req.body || Object.keys(req.body).length === 0) {
            return res.status(400).json({
                error: 'El cuerpo de la solicitud no puede estar vacío',
                codigo: 'DATOS_REQUERIDOS'
            });
        }

        // Validar estructura básica de la factura
        const erroresValidacion = validarEstructuraFactura(req.body);
        if (erroresValidacion.length > 0) {
            return res.status(400).json({
                error: 'Errores de validación en los datos de la factura',
                errores: erroresValidacion,
                codigo: 'VALIDACION_FALLIDA'
            });
        }

        console.log('📋 Procesando nueva factura...');

        // Llamar a generarYProcesarFactura del servicio SRI
        const resultado = await generarYProcesarFactura(req.body);

        // (Simulación de DB) Guardar el resultado en la base de datos
        if (resultado.exito && resultado.claveAcceso) {
            facturasBD.set(resultado.claveAcceso, {
                ...resultado,
                datosOriginales: req.body,
                fechaCreacion: new Date().toISOString(),
                estado: 'PROCESADA'
            });
            console.log(`💾 Factura guardada en BD con clave: ${resultado.claveAcceso}`);
        }

        // Responder al cliente con un código de estado apropiado
        if (resultado.exito) {
            return res.status(201).json({
                mensaje: 'Factura procesada exitosamente',
                resultado: {
                    claveAcceso: resultado.claveAcceso,
                    estado: 'AUTORIZADA',
                    fechaProceso: resultado.fechaProceso,
                    autorizacion: resultado.autorizacion
                }
            });
        } else {
            return res.status(500).json({
                error: 'Error al procesar la factura',
                detalle: resultado.error,
                codigo: 'ERROR_PROCESAMIENTO'
            });
        }

    } catch (error) {
        console.error('❌ Error en crearFacturaController:', error);
        return res.status(500).json({
            error: 'Error interno del servidor',
            detalle: error.message,
            codigo: 'ERROR_INTERNO'
        });
    }
}

// 3. Crear una función asíncrona consultarFacturaController
async function consultarFacturaController(req, res) {
    try {
        // Obtener la claveAcceso desde req.params
        const { claveAcceso } = req.params;

        if (!claveAcceso) {
            return res.status(400).json({
                error: 'Clave de acceso es requerida',
                codigo: 'CLAVE_REQUERIDA'
            });
        }

        console.log(`🔍 Consultando factura con clave: ${claveAcceso}`);

        // (Simulación de DB) Buscar en la base de datos por clave de acceso
        const facturaEncontrada = facturasBD.get(claveAcceso);

        if (!facturaEncontrada) {
            return res.status(404).json({
                error: 'Factura no encontrada',
                claveAcceso: claveAcceso,
                codigo: 'FACTURA_NO_ENCONTRADA'
            });
        }

        // Responder con los datos encontrados
        return res.status(200).json({
            mensaje: 'Factura encontrada',
            factura: {
                claveAcceso: facturaEncontrada.claveAcceso,
                estado: facturaEncontrada.estado,
                fechaCreacion: facturaEncontrada.fechaCreacion,
                fechaProceso: facturaEncontrada.fechaProceso,
                autorizacion: facturaEncontrada.autorizacion,
                // Incluir datos adicionales si es necesario
                resumen: {
                    razonSocialComprador: facturaEncontrada.datosOriginales?.infoFactura?.razonSocialComprador,
                    identificacionComprador: facturaEncontrada.datosOriginales?.infoFactura?.identificacionComprador,
                    importeTotal: facturaEncontrada.datosOriginales?.infoFactura?.importeTotal
                }
            }
        });

    } catch (error) {
        console.error('❌ Error en consultarFacturaController:', error);
        return res.status(500).json({
            error: 'Error interno del servidor',
            detalle: error.message,
            codigo: 'ERROR_INTERNO'
        });
    }
}

// Función auxiliar para listar todas las facturas (útil para desarrollo)
async function listarFacturasController(req, res) {
    try {
        const facturas = Array.from(facturasBD.entries()).map(([clave, factura]) => ({
            claveAcceso: clave,
            estado: factura.estado,
            fechaCreacion: factura.fechaCreacion,
            razonSocialComprador: factura.datosOriginales?.infoFactura?.razonSocialComprador,
            importeTotal: factura.datosOriginales?.infoFactura?.importeTotal
        }));

        return res.status(200).json({
            mensaje: `Se encontraron ${facturas.length} facturas`,
            facturas: facturas,
            total: facturas.length
        });

    } catch (error) {
        console.error('❌ Error en listarFacturasController:', error);
        return res.status(500).json({
            error: 'Error interno del servidor',
            detalle: error.message,
            codigo: 'ERROR_INTERNO'
        });
    }
}

module.exports = {
    crearFacturaController,
    consultarFacturaController,
    listarFacturasController
};
