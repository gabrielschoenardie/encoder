@echo off
:: Diagnostic Tool for Modular Profile Issues - FIXED PATHS
:: Instagram Encoder Framework V5.2

setlocal enabledelayedexpansion
echo ================================================================================
echo                  🔍 MODULAR PROFILE DIAGNOSTIC TOOL - FIXED
echo ================================================================================
echo.

set "CURRENT_DIR=%~dp0"
echo 📁 Current Directory: %CURRENT_DIR%

:: Try correct path first
set "PROFILES_DIR=%CURRENT_DIR%profiles\presets"
echo 🔍 Trying path: %PROFILES_DIR%

if exist "%PROFILES_DIR%" (
    echo ✅ FOUND! Profiles directory exists
) else (
    echo ❌ Not found, trying alternative paths...

    :: Try with different structure
    set "PROFILES_DIR=%CURRENT_DIR%src\profiles\presets"
    echo 🔍 Trying: !PROFILES_DIR!

    if exist "!PROFILES_DIR!" (
        echo ✅ FOUND! Alternative path works
    ) else (
        echo ❌ Still not found. Let's see what directories exist:
        echo.
        echo 📂 Directories in current location:
        dir /ad
        echo.
        pause
        exit /b 1
    )
)

echo.
echo 📊 PROFILES FOUND IN: %PROFILES_DIR%
echo ========================================================================
set "profile_count=0"
for %%F in ("%PROFILES_DIR%\*.prof") do (
    set /a "profile_count+=1"
    echo   📄 %%~nF.prof (Size: %%~zF bytes)
)

if %profile_count% EQU 0 (
    echo ❌ No .prof files found!
    pause
    exit /b 1
)

echo   📊 Total profiles found: %profile_count%

echo.
echo 🧪 TESTING PROFILE PARSING - REELS PROFILE:
echo ========================================================================

set "TEST_FILE=%PROFILES_DIR%\reels_9_16.prof"
if not exist "%TEST_FILE%" (
    echo ❌ REELS profile not found: %TEST_FILE%
    pause
    exit /b 1
)

echo ✅ Testing file: %TEST_FILE%

:: Show file content first
echo.
echo 📄 REELS PROFILE CONTENT (first 10 lines):
echo ========================================================================
set "line_count=0"
for /f "usebackq tokens=*" %%L in ("%TEST_FILE%") do (
    set /a "line_count+=1"
    echo !line_count!: %%L
    if !line_count! EQU 10 goto :content_done
)
:content_done
echo ========================================================================

echo.
echo 🔧 TESTING PARAMETER EXTRACTION:
echo ========================================================================

:: Reset test variables
set "TEST_PROFILE_NAME="
set "TEST_VIDEO_WIDTH="
set "TEST_VIDEO_HEIGHT="
set "TEST_TARGET_BITRATE="
set "TEST_MAX_BITRATE="
set "TEST_VIDEO_ASPECT="

echo 🔄 Parsing parameters...

:: Parse the file line by line
for /f "usebackq tokens=1,2 delims==" %%A in ("%TEST_FILE%") do (
    set "param_name=%%A"
    set "param_value=%%B"

    :: Skip comments and empty lines
    if not "!param_name:~0,1!"=="#" if defined param_value (
        echo   📝 Found: !param_name! = !param_value!

        if "!param_name!"=="PROFILE_NAME" set "TEST_PROFILE_NAME=!param_value!"
        if "!param_name!"=="VIDEO_WIDTH" set "TEST_VIDEO_WIDTH=!param_value!"
        if "!param_name!"=="VIDEO_HEIGHT" set "TEST_VIDEO_HEIGHT=!param_value!"
        if "!param_name!"=="VIDEO_ASPECT" set "TEST_VIDEO_ASPECT=!param_value!"
        if "!param_name!"=="TARGET_BITRATE" set "TEST_TARGET_BITRATE=!param_value!"
        if "!param_name!"=="MAX_BITRATE" set "TEST_MAX_BITRATE=!param_value!"
    )
)

echo.
echo 📊 PARSED RESULTS:
echo ========================================================================
echo   PROFILE_NAME: "%TEST_PROFILE_NAME%"
echo   VIDEO_WIDTH: "%TEST_VIDEO_WIDTH%"
echo   VIDEO_HEIGHT: "%TEST_VIDEO_HEIGHT%"
echo   VIDEO_ASPECT: "%TEST_VIDEO_ASPECT%"
echo   TARGET_BITRATE: "%TEST_TARGET_BITRATE%"
echo   MAX_BITRATE: "%TEST_MAX_BITRATE%"

echo.
echo 🎯 VALIDATION CHECK:
echo ========================================================================

set "validation_passed=Y"

if not defined TEST_PROFILE_NAME (
    echo ❌ PROFILE_NAME missing or empty
    set "validation_passed=N"
) else (
    echo ✅ PROFILE_NAME: OK
)

if not defined TEST_VIDEO_WIDTH (
    echo ❌ VIDEO_WIDTH missing or empty
    set "validation_passed=N"
) else (
    echo ✅ VIDEO_WIDTH: OK
)

if not defined TEST_VIDEO_HEIGHT (
    echo ❌ VIDEO_HEIGHT missing or empty
    set "validation_passed=N"
) else (
    echo ✅ VIDEO_HEIGHT: OK
)

if not defined TEST_TARGET_BITRATE (
    echo ❌ TARGET_BITRATE missing or empty
    set "validation_passed=N"
) else (
    echo ✅ TARGET_BITRATE: OK
)

echo.
if "%validation_passed%"=="Y" (
    echo ✅ DIAGNOSTIC RESULT: PROFILE PARSING WORKS CORRECTLY!
    echo 💡 The issue is likely in the path configuration in encoderV5.bat
    echo.
    echo 🔧 RECOMMENDED FIX:
    echo    In encoderV5.bat, change the PROFILES_DIR path to:
    echo    set "PROFILES_DIR=%%~dp0..\profiles\presets"
) else (
    echo ❌ DIAGNOSTIC RESULT: PROFILE PARSING HAS ISSUES
    echo 💡 The profile files may be corrupted or have wrong format
)

echo.
echo 🎯 DIAGNOSTIC COMPLETE
echo ========================================================================
pause