-- database/schema.sql - Esquema de base de datos para producción

-- Tabla de empresas emisoras
CREATE TABLE emisores (
    id SERIAL PRIMARY KEY,
    ruc VARCHAR(13) UNIQUE NOT NULL,
    razon_social VARCHAR(300) NOT NULL,
    nombre_comercial VARCHAR(300),
    direccion_matriz TEXT,
    obligado_contabilidad BOOLEAN DEFAULT true,
    certificado_p12 TEXT, -- Base64
    password_certificado VARCHAR(255),
    ambiente VARCHAR(20) DEFAULT 'PRUEBAS',
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de facturas
CREATE TABLE facturas (
    id SERIAL PRIMARY KEY,
    emisor_id INTEGER REFERENCES emisores(id),
    clave_acceso VARCHAR(49) UNIQUE NOT NULL,
    numero_secuencial VARCHAR(9) NOT NULL,
    fecha_emision DATE NOT NULL,
    
    -- Información del comprador
    tipo_identificacion_comprador VARCHAR(2),
    identificacion_comprador VARCHAR(20),
    razon_social_comprador VARCHAR(300),
    
    -- Totales
    total_sin_impuestos DECIMAL(12,2),
    total_descuento DECIMAL(12,2) DEFAULT 0,
    propina DECIMAL(12,2) DEFAULT 0,
    importe_total DECIMAL(12,2),
    
    -- XML y estados
    xml_generado TEXT,
    xml_firmado TEXT,
    estado VARCHAR(50) DEFAULT 'GENERADA', -- GENERADA, FIRMADA, ENVIADA, AUTORIZADA, RECHAZADA
    
    -- Respuestas del SRI
    numero_autorizacion VARCHAR(49),
    fecha_autorizacion TIMESTAMP,
    mensaje_sri TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de detalles de factura
CREATE TABLE factura_detalles (
    id SERIAL PRIMARY KEY,
    factura_id INTEGER REFERENCES facturas(id) ON DELETE CASCADE,
    codigo_principal VARCHAR(25),
    codigo_auxiliar VARCHAR(25),
    descripcion TEXT NOT NULL,
    cantidad DECIMAL(12,6),
    precio_unitario DECIMAL(12,6),
    descuento DECIMAL(12,2) DEFAULT 0,
    precio_total_sin_impuesto DECIMAL(12,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de impuestos por detalle
CREATE TABLE detalle_impuestos (
    id SERIAL PRIMARY KEY,
    detalle_id INTEGER REFERENCES factura_detalles(id) ON DELETE CASCADE,
    codigo VARCHAR(1), -- 2=IVA, 3=ICE, etc.
    codigo_porcentaje VARCHAR(4),
    tarifa DECIMAL(5,4),
    base_imponible DECIMAL(12,2),
    valor DECIMAL(12,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de logs de operaciones
CREATE TABLE logs_operaciones (
    id SERIAL PRIMARY KEY,
    factura_id INTEGER REFERENCES facturas(id),
    operacion VARCHAR(50), -- GENERACION, FIRMA, ENVIO, CONSULTA
    estado VARCHAR(20), -- EXITOSO, ERROR
    mensaje TEXT,
    datos_adicionales JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices para optimización
CREATE INDEX idx_facturas_clave_acceso ON facturas(clave_acceso);
CREATE INDEX idx_facturas_emisor ON facturas(emisor_id);
CREATE INDEX idx_facturas_fecha ON facturas(fecha_emision);
CREATE INDEX idx_facturas_estado ON facturas(estado);
CREATE INDEX idx_logs_factura ON logs_operaciones(factura_id);
CREATE INDEX idx_logs_fecha ON logs_operaciones(created_at);
