@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

REM 设置项目根目录
set "PROJECT_DIR=%~dp0"
cd /d "%PROJECT_DIR%"

set FLUTTER_ARGS=build web
set INJECT_ARGS=

REM 参数解析 - 兼容 Unicode
for %%a in (%*) do (
    if "%%~a"=="--no-web-resources-cdn" (
        set FLUTTER_ARGS=!FLUTTER_ARGS! --no-web-resources-cdn
        set INJECT_ARGS=!INJECT_ARGS! --local-assets
    )
    if "%%~a"=="--debug" (
        set FLUTTER_ARGS=!FLUTTER_ARGS! --debug
    )
)

echo Running Flutter build...
echo Command: flutter !FLUTTER_ARGS!
flutter !FLUTTER_ARGS!

if !errorlevel! neq 0 (
    echo Flutter build failed
    exit /b 1
)

echo Flutter build succeeded
echo Injecting loading screen...

REM 检查 Dart 注入脚本是否存在
if not exist "tools\inject_loading_screen.dart" (
    echo Error: tools\inject_loading_screen.dart not found
    exit /b 1
)

echo Command: dart run tools\inject_loading_screen.dart !INJECT_ARGS!
dart run tools\inject_loading_screen.dart !INJECT_ARGS!

if !errorlevel! neq 0 (
    echo Injection script failed
    exit /b 1
)

echo Build and injection completed successfully!
echo You can find the build results in build\web

endlocal