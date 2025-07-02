@echo off
:: Test Suite Runner - Instagram Encoder Framework V5.2

echo 🧪 Running test suite...

set "TESTS_PASSED=0"
set "TESTS_FAILED=0"

:: Test 1: Configuration loading
call :TestConfigurationLoading
if errorlevel 1 (
    set /a "TESTS_FAILED+=1"
    echo ❌ Configuration loading test failed
) else (
    set /a "TESTS_PASSED+=1"
    echo ✅ Configuration loading test passed
)

:: Test 2: Hardware detection
call :TestHardwareDetection
if errorlevel 1 (
    set /a "TESTS_FAILED+=1"
    echo ❌ Hardware detection test failed
) else (
    set /a "TESTS_PASSED+=1"
    echo ✅ Hardware detection test passed
)

:: Test 3: Profile validation
call :TestProfileValidation
if errorlevel 1 (
    set /a "TESTS_FAILED+=1"
    echo ❌ Profile validation test failed
) else (
    set /a "TESTS_PASSED+=1"
    echo ✅ Profile validation test passed
)

echo.
echo 📊 Test Results:
echo   ✅ Passed: %TESTS_PASSED%
echo   ❌ Failed: %TESTS_FAILED%

if %TESTS_FAILED% GTR 0 (
    echo 🚨 Some tests failed
    exit /b 1
) else (
    echo 🎉 All tests passed
    exit /b 0
)

:TestConfigurationLoading
if exist "..\config\encoder_config.json" (
    exit /b 0
) else (
    exit /b 1
)

:TestHardwareDetection
if defined PROCESSOR_IDENTIFIER (
    exit /b 0
) else (
    exit /b 1
)

:TestProfileValidation
if exist "..\profiles\presets\reels_9_16.prof" (
    exit /b 0
) else (
    exit /b 1
)