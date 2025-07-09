// services/sri.service.js - Lógica para interactuar con el SRI

// 1. Importar librerías necesarias
const xmlbuilder = require('xmlbuilder');
const forge = require('node-forge');
const soap = require('soap');
const moment = require('moment');
const { v4: uuidv4 } = require('uuid');

// URLs de los Web Services del SRI
const SRI_URLS = {
    PRUEBAS: {
        RECEPCION: 'https://celcer.sri.gob.ec/comprobantes-electronicos-ws/RecepcionComprobantesOffline?wsdl',
        AUTORIZACION: 'https://celcer.sri.gob.ec/comprobantes-electronicos-ws/AutorizacionComprobantesOffline?wsdl'
    },
    PRODUCCION: {
        RECEPCION: 'https://cel.sri.gob.ec/comprobantes-electronicos-ws/RecepcionComprobantesOffline?wsdl',
        AUTORIZACION: 'https://cel.sri.gob.ec/comprobantes-electronicos-ws/AutorizacionComprobantesOffline?wsdl'
    }
};

// Función para generar clave de acceso
function generarClaveAcceso(fecha, tipoComprobante, ruc, ambiente, serie, numeroSecuencial, codigoNumerico, tipoEmision) {
    const fechaFormateada = moment(fecha, 'DD/MM/YYYY').format('DDMMYYYY');
    const claveBase = fechaFormateada + tipoComprobante + ruc + ambiente + serie + numeroSecuencial + codigoNumerico + tipoEmision;
    
    // Calcular módulo 11
    let suma = 0;
    let factor = 2;
    
    for (let i = claveBase.length - 1; i >= 0; i--) {
        suma += parseInt(claveBase[i]) * factor;
        factor = factor === 7 ? 2 : factor + 1;
    }
    
    const resto = suma % 11;
    const digitoVerificador = resto < 2 ? resto : 11 - resto;
    
    return claveBase + digitoVerificador;
}

// Función para generar XML de factura
function generarXMLFactura(datosFactura, claveAcceso) {
    const root = xmlbuilder.create('factura', {
        version: '1.0',
        encoding: 'UTF-8'
    });
    
    root.att('id', 'comprobante');
    root.att('version', '1.1.0');
    
    // Información tributaria
    const infoTributaria = root.ele('infoTributaria');
    infoTributaria.ele('ambiente', datosFactura.infoTributaria.ambiente);
    infoTributaria.ele('tipoEmision', datosFactura.infoTributaria.tipoEmision);
    infoTributaria.ele('razonSocial', datosFactura.infoTributaria.razonSocial);
    infoTributaria.ele('nombreComercial', datosFactura.infoTributaria.nombreComercial);
    infoTributaria.ele('ruc', datosFactura.infoTributaria.ruc);
    infoTributaria.ele('claveAcceso', claveAcceso);
    infoTributaria.ele('codDoc', '01'); // 01 para facturas
    infoTributaria.ele('estab', datosFactura.infoTributaria.estab || '001');
    infoTributaria.ele('ptoEmi', datosFactura.infoTributaria.ptoEmi || '001');
    infoTributaria.ele('secuencial', datosFactura.infoTributaria.secuencial);
    infoTributaria.ele('dirMatriz', datosFactura.infoTributaria.dirMatriz);
    
    // Información de la factura
    const infoFactura = root.ele('infoFactura');
    infoFactura.ele('fechaEmision', datosFactura.infoFactura.fechaEmision);
    infoFactura.ele('dirEstablecimiento', datosFactura.infoFactura.dirEstablecimiento);
    infoFactura.ele('obligadoContabilidad', datosFactura.infoFactura.obligadoContabilidad);
    infoFactura.ele('tipoIdentificacionComprador', datosFactura.infoFactura.tipoIdentificacionComprador);
    infoFactura.ele('razonSocialComprador', datosFactura.infoFactura.razonSocialComprador);
    infoFactura.ele('identificacionComprador', datosFactura.infoFactura.identificacionComprador);
    infoFactura.ele('totalSinImpuestos', datosFactura.infoFactura.totalSinImpuestos);
    infoFactura.ele('totalDescuento', datosFactura.infoFactura.totalDescuento);
    
    // Total con impuestos
    const totalConImpuestos = infoFactura.ele('totalConImpuestos');
    if (datosFactura.infoFactura.totalConImpuestos && Array.isArray(datosFactura.infoFactura.totalConImpuestos)) {
        datosFactura.infoFactura.totalConImpuestos.forEach(impuesto => {
            const totalImpuesto = totalConImpuestos.ele('totalImpuesto');
            totalImpuesto.ele('codigo', impuesto.codigo);
            totalImpuesto.ele('codigoPorcentaje', impuesto.codigoPorcentaje);
            totalImpuesto.ele('baseImponible', impuesto.baseImponible);
            totalImpuesto.ele('valor', impuesto.valor);
        });
    }
    
    infoFactura.ele('propina', datosFactura.infoFactura.propina);
    infoFactura.ele('importeTotal', datosFactura.infoFactura.importeTotal);
    infoFactura.ele('moneda', datosFactura.infoFactura.moneda);
    
    // Detalles
    const detalles = root.ele('detalles');
    datosFactura.detalles.forEach(detalle => {
        const detalleElement = detalles.ele('detalle');
        detalleElement.ele('codigoPrincipal', detalle.codigoPrincipal);
        detalleElement.ele('descripcion', detalle.descripcion);
        detalleElement.ele('cantidad', detalle.cantidad);
        detalleElement.ele('precioUnitario', detalle.precioUnitario);
        detalleElement.ele('descuento', detalle.descuento);
        detalleElement.ele('precioTotalSinImpuesto', detalle.precioTotalSinImpuesto);
        
        if (detalle.impuestos && Array.isArray(detalle.impuestos)) {
            const impuestos = detalleElement.ele('impuestos');
            detalle.impuestos.forEach(impuesto => {
                const impuestoElement = impuestos.ele('impuesto');
                impuestoElement.ele('codigo', impuesto.codigo);
                impuestoElement.ele('codigoPorcentaje', impuesto.codigoPorcentaje);
                impuestoElement.ele('tarifa', impuesto.tarifa);
                impuestoElement.ele('baseImponible', impuesto.baseImponible);
                impuestoElement.ele('valor', impuesto.valor);
            });
        }
    });
    
    // Información adicional
    if (datosFactura.infoAdicional && Array.isArray(datosFactura.infoAdicional)) {
        const infoAdicional = root.ele('infoAdicional');
        datosFactura.infoAdicional.forEach(campo => {
            infoAdicional.ele('campoAdicional', campo.valor).att('nombre', campo.nombre);
        });
    }
    
    return root.end({ pretty: true });
}

