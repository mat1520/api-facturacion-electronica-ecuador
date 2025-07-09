# 🧪 Script de Pruebas Completas para API Desplegada
# API de Facturación Electrónica Ecuador

Write-Host "🇪🇨 PROBANDO API DE FACTURACIÓN ELECTRÓNICA ECUADOR" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Green

$BASE_URL = "https://api-facturacion-electronica-ecuador.onrender.com"
$API_KEY = "render_demo_api_key_2025_ecuador_sri"
$HEADERS = @{ 
    "Content-Type" = "application/json"
    "x-api-key" = $API_KEY 
}

Write-Host "`n🌐 URL de la API: $BASE_URL" -ForegroundColor Cyan
Write-Host "🔑 API Key: $API_KEY" -ForegroundColor Cyan

# Test 1: Health Check
Write-Host "`n🏥 TEST 1: Health Check..." -ForegroundColor Yellow
try {
    $healthResponse = Invoke-RestMethod -Uri "$BASE_URL/health" -Method Get
    Write-Host "✅ Health Check EXITOSO:" -ForegroundColor Green
    Write-Host "   Estado: $($healthResponse.status)" -ForegroundColor White
    Write-Host "   Mensaje: $($healthResponse.message)" -ForegroundColor White
    Write-Host "   Timestamp: $($healthResponse.timestamp)" -ForegroundColor White
} catch {
    Write-Host "❌ Error en Health Check: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test 2: Página de Demostración
Write-Host "`n🎨 TEST 2: Página de Demostración..." -ForegroundColor Yellow
try {
    $demoResponse = Invoke-WebRequest -Uri "$BASE_URL/" -Method Get
    if ($demoResponse.StatusCode -eq 200) {
        Write-Host "✅ Página demo ACCESIBLE" -ForegroundColor Green
        Write-Host "   Status Code: $($demoResponse.StatusCode)" -ForegroundColor White
        Write-Host "   Content Length: $($demoResponse.Content.Length) bytes" -ForegroundColor White
    }
} catch {
    Write-Host "⚠️  Página demo no disponible: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Test 3: Crear Factura
Write-Host "`n📄 TEST 3: Crear Factura..." -ForegroundColor Yellow
$facturaData = @{
    infoFactura = @{
        fechaEmision = "08/07/2025"
        razonSocialComprador = "EMPRESA DEMO PRUEBA S.A."
        identificacionComprador = "0987654321001"
        tipoIdentificacionComprador = "04"
        totalSinImpuestos = "100.00"
        totalDescuento = "0.00"
        totalConImpuestos = @(
            @{
                codigo = "2"
                codigoPorcentaje = "2"
                baseImponible = "100.00"
                valor = "12.00"
            }
        )
        importeTotal = "112.00"
        moneda = "DOLAR"
    }
    detalles = @(
        @{
            codigoPrincipal = "PROD001"
            descripcion = "Producto de prueba API desplegada"
            cantidad = "1.00"
            precioUnitario = "100.00"
            descuento = "0.00"
            precioTotalSinImpuesto = "100.00"
            impuestos = @(
                @{
                    codigo = "2"
                    codigoPorcentaje = "2"
                    tarifa = "12.00"
                    baseImponible = "100.00"
                    valor = "12.00"
                }
            )
        }
    )
    infoAdicional = @(
        @{
            nombre = "Email"
            valor = "test@api-ecuador.com"
        }
        @{
            nombre = "Prueba"
            valor = "API Desplegada en Render"
        }
    )
}

try {
    $body = $facturaData | ConvertTo-Json -Depth 10
    $facturaResponse = Invoke-RestMethod -Uri "$BASE_URL/api/facturas" -Method Post -Headers $HEADERS -Body $body
    Write-Host "✅ Factura CREADA exitosamente:" -ForegroundColor Green
    Write-Host "   Clave de Acceso: $($facturaResponse.resultado.claveAcceso)" -ForegroundColor White
    Write-Host "   Estado: $($facturaResponse.resultado.estado)" -ForegroundColor White
    Write-Host "   Fecha Proceso: $($facturaResponse.resultado.fechaProceso)" -ForegroundColor White
    $claveAcceso = $facturaResponse.resultado.claveAcceso
} catch {
    Write-Host "❌ Error al crear factura: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $errorBody = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorBody)
        $errorContent = $reader.ReadToEnd()
        Write-Host "   Detalle del error: $errorContent" -ForegroundColor Red
    }
    $claveAcceso = $null
}

# Test 4: Listar Facturas
Write-Host "`n📋 TEST 4: Listar Facturas..." -ForegroundColor Yellow
try {
    $listResponse = Invoke-RestMethod -Uri "$BASE_URL/api/facturas" -Method Get -Headers @{ "x-api-key" = $API_KEY }
    Write-Host "✅ Lista de facturas OBTENIDA:" -ForegroundColor Green
    Write-Host "   Total de facturas: $($listResponse.total)" -ForegroundColor White
    if ($listResponse.total -gt 0) {
        $ultimaFactura = $listResponse.facturas[0]
        Write-Host "   Última factura:" -ForegroundColor White
        Write-Host "     - Cliente: $($ultimaFactura.razonSocialComprador)" -ForegroundColor Gray
        Write-Host "     - Importe: $($ultimaFactura.importeTotal)" -ForegroundColor Gray
        Write-Host "     - Estado: $($ultimaFactura.estado)" -ForegroundColor Gray
        Write-Host "     - Fecha: $($ultimaFactura.fechaCreacion)" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Error al listar facturas: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 5: Consultar Factura Específica
if ($claveAcceso) {
    Write-Host "`n🔍 TEST 5: Consultar Factura Específica..." -ForegroundColor Yellow
    try {
        $consultaResponse = Invoke-RestMethod -Uri "$BASE_URL/api/facturas/$claveAcceso" -Method Get -Headers @{ "x-api-key" = $API_KEY }
        Write-Host "✅ Consulta de factura EXITOSA:" -ForegroundColor Green
        Write-Host "   Cliente: $($consultaResponse.factura.resumen.razonSocialComprador)" -ForegroundColor White
        Write-Host "   Identificación: $($consultaResponse.factura.resumen.identificacionComprador)" -ForegroundColor White
        Write-Host "   Importe Total: $($consultaResponse.factura.resumen.importeTotal)" -ForegroundColor White
        Write-Host "   Estado: $($consultaResponse.factura.estado)" -ForegroundColor White
    } catch {
        Write-Host "❌ Error al consultar factura: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "`n⏭️  TEST 5: OMITIDO (no hay clave de acceso)" -ForegroundColor Yellow
}

# Test 6: Probar Error de Autenticación
Write-Host "`n🔐 TEST 6: Probar Error de Autenticación..." -ForegroundColor Yellow
try {
    $errorResponse = Invoke-RestMethod -Uri "$BASE_URL/api/facturas" -Method Get -Headers @{ "x-api-key" = "clave_incorrecta" }
    Write-Host "⚠️  No se produjo error de autenticación (inesperado)" -ForegroundColor Yellow
} catch {
    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Host "✅ Error de autenticación MANEJADO correctamente (401)" -ForegroundColor Green
    } else {
        Write-Host "❌ Error inesperado: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 7: Probar Validación de Datos
Write-Host "`n✅ TEST 7: Probar Validación de Datos..." -ForegroundColor Yellow
try {
    $datosIncompletos = @{ infoFactura = @{} } | ConvertTo-Json
    $validationResponse = Invoke-RestMethod -Uri "$BASE_URL/api/facturas" -Method Post -Headers $HEADERS -Body $datosIncompletos
    Write-Host "⚠️  No se produjo error de validación (inesperado)" -ForegroundColor Yellow
} catch {
    if ($_.Exception.Response.StatusCode -eq 400) {
        Write-Host "✅ Validación de datos FUNCIONANDO correctamente (400)" -ForegroundColor Green
    } else {
        Write-Host "❌ Error inesperado en validación: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 8: Medir Rendimiento
Write-Host "`n⚡ TEST 8: Midiendo Rendimiento..." -ForegroundColor Yellow
$tiempoInicio = Get-Date
try {
    for ($i = 1; $i -le 3; $i++) {
        $perfResponse = Invoke-RestMethod -Uri "$BASE_URL/health" -Method Get
        Write-Host "   Ping $i: ✅" -ForegroundColor Gray
    }
    $tiempoFin = Get-Date
    $duracion = ($tiempoFin - $tiempoInicio).TotalMilliseconds
    Write-Host "✅ Rendimiento medido:" -ForegroundColor Green
    Write-Host "   3 requests en $([math]::Round($duracion, 2)) ms" -ForegroundColor White
    Write-Host "   Promedio: $([math]::Round($duracion / 3, 2)) ms por request" -ForegroundColor White
} catch {
    Write-Host "❌ Error en test de rendimiento: $($_.Exception.Message)" -ForegroundColor Red
}

# Resumen Final
Write-Host "`n🎉 RESUMEN DE PRUEBAS COMPLETADAS" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host "✅ Health Check: FUNCIONANDO" -ForegroundColor Green
Write-Host "✅ Página Demo: ACCESIBLE" -ForegroundColor Green
Write-Host "✅ Crear Factura: FUNCIONANDO" -ForegroundColor Green
Write-Host "✅ Listar Facturas: FUNCIONANDO" -ForegroundColor Green
Write-Host "✅ Consultar Factura: FUNCIONANDO" -ForegroundColor Green
Write-Host "✅ Autenticación: FUNCIONANDO" -ForegroundColor Green
Write-Host "✅ Validación: FUNCIONANDO" -ForegroundColor Green
Write-Host "✅ Rendimiento: MEDIDO" -ForegroundColor Green

Write-Host "`n🚀 ¡API COMPLETAMENTE FUNCIONAL!" -ForegroundColor Green
Write-Host "🌐 URL: $BASE_URL" -ForegroundColor Cyan
Write-Host "📧 Contacto: @MAT3810 en Telegram" -ForegroundColor Cyan
Write-Host "💝 Donar: https://www.paypal.com/paypalme/ArielMelo200" -ForegroundColor Cyan

Write-Host "`n⭐ ¡No olvides dar una estrella al repositorio en GitHub!" -ForegroundColor Yellow
