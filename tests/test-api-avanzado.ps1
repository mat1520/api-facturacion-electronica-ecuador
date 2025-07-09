# 🚀 Script de Pruebas Avanzadas - API Facturación Ecuador
# Desarrollado por: Ariel Melo (@MAT3810)
# URL de la API: https://api-facturacion-electronica-ecuador.onrender.com

# Configuración de colores y estilos
$Host.UI.RawUI.WindowTitle = "🇪🇨 API Facturación Ecuador - Pruebas Completas"

# Función para mostrar banner
function Show-Banner {
    Clear-Host
    Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                 🇪🇨 API FACTURACIÓN ECUADOR                    ║" -ForegroundColor Cyan
    Write-Host "║                     PRUEBAS COMPLETAS                        ║" -ForegroundColor Cyan
    Write-Host "╠══════════════════════════════════════════════════════════════╣" -ForegroundColor Cyan
    Write-Host "║ 🌐 URL: api-facturacion-electronica-ecuador.onrender.com    ║" -ForegroundColor White
    Write-Host "║ 👨‍💻 Desarrollador: Ariel Melo (@MAT3810)                      ║" -ForegroundColor White
    Write-Host "║ 📱 Telegram: @MAT3810                                       ║" -ForegroundColor White
    Write-Host "║ ☕ Donaciones: paypal.me/ArielMelo200                       ║" -ForegroundColor White
    Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

# Función para pruebas HTTP con timeout y retry
function Invoke-ApiTest {
    param(
        [string]$Method = "GET",
        [string]$Uri,
        [hashtable]$Headers = @{},
        [string]$Body = $null,
        [string]$TestName,
        [int]$TimeoutSec = 30,
        [int]$MaxRetries = 3
    )
    
    $attempt = 1
    while ($attempt -le $MaxRetries) {
        try {
            Write-Host "🔄 Intento $attempt/$MaxRetries - $TestName..." -ForegroundColor Yellow
            
            $params = @{
                Method = $Method
                Uri = $Uri
                Headers = $Headers
                TimeoutSec = $TimeoutSec
            }
            
            if ($Body) {
                $params.Body = $Body
                $params.ContentType = "application/json"
            }
            
            $startTime = Get-Date
            $response = Invoke-RestMethod @params
            $endTime = Get-Date
            $responseTime = ($endTime - $startTime).TotalMilliseconds
            
            return @{
                Success = $true
                Data = $response
                ResponseTime = $responseTime
                StatusCode = 200
                Attempt = $attempt
            }
        }
        catch {
            $errorMessage = $_.Exception.Message
            if ($attempt -eq $MaxRetries) {
                return @{
                    Success = $false
                    Error = $errorMessage
                    ResponseTime = -1
                    StatusCode = if ($_.Exception.Response) { $_.Exception.Response.StatusCode } else { "N/A" }
                    Attempt = $attempt
                }
            }
            Write-Host "⚠️  Intento $attempt falló: $errorMessage" -ForegroundColor Red
            Start-Sleep -Seconds 2
            $attempt++
        }
    }
}

# Función para mostrar resultados
function Show-TestResult {
    param(
        [hashtable]$Result,
        [string]$TestName,
        [string]$ExpectedBehavior = "success"
    )
    
    $success = if ($ExpectedBehavior -eq "fail") { !$Result.Success } else { $Result.Success }
    
    if ($success) {
        Write-Host "✅ $TestName - ÉXITO" -ForegroundColor Green
        if ($Result.ResponseTime -gt 0) {
            Write-Host "   ⏱️  Tiempo de respuesta: $([math]::Round($Result.ResponseTime, 2))ms" -ForegroundColor Gray
        }
        if ($Result.Data) {
            Write-Host "   📊 Datos recibidos correctamente" -ForegroundColor Gray
        }
    } else {
        Write-Host "❌ $TestName - FALLO" -ForegroundColor Red
        if ($Result.Error) {
            Write-Host "   ⚠️  Error: $($Result.Error)" -ForegroundColor Red
        }
        if ($Result.StatusCode) {
            Write-Host "   🔢 Status Code: $($Result.StatusCode)" -ForegroundColor Red
        }
    }
    Write-Host ""
    return $success
}

# Variables de configuración
$BASE_URL = "https://api-facturacion-electronica-ecuador.onrender.com"
$API_KEY = "test-api-key-12345"
$HEADERS_WITH_KEY = @{ 
    "x-api-key" = $API_KEY
    "Content-Type" = "application/json"
}
$HEADERS_WITHOUT_KEY = @{ 
    "Content-Type" = "application/json"
}

# Contadores de pruebas
$totalTests = 0
$passedTests = 0
$failedTests = 0

# Mostrar banner inicial
Show-Banner

Write-Host "🚀 Iniciando pruebas completas de la API..." -ForegroundColor Cyan
Write-Host "🎯 URL Base: $BASE_URL" -ForegroundColor White
Write-Host "🔑 API Key: $API_KEY" -ForegroundColor White
Write-Host ""

# ==================== PRUEBAS BÁSICAS ====================
Write-Host "📋 SECCIÓN 1: PRUEBAS BÁSICAS DE CONECTIVIDAD" -ForegroundColor Magenta
Write-Host "=" * 60 -ForegroundColor Magenta

# Test 1: Health Check
$totalTests++
$result1 = Invoke-ApiTest -Uri "$BASE_URL/health" -TestName "Health Check"
if (Show-TestResult -Result $result1 -TestName "Health Check del Sistema") {
    $passedTests++
    if ($result1.Data.status) {
        Write-Host "   📊 Estado del sistema: $($result1.Data.status)" -ForegroundColor Green
        Write-Host "   ⏰ Timestamp: $($result1.Data.timestamp)" -ForegroundColor Green
    }
} else {
    $failedTests++
}

# Test 2: Página Demo
$totalTests++
try {
    $result2 = Invoke-WebRequest -Uri "$BASE_URL/" -TimeoutSec 15
    $demoResult = @{ Success = ($result2.StatusCode -eq 200); Data = $result2; ResponseTime = 0 }
} catch {
    $demoResult = @{ Success = $false; Error = $_.Exception.Message; ResponseTime = -1 }
}

if (Show-TestResult -Result $demoResult -TestName "Página de Demostración") {
    $passedTests++
    Write-Host "   🎨 Página demo accesible en el navegador" -ForegroundColor Green
} else {
    $failedTests++
}

# ==================== PRUEBAS DE AUTENTICACIÓN ====================
Write-Host "🔐 SECCIÓN 2: PRUEBAS DE AUTENTICACIÓN Y SEGURIDAD" -ForegroundColor Magenta
Write-Host "=" * 60 -ForegroundColor Magenta

# Test 3: Sin API Key (debe fallar)
$totalTests++
$result3 = Invoke-ApiTest -Uri "$BASE_URL/api/facturas" -Headers $HEADERS_WITHOUT_KEY -TestName "Sin API Key"
if (Show-TestResult -Result $result3 -TestName "Rechazo sin API Key" -ExpectedBehavior "fail") {
    $passedTests++
    Write-Host "   🛡️ Seguridad funcionando correctamente" -ForegroundColor Green
} else {
    $failedTests++
}

# Test 4: API Key incorrecta (debe fallar)
$totalTests++
$wrongHeaders = @{ "x-api-key" = "clave-incorrecta-12345"; "Content-Type" = "application/json" }
$result4 = Invoke-ApiTest -Uri "$BASE_URL/api/facturas" -Headers $wrongHeaders -TestName "API Key incorrecta"
if (Show-TestResult -Result $result4 -TestName "Rechazo de API Key incorrecta" -ExpectedBehavior "fail") {
    $passedTests++
    Write-Host "   🔒 Validación de API Key funcionando" -ForegroundColor Green
} else {
    $failedTests++
}

# ==================== PRUEBAS DE FUNCIONALIDAD ====================
Write-Host "⚙️ SECCIÓN 3: PRUEBAS DE FUNCIONALIDAD PRINCIPAL" -ForegroundColor Magenta
Write-Host "=" * 60 -ForegroundColor Magenta

# Test 5: Listar facturas
$totalTests++
$result5 = Invoke-ApiTest -Uri "$BASE_URL/api/facturas" -Headers $HEADERS_WITH_KEY -TestName "Listar facturas"
if (Show-TestResult -Result $result5 -TestName "Listar Facturas Existentes") {
    $passedTests++
    if ($result5.Data.facturas) {
        Write-Host "   📄 Facturas encontradas: $($result5.Data.facturas.Count)" -ForegroundColor Green
    }
} else {
    $failedTests++
}

# Test 6: Crear factura válida
$totalTests++
$facturaValida = @{
    comprador = @{
        identificacion = "1234567890"
        razonSocial = "EMPRESA TEST DEMO S.A."
        email = "test@empresa.com"
        telefono = "0987654321"
        direccion = "Av. Amazonas 123, Quito"
    }
    items = @(
        @{
            descripcion = "Producto de Prueba API"
            cantidad = 2
            precioUnitario = 45.75
            descuento = 0
            codigoPrincipal = "PROD-TEST-001"
        },
        @{
            descripcion = "Servicio de Consultoría"
            cantidad = 1
            precioUnitario = 150.00
            descuento = 10.00
            codigoPrincipal = "SERV-CONS-001"
        }
    )
    formaPago = "01"
    moneda = "DOLAR"
    propina = 5.00
    descuentoAdicional = 0
    fechaEmision = (Get-Date).ToString("yyyy-MM-dd")
    ambiente = "PRUEBAS"
} | ConvertTo-Json -Depth 10

$result6 = Invoke-ApiTest -Method "POST" -Uri "$BASE_URL/api/facturas" -Headers $HEADERS_WITH_KEY -Body $facturaValida -TestName "Crear factura"
if (Show-TestResult -Result $result6 -TestName "Crear Factura Válida") {
    $passedTests++
    if ($result6.Data.factura) {
        Write-Host "   🧾 Factura creada: #$($result6.Data.factura.numero)" -ForegroundColor Green
        Write-Host "   🔑 Clave de acceso: $($result6.Data.factura.claveAcceso)" -ForegroundColor Green
        Write-Host "   💰 Total: $($result6.Data.factura.total)" -ForegroundColor Green
        $facturaId = $result6.Data.factura.id
    }
} else {
    $failedTests++
    $facturaId = $null
}

# Test 7: Obtener factura específica
if ($facturaId) {
    $totalTests++
    $result7 = Invoke-ApiTest -Uri "$BASE_URL/api/facturas/$facturaId" -Headers $HEADERS_WITH_KEY -TestName "Obtener factura específica"
    if (Show-TestResult -Result $result7 -TestName "Obtener Factura por ID") {
        $passedTests++
        Write-Host "   🎯 Factura recuperada correctamente" -ForegroundColor Green
    } else {
        $failedTests++
    }
}

# ==================== PRUEBAS DE VALIDACIÓN ====================
Write-Host "🧪 SECCIÓN 4: PRUEBAS DE VALIDACIÓN DE DATOS" -ForegroundColor Magenta
Write-Host "=" * 60 -ForegroundColor Magenta

# Test 8: Datos inválidos (debe fallar)
$totalTests++
$datosInvalidos = @{
    comprador = @{
        identificacion = ""  # Vacío
        razonSocial = ""     # Vacío
    }
    items = @()  # Array vacío
} | ConvertTo-Json -Depth 10

$result8 = Invoke-ApiTest -Method "POST" -Uri "$BASE_URL/api/facturas" -Headers $HEADERS_WITH_KEY -Body $datosInvalidos -TestName "Datos inválidos"
if (Show-TestResult -Result $result8 -TestName "Rechazo de Datos Inválidos" -ExpectedBehavior "fail") {
    $passedTests++
    Write-Host "   ✅ Validaciones funcionando correctamente" -ForegroundColor Green
} else {
    $failedTests++
}

# ==================== PRUEBAS DE RENDIMIENTO ====================
Write-Host "⚡ SECCIÓN 5: PRUEBAS DE RENDIMIENTO" -ForegroundColor Magenta
Write-Host "=" * 60 -ForegroundColor Magenta

# Test 9: Múltiples requests concurrentes
$totalTests++
Write-Host "🚀 Ejecutando 10 requests concurrentes..." -ForegroundColor Yellow

$jobs = @()
$startTime = Get-Date

for ($i = 1; $i -le 10; $i++) {
    $jobs += Start-Job -ScriptBlock {
        param($url, $apiKey)
        try {
            $headers = @{ "x-api-key" = $apiKey }
            $response = Invoke-RestMethod -Uri "$url/health" -Headers $headers -TimeoutSec 10
            return @{ Success = $true; Data = $response }
        } catch {
            return @{ Success = $false; Error = $_.Exception.Message }
        }
    } -ArgumentList $BASE_URL, $API_KEY
}

$results = $jobs | Wait-Job | Receive-Job
$jobs | Remove-Job -Force

$endTime = Get-Date
$totalTime = ($endTime - $startTime).TotalMilliseconds
$successfulRequests = ($results | Where-Object { $_.Success }).Count

if ($successfulRequests -ge 8) {  # Al menos 80% de éxito
    $passedTests++
    Write-Host "✅ Prueba de Rendimiento - ÉXITO" -ForegroundColor Green
    Write-Host "   ⚡ $successfulRequests/10 requests exitosos" -ForegroundColor Green
    Write-Host "   ⏱️  Tiempo total: $([math]::Round($totalTime, 2))ms" -ForegroundColor Green
    Write-Host "   📊 Promedio por request: $([math]::Round($totalTime/10, 2))ms" -ForegroundColor Green
} else {
    $failedTests++
    Write-Host "❌ Prueba de Rendimiento - FALLO" -ForegroundColor Red
    Write-Host "   ⚠️  Solo $successfulRequests/10 requests exitosos" -ForegroundColor Red
}

# ==================== RESUMEN FINAL ====================
Write-Host ""
Write-Host "📊 RESUMEN FINAL DE PRUEBAS" -ForegroundColor Magenta
Write-Host "=" * 60 -ForegroundColor Magenta

$successRate = [math]::Round(($passedTests / $totalTests) * 100, 1)

Write-Host "📈 Estadísticas:" -ForegroundColor White
Write-Host "   Total de pruebas: $totalTests" -ForegroundColor White
Write-Host "   ✅ Exitosas: $passedTests" -ForegroundColor Green
Write-Host "   ❌ Fallidas: $failedTests" -ForegroundColor Red
Write-Host "   📊 Tasa de éxito: $successRate%" -ForegroundColor Cyan

if ($successRate -ge 90) {
    Write-Host ""
    Write-Host "🎉 ¡EXCELENTE! La API está funcionando perfectamente" -ForegroundColor Green
    Write-Host "🚀 Lista para usar en producción" -ForegroundColor Green
} elseif ($successRate -ge 70) {
    Write-Host ""
    Write-Host "✅ BUENO: La API está funcionando bien" -ForegroundColor Yellow
    Write-Host "⚠️  Algunas mejoras recomendadas" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "⚠️  ATENCIÓN: Se detectaron problemas importantes" -ForegroundColor Red
    Write-Host "🔧 Revisión necesaria antes de usar en producción" -ForegroundColor Red
}

Write-Host ""
Write-Host "🔗 Enlaces útiles:" -ForegroundColor Cyan
Write-Host "   🌐 API en vivo: $BASE_URL" -ForegroundColor Blue
Write-Host "   📱 Telegram: @MAT3810" -ForegroundColor Blue
Write-Host "   ☕ Donaciones: https://www.paypal.com/paypalme/ArielMelo200" -ForegroundColor Blue
Write-Host ""
Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
