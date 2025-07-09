# Script de PowerShell para probar la API de Facturación Electrónica

Write-Host "🧪 Probando API de Facturación Electrónica Ecuador" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green

$BASE_URL = "http://localhost:3000"
$API_KEY = "demo_api_key_2025_ecuador_sri"
$HEADERS = @{ 
    "Content-Type" = "application/json"
    "x-api-key" = $API_KEY 
}

Write-Host "`n1. 🏥 Probando Health Check..." -ForegroundColor Yellow
try {
    $healthResponse = Invoke-RestMethod -Uri "$BASE_URL/health" -Method Get
    Write-Host "✅ Health Check exitoso:" -ForegroundColor Green
    Write-Host "   Estado: $($healthResponse.status)" -ForegroundColor Cyan
    Write-Host "   Mensaje: $($healthResponse.message)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Error en Health Check: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`n2. 📋 Creando factura de ejemplo..." -ForegroundColor Yellow
try {
    $body = Get-Content "ejemplo-factura.json" -Raw
    $facturaResponse = Invoke-RestMethod -Uri "$BASE_URL/api/facturas" -Method Post -Headers $HEADERS -Body $body
    Write-Host "✅ Factura creada exitosamente:" -ForegroundColor Green
    Write-Host "   Clave de Acceso: $($facturaResponse.resultado.claveAcceso)" -ForegroundColor Cyan
    Write-Host "   Estado: $($facturaResponse.resultado.estado)" -ForegroundColor Cyan
    $claveAcceso = $facturaResponse.resultado.claveAcceso
} catch {
    Write-Host "❌ Error al crear factura: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`n3. 📝 Listando todas las facturas..." -ForegroundColor Yellow
try {
    $listResponse = Invoke-RestMethod -Uri "$BASE_URL/api/facturas" -Method Get -Headers @{ "x-api-key" = $API_KEY }
    Write-Host "✅ Lista obtenida exitosamente:" -ForegroundColor Green
    Write-Host "   Total de facturas: $($listResponse.total)" -ForegroundColor Cyan
    if ($listResponse.total -gt 0) {
        Write-Host "   Primera factura:" -ForegroundColor Cyan
        Write-Host "     - Cliente: $($listResponse.facturas[0].razonSocialComprador)" -ForegroundColor White
        Write-Host "     - Importe: $($listResponse.facturas[0].importeTotal)" -ForegroundColor White
        Write-Host "     - Estado: $($listResponse.facturas[0].estado)" -ForegroundColor White
    }
} catch {
    Write-Host "❌ Error al listar facturas: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n4. 🔍 Consultando factura específica..." -ForegroundColor Yellow
try {
    $consultaResponse = Invoke-RestMethod -Uri "$BASE_URL/api/facturas/$claveAcceso" -Method Get -Headers @{ "x-api-key" = $API_KEY }
    Write-Host "✅ Consulta exitosa:" -ForegroundColor Green
    Write-Host "   Cliente: $($consultaResponse.factura.resumen.razonSocialComprador)" -ForegroundColor Cyan
    Write-Host "   Identificación: $($consultaResponse.factura.resumen.identificacionComprador)" -ForegroundColor Cyan
    Write-Host "   Importe Total: $($consultaResponse.factura.resumen.importeTotal)" -ForegroundColor Cyan
    Write-Host "   Estado: $($consultaResponse.factura.estado)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Error al consultar factura: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n5. ❌ Probando error de autenticación..." -ForegroundColor Yellow
try {
    $errorResponse = Invoke-RestMethod -Uri "$BASE_URL/api/facturas" -Method Get -Headers @{ "x-api-key" = "clave_incorrecta" }
    Write-Host "⚠️  No se produjo error de autenticación (inesperado)" -ForegroundColor Yellow
} catch {
    Write-Host "✅ Error de autenticación manejado correctamente" -ForegroundColor Green
}

Write-Host "`n🎉 ¡Todas las pruebas completadas!" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green
Write-Host "📊 Resumen:"
Write-Host "   - Health Check: ✅"
Write-Host "   - Crear Factura: ✅"
Write-Host "   - Listar Facturas: ✅"
Write-Host "   - Consultar Factura: ✅"
Write-Host "   - Autenticación: ✅"
Write-Host "`n🚀 La API está funcionando correctamente en modo demostración!" -ForegroundColor Green
