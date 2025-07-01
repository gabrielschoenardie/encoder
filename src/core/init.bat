@echo off
:: Instagram Encoder Framework - Modular Initialization
:: Version 5.2.0-modular

echo 🚀 Initializing Instagram Encoder Framework V5.2 - Modular Edition...

:: Set module paths
set "CORE_PATH=%~dp0"
set "PROJECT_ROOT=%CORE_PATH%..\.."
set "CONFIG_PATH=%PROJECT_ROOT%\src\config"
set "PROFILES_PATH=%PROJECT_ROOT%\src\profiles"
set "UTILS_PATH=%PROJECT_ROOT%\src\utils"

:: Load configuration
if exist "%CONFIG_PATH%\encoder_config.json" (
    echo ✅ Configuration loaded
) else (
    echo ❌ Configuration not found
    exit /b 1
)

:: Initialize modules
call "%CORE_PATH%\encoderV5.bat" %*