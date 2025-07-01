@echo off
:: Build and Package Tool - Instagram Encoder Framework V5.2

echo 🔨 Building Instagram Encoder Framework...

set "VERSION=5.2.0-modular"
set "BUILD_DIR=releases\v%VERSION%"

:: Create release directory
if not exist "releases" mkdir "releases"
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"

:: Copy source files
echo 📁 Copying source files...
xcopy "src\*" "%BUILD_DIR%\src\" /E /I /Y
xcopy "docs\user-guide\*" "%BUILD_DIR%\docs\" /E /I /Y
copy "README.md" "%BUILD_DIR%\"

:: Create launcher
echo @echo off > "%BUILD_DIR%\InstagramEncoder.bat"
echo cd /d %%~dp0 >> "%BUILD_DIR%\InstagramEncoder.bat"
echo src\core\init.bat %%* >> "%BUILD_DIR%\InstagramEncoder.bat"

echo ✅ Build complete: %BUILD_DIR%
echo 🚀 Ready for distribution
pause