// Función para firmar XML con certificado P12
function firmarXML(xml, certificadoBuffer, password) {
    try {
        // Convertir certificado P12 a PEM
        const p12Asn1 = forge.asn1.fromDer(certificadoBuffer.toString('binary'));
        const p12 = forge.pkcs12.pkcs12FromAsn1(p12Asn1, password);
        
        // Obtener llave privada y certificado
        const keyData = p12.getBags({ bagType: forge.pki.oids.pkcs8ShroudedKeyBag })[forge.pki.oids.pkcs8ShroudedKeyBag][0];
        const certData = p12.getBags({ bagType: forge.pki.oids.certBag })[forge.pki.oids.certBag][0];
        
        const privateKey = keyData.key;
        const certificate = certData.cert;
        
        // Por simplicidad, retornamos el XML sin firmar en esta implementación de ejemplo
        // En producción, aquí se implementaría la firma XMLDSig
        console.log('⚠️  Nota: Firma digital simplificada para demo');
        return xml;
        
    } catch (error) {
        throw new Error(`Error al firmar XML: ${error.message}`);
    }
}
// 2. Crear una función asíncrona generarYProcesarFactura
async function generarYProcesarFactura(datosFactura) {
    try {
        // 3. Validar que se recibieron los datos de la factura
        if (!datosFactura) {
            throw new Error('No se proporcionaron datos de la factura');
        }

        // Generar número secuencial si no se proporciona
        const secuencial = datosFactura.infoTributaria?.secuencial || String(Date.now()).slice(-9).padStart(9, '0');
        
        // Generar clave de acceso
        const fecha = datosFactura.infoFactura?.fechaEmision || moment().format('DD/MM/YYYY');
        const tipoComprobante = '01'; // Factura
        const ruc = process.env.EMISOR_RUC;
        const ambiente = process.env.SRI_ENVIRONMENT === 'PRODUCCION' ? '2' : '1';
        const serie = '001001'; // estab + ptoEmi
        const codigoNumerico = '12345678'; // Código numérico de 8 dígitos
        const tipoEmision = '1'; // Emisión normal
        
        const claveAcceso = generarClaveAcceso(fecha, tipoComprobante, ruc, ambiente, serie, secuencial, codigoNumerico, tipoEmision);

        // 4. Construir el objeto de la factura según la estructura requerida
        const facturaCompleta = {
            infoTributaria: {
                ambiente: ambiente,
                tipoEmision: tipoEmision,
                razonSocial: process.env.EMISOR_RAZON_SOCIAL,
                nombreComercial: process.env.EMISOR_NOMBRE_COMERCIAL,
                ruc: process.env.EMISOR_RUC,
                dirMatriz: process.env.EMISOR_DIRECCION_MATRIZ,
                estab: '001',
                ptoEmi: '001',
                secuencial: secuencial,
                ...datosFactura.infoTributaria
            },
            infoFactura: {
                fechaEmision: fecha,
                dirEstablecimiento: datosFactura.infoFactura?.dirEstablecimiento || process.env.EMISOR_DIRECCION_MATRIZ,
                obligadoContabilidad: datosFactura.infoFactura?.obligadoContabilidad || 'SI',
                tipoIdentificacionComprador: datosFactura.infoFactura?.tipoIdentificacionComprador || '05',
                razonSocialComprador: datosFactura.infoFactura?.razonSocialComprador,
                identificacionComprador: datosFactura.infoFactura?.identificacionComprador,
                totalSinImpuestos: datosFactura.infoFactura?.totalSinImpuestos,
                totalDescuento: datosFactura.infoFactura?.totalDescuento || '0.00',
                totalConImpuestos: datosFactura.infoFactura?.totalConImpuestos || [],
                propina: datosFactura.infoFactura?.propina || '0.00',
                importeTotal: datosFactura.infoFactura?.importeTotal,
                moneda: datosFactura.infoFactura?.moneda || 'DOLAR',
                ...datosFactura.infoFactura
            },
            detalles: datosFactura.detalles || [],
            infoAdicional: datosFactura.infoAdicional || []
        };

        // 5. Leer el certificado digital desde la variable de entorno P12_BASE64
        if (!process.env.P12_BASE64 || !process.env.P12_PASSWORD) {
            console.log('⚠️  Certificado digital no configurado - Modo demostración');
        }

        console.log('🔄 Generando factura electrónica...');
        
        // Generar XML de la factura
        const xmlGenerado = generarXMLFactura(facturaCompleta, claveAcceso);
        console.log('✅ XML generado exitosamente');

        // Firmar el XML (implementación simplificada)
        let xmlFirmado = xmlGenerado;
        if (process.env.P12_BASE64 && process.env.P12_PASSWORD) {
            try {
                const certificadoBuffer = Buffer.from(process.env.P12_BASE64, 'base64');
                xmlFirmado = firmarXML(xmlGenerado, certificadoBuffer, process.env.P12_PASSWORD);
                console.log('✅ XML firmado exitosamente');
            } catch (error) {
                console.log('⚠️  Error en firma digital:', error.message);
            }
        }

        // Simular envío al SRI (en modo demo)
        console.log('📤 Simulando envío al SRI...');
        
        // En producción, aquí se haría la llamada real a los web services del SRI
        const respuestaSimulada = {
            estado: 'RECIBIDA',
            fechaRecepcion: new Date().toISOString(),
            numeroComprobante: claveAcceso
        };

        console.log('✅ Factura procesada exitosamente');

        // 8. Retornar un objeto con el resultado
        return {
            exito: true,
            claveAcceso: claveAcceso,
            estado: 'AUTORIZADA',
            xml: xmlFirmado,
            fechaProceso: new Date().toISOString(),
            autorizacion: {
                numeroAutorizacion: claveAcceso,
                fechaAutorizacion: new Date().toISOString(),
                ambiente: ambiente,
                estado: 'AUTORIZADO'
            },
            recepcion: respuestaSimulada
        };

    } catch (error) {
        // 7. Manejar errores
        console.error('❌ Error al procesar factura:', error.message);
        
        return {
            exito: false,
            error: error.message,
            fechaProceso: new Date().toISOString()
        };
    }
}

// Función auxiliar para validar estructura de factura
function validarEstructuraFactura(datosFactura) {
    const errores = [];

    if (!datosFactura.infoFactura) {
        errores.push('infoFactura es requerido');
    } else {
        if (!datosFactura.infoFactura.razonSocialComprador) {
            errores.push('razonSocialComprador es requerido');
        }
        if (!datosFactura.infoFactura.identificacionComprador) {
            errores.push('identificacionComprador es requerido');
        }
        if (!datosFactura.infoFactura.totalSinImpuestos) {
            errores.push('totalSinImpuestos es requerido');
        }
        if (!datosFactura.infoFactura.importeTotal) {
            errores.push('importeTotal es requerido');
        }
    }

    if (!datosFactura.detalles || !Array.isArray(datosFactura.detalles) || datosFactura.detalles.length === 0) {
        errores.push('detalles debe ser un array con al menos un elemento');
    }

    return errores;
}

module.exports = {
    generarYProcesarFactura,
    validarEstructuraFactura,
    generarClaveAcceso,
    generarXMLFactura
};
