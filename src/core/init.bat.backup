@echo off
title Instagram Encoder Framework V5.2 - Modular Edition
color 0A

echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║        🎬 INSTAGRAM ENCODER FRAMEWORK V5.2 - MODULAR EDITION 🎬             ║
echo ║                        🏗️ Professional Architecture 🏗️                      ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

:: Set module paths
set "CORE_PATH=%~dp0"
set "PROJECT_ROOT=%CORE_PATH%..\.."
set "CONFIG_PATH=%PROJECT_ROOT%\src\config"
set "PROFILES_PATH=%PROJECT_ROOT%\src\profiles"
set "UTILS_PATH=%PROJECT_ROOT%\src\utils"

echo 🚀 Initializing modular system...
echo   📁 Project Root: %PROJECT_ROOT%
echo   ⚙️ Config Path: %CONFIG_PATH%
echo   🎬 Profiles Path: %PROFILES_PATH%

:: Load configuration
if exist "%CONFIG_PATH%\encoder_config.json" (
    echo   ✅ Configuration found: encoder_config.json
) else (
    echo   ⚠️ Configuration not found, using defaults
)

:: Initialize hardware detection
if exist "%UTILS_PATH%\hardware_detection.bat" (
    echo   🔬 Loading hardware detection module...
    call "%UTILS_PATH%\hardware_detection.bat"
)

echo.
echo 🎯 Starting main encoder...
echo.

:: Start main encoder
call "%CORE_PATH%\encoderV5.bat" %*

:: Only show completion if encoder actually finished encoding
if errorlevel 1 (
    echo ❌ Encoder ended with error
) else (
    echo 💡 Encoder session ended
)