@echo off
:: Structure Diagnostic Tool - Instagram Encoder Framework V5.2
setlocal enabledelayedexpansion

echo.
echo ================================================================================
echo                    PROJECT STRUCTURE DIAGNOSTIC                           
echo                     Instagram Encoder Framework V5.2                        
echo ================================================================================
echo.

set "CURRENT_DIR=%CD%"
echo Current Directory: %CURRENT_DIR%
echo.

echo ================================================================================
echo                         DIRECTORY STRUCTURE ANALYSIS                        
echo ================================================================================
echo.

echo 1. CURRENT DIRECTORY CONTENTS:
echo ------------------------------
dir /B

echo.
echo 2. LOOKING FOR PROJECT ROOT INDICATORS:
echo ---------------------------------------
if exist "src" (
    echo   [FOUND] src\ directory
    if exist "src\profiles" (
        echo   [FOUND] src\profiles\ directory
        if exist "src\profiles\presets" (
            echo   [FOUND] src\profiles\presets\ directory
            echo   [INFO] This appears to be PROJECT ROOT
        ) else (
            echo   [MISSING] src\profiles\presets\ directory
        )
    ) else (
        echo   [MISSING] src\profiles\ directory
    )
) else (
    echo   [MISSING] src\ directory
)

if exist "README.md" echo   [FOUND] README.md (project root indicator)
if exist "setup_profiles.bat" echo   [FOUND] setup_profiles.bat (project root indicator)

echo.
echo 3. CHECKING PARENT DIRECTORIES:
echo -------------------------------

:: Check one level up
set "PARENT_DIR=%CURRENT_DIR%\.."
echo Parent directory (..\): 
for %%I in ("%PARENT_DIR%") do echo   Full path: %%~fI
if exist "..\src\profiles\presets" (
    echo   [FOUND] ..\src\profiles\presets\
) else (
    echo   [MISSING] ..\src\profiles\presets\
)

:: Check two levels up
set "GRANDPARENT_DIR=%CURRENT_DIR%\..\.."
echo Grandparent directory (..\..\):
for %%I in ("%GRANDPARENT_DIR%") do echo   Full path: %%~fI
if exist "..\..\src\profiles\presets" (
    echo   [FOUND] ..\..\src\profiles\presets\
) else (
    echo   [MISSING] ..\..\src\profiles\presets\
)

echo.
echo 4. PROFILE FILES SEARCH:
echo ------------------------

:: Search in current directory
if exist "src\profiles\presets\*.prof" (
    echo PROFILES FOUND IN CURRENT DIRECTORY:
    dir "src\profiles\presets\*.prof" /B
    echo Full paths:
    for %%F in ("src\profiles\presets\*.prof") do echo   %%~fF
)

:: Search one level up
if exist "..\src\profiles\presets\*.prof" (
    echo PROFILES FOUND ONE LEVEL UP:
    dir "..\src\profiles\presets\*.prof" /B
    echo Full paths:
    for %%F in ("..\src\profiles\presets\*.prof") do echo   %%~fF
)

:: Search two levels up
if exist "..\..\src\profiles\presets\*.prof" (
    echo PROFILES FOUND TWO LEVELS UP:
    dir "..\..\src\profiles\presets\*.prof" /B
    echo Full paths:
    for %%F in ("..\..\src\profiles\presets\*.prof") do echo   %%~fF
)

echo.
echo 5. PATH RESOLUTION TEST:
echo -----------------------

:: Test different path resolutions
echo Testing path resolution methods:

if exist "src\profiles\presets" (
    for %%I in ("src\profiles\presets") do (
        echo   Method 1 - Relative: src\profiles\presets
        echo   Method 1 - Resolved: %%~fI
    )
)

if exist "..\..\src\profiles\presets" (
    for %%I in ("..\..\src\profiles\presets") do (
        echo   Method 2 - Relative: ..\..\src\profiles\presets  
        echo   Method 2 - Resolved: %%~fI
    )
)

echo.
echo 6. RECOMMENDED PATHS:
echo --------------------

if exist "src\profiles\presets" (
    set "RECOMMENDED_ROOT=%CURRENT_DIR%"
    set "RECOMMENDED_PROFILES=%CURRENT_DIR%\src\profiles\presets"
    echo   Project Root: !RECOMMENDED_ROOT!
    echo   Profiles Dir: !RECOMMENDED_PROFILES!
    echo   Status: Running from PROJECT ROOT
) else if exist "..\..\src\profiles\presets" (
    for %%I in ("%CURRENT_DIR%\..\..") do set "RECOMMENDED_ROOT=%%~fI"
    set "RECOMMENDED_PROFILES=!RECOMMENDED_ROOT!\src\profiles\presets"
    echo   Project Root: !RECOMMENDED_ROOT!
    echo   Profiles Dir: !RECOMMENDED_PROFILES!
    echo   Status: Running from SUBDIRECTORY (probably src\tools)
) else (
    echo   ERROR: Cannot determine correct paths
    echo   Please run this diagnostic from:
    echo   - Project root directory
    echo   - src\tools directory
)

echo.
echo ================================================================================
echo                            DIAGNOSTIC COMPLETE                            
echo ================================================================================
echo.
pause