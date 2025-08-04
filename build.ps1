param(
    [switch]$NoCdn,
    [switch]$DebugMode
)

$flutterArgs = "build", "web"
$injectArgs = @()
$flutterArgs += "--no-web-resources-cdn"
if ($NoCdn) {
    $flutterArgs += "--no-web-resources-cdn"
    $injectArgs += "--local-assets"
}

if ($DebugMode) {
    $flutterArgs += "--debug"
}

Write-Host "Running Flutter build..."
Write-Host $flutterArgs
flutter $flutterArgs

if ($LASTEXITCODE -ne 0) {
    Write-Host "Flutter build failed" -ForegroundColor Red
    exit 1
}

Write-Host "Injecting loading screen..."
dart run tools\inject_loading_screen.dart $injectArgs

if ($LASTEXITCODE -ne 0) {
    Write-Host "Injection script failed" -ForegroundColor Red
    exit 1
}

Write-Host "Build and injection completed successfully!" -ForegroundColor Green