// services/sri-webservices.js - Integración real con SRI

const soap = require('soap');

class SRIWebServices {
    constructor(ambiente = 'PRUEBAS') {
        this.urls = {
            PRUEBAS: {
                RECEPCION: 'https://celcer.sri.gob.ec/comprobantes-electronicos-ws/RecepcionComprobantesOffline?wsdl',
                AUTORIZACION: 'https://celcer.sri.gob.ec/comprobantes-electronicos-ws/AutorizacionComprobantesOffline?wsdl'
            },
            PRODUCCION: {
                RECEPCION: 'https://cel.sri.gob.ec/comprobantes-electronicos-ws/RecepcionComprobantesOffline?wsdl',
                AUTORIZACION: 'https://cel.sri.gob.ec/comprobantes-electronicos-ws/AutorizacionComprobantesOffline?wsdl'
            }
        };
        this.ambiente = ambiente;
    }

    async enviarComprobante(xmlFirmado) {
        try {
            const client = await soap.createClientAsync(this.urls[this.ambiente].RECEPCION);
            
            const args = {
                xml: Buffer.from(xmlFirmado).toString('base64')
            };
            
            const [result] = await client.validarComprobanteAsync(args);
            return result;
            
        } catch (error) {
            throw new Error(`Error al enviar al SRI: ${error.message}`);
        }
    }

    async consultarAutorizacion(claveAcceso) {
        try {
            const client = await soap.createClientAsync(this.urls[this.ambiente].AUTORIZACION);
            
            const args = {
                claveAccesoComprobante: claveAcceso
            };
            
            const [result] = await client.autorizacionComprobanteAsync(args);
            return result;
            
        } catch (error) {
            throw new Error(`Error al consultar autorización: ${error.message}`);
        }
    }
}

module.exports = SRIWebServices;
