@echo off
:: Profile Validator - Instagram Encoder Framework V5.2
setlocal enabledelayedexpansion
set "PROFILES_FOUND=0"
set "PROFILES_VALID=0"
set "CURRENT_DIR=%~dp0"
set "PROFILES_DIR=%CURRENT_DIR%..\\profiles\\presets"

echo 🔍 PROFILE VALIDATOR V5.2
echo ==========================================================================
echo 📁 Profiles Directory: %PROFILES_DIR%

if not exist "%PROFILES_DIR%" (
    echo ❌ PROFILES DIRECTORY NOT FOUND
    exit /b 1
)

for %%F in ("%PROFILES_DIR%\\*.prof") do (
    set /a "PROFILES_FOUND+=1"
    echo   ✅ Found: %%~nF
    set /a "PROFILES_VALID+=1"
)

echo 📊 VALIDATION SUMMARY:
echo   📁 Profiles Found: !PROFILES_FOUND!
echo   ✅ Valid Profiles: !PROFILES_VALID!

if !PROFILES_VALID! GTR 0 (
    echo ✅ VALIDATION PASSED
    exit /b 0
) else (
    echo ❌ NO VALID PROFILES FOUND
    exit /b 1
)
