@echo off
:: Build and Package Tool - Instagram Encoder Framework V5.2

echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                    🔨 BUILD SYSTEM - MODULAR EDITION                         ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

set "VERSION=5.2.0-modular"
set "BUILD_DIR=releases\v%VERSION%"

echo 📦 Building Instagram Encoder Framework V%VERSION%...

:: Create release directory
if not exist "releases" mkdir "releases"
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"

:: Copy source files with structure
echo 📁 Copying modular structure...
xcopy "src\*" "%BUILD_DIR%\src\" /E /I /Y >nul
xcopy "docs\user-guide\*" "%BUILD_DIR%\docs\" /E /I /Y >nul
copy "README.md" "%BUILD_DIR%\" >nul

:: Create launcher
echo 📝 Creating launcher...
echo @echo off > "%BUILD_DIR%\InstagramEncoder.bat"
echo title Instagram Encoder Framework V%VERSION% >> "%BUILD_DIR%\InstagramEncoder.bat"
echo cd /d %%~dp0 >> "%BUILD_DIR%\InstagramEncoder.bat"
echo src\core\init.bat %%* >> "%BUILD_DIR%\InstagramEncoder.bat"

:: Create package info
echo 📋 Creating package info...
echo Instagram Encoder Framework V%VERSION% > "%BUILD_DIR%\VERSION.txt"
echo Build Date: %date% %time% >> "%BUILD_DIR%\VERSION.txt"
echo Architecture: Modular >> "%BUILD_DIR%\VERSION.txt"

echo.
echo ✅ Build complete: %BUILD_DIR%
echo 🚀 Ready for distribution
echo 📦 Launch with: %BUILD_DIR%\InstagramEncoder.bat
echo.
pause