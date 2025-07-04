@echo off
:: Teste de Integração Modular - Fixed Paths
:: Instagram Encoder Framework V5.2 - Integration Test
setlocal enabledelayedexpansion

title Modular Integration Test - Fixed
color 0A

echo.
echo ================================================================================
echo                         🧪 MODULAR INTEGRATION TEST                          
echo                      Instagram Encoder Framework V5.2                        
echo ================================================================================
echo.

:: Auto-detect if running from src/ or project root
set "CURRENT_DIR=%CD%"
echo 📍 Current Directory: %CURRENT_DIR%

:: Detect project structure and set correct paths
if exist "core\encoderV5.bat" (
    echo 📍 Detected: Running from src\ directory
    set "ENCODER_FILE=core\encoderV5.bat"
    set "PROFILES_DIR=profiles\presets"
    set "VALIDATOR=tools\validate_profiles_fixed.bat"
    set "PROJECT_ROOT=%CURRENT_DIR%\.."
) else if exist "src\core\encoderV5.bat" (
    echo 📍 Detected: Running from project root
    set "ENCODER_FILE=src\core\encoderV5.bat"
    set "PROFILES_DIR=src\profiles\presets"
    set "VALIDATOR=src\tools\validate_profiles_fixed.bat"
    set "PROJECT_ROOT=%CURRENT_DIR%"
) else (
    echo ❌ ERROR: Cannot detect project structure
    echo Please run from either:
    echo   - Project root: C:\Users\Gabriel\encoder\
    echo   - Src directory: C:\Users\Gabriel\encoder\src\
    pause
    exit /b 1
)

echo 📂 Project Root: %PROJECT_ROOT%
echo 📄 Encoder File: %ENCODER_FILE%
echo 📁 Profiles Dir: %PROFILES_DIR%
echo 🔧 Validator: %VALIDATOR%
echo.

echo 📋 Integration Test Plan:
echo ==========================================================================
echo   1. Verify encoder file exists and is modified
echo   2. Check modular structure is in place
echo   3. Test validator functionality
echo   4. Test encoder startup
echo   5. Validate modular system detection
echo.

set "TESTS_PASSED=0"
set "TESTS_FAILED=0"

:: Test 1: Encoder file
echo 🧪 Test 1: Encoder File Verification
echo ==========================================================================
if exist "%ENCODER_FILE%" (
    echo   ✅ Encoder file exists: %ENCODER_FILE%
    
    :: Check file size to ensure it's not empty
    for %%A in ("%ENCODER_FILE%") do set "file_size=%%~zA"
    echo   📊 File size: !file_size! bytes
    
    if !file_size! GTR 10000 (
        echo   ✅ File size appears normal
        
        :: Check if modular variables were added
        findstr "MODULAR_PROFILES_DIR" "%ENCODER_FILE%" >nul
        if not errorlevel 1 (
            echo   ✅ Modular variables detected in encoder
            set /a "TESTS_PASSED+=1"
        ) else (
            echo   ❌ Modular variables not found in encoder
            echo   💡 Integration may not be complete
            set /a "TESTS_FAILED+=1"
        )
    ) else (
        echo   ❌ File size too small - may be corrupted
        set /a "TESTS_FAILED+=1"
    )
) else (
    echo   ❌ Encoder file not found: %ENCODER_FILE%
    set /a "TESTS_FAILED+=1"
)
echo.

:: Test 2: Modular structure
echo 🧪 Test 2: Modular Structure Verification  
echo ==========================================================================
if exist "%PROFILES_DIR%" (
    echo   ✅ Profiles directory exists: %PROFILES_DIR%
    
    set "PROFILE_COUNT=0"
    for %%F in ("%PROFILES_DIR%\*.prof") do set /a "PROFILE_COUNT+=1"
    
    if !PROFILE_COUNT! GEQ 4 (
        echo   ✅ Found !PROFILE_COUNT! profile files
        echo   📋 Profile files:
        for %%F in ("%PROFILES_DIR%\*.prof") do echo     • %%~nF
        set /a "TESTS_PASSED+=1"
    ) else (
        echo   ❌ Insufficient profile files found: !PROFILE_COUNT!
        echo   💡 Expected at least 4 profiles (reels, feed, cinema, speedramp)
        set /a "TESTS_FAILED+=1"
    )
) else (
    echo   ❌ Profiles directory not found: %PROFILES_DIR%
    echo   💡 Run setup_profiles.bat to create missing profiles
    set /a "TESTS_FAILED+=1"
)
echo.

:: Test 3: Validator
echo 🧪 Test 3: Validator Functionality Test
echo ==========================================================================
if exist "%VALIDATOR%" (
    echo   ✅ Validator exists: %VALIDATOR%
    
    echo   🔍 Running validator test...
    call "%VALIDATOR%" >nul 2>&1
    set "VALIDATOR_EXIT=%ERRORLEVEL%"
    
    if !VALIDATOR_EXIT! EQU 0 (
        echo   ✅ Validator executed successfully (exit code: 0)
        set /a "TESTS_PASSED+=1"
    ) else (
        echo   ❌ Validator failed with exit code: !VALIDATOR_EXIT!
        echo   💡 Try running validator manually to debug
        set /a "TESTS_FAILED+=1"
    )
) else (
    echo   ❌ Validator not found: %VALIDATOR%
    echo   💡 Validator should be in src\tools\ directory
    set /a "TESTS_FAILED+=1"
)
echo.

:: Test 4: Integration functions check
echo 🧪 Test 4: Integration Function Check
echo ==========================================================================

if not exist "%ENCODER_FILE%" (
    echo   ❌ Cannot check functions - encoder file not found
    set /a "TESTS_FAILED+=1"
) else (
    :: Check for key integration functions
    set "INTEGRATION_FUNCTIONS=0"
    
    echo   🔍 Checking for integration functions...
    
    findstr /C:"LoadModularProfile" "%ENCODER_FILE%" >nul
    if not errorlevel 1 (
        echo   ✅ LoadModularProfile function found
        set /a "INTEGRATION_FUNCTIONS+=1"
    ) else (
        echo   ❌ LoadModularProfile function missing
    )
    
    findstr /C:"DetectModularStructure" "%ENCODER_FILE%" >nul
    if not errorlevel 1 (
        echo   ✅ DetectModularStructure function found
        set /a "INTEGRATION_FUNCTIONS+=1"
    ) else (
        echo   ❌ DetectModularStructure function missing
    )
    
    findstr /C:"RunModularValidation" "%ENCODER_FILE%" >nul
    if not errorlevel 1 (
        echo   ✅ RunModularValidation function found
        set /a "INTEGRATION_FUNCTIONS+=1"
    ) else (
        echo   ❌ RunModularValidation function missing
    )
    
    findstr /C:"ParseModularProfileFile" "%ENCODER_FILE%" >nul
    if not errorlevel 1 (
        echo   ✅ ParseModularProfileFile function found
        set /a "INTEGRATION_FUNCTIONS+=1"
    ) else (
        echo   ❌ ParseModularProfileFile function missing
    )
    
    echo   📊 Functions found: !INTEGRATION_FUNCTIONS!/4
    
    if !INTEGRATION_FUNCTIONS! GEQ 3 (
        echo   ✅ Most integration functions detected
        set /a "TESTS_PASSED+=1"
    ) else (
        echo   ❌ Missing critical integration functions
        echo   💡 Integration appears incomplete
        set /a "TESTS_FAILED+=1"
    )
)
echo.

:: Test Results
echo ================================================================================
echo                              🧪 TEST RESULTS                                  
echo ================================================================================
echo.

set /a "TOTAL_TESTS=%TESTS_PASSED%+%TESTS_FAILED%"
echo 📊 Test Summary:
echo   🧪 Total Tests: %TOTAL_TESTS%
echo   ✅ Tests Passed: %TESTS_PASSED%
echo   ❌ Tests Failed: %TESTS_FAILED%
echo.

if %TESTS_FAILED% EQU 0 (
    echo 🎉 ALL AUTOMATED TESTS PASSED!
    echo ✅ Modular integration appears successful
    echo.
    echo 🎯 Next Steps:
    echo   1. Run manual encoder test: %ENCODER_FILE%
    echo   2. Verify modular features work correctly
    echo   3. Test profile loading from files
    echo   4. Try encoding with modular profiles
    echo.
    echo ================================================================================
    echo                          🎊 INTEGRATION SUCCESSFUL! 🎊                          
    echo           Your encoder now supports modular, file-based profiles!                   
    echo ================================================================================
) else (
    echo ⚠️ SOME TESTS FAILED
    echo 🔧 Please review the failed tests and fix issues
    echo.
    echo 💡 Common Issues and Solutions:
    if %TESTS_FAILED% EQU %TOTAL_TESTS% (
        echo   🔍 ALL TESTS FAILED - This suggests:
        echo     • Integration code has not been added to encoder yet
        echo     • Wrong file paths or locations
        echo     • Files may be missing or corrupted
        echo.
        echo   🔧 Recommended Actions:
        echo     1. Verify you've made the code changes to encoderV5.bat
        echo     2. Check that profile files exist in correct location
        echo     3. Ensure validator script works independently
        echo     4. Review implementation checklist step by step
    ) else (
        echo   🔍 PARTIAL FAILURE - Some components working:
        echo     • Review specific failed test messages above
        echo     • Fix individual issues one by one
        echo     • Re-run test after each fix
    )
    echo.
    echo ================================================================================
    echo                        INTEGRATION NEEDS ATTENTION                         
    echo   Please fix the failed tests before using the modular system               
    echo ================================================================================
)

echo.
echo 📝 Integration test completed
echo 🔍 For detailed debugging, check each component individually
pause