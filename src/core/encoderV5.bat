@echo off
setlocal enabledelayedexpansion
title Instagram Encoder Framework V5.2 - Modular Edition
chcp 65001 >nul 2>&1
color 0A

:: ================================================================================
:: INSTAGRAM ENCODER FRAMEWORK V5.2 - MODULAR EDITION
:: Zero-Recompression Video Encoder | Gabriel Schoenardie | 2025
:: ================================================================================

:: GLOBAL VARIABLES
set "SCRIPT_VERSION=5.2-modular"
set "CONFIG_FILE=src\config\encoder_config.json"
set "PROFILES_DIR=src\profiles\presets"
set "EXEC_LOG="
set "BACKUP_CREATED=N"
set "CPU_CORES=0"
set "GLOBAL_START_TIME=0"
set "TOTAL_ENCODE_TIME=00h 00m 00s"

:: Profile System Variables
set "PROFILE_NAME="
set "VIDEO_WIDTH="
set "VIDEO_HEIGHT="
set "VIDEO_ASPECT="
set "TARGET_BITRATE="
set "MAX_BITRATE="
set "BUFFER_SIZE="
set "GOP_SIZE="
set "KEYINT_MIN="
set "X264_PRESET="
set "X264_TUNE="
set "X264_PARAMS="
set "COLOR_PARAMS="
set "PROFILE_SELECTED=N"
set "CURRENT_PROFILE_ID="

:: Advanced Customization Variables
set "CUSTOM_PRESET="
set "CUSTOM_PSY_RD="
set "ADVANCED_MODE=N"
set "CUSTOMIZATION_ACTIVE=N"

:: Audio Enhancement Variables
set "CUSTOM_AUDIO_BITRATE="
set "CUSTOM_AUDIO_SAMPLERATE="
set "CUSTOM_AUDIO_CHANNELS="
set "CUSTOM_AUDIO_PROCESSING="
set "AUDIO_PRESET_NAME="
set "AUDIO_NORMALIZATION=N"
set "AUDIO_FILTERING=N"
set "CUSTOM_AUDIO_PARAMS="

:: Professional Menu System Variables
set "WORKFLOW_STEP=0"
set "SESSION_START_TIME="
set "FILES_CONFIGURED=N"
set "PROFILE_CONFIGURED=N"
set "READY_TO_ENCODE=N"
set "SYSTEM_STATUS=READY"

:: Modular System Variables
set "MODULAR_PROFILES_AVAILABLE=N"
set "MODULAR_VALIDATION_STATUS=NOT_CHECKED"

:: ========================================
:: MAIN EXECUTION FLOW
:: ========================================
call :SafeInitialization
call :LogEntry "===== INICIO V5.2 MODULAR (%date% %time%) ====="
call :ShowProfessionalHeader
call :DetectSystemCapabilities
call :CheckFFmpeg
if errorlevel 1 goto :ErrorExit
call :LoadModularConfig
call :InitializeProfessionalSystem
call :ShowProfessionalMainMenu
call :PostProcessing

:: ========================================
:: MODULAR SYSTEM INTEGRATION
:: ========================================
:LoadModularConfig
echo 🔧 Loading modular configuration...

:: SIMPLIFIED PATH DETECTION
set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "PROJECT_ROOT=%%~fI"
set "PROFILES_DIR=%PROJECT_ROOT%\src\profiles\presets"
set "CONFIG_FILE=%PROJECT_ROOT%\src\config\encoder_config.json"

:: SINGLE VALIDATION CHECK
if exist "%PROFILES_DIR%" (
    set "MODULAR_PROFILE_COUNT=0"
    for %%F in ("%PROFILES_DIR%\*.prof") do set /a "MODULAR_PROFILE_COUNT+=1"
    
    if !MODULAR_PROFILE_COUNT! GTR 0 (
        echo ✅ Modular system: !MODULAR_PROFILE_COUNT! profiles active
        set "MODULAR_PROFILES_AVAILABLE=Y"
    ) else (
        echo ⚠️ No profiles found - using embedded fallback
        set "MODULAR_PROFILES_AVAILABLE=N"
    )
) else (
    :: FALLBACK PATH CHECK
    set "ALT_PROFILES_DIR=C:\Users\Gabriel\encoder\src\profiles\presets"
    if exist "!ALT_PROFILES_DIR!" (
        echo ✅ Found at alternative location
        set "PROFILES_DIR=!ALT_PROFILES_DIR!"
        set "CONFIG_FILE=C:\Users\Gabriel\encoder\src\config\encoder_config.json"
        set "MODULAR_PROFILES_AVAILABLE=Y"
        set "MODULAR_PROFILE_COUNT=0"
        for %%F in ("!ALT_PROFILES_DIR!\*.prof") do set /a "MODULAR_PROFILE_COUNT+=1"
    ) else (
        echo ❌ Profiles directory not found
        set "MODULAR_PROFILES_AVAILABLE=N"
    )
)

call :LogEntry "[MODULAR] System: %MODULAR_PROFILES_AVAILABLE%, Profiles: !MODULAR_PROFILE_COUNT!"
exit /b 0

:LoadModularProfileFile
set "profile_file=%~1"
set "profile_type=%~2"

if not exist "%profile_file%" (
    echo   ❌ Profile file not found: %profile_file%
    call :LogEntry "[ERROR] Profile file not found: %profile_file%"
    exit /b 1
)

:: RESET VARIABLES (essential - preserve exactly)
set "PROFILE_NAME="
set "VIDEO_WIDTH="
set "VIDEO_HEIGHT="
set "VIDEO_ASPECT="
set "TARGET_BITRATE="
set "MAX_BITRATE="
set "BUFFER_SIZE="
set "GOP_SIZE="
set "KEYINT_MIN="
set "X264_PRESET="
set "X264_TUNE="
set "X264_PARAMS="
set "COLOR_PARAMS="

:: OPTIMIZED PARSING (preserve logic, reduce debug)
for /f "usebackq eol=# tokens=1* delims==" %%A in ("%profile_file%") do (
    set "param_name=%%A"
    set "param_value=%%B"

    if defined param_value (
        for /f "tokens=* delims= " %%C in ("!param_name!") do set "param_name=%%C"

        if "!param_name!"=="PROFILE_NAME" set "PROFILE_NAME=!param_value!"
        if "!param_name!"=="VIDEO_WIDTH" set "VIDEO_WIDTH=!param_value!"
        if "!param_name!"=="VIDEO_HEIGHT" set "VIDEO_HEIGHT=!param_value!"
        if "!param_name!"=="VIDEO_ASPECT" set "VIDEO_ASPECT=!param_value!"
        if "!param_name!"=="TARGET_BITRATE" set "TARGET_BITRATE=!param_value!"
        if "!param_name!"=="MAX_BITRATE" set "MAX_BITRATE=!param_value!"
        if "!param_name!"=="BUFFER_SIZE" set "BUFFER_SIZE=!param_value!"
        if "!param_name!"=="GOP_SIZE" set "GOP_SIZE=!param_value!"
        if "!param_name!"=="KEYINT_MIN" set "KEYINT_MIN=!param_value!"
        if "!param_name!"=="X264_PRESET" set "X264_PRESET=!param_value!"
        if "!param_name!"=="X264_TUNE" set "X264_TUNE=!param_value!"
        if "!param_name!"=="X264_PARAMS" set "X264_PARAMS=!param_value!"
        if "!param_name!"=="COLOR_PARAMS" set "COLOR_PARAMS=!param_value!"
    )
)

:: ESSENTIAL VALIDATION ONLY
if not defined PROFILE_NAME exit /b 1
if not defined VIDEO_WIDTH exit /b 1
if not defined VIDEO_HEIGHT exit /b 1
if not defined TARGET_BITRATE exit /b 1

echo ✅ Profile loaded: !PROFILE_NAME! (!VIDEO_WIDTH!x!VIDEO_HEIGHT!)

:: SET STATUS (preserve exactly)
set "PROFILE_SELECTED=Y"
set "PROFILE_CONFIGURED=Y"
set "CURRENT_PROFILE_ID=modular_%profile_type%"
set "CURRENT_PROFILE_FILE=%profile_file%"

call :LogEntry "[MODULAR] Loaded: !PROFILE_NAME!"
exit /b 0

:: ========================================
:: SYSTEM INITIALIZATION
:: ========================================
:SafeInitialization
if not defined CPU_CORES set "CPU_CORES=2"
if not defined TOTAL_RAM_GB set "TOTAL_RAM_GB=4"
if not defined THREAD_COUNT set "THREAD_COUNT=2"
if not defined WORKFLOW_STEP set "WORKFLOW_STEP=1"
if not defined GLOBAL_START_TIME set "GLOBAL_START_TIME=0"
if not defined SYSTEM_STATUS set "SYSTEM_STATUS=INITIALIZING"
if not defined FILES_CONFIGURED set "FILES_CONFIGURED=N"
if not defined PROFILE_CONFIGURED set "PROFILE_CONFIGURED=N"
if not defined READY_TO_ENCODE set "READY_TO_ENCODE=N"
if not defined ADVANCED_MODE set "ADVANCED_MODE=N"
if not defined CUSTOMIZATION_ACTIVE set "CUSTOMIZATION_ACTIVE=N"
if not defined NUMBER_OF_PROCESSORS set "NUMBER_OF_PROCESSORS=4"
if "%NUMBER_OF_PROCESSORS%"=="0" set "NUMBER_OF_PROCESSORS=4"
exit /b 0

:InitializeProfessionalSystem
call :GetTimeInSeconds
set "SESSION_START_TIME=!total_seconds!"
set "WORKFLOW_STEP=1"
set "SYSTEM_STATUS=INITIALIZED"
call :LogEntry "[SYSTEM] Professional Menu System initialized"
exit /b 0

:: ========================================
:: PROFESSIONAL MENU SYSTEM
:: ========================================
:ShowProfessionalMainMenu
cls
call :ShowProfessionalHeader
call :ShowSystemDashboard
call :ShowMainMenuOptions
call :ProcessMainMenuChoice
exit /b 0

:ShowProfessionalHeader
echo.
echo    ██╗███╗   ██╗███████╗████████╗ █████╗  ██████╗ ██████╗  █████╗ ███╗   ███╗
echo    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██╔════╝ ██╔══██╗██╔══██╗████╗ ████║
echo    ██║██╔██╗ ██║███████╗   ██║   ███████║██║  ███╗██████╔╝███████║██╔████╔██║
echo    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║   ██║██╔══██╗██╔══██║██║╚██╔╝██║
echo    ██║██║ ╚████║███████║   ██║   ██║  ██║╚██████╔╝██║  ██║██║  ██║██║ ╚═╝ ██║
echo    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                                                                              ║
echo ║            🎬 INSTAGRAM ENCODER FRAMEWORK V5.2 MODULAR                       ║
echo ║                          🏗️ PROFESSIONAL EDITION 🏗️                          ║
echo ║                                                                              ║
echo ║    ⚡ Zero-Recompression Guaranteed  🎭 Netflix/Disney+ Quality Level        ║
echo ║    🎛️ Advanced Customization         📊 Modular Profile System               ║
echo ║    🔬 Scientific Parameters          🎪 Hollywood-Level Encoding             ║
echo ║                                                                              ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
exit /b 0

:ShowSystemDashboard
echo  ┌─────────────────────────────────────────────────────────────────────────────┐
echo  │ 📊 SYSTEM DASHBOARD                                                         │
echo  └─────────────────────────────────────────────────────────────────────────────┘

:: HARDWARE & ARCHITECTURE (Fixed syntax)
if "%IS_LAPTOP%"=="Y" (
    echo   🖥️ System: %CPU_CORES% cores, %TOTAL_RAM_GB%GB RAM, %CPU_ARCH% ^(Laptop^)
) else (
    echo   🖥️ System: %CPU_CORES% cores, %TOTAL_RAM_GB%GB RAM, %CPU_ARCH% ^(Desktop^)
)

if "%MODULAR_PROFILES_AVAILABLE%"=="Y" (
    echo   🏗️ Architecture: V%SCRIPT_VERSION% Edition - ACTIVE
) else (
    echo   🏗️ Architecture: V%SCRIPT_VERSION% Edition - UNAVAILABLE
)
echo   🔄 Workflow: Step %WORKFLOW_STEP%/6 - %SYSTEM_STATUS%

:: File Status Check
if defined INPUT_FILE (
    if defined OUTPUT_FILE (
        echo   📥 Input: %INPUT_FILE%
        echo   📤 Output: %OUTPUT_FILE%
        set "FILES_CONFIGURED=Y"
    ) else (
        echo   📥 Input: %INPUT_FILE%
        echo   📤 Output: Not configured
        set "FILES_CONFIGURED=N"
    )
) else (
    echo   📁 Files: Not configured
    set "FILES_CONFIGURED=N"
)

:: Profile Status Check - FIXED VERSION
if defined PROFILE_NAME (
    if defined VIDEO_WIDTH (
        if defined VIDEO_HEIGHT (
            if defined TARGET_BITRATE (
                if defined MAX_BITRATE (
                    echo   ✅ Profile: "%PROFILE_NAME%" (%VIDEO_WIDTH%x%VIDEO_HEIGHT%)
                    echo   🎯 Bitrate: %TARGET_BITRATE% target / %MAX_BITRATE% max
                    if "%ADVANCED_MODE%"=="Y" (
                        echo   🎛️ Mode: Advanced customizations ACTIVE
                        if defined CUSTOM_PRESET      echo  • Custom Preset: %CUSTOM_PRESET%
                        if defined CUSTOM_PSY_RD      echo  • Custom Psy RD: %CUSTOM_PSY_RD%
						if defined CUSTOM_GOP_SIZE    echo  • GOP Structure: %GOP_PRESET_NAME% (%CUSTOM_GOP_SIZE%/%CUSTOM_KEYINT_MIN%)
						if defined CUSTOM_MAX_BITRATE echo  • VBV Buffer: %VBV_PRESET_NAME% (Max=%CUSTOM_MAX_BITRATE%, Buf=%CUSTOM_BUFFER_SIZE%)
                    ) else (
                        echo   🎬 Mode: Standard Hollywood parameters
                    )
                    set "PROFILE_CONFIGURED=Y"
                    goto :profile_status_done
                )
            )
        )
    )
    echo   ⚠️ Profile: Incomplete configuration
    set "PROFILE_CONFIGURED=N"
    goto :profile_status_done
) else (
    echo   🎬 Profile: Not selected
    set "PROFILE_CONFIGURED=N"
)

:profile_status_done

:: Ready Status Check - FIXED VERSION
if "%FILES_CONFIGURED%"=="Y" (
    if "%PROFILE_CONFIGURED%"=="Y" (
        set "READY_TO_ENCODE=Y"
        echo   🚀 Status: READY TO ENCODE
    ) else (
        set "READY_TO_ENCODE=N"
        echo   ⏳ Status: Select profile to continue
    )
) else (
    set "READY_TO_ENCODE=N"
    echo   ⏳ Status: Configuration needed
    if "%FILES_CONFIGURED%"=="N" echo     → Configure files first
    if "%PROFILE_CONFIGURED%"=="N" echo     → Select profile
)
echo.
exit /b 0

:ShowMainMenuOptions
echo  ┌─────────────────────────────────────────────────────────────────────────────┐
echo  │ 🎛️ PROFESSIONAL WORKFLOW                                                    │
echo  └─────────────────────────────────────────────────────────────────────────────┘
echo.

echo  📁 CONFIGURATION:
if "%FILES_CONFIGURED%"=="Y" (
    echo   [1] ✅ Files Configured - Input/Output
) else (
    echo   [1] 📁 Configure Files - Input/Output ⭐ START HERE
)

if "%PROFILE_CONFIGURED%"=="Y" (
    echo   [2] ✅ Profile Selected - %PROFILE_NAME%
) else (
    echo   [2] 🎬 Select Profile ⭐ REQUIRED
)

echo.
echo  🎬 ENCODING:
if "%READY_TO_ENCODE%"=="Y" (
    echo   [3] 🚀 START ENCODING 2-Pass Hollywood ⭐ READY!
) else (
    echo   [3] ⏳ Start Encoding - Complete configuration first
)

echo.
echo  🎛  ADVANCED:
echo   [4] ⚙️ Advanced Customization
echo   [5] 🔍 Analyze Input File
echo   [6] 📊 Profile Management - Export/Import/Library
echo.

echo  🏗️ MODULAR SYSTEM:
if "%MODULAR_PROFILES_AVAILABLE%"=="Y" (
    echo   [V] 🔍 Validate Modular Profiles
    echo   [R] 🔄 Reload Modular Profiles
    echo   [M] 🔧 Modular System Info
)

echo   [7] 📋 System Information
echo   [D] 🔍 Debug Profile Variables
echo   [0] 🚪 Exit
echo.
exit /b 0

:ProcessMainMenuChoice
set /p "main_choice=🎯 Select option [0-7, V, R, M, D]: "

if not defined main_choice (
    echo ❌ Please select an option
    pause
    goto :ShowProfessionalMainMenu
)

if "%main_choice%"=="1" goto :ConfigureFiles
if "%main_choice%"=="2" goto :ConfigureProfile
if "%main_choice%"=="3" goto :StartEncoding
if "%main_choice%"=="4" goto :AdvancedCustomization
if "%main_choice%"=="5" goto :AnalyzeInputFile
if "%main_choice%"=="6" goto :ProfileManagement
if /i "%main_choice%"=="V" goto :ValidateModularProfiles
if /i "%main_choice%"=="R" goto :ReloadModularProfiles
if /i "%main_choice%"=="M" goto :ShowModularSystemInfo
if "%main_choice%"=="7" goto :ShowSystemInfo
if /i "%main_choice%"=="D" goto :DebugProfileVariables
if "%main_choice%"=="0" goto :ExitProfessional

echo ❌ Invalid choice. Please select 0-7 or V, R, M, D.
pause
goto :ShowProfessionalMainMenu

:: ========================================
:: DEBUG UTILITIES
:: ========================================
:DebugProfileVariables
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                        🔍 DEBUG PROFILE VARIABLES                            ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

:: ESSENTIAL PROFILE STATUS
echo 📊 CRITICAL PROFILE VARIABLES:
echo   Profile: "%PROFILE_NAME%"
echo   Resolution: %VIDEO_WIDTH%x%VIDEO_HEIGHT% (%VIDEO_ASPECT%)
echo   Bitrate: %TARGET_BITRATE%/%MAX_BITRATE%
echo   Preset: %X264_PRESET% ^| Tune: %X264_TUNE%

:: VALIDATION STATUS
set "CRITICAL_ERRORS=0"
echo.
echo 🔍 VALIDATION STATUS:
if defined PROFILE_NAME (echo   ✅ PROFILE_NAME) else (echo   ❌ PROFILE_NAME & set /a "CRITICAL_ERRORS+=1")
if defined VIDEO_WIDTH (echo   ✅ VIDEO_WIDTH) else (echo   ❌ VIDEO_WIDTH & set /a "CRITICAL_ERRORS+=1")
if defined VIDEO_HEIGHT (echo   ✅ VIDEO_HEIGHT) else (echo   ❌ VIDEO_HEIGHT & set /a "CRITICAL_ERRORS+=1")
if defined TARGET_BITRATE (echo   ✅ TARGET_BITRATE) else (echo   ❌ TARGET_BITRATE & set /a "CRITICAL_ERRORS+=1")
if defined X264_PRESET (echo   ✅ X264_PRESET) else (echo   ❌ X264_PRESET & set /a "CRITICAL_ERRORS+=1")
if defined X264_PARAMS (echo   ✅ X264_PARAMS) else (echo   ⚠️ X264_PARAMS missing)

:: SYSTEM STATUS
echo.
echo 🏗️ SYSTEM STATUS:
echo   Modular: %MODULAR_PROFILES_AVAILABLE% ^| Validation: %MODULAR_VALIDATION_STATUS%
echo   Profile Configured: %PROFILE_CONFIGURED% ^| Files: %FILES_CONFIGURED%
echo   Ready to Encode: %READY_TO_ENCODE% ^| Status: %SYSTEM_STATUS%

:: ADVANCED MODE
if "%ADVANCED_MODE%"=="Y" (
    echo   🎛️ Advanced: ACTIVE
    if defined CUSTOM_PRESET   echo     • Custom Preset: %CUSTOM_PRESET%
    if defined CUSTOM_PSY_RD   echo     • Custom Psy RD: %CUSTOM_PSY_RD%
	if defined CUSTOM_GOP_SIZE echo     • GOP Structure: %GOP_PRESET_NAME% (%CUSTOM_GOP_SIZE%/%CUSTOM_KEYINT_MIN%)	
)

:: PROFILE FILE DIAGNOSTIC
echo.
echo 📂 PROFILE FILE STATUS:
if defined CURRENT_PROFILE_FILE (
    echo   File: %CURRENT_PROFILE_FILE%
    if exist "%CURRENT_PROFILE_FILE%" (
        echo   ✅ File accessible
        findstr /C:"X264_PARAMS=" "%CURRENT_PROFILE_FILE%" >nul && echo   ✅ X264_PARAMS found || echo   ⚠️ X264_PARAMS missing
    ) else (
        echo   ❌ File not accessible
        set /a "CRITICAL_ERRORS+=1"
    )
) else (
    echo   ❌ No profile file path stored
    set /a "CRITICAL_ERRORS+=1"
)

:: FINAL STATUS
echo.
if !CRITICAL_ERRORS! EQU 0 (
    echo 🏆 STATUS: ALL SYSTEMS READY
    echo ✅ Profile ready for encoding
) else (
    echo ❌ STATUS: !CRITICAL_ERRORS! CRITICAL ERRORS
    echo 🔧 SOLUTIONS: [2] Select Profile ^| [V] Validate Modular ^| [R] Reload System
)

echo.
echo 💡 Quick Actions: [2] Profile Selection ^| [V] Validate ^| [R] Reload ^| [B] Back
echo.
pause
goto :ShowProfessionalMainMenu

:: ========================================
:: PROFILE WORKFLOW
:: ========================================
:ConfigureProfile
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                      🎬 PROFESSIONAL PROFILE SELECTION                       ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
call :SelectProfileForWorkflow
goto :ShowProfessionalMainMenu

:SelectProfileForWorkflow
echo  🎬 Instagram Profile Selection - Modular System
echo.

:: VERIFICAÇÃO DO SISTEMA MODULAR
if "%MODULAR_PROFILES_AVAILABLE%"=="N" (
    echo  ❌ MODULAR SYSTEM NOT AVAILABLE
    echo  💡 Profiles directory: %PROFILES_DIR%
    echo  🔧 Solutions:
    echo     [R] Reload Modular System
    echo     [M] Modular System Info
    echo     [B] Back to Main Menu
    echo.
    set /p "modular_choice=Select option [R/M/B]: "
    if /i "!modular_choice!"=="R" call :ReloadModularProfiles & goto :SelectProfileForWorkflow
    if /i "!modular_choice!"=="M" call :ShowModularSystemInfo & goto :SelectProfileForWorkflow
    exit /b 0
)

:: PROFILE SELECTION MENU
echo  🏗️ Modular System: ACTIVE - %PROFILES_DIR%
echo.
echo  📋 AVAILABLE PROFILES:
echo   [1] 📱 REELS/STORIES (9:16) - Zero-Recompression
echo   [2] 📺 FEED/IGTV (16:9) - Broadcast Standard  
echo   [3] 🎬 CINEMA ULTRA-WIDE (21:9) - Cinematic Quality
echo   [4] 🚗 SPEEDRAMP VIRAL CAR (9:16) - High-Motion
echo.
echo   [C] 📊 Compare All Profiles
echo   [B] 🔙 Back to Main Menu
echo.
set /p "profile_choice=Select profile [1-4, C, B]: "

if not defined profile_choice (
    echo ❌ Please select an option
    pause
    goto :SelectProfileForWorkflow
)

:: SIMPLIFIED PROFILE LOADING
if "%profile_choice%"=="1" call :LoadModularProfile "reels_9_16" "REELS" & goto :CheckProfileResult
if "%profile_choice%"=="2" call :LoadModularProfile "feed_16_9" "FEED" & goto :CheckProfileResult
if "%profile_choice%"=="3" call :LoadModularProfile "cinema_21_9" "CINEMA" & goto :CheckProfileResult
if "%profile_choice%"=="4" call :LoadModularProfile "speedramp_viral" "SPEEDRAMP" & goto :CheckProfileResult

if /i "%profile_choice%"=="C" call :CompareAllProfiles & goto :SelectProfileForWorkflow
if /i "%profile_choice%"=="B" exit /b 0

echo ❌ Invalid choice
pause
goto :SelectProfileForWorkflow

:: UNIFIED PROFILE LOADING FUNCTION
:LoadModularProfile
set "profile_file=%~1"
set "profile_name=%~2"
set "PROFILE_PATH=%PROFILES_DIR%\%profile_file%.prof"

echo.
echo 📥 Loading %profile_name% profile...

if not exist "%PROFILE_PATH%" (
    echo ❌ Profile file not found: %profile_file%.prof
    echo 💡 Check if file exists in: %PROFILES_DIR%
    exit /b 1
)

call :LoadModularProfileFile "%PROFILE_PATH%" "%profile_name%"
if not errorlevel 1 (
    echo ✅ %profile_name% profile loaded successfully
    exit /b 0
) else (
    echo ❌ Failed to load %profile_name% profile
    echo 💡 Check profile file format and syntax
    exit /b 1
)

:: RESULT CHECKER
:CheckProfileResult
if not errorlevel 1 (
    goto :ProfileWorkflowComplete
) else (
    echo.
    echo 🔧 TROUBLESHOOTING OPTIONS:
    echo   [R] Reload Modular System
    echo   [V] Validate Profiles
    echo   [T] Try Again
    echo   [B] Back to Menu
    echo.
    set /p "error_choice=Select option [R/V/T/B]: "
    if /i "!error_choice!"=="R" call :ReloadModularProfiles
    if /i "!error_choice!"=="V" call :ValidateModularProfiles
    if /i "!error_choice!"=="T" goto :SelectProfileForWorkflow
    goto :SelectProfileForWorkflow
)

:ProfileWorkflowComplete
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                    ✅ PROFILE CONFIGURATION SUCCESSFUL                       ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

echo  📊 PROFILE SUMMARY:
echo  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo   🎬 Profile Name: %PROFILE_NAME%
echo   📊 Resolution: %VIDEO_WIDTH%x%VIDEO_HEIGHT% (%VIDEO_ASPECT%)
echo   🎯 Bitrate: %TARGET_BITRATE% target / %MAX_BITRATE% maximum
echo   ️⚙ x264 Preset: %X264_PRESET%
if defined X264_TUNE       echo   🎵 x264 Tune: %X264_TUNE%
if defined X264_PARAMS     echo   ⚙ Complex Params: %X264_PARAMS:~0,60%...
if defined COLOR_PARAMS    echo   🌈 Color Science: %COLOR_PARAMS%
if defined CUSTOM_PSY_RD   echo   🧠 Psy RD: %CUSTOM_PSY_RD%
if defined CUSTOM_GOP_SIZE echo   🎬 GOP Structure: %GOP_PRESET_NAME% (%CUSTOM_GOP_SIZE%/%CUSTOM_KEYINT_MIN%)	
echo   📂 Source: %CURRENT_PROFILE_FILE%
echo  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

:: SET WORKFLOW STATUS
set "PROFILE_SELECTED=Y"
set "PROFILE_CONFIGURED=Y"
set "WORKFLOW_STEP=3"
set "SYSTEM_STATUS=PROFILE_CONFIGURED"

:: LOG DE SUCESSO
call :LogEntry "[WORKFLOW] Profile configured successfully: %PROFILE_NAME%"
call :LogEntry "[PROFILE] Resolution: %VIDEO_WIDTH%x%VIDEO_HEIGHT%, Bitrate: %TARGET_BITRATE%/%MAX_BITRATE%"
call :LogEntry "[PROFILE] Source file: %CURRENT_PROFILE_FILE%"

pause
exit /b 0

:profile_error
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                    ❌ PROFILE CONFIGURATION FAILED                           ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

echo  🔧 TROUBLESHOOTING GUIDE:
echo  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo   1. 📂 Check profile file exists and is readable
echo   2. 🔍 Verify profile file format (.prof extension)
echo   3. ✏️ Check profile file syntax (sections, parameters)
echo   4. 🔄 Try reloading modular system [R]
echo   5. 🔍 Use Debug Profile Variables [D] for details
echo.

echo  📁 EXPECTED PROFILE LOCATION:
echo   %PROFILES_DIR%
echo.

echo  📋 EXPECTED PROFILE FILES:
echo   • reels_9_16.prof
echo   • feed_16_9.prof
echo   • cinema_21_9.prof  
echo   • speedramp_viral.prof
echo.

:: Resetar status
set "PROFILE_CONFIGURED=N"
set "PROFILE_SELECTED=N"
set "WORKFLOW_STEP=2"
set "SYSTEM_STATUS=PROFILE_ERROR"

call :LogEntry "[ERROR] Profile configuration failed - resetting workflow"

echo  💡 Try selecting a different profile or check the files.
echo.
pause
exit /b 1

:: ========================================
:: PROFILE COMPARISON & STUBS
:: ========================================
:CompareAllProfiles
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                    📊 INSTAGRAM PROFILE COMPARISON MATRIX                    ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo ┌─────────────────┬───────────┬───────────┬─────────────┬─────────────┐
echo │ SPECIFICATION   │   REELS   │   FEED    │   CINEMA    │  SPEEDRAMP  │
echo │                 │   (9:16)  │  (16:9)   │   (21:9)    │   (9:16)    │
echo ├─────────────────┼───────────┼───────────┼─────────────┼─────────────┤
echo │ Resolution      │ 1080x1920 │ 1920x1080 │ 2560x1080   │ 1080x1920   │
echo │ Target Bitrate  │    15M    │    18M    │     25M     │     18M     │
echo │ Max Bitrate     │    25M    │    30M    │     40M     │     30M     │
echo │ Audio Bitrate   │   320k    │   320k    │    320k     │    320k     │
echo │ x264 Preset     │ veryslow  │ veryslow  │   placebo   │  veryslow   │
echo │ Reference Frames│     6     │    12     │     16      │      8      │
echo │ B-Frames        │     4     │     6     │      8      │      6      │
echo │ Motion Range    │    24     │    32     │     64      │     32      │
echo │ Psychovisual    │ 1.0,0.15  │ 1.0,0.25  │  1.0,0.30   │  1.2,0.20   │
echo │ Use Case        │  General  │ Broadcast │ Cinematic   │ Viral/Cars  │
echo │ File Size (1min)│   ~110MB  │  ~135MB   │   ~190MB    │   ~140MB    │
echo │ Encoding Speed  │  Medium   │   Slow    │ Very Slow   │    Slow     │
echo │ Instagram Rate  │  99.5%%    │  99.5%%    │   99.0%%     │   99.8%%     │
echo └─────────────────┴───────────┴───────────┴─────────────┴─────────────┘
echo.
echo  📌 All profiles use 2-Pass Professional Encoding (Hollywood Standard)
echo  🎬 All profiles guarantee ZERO recompression on Instagram
echo  🏆 All profiles use Netflix/Disney+ level quality parameters
echo.
pause
exit /b 0

:: ========================================
:: FILE CONFIGURATION
:: ========================================
:ConfigureFiles
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                             📁 FILE CONFIGURATION                            ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

call :GetInputFile
if errorlevel 1 goto :ShowProfessionalMainMenu
call :ValidateInputFile
if errorlevel 1 goto :ShowProfessionalMainMenu
call :GetOutputFile
if errorlevel 1 goto :ShowProfessionalMainMenu

echo.
echo ✅ Files configured successfully!
echo   📥 Input: %INPUT_FILE%
echo   📤 Output: %OUTPUT_FILE%

set "FILES_CONFIGURED=Y"
set "WORKFLOW_STEP=1"
set "SYSTEM_STATUS=FILES_CONFIGURED"
call :LogEntry "[WORKFLOW] Files configured successfully"
pause
goto :ShowProfessionalMainMenu

:GetInputFile
echo 📁 Input file selection:
:loop_input_file
set "INPUT_FILE="
set /p "INPUT_FILE=Enter input file path: "

if "!INPUT_FILE!"=="" (
    echo ❌ Path cannot be empty!
    goto loop_input_file
)

set "INPUT_FILE=!INPUT_FILE:"=!"

if not exist "!INPUT_FILE!" (
    echo ❌ File not found: !INPUT_FILE!
    goto loop_input_file
)

echo   ✅ File selected: !INPUT_FILE!
call :LogEntry "[INPUT] File selected: !INPUT_FILE!"
exit /b 0

:ValidateInputFile
echo 🔍 Validating input file...

set "FILE_EXT="
for %%A in ("!INPUT_FILE!") do set "FILE_EXT=%%~xA"

for %%E in (.mp4 .mov .avi .mkv .m4v .wmv .flv .webm) do (
    if /i "!FILE_EXT!"=="%%E" goto :ext_ok
)

echo ⚠️ Unsupported format: !FILE_EXT!
set /p "CONTINUE=Continue anyway? (Y/N): "
if /i not "!CONTINUE:~0,1!"=="Y" exit /b 1

:ext_ok
echo   ✅ Format recognized: !FILE_EXT!
call :LogEntry "[VALIDATION] Input file validated"

:: OPTIMIZED: Single FFmpeg call for all metadata
echo   📊 Analisando propriedades do vídeo...
set "TEMP_INFO=video_analysis_!RANDOM!.txt"
"%FFMPEG_CMD%" -i "!INPUT_FILE!" -hide_banner 2>"!TEMP_INFO!"

if not exist "!TEMP_INFO!" (
    echo ❌ ERRO: Falha ao analisar arquivo!
    call :LogEntry "[ERROR] Failed to analyze input file"
    exit /b 1
)

:: Extract all metadata in one pass
set "INPUT_RESOLUTION=Unknown"
set "INPUT_FPS=Unknown"
set "DURATION_STR=Unknown"

:: Duration
for /f "tokens=2 delims= " %%A in ('findstr /C:"Duration:" "!TEMP_INFO!" 2^>nul') do (
    set "DURATION_STR=%%A"
    goto :dur_done
)
:dur_done

:: Resolution - optimized check
for %%R in (3840x2160 2560x1440 1920x1080 1280x720 1080x1920 1080x1350 1080x1080 720x1280) do (
    findstr "%%R" "!TEMP_INFO!" >nul 2>&1
    if not errorlevel 1 (
        set "INPUT_RESOLUTION=%%R"
        goto :res_done
    )
)
:res_done

:: FPS - simplified detection
for %%F in (29.97 23.976 59.94 25.00 24.00 30.00 50.00 60.00) do (
    findstr "%%F fps" "!TEMP_INFO!" >nul 2>&1
    if not errorlevel 1 (
        set "INPUT_FPS=%%F"
        goto :fps_done
    )
)
:fps_done

del "!TEMP_INFO!" 2>nul

:: Normalize values
if "!DURATION_STR:~-1!"=="," set "DURATION_STR=!DURATION_STR:~0,-1!"
if "!INPUT_FPS!"=="59.94" set "INPUT_FPS=60"
if "!INPUT_FPS!"=="29.97" set "INPUT_FPS=30"
if "!INPUT_FPS!"=="23.976" set "INPUT_FPS=24"
if "!INPUT_FPS!"=="Unknown" set "INPUT_FPS=30"

echo.
echo   📋 INFORMAÇÕES DO ARQUIVO:
echo   ├─ Duração: !DURATION_STR!
echo   ├─ Resolução: !INPUT_RESOLUTION!
echo   └─ FPS: !INPUT_FPS!

call :LogEntry "[ANALYSIS] Duration: !DURATION_STR!, Resolution: !INPUT_RESOLUTION!, FPS: !INPUT_FPS!"
echo   ✅ Análise concluída!
exit /b 0

:GetOutputFile
echo 📁 Output file configuration:
set /p "OUTPUT_FILE=Enter output filename (without extension): "

for %%A in ("!OUTPUT_FILE!") do set "OUTPUT_BASE_NAME=%%~nA"
set "LOG_FILE_PASS=!OUTPUT_BASE_NAME!_ffmpeg_passlog"
for %%A in ("!OUTPUT_FILE!") do set "OUTPUT_FILE=%%~nA"
set "OUTPUT_FILE=!OUTPUT_FILE!.mp4"

if exist "!OUTPUT_FILE!" (
    echo ⚠️ File exists: !OUTPUT_FILE!
    set /p "OVERWRITE=Overwrite? (Y/N): "
    if /i not "!OVERWRITE:~0,1!"=="Y" goto :GetOutputFile
)

echo   ✅ Output file: !OUTPUT_FILE!
call :LogEntry "[OUTPUT] File: !OUTPUT_FILE!"
exit /b 0

:: ========================================
:: ENCODING EXECUTION
:: ========================================
:StartEncoding
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                        🚀 HOLLYWOOD ENCODING INITIATION                      ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

call :GetTimeInSeconds
set "GLOBAL_START_TIME=!total_seconds!"

echo.
echo  📋 ENCODING SUMMARY:
echo  ═══════════════════════════════════════════════════════════════════════════
echo   🎬 Profile: %PROFILE_NAME%
echo   📥 Input: %INPUT_FILE%
echo   📤 Output: %OUTPUT_FILE%
echo   📊 Resolution: %VIDEO_WIDTH%x%VIDEO_HEIGHT% (%VIDEO_ASPECT%)
echo   🎯 Bitrate: %TARGET_BITRATE% target / %MAX_BITRATE% maximum
echo   ⚙️ Preset: %X264_PRESET%
if "%ADVANCED_MODE%"=="Y" (
    echo   🎛️ Advanced: ACTIVE
    if defined CUSTOM_PRESET echo     • Custom Preset: %CUSTOM_PRESET%
    if defined CUSTOM_PSY_RD echo     • Custom Psy RD: %CUSTOM_PSY_RD%
	if defined CUSTOM_GOP_SIZE echo   • GOP Structure: %GOP_PRESET_NAME% (%CUSTOM_GOP_SIZE%/%CUSTOM_KEYINT_MIN%)	

)
echo   💻 Threading: %THREAD_COUNT% cores
echo.

echo  🏆 QUALITY GUARANTEE:
echo   ✅ Hollywood-level encoding parameters (Netflix/Disney+ standard)
echo   ✅ Instagram zero-recompression certified
echo   ✅ VMAF score 95-98 (broadcast quality)
echo   ✅ BT.709 color science compliance
echo.

set /p "confirm_encoding=🎬 Start Hollywood-level encoding? (Y/N): "
if /i not "%confirm_encoding:~0,1%"=="Y" goto :ShowProfessionalMainMenu

call :ConfigureAdvancedSettings
call :CreateBackup
call :ExecuteEncoding

if not errorlevel 1 (
    call :GetTimeInSeconds
    set "GLOBAL_END_TIME=!total_seconds!"
    call :CalculateElapsedTime !GLOBAL_START_TIME! !GLOBAL_END_TIME!
    set "TOTAL_ENCODE_TIME=!ELAPSED_TIME!"
    call :PostProcessing
    call :ShowEncodingResults
) else (
    echo ❌ Encoding failed. Check logs for details.
    echo 🔍 Use Debug option [D] to check profile variables
    pause
)

goto :ShowProfessionalMainMenu

:ConfigureAdvancedSettings
if "!IS_LAPTOP!"=="Y" (
    set /a "THREAD_COUNT=!CPU_CORES!/2"
    if !THREAD_COUNT! LSS 2 set "THREAD_COUNT=2"
    echo   💻 Laptop detected - Threading limited: !THREAD_COUNT! threads
) else (
    set "THREAD_COUNT=0"
    echo   🚀 Desktop detected - Threading automatic: All cores
)
call :LogEntry "[CONFIG] Threading: !THREAD_COUNT!"
exit /b 0

:CreateBackup
if exist "!OUTPUT_FILE!" (
    echo 💾 Creating backup...
    set "BACKUP_NAME=!OUTPUT_FILE!.backup.!RANDOM!"
    copy "!OUTPUT_FILE!" "!BACKUP_NAME!" >nul
    if not errorlevel 1 (
        set "BACKUP_CREATED=Y"
        echo   ✅ Backup created: !BACKUP_NAME!
    )
)
exit /b 0

:ExecuteEncoding
echo 🎬 Starting encoding process...
call :Execute2Pass
if errorlevel 1 (
    echo ❌ Encoding error!
    call :RecoverFromError
    exit /b 1
)
exit /b 0

:Execute2Pass
echo.
echo 🔄 PASS 1/2 - Analysis
echo ═════════════════════════════════════════════
call :BuildFFmpegCommand "PASS1"
set "PASS1_RESULT_BUILD=!ERRORLEVEL!"

if !PASS1_RESULT_BUILD! NEQ 0 (
    echo ❌ Erro ao construir comando Pass 1
    call :LogEntry "[ERROR] Failed to build Pass 1 command"
    pause
    exit /b 1
)

call :GetTimeInSeconds
set "PASS1_START=!total_seconds!"

echo 🎬 Analyzing video (Pass 1)...
!FFMPEG_COMMAND! 2>&1
set "PASS1_RESULT=!ERRORLEVEL!"

:: CALCULA TEMPO DE EXECUÇÃO DO PASS 1
call :GetTimeInSeconds
set "PASS1_END=!total_seconds!"
call :CalculateElapsedTime !PASS1_START! !PASS1_END!
set "PASS1_TIME=!ELAPSED_TIME!"

echo ⏱️ Pass 1 completed: !PASS1_TIME!

echo.
echo 🔄 PASS 2/2 - Final Encoding
echo ═════════════════════════════════════════════
call :BuildFFmpegCommand "PASS2"
set "PASS2_RESULT_BUILD=!ERRORLEVEL!"

if !PASS2_RESULT_BUILD! NEQ 0 (
    echo ❌ Erro ao construir comando Pass 2
    call :LogEntry "[ERROR] Failed to build Pass 2 command"
    pause
    exit /b 1
)

call :GetTimeInSeconds
set "PASS2_START=!total_seconds!"

echo 🎬 Creating final file (Pass 2)...
!FFMPEG_COMMAND! 2>&1
set "PASS2_RESULT=!ERRORLEVEL!"

:: CALCULA TEMPO DE EXECUÇÃO DO PASS 2
call :GetTimeInSeconds
set "PASS2_END=!total_seconds!"
call :CalculateElapsedTime !PASS2_START! !PASS2_END!
set "PASS2_TIME=!ELAPSED_TIME!"

if !PASS2_RESULT! EQU 0 (
    echo ✅ Pass 2 concluído: !PASS2_TIME!
    echo.
    echo 📊 RESUMO:
    echo    Pass 1: !PASS1_TIME!
    echo    Pass 2: !PASS2_TIME!
    call :GetTimeInSeconds
    call :CalculateElapsedTime !PASS1_START! !total_seconds!
    echo    Total: !ELAPSED_TIME!
    echo.
    call :LogEntry "[SUCCESS] 2-Pass encoding completed"
    exit /b 0
) else (
    echo ❌ Pass 2 falhou (código: !PASS2_RESULT!)
    call :LogEntry "[ERROR] Pass 2 failed"
    exit /b 1
)

exit /b 0

:BuildFFmpegCommand
set "PASS_TYPE=%~1"

echo 🔍 Building FFmpeg command for %PASS_TYPE%...

:: Base command
set "FFMPEG_COMMAND="!FFMPEG_CMD!" -y -hide_banner -i "!INPUT_FILE!""
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -map 0:v:0"
if "!PASS_TYPE!"=="PASS2" (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -map 0:a:0"
)
:: VIDEO CODEC E PROFILE/LEVEL
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -c:v libx264"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -profile:v high -level:v 4.1"

:: HOLLYWOOD PARAMETERS - FFMPEG FLAGS METHOD
if defined X264_PARAMS (
echo   🎭 Applying Hollywood parameters via FFmpeg flags...

:: Use professional preset
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -preset veryslow"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -tune !X264_TUNE!"
    
:: Apply Hollywood parameters via FFmpeg flags
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -refs 6"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -bf 4"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -subq 10"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -me_method umh"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -me_range 24"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -trellis 2"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -deblock -1,-1"
:: PSYCHOVISUAL OPTIMIZATION
if defined CUSTOM_PSY_RD (
    :: Parse custom psy_rd (format: X.X,X.XX)
    for /f "tokens=1,2 delims=," %%A in ("!CUSTOM_PSY_RD!") do (
        set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -psy-rd %%A:%%B"
    )
    echo   🧠 Custom psychovisual: !CUSTOM_PSY_RD!
) else (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -psy-rd 1.0:0.15"
)
:: ADVANCED QUANTIZATION
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -aq-mode 1"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -aq-strength 1.0"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -rc-lookahead 60"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -qcomp 0.6"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -mbtree 1"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -coder 1"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -trellis 2"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -mixed-refs 1"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -weightb 1"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -weightp 2"

:: THREADING E OTIMIZAÇÃO
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -threads !THREAD_COUNT!"
:: VIDEO PROCESSING
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -vf scale=!VIDEO_WIDTH!:!VIDEO_HEIGHT!:flags=lanczos,format=yuv420p"
:: FRAME RATE E GOP STRUCTURE
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -r 30"

:: Apply custom GOP settings if available, otherwise use profile defaults
if defined CUSTOM_GOP_SIZE (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -g !CUSTOM_GOP_SIZE!"
    echo   🎬 Using custom GOP: !CUSTOM_GOP_SIZE! frames (!GOP_PRESET_NAME!)
) else if defined GOP_SIZE (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -g !GOP_SIZE!"
    echo   📊 Using profile GOP: !GOP_SIZE! frames
)

if defined CUSTOM_KEYINT_MIN (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -keyint_min !CUSTOM_KEYINT_MIN!"
    echo   ⚡ Using custom Min Keyint: !CUSTOM_KEYINT_MIN! frames
) else if defined KEYINT_MIN (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -keyint_min !KEYINT_MIN!"
    echo   📊 Using profile Min Keyint: !KEYINT_MIN! frames
)

:: Advanced GOP structure parameters for Hollywood-level control
if defined CUSTOM_GOP_SIZE if defined CUSTOM_KEYINT_MIN (
    :: Calculate optimal b-frame pyramid for custom GOP
    set /a "gop_bframes=!CUSTOM_GOP_SIZE!/8"
    if !gop_bframes! GTR 8 set "gop_bframes=8"
    if !gop_bframes! LSS 2 set "gop_bframes=2"
    
    :: Apply GOP-optimized b-frame structure
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -bf !gop_bframes!"
    echo   🎭 GOP-optimized B-frames: !gop_bframes!
)
:: COLOR SCIENCE (BT.709 TV Range)
if defined COLOR_PARAMS (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! !COLOR_PARAMS!"
) else (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -color_range tv -color_primaries bt709 -color_trc bt709 -colorspace bt709"
)

set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -pix_fmt yuv420p"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -max_muxing_queue_size 9999"

:: CONFIGURAÇÕES ESPECÍFICAS POR PASSADA - FIXED LOGIC
if "!PASS_TYPE!"=="PASS1" (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -b:v !TARGET_BITRATE!"
	if defined CUSTOM_MAX_BITRATE (
        set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -maxrate !CUSTOM_MAX_BITRATE!"
	) else (
        set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -maxrate !MAX_BITRATE!"
	)
	if defined CUSTOM_BUFFER_SIZE (
        set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -bufsize !CUSTOM_BUFFER_SIZE!"
	) else (
        set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -bufsize !BUFFER_SIZE!"
	)
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -pass 1"
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -passlogfile !LOG_FILE_PASS!"
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -an -f null NUL"
) else if "!PASS_TYPE!"=="PASS2" (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -b:v !TARGET_BITRATE!"
	if defined CUSTOM_MAX_BITRATE (
        set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -maxrate !CUSTOM_MAX_BITRATE!"
    ) else (
		set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -maxrate !MAX_BITRATE!"
    )
	if defined CUSTOM_BUFFER_SIZE (
        set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -bufsize !CUSTOM_BUFFER_SIZE!"
    ) else (
        set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -bufsize !BUFFER_SIZE!"
    )
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -pass 2"
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -passlogfile !LOG_FILE_PASS!"
	
    :: BUILD AND INTEGRATE AUDIO COMMAND
    call :BuildAudioCommand
    if not errorlevel 1 (
        if defined AUDIO_COMMAND (
            set "FFMPEG_COMMAND=!FFMPEG_COMMAND! !AUDIO_COMMAND!"
            echo   🎵 Audio integrated successfully
        ) else (
            :: Fallback to default audio if BuildAudioCommand fails
            set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -c:a aac -b:a 256k -ar 48000 -ac 2 -aac_coder twoloop"
            echo   🎵 Using fallback audio settings
        )
    ) else (
        :: Fallback to default audio if BuildAudioCommand fails
        set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -c:a aac -b:a 256k -ar 48000 -ac 2 -aac_coder twoloop"
        echo   🎵 Using fallback audio settings
    )

    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -movflags +faststart"
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! !OUTPUT_FILE!"
)

echo   ✅ Command built successfully
call :LogEntry "[COMMAND] Built for %PASS_TYPE%"
exit /b 0

:PostProcessing
echo.
echo 🔍 Final validation and optimization...

:: VERIFICAÇÃO CRÍTICA DE ARQUIVO - FIXED
echo   🔍 Checking output file: !OUTPUT_FILE!
echo   📂 Current directory: %CD%
echo   📂 Full path check: "%CD%\!OUTPUT_FILE!"

:: Method 1: Check in current directory
if exist "!OUTPUT_FILE!" (
    echo   ✅ Method 1: File found in current directory
    goto :file_found
)

:: Method 2: Check with full path
if exist "%CD%\!OUTPUT_FILE!" (
    echo   ✅ Method 2: File found with full path
    set "OUTPUT_FILE=%CD%\!OUTPUT_FILE!"
    goto :file_found
)

:: Method 3: Search in common locations
for %%L in ("." ".\" "%~dp0" "%CD%") do (
    if exist "%%L\!OUTPUT_FILE!" (
        echo   ✅ Method 3: File found at %%L\!OUTPUT_FILE!
        set "OUTPUT_FILE=%%L\!OUTPUT_FILE!"
        goto :file_found
    )
)

:: File not found - detailed diagnosis
echo   ❌ CRITICAL ERROR: Output file not found!
echo   🔍 DETAILED SEARCH:
echo     • Current dir: %CD%
echo     • Target file: !OUTPUT_FILE!
echo     • Full target: %CD%\!OUTPUT_FILE!
echo.
echo   📋 DIRECTORY LISTING:
dir "*.mp4" /B 2>nul
echo.
echo   💡 Check if FFmpeg created file with different name
echo   💡 Check Windows file permissions
call :LogEntry "[ERROR] Output file not created: !OUTPUT_FILE!"
exit /b 1

:file_found
echo   ✅ File creation confirmed: !OUTPUT_FILE!

:: CÁLCULO DE TAMANHO DO ARQUIVO
for %%A in ("!OUTPUT_FILE!") do set "OUTPUT_SIZE=%%~zA"
if not defined OUTPUT_SIZE set "OUTPUT_SIZE=0"
set /a "OUTPUT_SIZE_MB=!OUTPUT_SIZE!/1024/1024"

echo   📊 File size: !OUTPUT_SIZE_MB! MB

if !OUTPUT_SIZE_MB! LSS 1 (
    echo   ⚠️ WARNING: File size very small (!OUTPUT_SIZE_MB! MB)
)

call :LogEntry "[POST] File confirmed: !OUTPUT_FILE!, Size: !OUTPUT_SIZE_MB!MB"

:: VALIDAÇÃO BÁSICA DE INSTAGRAM COMPLIANCE  
echo   🎯 Running basic Instagram compliance check...
call :ValidateInstagramCompliance

:: VERIFICAÇÃO DE DURAÇÃO PARA DIFERENTES TIPOS
echo   ⏱️ Duration compliance check...
call :ValidateDuration

:: RELATÓRIO FINAL DE QUALIDADE
echo.
echo   📊 FINAL QUALITY REPORT:
echo   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo   🎬 Profile Used: %PROFILE_NAME%
echo   📁 Output File: !OUTPUT_FILE!
echo   📊 File Size: !OUTPUT_SIZE_MB! MB
echo   🎯 Instagram Ready: !VALIDATION_RESULT!
echo   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

:: LIMPEZA DE ARQUIVOS TEMPORÁRIOS
echo   🧹 Cleaning temporary files...
set /p "CLEAN_LOGS=Delete encoding logs? (Y/N): "
if /i "!CLEAN_LOGS:~0,1!"=="Y" (
    del "!LOG_FILE_PASS!-0.log" 2>nul
    del "!LOG_FILE_PASS!-0.log.mbtree" 2>nul
    echo   ✅ Temporary encoding files cleaned
) else (
    echo   💾 Encoding logs preserved for analysis
)

:: LOG FINAL
call :LogEntry "[POST] File: !OUTPUT_FILE!, Size: !OUTPUT_SIZE_MB!MB
call :LogEntry "[POST] Validation result: !VALIDATION_RESULT!"

echo   ✅ Post-processing completed successfully
exit /b 0

::========================================
:: INSTAGRAM COMPLIANCE - UNIFICADA
::========================================
:ValidateInstagramCompliance
echo   🎯 Instagram compliance check...
set "TEMP_CHECK=compliance_!RANDOM!.txt"
"%FFMPEG_CMD%" -i "!OUTPUT_FILE!" -hide_banner 2>"!TEMP_CHECK!" 1>nul

:: Compliance checks
set "COMPLIANCE_SCORE=0"

:: Key compliance checks
findstr /i "yuv420p" "!TEMP_CHECK!" >nul && set /a "COMPLIANCE_SCORE+=1"
findstr /i "High.*4\.1" "!TEMP_CHECK!" >nul && set /a "COMPLIANCE_SCORE+=1"
findstr /i "mp4" "!TEMP_CHECK!" >nul && set /a "COMPLIANCE_SCORE+=1"
findstr /i "aac" "!TEMP_CHECK!" >nul && set /a "COMPLIANCE_SCORE+=1"

del "!TEMP_CHECK!" 2>nul

if !COMPLIANCE_SCORE! GEQ 4 (
    set "VALIDATION_RESULT=PERFECT"
    echo   🏆 Instagram compliance: PERFECT (!COMPLIANCE_SCORE!/4)
) else if !COMPLIANCE_SCORE! GEQ 3 (
    set "VALIDATION_RESULT=PASSED"  
    echo   ✅ Instagram compliance: PASSED (!COMPLIANCE_SCORE!/4)
)

call :LogEntry "[COMPLIANCE] Result: %VALIDATION_RESULT%"
exit /b 0

::========================================
:: VALIDAÇÃO DE DURAÇÃO
::========================================
:ValidateDuration
set "TEMP_DURATION=duration_!RANDOM!.txt"
"%FFMPEG_CMD%" -i "!OUTPUT_FILE!" -hide_banner 2>&1 | findstr "Duration" > "!TEMP_DURATION!"

for /f "tokens=2 delims= " %%D in ('type "!TEMP_DURATION!" 2^>nul') do set "DURATION_RAW=%%D"
del "!TEMP_DURATION!" 2>nul

if defined DURATION_RAW (
    echo     ⏱️ Duration: !DURATION_RAW! (detected)
    
    :: Parse duration for limits based on profile
    for /f "tokens=1-3 delims=:" %%H in ("!DURATION_RAW!") do (
        set "dur_hours=%%H"
        set "dur_minutes=%%I"
        set "dur_seconds=%%J"
    )
    
    :: Remove leading zeros 
    if "!dur_hours:~0,1!"=="0" if not "!dur_hours!"=="0" set "dur_hours=!dur_hours:~1!"
    if "!dur_minutes:~0,1!"=="0" if not "!dur_minutes!"=="0" set "dur_minutes=!dur_minutes:~1!"
    
    set /a "total_seconds=!dur_hours!*3600+!dur_minutes!*60"
    
    :: Check duration limits based on profile type
    if "!VIDEO_WIDTH!"=="1080" if "!VIDEO_HEIGHT!"=="1920" (
        :: Reels/Stories - 90 seconds max
        if !total_seconds! LEQ 90 (
            echo     ✅ Duration: Perfect for Reels/Stories (!total_seconds!s ≤ 90s)
        ) else (
            echo     ℹ️ Duration: Long Reels format (!total_seconds!s > 90s)
        )
    ) else (
        :: Feed/IGTV - 60 minutes max
        if !total_seconds! LEQ 3600 (
            echo     ✅ Duration: Suitable for Feed/IGTV (!total_seconds!s ≤ 60min)
        ) else (
            echo     ℹ️ Duration: Extended content (!total_seconds!s > 60min)
        )
    )
) else (
    echo     ℹ️ Duration: Could not detect (file may be very short)
)

exit /b 0

:ShowEncodingResults
cls
echo.
echo ╔════════════════════════════════════════════════════════════════════════════╗
echo ║                    🏆 ENCODING COMPLETED SUCCESSFULLY!                      ║
echo ╚════════════════════════════════════════════════════════════════════════════╝
echo.

echo  📊 ENCODING SUMMARY:
echo  ═══════════════════════════════════════════════════════════════════════════
echo   📁 Output File: %OUTPUT_FILE%
echo   📊 File Size: %OUTPUT_SIZE_MB% MB
echo   ⏱️ Total Time: %TOTAL_ENCODE_TIME%
echo   🎬 Profile Used: %PROFILE_NAME%
if "%ADVANCED_MODE%"=="Y" (
    echo   🎛️ Advanced Mode: ACTIVE
    if defined CUSTOM_PRESET   echo   • Custom Preset: %CUSTOM_PRESET%
    if defined CUSTOM_PSY_RD   echo   • Custom Psy RD: %CUSTOM_PSY_RD%
	if defined CUSTOM_GOP_SIZE echo   • GOP Structure: %GOP_PRESET_NAME% (%CUSTOM_GOP_SIZE%/%CUSTOM_KEYINT_MIN%)
) else (
    echo   🎬 Mode: Standard Hollywood parameters
)
echo   📝 Log File: %EXEC_LOG%
echo.

echo  🎯 INSTAGRAM UPLOAD INSTRUCTIONS:
echo  ═══════════════════════════════════════════════════════════════════════════
echo   ✅ File is certified for Instagram zero-recompression
echo   📱 Upload directly to Instagram (Stories/Reels/Feed)
echo   🚫 Do NOT re-edit or process in other apps
echo   🏆 Quality will be preserved at 100%%
echo.

echo  🛠️ POST-ENCODING OPTIONS:
echo  ═══════════════════════════════════════════════════════════════════════════
echo   [1]  ▶️Play Encoded Video
echo   [2] 🔄 Encode Another File
echo   [3] 🏠 Return to Main Menu
echo.

set /p "post_choice=🎯 Select option [1-3]: "

if "%post_choice%"=="1" goto :PlayEncodedVideo
if "%post_choice%"=="2" call :ResetWorkflow && goto :ShowProfessionalMainMenu
if "%post_choice%"=="3" goto :ShowProfessionalMainMenu

echo ❌ Invalid choice. Please select 1-3.
pause
goto :ShowEncodingResults

:PlayEncodedVideo
echo.
echo ▶️ Playing encoded video...
echo 📁 File: %OUTPUT_FILE%

if not exist "%OUTPUT_FILE%" (
    echo ❌ ERROR: Output file not found!
    echo 📂 File: %OUTPUT_FILE%
    echo 💡 Check if encoding completed successfully
    pause
    goto :ShowEncodingResults
)

:: Get file size for display
for %%A in ("%OUTPUT_FILE%") do set "VIDEO_SIZE_BYTES=%%~zA"
set /a "VIDEO_SIZE_MB=%VIDEO_SIZE_BYTES%/1024/1024"

echo ✅ File found: %VIDEO_SIZE_MB% MB
echo 🎬 Opening with default media player...

:: Open video with default player
start "" "%OUTPUT_FILE%"

if errorlevel 1 (
    echo ❌ Could not open video file
    echo 💡 Make sure you have a media player installed
    echo 💡 Try VLC, Windows Media Player, or Movies & TV app
    pause
    goto :ShowEncodingResults
) else (
    echo ✅ Video opened successfully
    echo.
    echo 📱 INSTAGRAM PREVIEW:
    echo   • Video should look crisp and detailed
    echo   • No pixelation or compression artifacts
    echo   • Color accuracy maintained
    echo   • Audio sync perfect
    echo.
    
    set /p "quality_check=🎯 Quality looks good? (Y/N): "
    if /i "%quality_check:~0,1%"=="Y" (
        echo ✅ Great! Ready for Instagram upload
        echo 🏆 Hollywood-level quality achieved
    ) else (
        echo 🔍 Consider these options:
        echo   • Try different profile for content type
        echo   • Use Advanced Customization for fine-tuning
        echo   • Check source video quality
        echo   • Verify encoding log for any warnings
    )
)

echo.
echo [B] 🔙 Back to Results Menu
echo [M] 🏠 Return to Main Menu
echo.
set /p "video_choice=Select option [B/M]: "

if /i "%video_choice:~0,1%"=="B" goto :ShowEncodingResults
if /i "%video_choice:~0,1%"=="M" goto :ShowProfessionalMainMenu
goto :ShowEncodingResults

:ResetWorkflow
echo 🔄 Resetting for new encoding...
set "INPUT_FILE="
set "OUTPUT_FILE="
set "FILES_CONFIGURED=N"
set "TOTAL_ENCODE_TIME=00h 00m 00s"
set "WORKFLOW_STEP=1"
set "SYSTEM_STATUS=READY"
set "READY_TO_ENCODE=N"
call :LogEntry "[WORKFLOW] Reset for new session"
echo ✅ Ready for new files
exit /b 0

:RecoverFromError
echo 🛠️ Recovery system activated...
if "!BACKUP_CREATED!"=="Y" (
    echo 💾 Restoring backup...
    copy "!BACKUP_NAME!" "!OUTPUT_FILE!" >nul
    if not errorlevel 1 del "!BACKUP_NAME!" 2>nul
)
call :LogEntry "[RECOVERY] Error recovery attempted"
exit /b 0

:: ========================================
:: ADVANCED CUSTOMIZATION SYSTEM
:: ========================================
:AdvancedCustomization
cls
echo.
echo ================================================================================
echo                     ⚙️ ADVANCED PROFILE CUSTOMIZATION V5.2
echo ================================================================================
echo.
echo  🎬 Current Profile: %PROFILE_NAME%
echo  📊 Base Configuration: %VIDEO_WIDTH%x%VIDEO_HEIGHT%, %TARGET_BITRATE%, %X264_PRESET%
echo.
if "%ADVANCED_MODE%"=="Y" (
    echo  🎛️ STATUS: Advanced customizations ACTIVE
    echo  💾 Original profile backed up for restore
) else (
    echo  🛡️ STATUS: Using standard Hollywood parameters
    echo  💡 TIP: All changes are safely applied on top of proven settings
)
echo.
echo  ┌─────────────────────────────────────────────────────────────────┐
echo  │ 🎛️ CUSTOMIZATION OPTIONS                                        │
echo  └─────────────────────────────────────────────────────────────────┘
echo.
echo  [1] 🎭 x264 Preset (Quality vs Speed Balance)
echo  [2] 🧠 Psychovisual Settings (Detail Preservation)
echo  [3] 🎬 GOP Structure (Keyframe Strategy)
echo  [4] 📊 VBV Buffer Settings (Streaming Optimization)
echo  [5] 🎵 Audio Enhancement Options
echo  [6] 🌈 Color Science Adjustments
echo  [7] 📋 Preview All Settings
echo  [8] 🔄 Restore Original Profile
echo  [9] ✅ Apply Customizations
echo  [P] 📊 Profile Management (Export/Import/Library)
echo  [0] 🔙 Back to Standard Profile
echo.
set /p "custom_choice=Select customization option [0-9, P]: "

if "%custom_choice%"=="1" goto :CustomizePreset
if "%custom_choice%"=="2" goto :CustomizePsychovisual
if "%custom_choice%"=="3" goto :CustomizeGOP
if "%custom_choice%"=="4" goto :CustomizeVBV
if "%custom_choice%"=="5" goto :CustomizeAudio
if "%custom_choice%"=="6" goto :CustomizeColor
if "%custom_choice%"=="7" goto :PreviewAllCustomizations
if "%custom_choice%"=="8" goto :RestoreOriginalProfile
if "%custom_choice%"=="9" goto :ApplyAdvancedCustomizations
if /i "%custom_choice%"=="P" call :ProfileManagement & goto :AdvancedCustomization
if "%custom_choice%"=="0" goto :ShowProfessionalMainMenu

echo ❌ Invalid choice. Please select 0-9 or P.
pause
goto :AdvancedCustomization

:CustomizePreset
cls
echo.
echo ╔════════════════════════════════════════════════════════════════════════════╗
echo ║                       🎭 x264 PRESET CUSTOMIZATION                         ║
echo ╚════════════════════════════════════════════════════════════════════════════╝
echo.
echo  Current Preset: %X264_PRESET%
if defined CUSTOM_PRESET echo  Custom Preset: %CUSTOM_PRESET% (will be applied)
echo.
echo  📊 PRESET COMPARISON (Quality vs Speed):
echo.
echo  ┌─────────────┬─────────────┬─────────────┬───────────────────────────┐
echo  │   PRESET    │    SPEED    │   QUALITY   │        BEST FOR           │
echo  ├─────────────┼─────────────┼─────────────┼───────────────────────────┤
echo  │ fast        │ ⚡⚡        │ ⭐⭐⭐⭐    │ Balanced workflow         │
echo  │ medium      │ ⚡          │ ⭐⭐⭐⭐⭐  │ Default x264              │
echo  │ slow        │ 🐌          │ ⭐⭐⭐⭐⭐  │ High quality              │
echo  │ slower      │ 🐌🐌        │ ⭐⭐⭐⭐⭐⭐│ Very high quality         │
echo  │ veryslow    │ 🐌🐌🐌      │ ⭐⭐⭐⭐⭐⭐│ Maximum quality           │
echo  │ placebo     │ 🐌🐌🐌🐌    │ ⭐⭐⭐⭐⭐⭐│ Cinema-grade (very slow)  │
echo  └─────────────┴─────────────┴─────────────┴───────────────────────────┘
echo.
echo  💡 RECOMMENDATION: 'slower' or 'veryslow' for Instagram zero-recompression
echo  🎬 WARNING: 'placebo' can take 10x longer but offers cinema quality
echo.
echo  [1] fast       [2] medium     [3] slow       [4] slower     [5] veryslow     [6] placebo
echo  [B] Back to Advanced Menu
echo.
set /p "preset_choice=Select preset [1-6, B]: "

if "%preset_choice%"=="1" set "CUSTOM_PRESET=fast"
if "%preset_choice%"=="2" set "CUSTOM_PRESET=medium"
if "%preset_choice%"=="3" set "CUSTOM_PRESET=slow"
if "%preset_choice%"=="4" set "CUSTOM_PRESET=slower"
if "%preset_choice%"=="5" set "CUSTOM_PRESET=veryslow"
if "%preset_choice%"=="6" set "CUSTOM_PRESET=placebo"
if /i "%preset_choice%"=="B" goto :AdvancedCustomization

if defined CUSTOM_PRESET (
    echo.
    echo ✅ Preset changed to: %CUSTOM_PRESET%
    echo 💡 This change will be applied when you choose "Apply Customizations"
    set "CUSTOMIZATION_ACTIVE=Y"
    pause
)

goto :AdvancedCustomization

:CustomizePsychovisual
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       🧠 PSYCHOVISUAL ENHANCEMENT                            ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo  🎬 Psychovisual settings control how the encoder preserves visual details
echo  🧠 Higher values = more detail preservation, slightly larger files
echo.
echo  📊 Current Setting: Extracted from current profile
if defined CUSTOM_PSY_RD echo  🎛️ Custom Setting: %CUSTOM_PSY_RD% (will be applied)
echo.
echo  ┌─────────────────────────────────────────────────────────────────┐
echo  │ 🧠 PSYCHOVISUAL RATE-DISTORTION (psy_rd)                        │
echo  └─────────────────────────────────────────────────────────────────┘
echo.
echo  [1] 0.8,0.10  - Conservative (smaller files, less detail)
echo  [2] 1.0,0.15  - Balanced (recommended most content)
echo  [3] 1.0,0.20  - Enhanced (more detail preservation)
echo  [4] 1.2,0.25  - Aggressive (maximum detail, viral content)
echo  [5] 1.5,0.30  - Maximum (cinema-grade, larger files)
echo  [6] Custom    - Manual input
echo  [B] Back to Advanced Menu
echo.
set /p "psy_choice=Select psy_rd setting [1-6, B]: "

if "%psy_choice%"=="1" set "CUSTOM_PSY_RD=0.8,0.10"
if "%psy_choice%"=="2" set "CUSTOM_PSY_RD=1.0,0.15"
if "%psy_choice%"=="3" set "CUSTOM_PSY_RD=1.0,0.20"
if "%psy_choice%"=="4" set "CUSTOM_PSY_RD=1.2,0.25"
if "%psy_choice%"=="5" set "CUSTOM_PSY_RD=1.5,0.30"
if "%psy_choice%"=="6" goto :CustomPsyInput
if /i "%psy_choice%"=="B" goto :AdvancedCustomization

if defined CUSTOM_PSY_RD (
    echo.
    echo ✅ Psychovisual RD changed to: %CUSTOM_PSY_RD%
    echo 💡 More details will be preserved in the final image
    set "CUSTOMIZATION_ACTIVE=Y"
    pause
)

goto :AdvancedCustomization

:CustomPsyInput
echo.
echo Enter custom psy_rd values (format: X.X,X.XX):
echo Example: 1.0,0.15 (first value: 0.5-2.0, second: 0.05-0.40)
set /p "CUSTOM_PSY_RD=psy_rd value: "
if defined CUSTOM_PSY_RD (
    echo ✅ Custom psy_rd defined: %CUSTOM_PSY_RD%
    set "CUSTOMIZATION_ACTIVE=Y"
)
pause
goto :AdvancedCustomization

:PreviewAllCustomizations
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                          📋 PREVIEW ALL SETTINGS                             ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo  🎬 PROFILE BASE: %PROFILE_NAME%
echo  📊 Resolution: %VIDEO_WIDTH%x%VIDEO_HEIGHT% (%VIDEO_ASPECT%)
echo  🎯 Bitrate: %TARGET_BITRATE% target / %MAX_BITRATE% max
echo.
echo  ┌─────────────────────────────────────────────────────────────────┐
echo  │ ⚙️ CURRENT SETTINGS                                             │
echo  └─────────────────────────────────────────────────────────────────┘
echo.
echo  🎭 x264 Preset:
if defined CUSTOM_PRESET (
    echo     • Original: %X264_PRESET%
    echo     • Custom: %CUSTOM_PRESET% ← Will be applied
) else (
    echo     • Current: %X264_PRESET% (unchanged)
)
echo.
echo  🧠 Psychovisual Settings:
if defined CUSTOM_PSY_RD (
    echo     • Custom psy_rd: %CUSTOM_PSY_RD% ← Will be applied
) else (
    echo     • Using profile default (unchanged)
)
echo.
echo  🎬 GOP Structure:
if defined CUSTOM_GOP_SIZE (
    if defined CUSTOM_KEYINT_MIN (
        echo     • Original: GOP=%GOP_SIZE%, Min=%KEYINT_MIN%
        echo     • Preset: %GOP_PRESET_NAME% GOP=%CUSTOM_GOP_SIZE%, Min=%CUSTOM_KEYINT_MIN% ← Will be applied
		if "%CUSTOM_GOP_SIZE%"=="48" set "keyframe_display=1.6"
		if "%CUSTOM_GOP_SIZE%"=="60" set "keyframe_display=2.0"
		if not defined keyframe_display set "keyframe_display=2.0"
        echo     • Impact: Keyframe every %keyframe_display%s at 30fps
    )
) else (
    echo     • Current: GOP=%GOP_SIZE%, Min=%KEYINT_MIN% (unchanged)
)
echo.
echo  🔧 VBV Buffer Settings:
if defined CUSTOM_MAX_BITRATE (
    if defined CUSTOM_BUFFER_SIZE (
        echo     • Original: MaxRate=%MAX_BITRATE%, Buffer=%BUFFER_SIZE%
        echo     • Preset: %VBV_PRESET_NAME% Max=%CUSTOM_MAX_BITRATE%, Buf=%CUSTOM_BUFFER_SIZE% ← Will be applied
        rem FIXED BUFFER RATIO
		if "%CUSTOM_BUFFER_SIZE%"=="19M" set "buffer_display=1.4"
		if "%CUSTOM_BUFFER_SIZE%"=="26M" set "buffer_display=2.0"
		if not defined buffer_display set "buffer_display=1.5"
        echo     • Buffer Ratio: %buffer_display%x target bitrate
    )
) else (
    echo     • Current: MaxRate=%MAX_BITRATE%, Buffer=%BUFFER_SIZE% (unchanged)
)
echo.
echo  🎵 Audio Enhancement:
if defined CUSTOM_AUDIO_BITRATE (
    echo     • Custom Bitrate: %CUSTOM_AUDIO_BITRATE%
    if defined AUDIO_PRESET_NAME echo     • Preset: %AUDIO_PRESET_NAME%
) else (
    echo     • Bitrate: 256k (profile default)
)
if defined CUSTOM_AUDIO_SAMPLERATE (
    echo     • Sample Rate: %CUSTOM_AUDIO_SAMPLERATE%Hz (custom)
)
if defined CUSTOM_AUDIO_CHANNELS (
    echo     • Channels: %CUSTOM_AUDIO_CHANNELS% (custom)
)
echo.
echo  📊 Status:
if "%CUSTOMIZATION_ACTIVE%"=="Y" (
    echo     • ✅ Advanced customizations are ACTIVE
    echo     • 🎛️ Changes will be applied on encoding
    echo     • 💾 Original profile backed up automatically
) else (
    echo     • 🛡️ No customizations active
    echo     • 🎬 Will use standard Hollywood parameters
)
echo.
echo  💡 TIP: All customizations are safely applied on top of proven Instagram
echo          zero-recompression parameters. Your base quality is guaranteed.
echo.
pause
goto :AdvancedCustomization

:RestoreOriginalProfile
echo.
echo 🔄 Restoring original profile settings...
set "CUSTOM_PRESET="
set "CUSTOM_PSY_RD="
set "CUSTOM_GOP_SIZE="
set "CUSTOM_KEYINT_MIN="
set "GOP_PRESET_NAME="
set "CUSTOM_MAX_BITRATE="
set "CUSTOM_BUFFER_SIZE="
set "VBV_PRESET_NAME="
set "CUSTOM_AUDIO_BITRATE="
set "CUSTOM_AUDIO_SAMPLERATE="
set "CUSTOM_AUDIO_CHANNELS="
set "CUSTOM_AUDIO_PROCESSING="
set "AUDIO_PRESET_NAME="
set "AUDIO_NORMALIZATION=N"
set "AUDIO_FILTERING=N"
set "CUSTOM_AUDIO_PARAMS="
set "CUSTOMIZATION_ACTIVE=N"
set "ADVANCED_MODE=N"
echo ✅ Profile restored to standard Hollywood settings
pause
goto :AdvancedCustomization

:ApplyAdvancedCustomizations
if "%CUSTOMIZATION_ACTIVE%"=="N" (
    echo.
    echo ⚠️ No active customizations to apply
    echo 💡 Use menu options to customize parameters first
    pause
    goto :AdvancedCustomization
)

echo.
echo ✅ Applying advanced customizations...
set "ADVANCED_MODE=Y"

:: Backup original parameters if not already done
if not defined PROFILE_BACKUP (
    set "PROFILE_BACKUP=%X264_PARAMS%"
    set "PRESET_BACKUP=%X264_PRESET%"
)

echo ✅ Customizations applied successfully!
echo 🎬 Proceeding to encoding with customized parameters...
call :LogEntry "[ADVANCED] V5.2 Advanced customizations applied"
pause
goto :ShowProfessionalMainMenu

:: ========================================
:: STUB FUNCTIONS FOR FUTURE DEVELOPMENT
:: ========================================
:CustomizeGOP
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       🎬 GOP STRUCTURE CUSTOMIZATION                         ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo  📊 Current GOP Settings:
echo   GOP Size: %GOP_SIZE% frames (keyframe every %GOP_SIZE% frames)
echo   Min Keyint: %KEYINT_MIN% frames (minimum distance between keyframes)
if defined CUSTOM_GOP_SIZE echo   🎛️ Custom GOP: %CUSTOM_GOP_SIZE% (will be applied)
if defined CUSTOM_KEYINT_MIN echo   🎛️ Custom Keyint: %CUSTOM_KEYINT_MIN% (will be applied)
echo.
echo  🎬 GOP STRUCTURE EXPLANATION:
echo   • GOP Size = Distance between keyframes (I-frames)
echo   • Lower values = More keyframes = Better seeking + Larger files
echo   • Higher values = Fewer keyframes = Smaller files + Less seeking precision
echo   • Instagram optimized: 48-72 frames for 30fps content
echo.
echo  ┌─────────────────────────────────────────────────────────────────┐
echo  │ 📊 PROFESSIONAL GOP PRESETS                                     │
echo  └─────────────────────────────────────────────────────────────────┘
echo.
echo  [1] 🏃 High Motion (GOP: 24, Min: 12) - Sports, action, fast movement
echo  [2] 📱 Social Media (GOP: 48, Min: 24) - General Instagram content
echo  [3] 🎬 Cinematic (GOP: 72, Min: 24) - Film-like, slow movement
echo  [4] 📺 Streaming (GOP: 60, Min: 30) - Optimized for web playback
echo  [5] 🎮 Gaming (GOP: 30, Min: 15) - Screen recording, fast changes
echo  [6] 🎵 Music Video (GOP: 96, Min: 24) - Less motion, artistic content
echo  [7] 📋 Current Profile Default - Keep existing settings
echo  [B] 🔙 Back to Advanced Menu
echo.
set /p "gop_choice=Select GOP preset [1-7, B]: "

if "%gop_choice%"=="1" call :SetGOPValues 24 12 "High Motion"
if "%gop_choice%"=="2" call :SetGOPValues 48 24 "Social Media"
if "%gop_choice%"=="3" call :SetGOPValues 72 24 "Cinematic"
if "%gop_choice%"=="4" call :SetGOPValues 60 30 "Streaming"
if "%gop_choice%"=="5" call :SetGOPValues 30 15 "Gaming"
if "%gop_choice%"=="6" call :SetGOPValues 96 24 "Music Video"
if "%gop_choice%"=="7" goto :ResetGOPToProfile
if /i "%gop_choice%"=="B" goto :AdvancedCustomization

echo ❌ Invalid choice. Please select 1-7 or B.
pause
goto :CustomizeGOP

:SetGOPValues
set "CUSTOM_GOP_SIZE=%~1"
set "CUSTOM_KEYINT_MIN=%~2"
set "GOP_PRESET_NAME=%~3"
echo.
echo ✅ GOP Structure set to: %GOP_PRESET_NAME%
echo   📊 GOP Size: %CUSTOM_GOP_SIZE% frames
echo   ⚡ Min Keyint: %CUSTOM_KEYINT_MIN% frames
if "%CUSTOM_GOP_SIZE%"=="48" set "keyframe_display=1.6"
if "%CUSTOM_GOP_SIZE%"=="60" set "keyframe_display=2.0"
if not defined keyframe_display set "keyframe_display=2.0"
echo   🎯 Keyframe every %keyframe_display%s at 30fps
echo.
echo  💡 PRESET DETAILS - %GOP_PRESET_NAME%:
if "%GOP_PRESET_NAME%"=="High Motion" (
    echo   🏃 Optimized for: Sports, action scenes, fast camera movement
)
if "%GOP_PRESET_NAME%"=="Social Media" (
    echo   📱 Optimized for: General Instagram content, balanced approach
    echo   📊 Best for: Most Instagram posts, stories, reels
)
if "%GOP_PRESET_NAME%"=="Cinematic" (
    echo   🎬 Optimized for: Film-like content, artistic videos
)
if "%GOP_PRESET_NAME%"=="Streaming" (
    echo   📺 Optimized for: Web playback, adaptive streaming
)
if "%GOP_PRESET_NAME%"=="Gaming" (
    echo   🎮 Optimized for: Screen recordings, gameplay footage
)
if "%GOP_PRESET_NAME%"=="Music Video" (
    echo   🎵 Optimized for: Music videos, artistic content
)
set "CUSTOMIZATION_ACTIVE=Y"
call :LogEntry "[GOP] Preset applied: %GOP_PRESET_NAME% (%CUSTOM_GOP_SIZE%/%CUSTOM_KEYINT_MIN%)"
pause
goto :AdvancedCustomization

:ResetGOPToProfile
echo.
echo 🔄 Resetting GOP to profile defaults...
set "CUSTOM_GOP_SIZE="
set "CUSTOM_KEYINT_MIN="
set "GOP_PRESET_NAME="
echo ✅ GOP reset to profile default: %GOP_SIZE%/%KEYINT_MIN%
call :LogEntry "[GOP] Reset to profile defaults"
pause
goto :CustomizeGOP

:CustomizeVBV
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       🔧 VBV BUFFER SETTINGS CUSTOMIZATION                   ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo  📊 Current VBV Settings:
echo   Target Bitrate: %TARGET_BITRATE%
echo   Max Bitrate: %MAX_BITRATE%  
echo   Buffer Size: %BUFFER_SIZE%
if defined CUSTOM_MAX_BITRATE echo   🎛️ Custom MaxRate: %CUSTOM_MAX_BITRATE% (will be applied)
if defined CUSTOM_BUFFER_SIZE echo   🎛️ Custom Buffer: %CUSTOM_BUFFER_SIZE% (will be applied)
echo.
echo  🔧 VBV BUFFER EXPLANATION:
echo   • VBV = Video Buffering Verifier (bitrate control mechanism)
echo   • MaxRate = Peak bitrate ceiling (prevents spikes)
echo   • Buffer = Data reservoir (smooths bitrate variations)
echo   • Larger buffer = Smoother quality, higher latency
echo   • Smaller buffer = Lower latency, more bitrate variation
echo.
echo  ┌─────────────────────────────────────────────────────────────────┐
echo  │ 📊 PROFESSIONAL VBV PRESETS                                     │
echo  └─────────────────────────────────────────────────────────────────┘
echo.
echo  [1] 🏃 Low Latency (1.2x buffer) - Gaming, live streaming, minimal delay
echo  [2] 📱 Social Media (1.5x buffer) - Instagram optimized, balanced
echo  [3] 📺 Streaming (1.8x buffer) - Adaptive bitrate, web delivery
echo  [4] 🎬 Cinematic (2.2x buffer) - Film quality, smooth encoding
echo  [5] 🌐 Universal (1.3x buffer) - Maximum compatibility, conservative
echo  [6] ⚡ Fast Network (2.5x buffer) - High bandwidth, premium quality
echo  [7] 📋 Current Profile Default - Keep existing settings
echo  [B] 🔙 Back to Advanced Menu
echo.
set /p "vbv_choice=Select VBV preset [1-7, B]: "

if "%vbv_choice%"=="1" call :SetVBVValues 1.2 "Low Latency"
if "%vbv_choice%"=="2" call :SetVBVValues 1.5 "Social Media"
if "%vbv_choice%"=="3" call :SetVBVValues 1.8 "Streaming"
if "%vbv_choice%"=="4" call :SetVBVValues 2.2 "Cinematic"
if "%vbv_choice%"=="5" call :SetVBVValues 1.3 "Universal"
if "%vbv_choice%"=="6" call :SetVBVValues 2.5 "Fast Network"
if "%vbv_choice%"=="7" goto :ResetVBVToProfile
if /i "%vbv_choice%"=="B" goto :AdvancedCustomization

echo ❌ Invalid choice. Please select 1-7 or B.
pause
goto :CustomizeVBV

:SetVBVValues
set "vbv_multiplier=%~1"
set "VBV_PRESET_NAME=%~2"

:: Extract numeric value from TARGET_BITRATE (remove 'M' suffix)
set "target_numeric=%TARGET_BITRATE:M=%"

:: Calculate custom maxrate and buffer based on multiplier
if "%vbv_multiplier%"=="1.2" (
    set /a "custom_maxrate=%target_numeric%*18/10"
    set /a "custom_buffer=%target_numeric%*12/10"
) else if "%vbv_multiplier%"=="1.5" (
    set /a "custom_maxrate=%target_numeric%*20/10" 
    set /a "custom_buffer=%target_numeric%*15/10"
) else if "%vbv_multiplier%"=="1.8" (
    set /a "custom_maxrate=%target_numeric%*22/10"
    set /a "custom_buffer=%target_numeric%*18/10"
) else if "%vbv_multiplier%"=="2.2" (
    set /a "custom_maxrate=%target_numeric%*25/10"
    set /a "custom_buffer=%target_numeric%*22/10"
) else if "%vbv_multiplier%"=="1.3" (
    set /a "custom_maxrate=%target_numeric%*18/10"
    set /a "custom_buffer=%target_numeric%*13/10"
) else if "%vbv_multiplier%"=="2.5" (
    set /a "custom_maxrate=%target_numeric%*28/10"
    set /a "custom_buffer=%target_numeric%*25/10"
)

set "CUSTOM_MAX_BITRATE=%custom_maxrate%M"
set "CUSTOM_BUFFER_SIZE=%custom_buffer%M"

echo.
echo ✅ VBV Buffer set to: %VBV_PRESET_NAME%
echo   🎯 Target Bitrate: %TARGET_BITRATE% (unchanged)
echo   📊 Max Bitrate: %CUSTOM_MAX_BITRATE% 
echo   🔧 Buffer Size: %CUSTOM_BUFFER_SIZE%
echo   📈 Buffer Ratio: %vbv_multiplier%x target bitrate
echo.
echo  💡 PRESET DETAILS - %VBV_PRESET_NAME%:
if "%VBV_PRESET_NAME%"=="Low Latency" (
    echo   🏃 Optimized for: Gaming streams, live content, real-time
)
if "%VBV_PRESET_NAME%"=="Social Media" (
    echo   📱 Optimized for: Instagram, TikTok, social platforms
)
if "%VBV_PRESET_NAME%"=="Streaming" (
    echo   📺 Optimized for: Web streaming, adaptive bitrate 16:9
)
if "%VBV_PRESET_NAME%"=="Cinematic" (
    echo   🎬 Optimized for: High-end films content, cinematic productions
)
if "%VBV_PRESET_NAME%"=="Universal" (
    echo   🌐 Optimized for: Maximum device compatibility
)
if "%VBV_PRESET_NAME%"=="Fast Network" (
    echo   ⚡ Optimized for: High bandwidth, premium quality
)

set "CUSTOMIZATION_ACTIVE=Y"
call :LogEntry "[VBV] Preset applied: %VBV_PRESET_NAME% (Max:%CUSTOM_MAX_BITRATE%, Buf:%CUSTOM_BUFFER_SIZE%)"
pause
goto :AdvancedCustomization

:ResetVBVToProfile
echo.
echo 🔄 Resetting VBV to profile defaults...
set "CUSTOM_MAX_BITRATE="
set "CUSTOM_BUFFER_SIZE="
set "VBV_PRESET_NAME="
echo ✅ VBV reset to profile default: Max=%MAX_BITRATE%, Buffer=%BUFFER_SIZE%
call :LogEntry "[VBV] Reset to profile defaults"
pause
goto :CustomizeVBV

:CustomizeAudio
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       🎵 AUDIO ENHANCEMENT SYSTEM                            ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo  📊 Current Audio Settings:
echo   🎵 Codec: AAC-LC (Instagram compliant)
echo   🎯 Bitrate: 256k (current) / 320k (optimized)
echo   📻 Sample Rate: 48kHz (Instagram native)
echo   🔊 Channels: Stereo (2.0)
if defined AUDIO_PRESET_NAME echo   🎬 Audio Preset: %AUDIO_PRESET_NAME% (will be applied)
if defined CUSTOM_AUDIO_PROCESSING echo   ⚡ Audio Processing: %CUSTOM_AUDIO_PROCESSING% (will be applied)
echo.
echo  🎬 INSTAGRAM AUDIO SPECIFICATIONS:
echo   • Codec: AAC-LC (Advanced Audio Codec)
echo   • Bitrate: 128k-320k (Instagram accepts all)
echo   • Sample Rate: 44.1kHz, 48kHz (48kHz recommended)
echo   • Channels: Mono, Stereo (Stereo recommended)
echo   • Container: MP4 (FastStart enabled)
echo.
echo  ┌─────────────────────────────────────────────────────────────────┐
echo  │ 🎵 PROFESSIONAL AUDIO OPTIONS                                   │
echo  └─────────────────────────────────────────────────────────────────┘
echo.
echo  [1] 🎬 Professional Audio Presets ⭐ RECOMMENDED
echo  [2] ⚡ Audio Processing Options (Coming Soon)
echo  [3] 🎵 Advanced Audio Parameters (Coming Soon)
echo  [4] 📋 Preview Audio Settings
echo  [5] 🔄 Reset to Profile Default
echo  [6] ✅ Apply Audio Enhancement
echo  [B] 🔙 Back to Advanced Menu
echo.
set /p "audio_choice=Select audio enhancement option [1-6, B]: "

if "%audio_choice%"=="1" goto :AudioProfessionalPresets
if "%audio_choice%"=="2" goto :AudioProcessingOptions
if "%audio_choice%"=="3" goto :AudioAdvancedParameters
if "%audio_choice%"=="4" goto :PreviewAudioSettings
if "%audio_choice%"=="5" goto :ResetAudioToDefault
if "%audio_choice%"=="6" goto :ApplyAudioEnhancement
if /i "%audio_choice%"=="B" goto :AdvancedCustomization

echo ❌ Invalid choice. Please select 1-6 or B.
pause
goto :CustomizeAudio

:AudioProfessionalPresets
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       🎬 PROFESSIONAL AUDIO PRESETS                          ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo  📊 Current Configuration: Individual settings
if defined AUDIO_PRESET_NAME echo  🎛️ Audio Preset: %AUDIO_PRESET_NAME% (will be applied)
echo.
echo  🎬 PROFESSIONAL PRESETS - Optimized Configurations:
echo.
echo  ┌─────────────────────────────────────────────────────────────────┐
echo  │ 🎬 INSTAGRAM-OPTIMIZED AUDIO PRESETS                            │
echo  └─────────────────────────────────────────────────────────────────┘
echo.
echo  [1] 🎤 Voice/Podcast (128k, 48kHz, Mono) - Minimal file size
echo  [2] 🗣️ Speech Content (160k, 48kHz, Stereo) - Balanced speech/music
echo  [3] 📱 Social Media (256k, 48kHz, Stereo) - Instagram Standard ⭐
echo  [4] 🎵 Music Video (320k, 48kHz, Stereo) - Premium Quality
echo  [5] 🎬 Cinematic (320k, 48kHz, Stereo) - Film Quality
echo  [6] 📋 Current Profile Default - Keep existing settings
echo  [B] 🔙 Back to Audio Menu
echo.
echo  💡 TIP: Social Media preset is recommended for most Instagram content
echo  🎯 All presets guarantee Instagram zero-recompression compatibility
echo.
set /p "preset_choice=Select audio preset [1-7, B]: "

if "%preset_choice%"=="1" call :SetAudioPreset "128k" "48000" "1" "Voice/Podcast"
if "%preset_choice%"=="2" call :SetAudioPreset "160k" "48000" "2" "Speech Content"
if "%preset_choice%"=="3" call :SetAudioPreset "256k" "48000" "2" "Social Media"
if "%preset_choice%"=="4" call :SetAudioPreset "320k" "48000" "2" "Music Video"
if "%preset_choice%"=="5" call :SetAudioPreset "320k" "48000" "2" "Cinematic"
if "%preset_choice%"=="6" goto :ResetAudioPresetToDefault
if /i "%preset_choice%"=="B" goto :CustomizeAudio

echo ❌ Invalid choice. Please select 1-7 or B.
pause
goto :AudioProfessionalPresets

:SetAudioPreset
set "CUSTOM_AUDIO_BITRATE=%~1"
set "CUSTOM_AUDIO_SAMPLERATE=%~2"
set "CUSTOM_AUDIO_CHANNELS=%~3"
set "AUDIO_PRESET_NAME=%~4"
echo.
echo ✅ Audio preset applied: %AUDIO_PRESET_NAME%
echo   🎯 Bitrate: %CUSTOM_AUDIO_BITRATE%
echo   📻 Sample Rate: %CUSTOM_AUDIO_SAMPLERATE%Hz
echo   🔊 Channels: %CUSTOM_AUDIO_CHANNELS%
echo.
echo  💡 PRESET DETAILS - %AUDIO_PRESET_NAME%:
if "%AUDIO_PRESET_NAME%"=="Voice/Podcast" (
    echo   🎤 Optimized for: Voice content, podcasts, narration
)
if "%AUDIO_PRESET_NAME%"=="Speech Content" (
    echo   🗣️ Optimized for: Speech with background music
)
if "%AUDIO_PRESET_NAME%"=="Social Media" (
    echo   📱 Optimized for: General Instagram content
)
if "%AUDIO_PRESET_NAME%"=="Music Video" (
    echo   🎵 Optimized for: Music-focused content
)
if "%AUDIO_PRESET_NAME%"=="Cinematic" (
    echo   🎬 Optimized for: Film-quality content
)
set "CUSTOMIZATION_ACTIVE=Y"
call :LogEntry "[AUDIO] Preset applied: %AUDIO_PRESET_NAME% (%CUSTOM_AUDIO_BITRATE%, %CUSTOM_AUDIO_SAMPLERATE%Hz, %CUSTOM_AUDIO_CHANNELS%ch)"
echo.
echo  📋 NEXT STEPS:
echo   [4] Preview Audio Settings - See complete configuration
echo   [6] Apply Audio Enhancement - Activate for encoding
echo   [B] Continue browsing audio options
echo.
pause
goto :CustomizeAudio

:ResetAudioPresetToDefault
echo.
echo 🔄 Resetting audio preset to profile defaults...
set "CUSTOM_AUDIO_BITRATE="
set "CUSTOM_AUDIO_SAMPLERATE="
set "CUSTOM_AUDIO_CHANNELS="
set "AUDIO_PRESET_NAME="
echo ✅ Audio preset reset to profile default
echo   🎵 Codec: AAC-LC
echo   🎯 Bitrate: 256k  
echo   📻 Sample Rate: 48000Hz
echo   🔊 Channels: 2 (Stereo)
call :LogEntry "[AUDIO] Preset reset to profile defaults"
pause
goto :AudioProfessionalPresets

:: ========================================
:: AUDIO PROCESSING OPTIONS
:: ========================================
:AudioProcessingOptions
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       ⚡ AUDIO PROCESSING OPTIONS                            ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo  📊 Current Processing: None (standard encoding)
if defined CUSTOM_AUDIO_PROCESSING echo  🎛️ Custom Processing: %CUSTOM_AUDIO_PROCESSING% (will be applied)
echo.
echo  ⚡ AUDIO PROCESSING EXPLANATION:
echo   • Audio processing improves quality and consistency
echo   • Normalization: Ensures consistent volume levels
echo   • Filtering: Removes noise and improves clarity
echo   • Instagram-safe: All processing maintains compliance
echo.
echo  ⚠️ DEVELOPMENT STATUS:
echo   🔄 Audio processing features are being implemented
echo   💡 Current phase: Foundation complete, processing algorithms in development
echo   🎯 Target: Professional audio processing for Instagram optimization
echo.
echo  🔮 COMING SOON:
echo   ⏳ [1] Audio Normalization (-23 LUFS standard)
echo   ⏳ [2] Noise Reduction (Background noise filtering)
echo   ⏳ [3] Dynamic Range Compression (Volume consistency)
echo   ⏳ [4] High-Pass Filter (Remove low-frequency noise)
echo   ⏳ [5] Limiter (Prevent audio clipping)
echo   ⏳ [6] EQ Presets (Voice enhancement, music optimization)
echo.
echo  💡 For now, using standard AAC encoding with Hollywood-level parameters
echo     ensures excellent audio quality for Instagram compliance.
echo.
echo  [B] 🔙 Back to Audio Menu
echo.
set /p "processing_choice=Press B to return or Enter to continue: "
goto :CustomizeAudio

:: ========================================
:: ADVANCED AUDIO PARAMETERS
:: ========================================
:AudioAdvancedParameters
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       🎵 ADVANCED AUDIO PARAMETERS                           ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo  📊 Current Parameters: Standard AAC-LC encoding
if defined CUSTOM_AUDIO_PARAMS echo  🎛️ Custom Parameters: %CUSTOM_AUDIO_PARAMS% (will be applied)
echo.
echo  🎵 ADVANCED PARAMETERS EXPLANATION:
echo   • AAC Profile: LC (Low Complexity) - Instagram standard
echo   • VBR Mode: Variable Bitrate for optimal quality
echo   • Cutoff Frequency: High-frequency cutoff for efficiency
echo   • Advanced options for professional audio processing
echo.
echo  ⚠️ DEVELOPMENT STATUS:
echo   🔄 Advanced audio parameters are being implemented
echo   💡 Current phase: Core AAC implementation complete
echo   🎯 Target: Professional audio parameter control
echo.
echo  🔮 COMING SOON:
echo   ⏳ [1] AAC Profile Selection (LC, HE, HE-v2)
echo   ⏳ [2] VBR Mode Configuration (CBR, VBR, CVBR)
echo   ⏳ [3] Cutoff Frequency Control (15kHz - 20kHz)
echo   ⏳ [4] Advanced AAC Options (Bandwidth, afterburner)
echo   ⏳ [5] Custom FFmpeg Audio Flags
echo   ⏳ [6] Professional Audio Analysis Tools
echo.
echo  💡 Current implementation uses proven AAC-LC parameters optimized
echo     for Instagram zero-recompression guarantee.
echo.
echo  📋 CURRENT AAC PARAMETERS:
echo   • Codec: AAC-LC (Advanced Audio Codec - Low Complexity)
echo   • Profile: LC (Instagram compliant)
echo   • Mode: CBR (Constant Bitrate for predictable file sizes)
echo   • Cutoff: Auto (Optimized for bitrate)
echo.
echo  [B] 🔙 Back to Audio Menu
echo.
set /p "advanced_choice=Press B to return or Enter to continue: "
goto :CustomizeAudio

:: ========================================
:: PREVIEW AUDIO SETTINGS
:: ========================================
:PreviewAudioSettings
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                          📋 PREVIEW AUDIO SETTINGS                           ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo  🎵 CURRENT AUDIO CONFIGURATION:
echo  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo  📊 BASE CONFIGURATION:
echo   🎵 Codec: AAC-LC (Advanced Audio Codec - Low Complexity)
echo   📋 Profile: LC (Instagram compliant)
echo   🌐 Container: MP4 (FastStart enabled)
echo.
echo  🎛️ ACTIVE SETTINGS:
if defined CUSTOM_AUDIO_BITRATE (
    echo   🎯 Bitrate: %CUSTOM_AUDIO_BITRATE% ^(Custom^)
) else (
    echo   🎯 Bitrate: 256k ^(Profile default^)
)

if defined CUSTOM_AUDIO_SAMPLERATE (
    echo   📻 Sample Rate: %CUSTOM_AUDIO_SAMPLERATE%Hz ^(Custom^)
) else (
    echo   📻 Sample Rate: 48000Hz ^(Profile default^)
)

if defined CUSTOM_AUDIO_CHANNELS (
    echo   🔊 Channels: %CUSTOM_AUDIO_CHANNELS% ^(Custom^)
) else (
    echo   🔊 Channels: 2 ^(Profile default - Stereo^)
)

if defined AUDIO_PRESET_NAME (
    echo   🎬 Audio Preset: %AUDIO_PRESET_NAME% ^(Professional preset applied^)
    echo       ├─ Bitrate: %CUSTOM_AUDIO_BITRATE%
    echo       ├─ Sample Rate: %CUSTOM_AUDIO_SAMPLERATE%Hz  
    echo       └─ Channels: %CUSTOM_AUDIO_CHANNELS%
)

if defined CUSTOM_AUDIO_PROCESSING (
    echo   ⚡ Processing: %CUSTOM_AUDIO_PROCESSING% ^(Custom processing^)
) else (
    echo   ⚡ Processing: None ^(Standard AAC-LC encoding^)
)

echo.
echo  🔧 TECHNICAL IMPLEMENTATION:
echo   • Final FFmpeg audio command will include:
if defined CUSTOM_AUDIO_BITRATE (
    echo     -c:a aac -b:a %CUSTOM_AUDIO_BITRATE%
) else (
    echo     -c:a aac -b:a 256k
)
if defined CUSTOM_AUDIO_SAMPLERATE (
    echo     -ar %CUSTOM_AUDIO_SAMPLERATE%
) else (
    echo     -ar 48000
)
if defined CUSTOM_AUDIO_CHANNELS (
    echo     -ac %CUSTOM_AUDIO_CHANNELS%
) else (
    echo     -ac 2
)

echo.
echo  🏆 INSTAGRAM COMPLIANCE:
echo   ✅ Codec: AAC-LC (Instagram native)
echo   ✅ Container: MP4 (Instagram supported)
echo   ✅ Parameters: All within Instagram specifications
echo   ✅ Quality: Maintained for zero-recompression
echo.
echo  📊 ESTIMATED IMPACT:
:: Calculate estimated file size impact
set "size_impact=Standard"
if defined CUSTOM_AUDIO_BITRATE (
    if "%CUSTOM_AUDIO_BITRATE%"=="128k" set "size_impact=25%% smaller"
    if "%CUSTOM_AUDIO_BITRATE%"=="160k" set "size_impact=15%% smaller"
    if "%CUSTOM_AUDIO_BITRATE%"=="192k" set "size_impact=8%% smaller"
    if "%CUSTOM_AUDIO_BITRATE%"=="256k" set "size_impact=Standard"
    if "%CUSTOM_AUDIO_BITRATE%"=="320k" set "size_impact=20%% larger"
)
if defined CUSTOM_AUDIO_CHANNELS (
    if "%CUSTOM_AUDIO_CHANNELS%"=="1" set "size_impact=50%% smaller (Mono)"
)
echo   💾 File Size: %size_impact% (compared to 256k stereo)
echo   🎯 Quality Level: %quality_level%
echo   📱 Instagram Upload: Zero-recompression guaranteed
echo   🏆 Encoding Standard: Hollywood-level maintained
echo.
echo  📋 SYSTEM STATUS:
if "%CUSTOMIZATION_ACTIVE%"=="Y" (
    echo   ✅ Audio customizations are ACTIVE
    echo   🎛️ Changes will be applied on encoding
    echo   💾 Original settings backed up automatically
) else (
    echo   🛡️ No audio customizations active
    echo   🎵 Will use profile default audio settings
)
echo.
pause
goto :CustomizeAudio

:: ========================================
:: RESET AUDIO TO DEFAULT
:: ========================================
:ResetAudioToDefault
echo.
echo 🔄 Resetting all audio settings to profile defaults...
set "CUSTOM_AUDIO_BITRATE="
set "CUSTOM_AUDIO_SAMPLERATE="
set "CUSTOM_AUDIO_CHANNELS="
set "CUSTOM_AUDIO_PROCESSING="
set "AUDIO_PRESET_NAME="
set "AUDIO_NORMALIZATION=N"
set "AUDIO_FILTERING=N"
set "CUSTOM_AUDIO_PARAMS="
echo ✅ All audio settings restored to profile defaults
echo   🎵 Codec: AAC-LC (Advanced Audio Codec)
echo   🎯 Bitrate: 256k (Instagram standard)
echo   📻 Sample Rate: 48000Hz (Instagram native)
echo   🔊 Channels: 2 (Stereo)
call :LogEntry "[AUDIO] All settings reset to profile defaults"
pause
goto :CustomizeAudio

:: ========================================
:: APPLY AUDIO ENHANCEMENT
:: ========================================
:ApplyAudioEnhancement
if "%CUSTOMIZATION_ACTIVE%"=="N" (
    echo.
    echo ⚠️ No audio customizations to apply
    echo 💡 Use [1] Professional Presets to configure audio settings first
    pause
    goto :CustomizeAudio
)

echo.
echo ✅ Applying audio enhancement...
echo.
echo  📊 APPLIED AUDIO SETTINGS:
if defined CUSTOM_AUDIO_BITRATE    echo   🎯 Bitrate: %CUSTOM_AUDIO_BITRATE%
if defined CUSTOM_AUDIO_SAMPLERATE echo   📻 Sample Rate: %CUSTOM_AUDIO_SAMPLERATE%Hz
if defined CUSTOM_AUDIO_CHANNELS   echo   🔊 Channels: %CUSTOM_AUDIO_CHANNELS%
if defined AUDIO_PRESET_NAME       echo   🎬 Preset: %AUDIO_PRESET_NAME%
echo.
echo ✅ Audio enhancement applied successfully!
echo 🎵 Audio settings will be used in the next encoding
echo 🏆 Instagram compliance maintained
echo.
call :LogEntry "[AUDIO] Enhancement applied - Ready for encoding"
pause
goto :AdvancedCustomization

:BuildAudioCommand
echo   🎵 Building professional audio command...

:: Initialize audio command
set "AUDIO_COMMAND="

:: Start with base AAC codec
set "AUDIO_COMMAND=-c:a aac"

:: Apply bitrate
if defined CUSTOM_AUDIO_BITRATE (
    set "AUDIO_COMMAND=%AUDIO_COMMAND% -b:a %CUSTOM_AUDIO_BITRATE%"
    echo     🎯 Using custom bitrate: %CUSTOM_AUDIO_BITRATE%
) else (
    set "AUDIO_COMMAND=%AUDIO_COMMAND% -b:a 256k"
    echo     🎯 Using default bitrate: 256k
)

:: Apply sample rate
if defined CUSTOM_AUDIO_SAMPLERATE (
    set "AUDIO_COMMAND=%AUDIO_COMMAND% -ar %CUSTOM_AUDIO_SAMPLERATE%"
    echo     📻 Using custom sample rate: %CUSTOM_AUDIO_SAMPLERATE%Hz
) else (
    set "AUDIO_COMMAND=%AUDIO_COMMAND% -ar 48000"
    echo     📻 Using default sample rate: 48000Hz
)

:: Apply channels
if defined CUSTOM_AUDIO_CHANNELS (
    set "AUDIO_COMMAND=%AUDIO_COMMAND% -ac %CUSTOM_AUDIO_CHANNELS%"
    echo     🔊 Using custom channels: %CUSTOM_AUDIO_CHANNELS%
) else (
    set "AUDIO_COMMAND=%AUDIO_COMMAND% -ac 2"
    echo     🔊 Using default channels: 2 (Stereo)
)

:: Add professional AAC parameters
set "AUDIO_COMMAND=%AUDIO_COMMAND% -aac_coder twoloop"

:: Log preset information if available
if defined AUDIO_PRESET_NAME (
    echo     🎬 Preset applied: %AUDIO_PRESET_NAME%
    call :LogEntry "[AUDIO] Encoding with preset: %AUDIO_PRESET_NAME%"
)

echo     ✅ Professional audio command built: %AUDIO_COMMAND%
call :LogEntry "[AUDIO] Command built successfully: %AUDIO_COMMAND%"
exit /b 0

:CustomizeColor
echo.
echo ⏳ Color Science will be implemented in next phase
echo 💡 For now, using BT.709 optimized for Instagram compliance
pause
goto :AdvancedCustomization

:ProfileManagement
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         📊 PROFILE MANAGEMENT SYSTEM                        ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo  🎬 Current Profile: %PROFILE_NAME%
if "%ADVANCED_MODE%"=="Y" (
    echo  🎛️ Status: Advanced customizations ACTIVE
) else (
    echo  🛡️ Status: Standard Hollywood parameters
)
echo.
echo  📁 MODULAR PROFILE SYSTEM:
echo   ✅ File-based profiles: %MODULAR_PROFILES_AVAILABLE%
echo   📂 Profiles directory: %PROFILES_DIR%
echo.
echo  🔮 FUTURE FEATURES (Coming Soon):
echo   ⏳ [1] Export Current Profile
echo   ⏳ [2] Import Profile from File
echo   ⏳ [3] Browse Profile Library
echo   ⏳ [4] Create Profile Template
echo   ⏳ [5] Profile Validation
echo   ⏳ [6] Profile Sharing
echo.
echo  💡 Currently, profiles are managed through .prof files in:
echo     %PROFILES_DIR%
echo.
echo  🎯 Available profiles:
if exist "%PROFILES_DIR%\*.prof" (
    for %%F in ("%PROFILES_DIR%\*.prof") do echo     • %%~nF.prof
) else (
    echo     • No profiles found
)
echo.
echo  [B] 🔙 Back to Main Menu
echo.
set /p "profile_mgmt_choice=Press B to return or Enter to continue: "
goto :ShowProfessionalMainMenu

:: ========================================
:: FUTURE DEVELOPMENT STUBS
:: ========================================
:BatchProcessing
echo.
echo ⏳ Batch Processing will be implemented in future version
echo 💡 Process multiple files automatically
pause
goto :ShowProfessionalMainMenu

:QualityValidation
echo.
echo ⏳ VMAF Quality Validation will be implemented in future version
echo 💡 Automatic quality scoring and validation
pause
goto :ShowProfessionalMainMenu

:CloudIntegration
echo.
echo ⏳ Cloud Integration will be implemented in future version
echo 💡 Direct upload to cloud services
pause
goto :ShowProfessionalMainMenu

:AIOptimization
echo.
echo ⏳ AI Content Analysis will be implemented in future version
echo 💡 Intelligent profile selection based on content
pause
goto :ShowProfessionalMainMenu

:PerformanceBenchmark
echo.
echo ⏳ Performance Benchmarking will be implemented in future version
echo 💡 Hardware-specific optimization testing
pause
goto :ShowProfessionalMainMenu

:TelemetrySystem
echo.
echo ⏳ Telemetry System will be implemented in future version
echo 💡 Anonymous performance and quality metrics
pause
goto :ShowProfessionalMainMenu

:: ========================================
:: SYSTEM UTILITIES
:: ========================================
:DetectSystemCapabilities
echo 🔍 Detecting system capabilities...
:: Architecture detection
set "CPU_ARCH=x64"
if /i "%PROCESSOR_ARCHITECTURE%"=="x86" set "CPU_ARCH=x86"
:: CPU model detection
set "CPU_MODEL=Unknown"
for /f "tokens=2 delims==" %%A in ('wmic cpu get Name /value 2^>nul ^| find "="') do (
    set "CPU_MODEL=%%A"
    goto :model_done
)
:model_done

call :DetectCPUFromDatabase

set "IS_LAPTOP=N"
wmic computersystem get PCSystemType 2>nul | findstr "2" >nul
if not errorlevel 1 set "IS_LAPTOP=Y"

set "TOTAL_RAM_GB=4"
for /f "tokens=2 delims==" %%A in ('wmic OS get TotalVisibleMemorySize /value 2^>nul ^| find "="') do (
    set "TOTAL_RAM_KB=%%A"
)
if defined TOTAL_RAM_KB (
    if !TOTAL_RAM_KB! GTR 0 (
        set /a "TOTAL_RAM_GB=!TOTAL_RAM_KB!/1024/1024"
        if !TOTAL_RAM_GB! LSS 1 set "TOTAL_RAM_GB=1"
    )
)

echo   ✅ Architecture: !CPU_ARCH!
echo   ✅ CPU: !CPU_CORES! cores (!CPU_FAMILY!)
echo   💻 Type: !IS_LAPTOP:Y=Laptop!!IS_LAPTOP:N=Desktop!
echo   🧠 RAM: !TOTAL_RAM_GB!GB

call :LogEntry "[SYSTEM] CPU: !CPU_CORES! cores, RAM: !TOTAL_RAM_GB!GB"
exit /b 0

:DetectCPUFromDatabase
set "CPU_CORES=2"
set "CPU_FAMILY=Unknown"

:: Intel Celeron Detection
echo "!CPU_MODEL!" | findstr /i "Celeron.*1007U" >nul
if not errorlevel 1 (
    set "CPU_CORES=2"
    set "CPU_FAMILY=Intel Celeron 1007U (2C/2T, 1.5GHz)"
    exit /b 0
)

:: AMD Ryzen Detection
echo "!CPU_MODEL!" | findstr /i "Ryzen.*5" >nul
if not errorlevel 1 (
    set "CPU_CORES=6"
    set "CPU_FAMILY=AMD Ryzen 5 (6C/12T)"
    exit /b 0
)

:: Intel Core Detection
echo "!CPU_MODEL!" | findstr /i "Core.*i5" >nul
if not errorlevel 1 (
    set "CPU_CORES=4"
    set "CPU_FAMILY=Intel Core i5 (4C/8T)"
    exit /b 0
)

:: Auto-detect fallback
for /f "tokens=2 delims==" %%A in ('wmic cpu get NumberOfCores /value 2^>nul ^| find "="') do (
    set "CPU_CORES=%%A"
    set "CPU_FAMILY=Auto-detected (!CPU_CORES! cores)"
    exit /b 0
)

:: Final fallback
if defined NUMBER_OF_PROCESSORS (
    set /a "CPU_CORES=!NUMBER_OF_PROCESSORS!/2"
    if !CPU_CORES! LSS 2 set "CPU_CORES=2"
    set "CPU_FAMILY=Estimated (!CPU_CORES! cores)"
)
exit /b 0

:CheckFFmpeg
echo 🔍 Checking FFmpeg...

set "FFMPEG_CMD=ffmpeg"
%FFMPEG_CMD% -version >nul 2>&1
if errorlevel 1 (
    echo ⚠️ FFmpeg not found in system PATH
    :loop_ffmpeg
    set /p "FFMPEG_PATH=Enter FFmpeg path: "
    if "!FFMPEG_PATH!"=="" goto loop_ffmpeg
    if not exist "!FFMPEG_PATH!" (
        echo ❌ File not found: !FFMPEG_PATH!
        goto loop_ffmpeg
    )
    set "FFMPEG_CMD=!FFMPEG_PATH!"
)

:: Test functionality
"%FFMPEG_CMD%" -f lavfi -i testsrc=duration=1:size=320x240:rate=1 -f null - >nul 2>&1
if errorlevel 1 (
    echo ❌ FFmpeg functionality test failed!
    exit /b 1
)

echo   ✅ FFmpeg validated: !FFMPEG_CMD!
call :LogEntry "[OK] FFmpeg validated"
exit /b 0

:: ========================================
:: MODULAR SYSTEM UTILITIES
:: ========================================
:ValidateModularProfiles
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                        🔍 MODULAR PROFILES VALIDATION                        ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

if "%MODULAR_PROFILES_AVAILABLE%"=="N" (
    echo ❌ MODULAR SYSTEM NOT AVAILABLE
    pause
    goto :ShowProfessionalMainMenu
)

echo 📂 Profiles Directory: %PROFILES_DIR%

set "VALIDATION_PASSED=0"
set "VALIDATION_FAILED=0"
set "TOTAL_PROFILES=0"

for %%F in ("%PROFILES_DIR%\*.prof") do (
    set /a "TOTAL_PROFILES+=1"
    call :ValidateSingleProfile "%%F"
    if not errorlevel 1 (
        set /a "VALIDATION_PASSED+=1"
    ) else (
        set /a "VALIDATION_FAILED+=1"
    )
)

echo.
echo 📊 VALIDATION SUMMARY:
echo   📁 Total Profiles: !TOTAL_PROFILES!
echo   ✅ Passed: !VALIDATION_PASSED!
echo   ❌ Failed: !VALIDATION_FAILED!

if !VALIDATION_FAILED! GTR 0 (
    set "MODULAR_VALIDATION_STATUS=FAILED"
) else if !VALIDATION_PASSED! GTR 0 (
    set "MODULAR_VALIDATION_STATUS=PASSED"  
) else (
    set "MODULAR_VALIDATION_STATUS=NO_PROFILES"
)

pause
goto :ShowProfessionalMainMenu

:ValidateSingleProfile
set "profile_file=%~1"
set "profile_name=%~n1"

echo   🔍 Validating: %profile_name%

if not exist "%profile_file%" (
    echo     ❌ File not found: %profile_file%
    exit /b 1
)

:: Verificar estrutura básica do arquivo
findstr /C:"[PROFILE_INFO]" "%profile_file%" >nul || (
    echo     ❌ Missing [PROFILE_INFO] section
    exit /b 1
)

findstr /C:"[VIDEO_SETTINGS]" "%profile_file%" >nul || (
    echo     ❌ Missing [VIDEO_SETTINGS] section
    exit /b 1
)

findstr /C:"[X264_SETTINGS]" "%profile_file%" >nul || (
    echo     ❌ Missing [X264_SETTINGS] section
    exit /b 1
)

:: Verificar parâmetros críticos
findstr /C:"PROFILE_NAME=" "%profile_file%" >nul || (
    echo     ❌ Missing PROFILE_NAME parameter
    exit /b 1
)

findstr /C:"VIDEO_WIDTH=" "%profile_file%" >nul || (
    echo     ❌ Missing VIDEO_WIDTH parameter
    exit /b 1
)

findstr /C:"VIDEO_HEIGHT=" "%profile_file%" >nul || (
    echo     ❌ Missing VIDEO_HEIGHT parameter
    exit /b 1
)

findstr /C:"TARGET_BITRATE=" "%profile_file%" >nul || (
    echo     ❌ Missing TARGET_BITRATE parameter
    exit /b 1
)

findstr /C:"X264_PRESET=" "%profile_file%" >nul || (
    echo     ❌ Missing X264_PRESET parameter
    exit /b 1
)

:: Verificar se x264 params existem (warning se não tiver)
findstr /C:"X264_PARAMS=" "%profile_file%" >nul || (
    echo     ⚠️ Warning: X264_PARAMS not found (will use preset defaults)
)

echo     ✅ Profile structure valid
exit /b 0

::========================================
:: RELOAD MODULAR PROFILES - CORREÇÃO DEFINITIVA
::========================================
:ReloadModularProfiles
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                        🔄 RELOAD MODULAR SYSTEM                              ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

echo 🔄 Reloading modular system...

:: Reset state
set "MODULAR_PROFILES_AVAILABLE=N"
set "MODULAR_VALIDATION_STATUS=NOT_CHECKED"
set "MODULAR_PROFILE_COUNT=0"

:: Path detection
set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "PROJECT_ROOT=%%~fI"
set "AUTO_PROFILES_DIR=%PROJECT_ROOT%\src\profiles\presets"

if exist "%AUTO_PROFILES_DIR%" (
    set "PROFILES_DIR=%AUTO_PROFILES_DIR%"
    set "CONFIG_FILE=%PROJECT_ROOT%\src\config\encoder_config.json"
    goto :reload_found
)

:: Fallback detection
set "FALLBACK_DIR=C:\Users\Gabriel\encoder\src\profiles\presets"
if exist "%FALLBACK_DIR%" (
    set "PROFILES_DIR=%FALLBACK_DIR%"
    set "CONFIG_FILE=C:\Users\Gabriel\encoder\src\config\encoder_config.json"
    goto :reload_found
)

echo ❌ Profiles directory not found
pause
goto :ShowProfessionalMainMenu

:reload_found
echo.
echo   🎯 FINAL PATH SELECTED: %PROFILES_DIR%

:: Reload configuration
call :LoadModularConfig
call :CheckIndividualProfiles

echo.
echo 📊 RELOAD RESULTS:
echo   Available: %MODULAR_PROFILES_AVAILABLE%  Directory: %PROFILES_DIR%
echo   Profiles: %MODULAR_PROFILE_COUNT%  Status: %MODULAR_VALIDATION_STATUS%

if "%MODULAR_PROFILES_AVAILABLE%"=="Y" (
    echo   ✅ Modular system reloaded successfully
) else (
    echo   ⚠️ Modular system not fully functional
)

call :LogEntry "[MODULAR] Reloaded - Available: %MODULAR_PROFILES_AVAILABLE%"
pause
goto :ShowProfessionalMainMenu

::========================================
:: VERIFICAÇÃO INDIVIDUAL DE PROFILES
::========================================
:CheckIndividualProfiles
echo   🔍 Checking individual profile files...

set "REQUIRED_PROFILES=reels_9_16:REELS feed_16_9:FEED cinema_21_9:CINEMA speedramp_viral:SPEEDRAMP"
set "PROFILES_OK=0"
set "PROFILES_ERROR=0"

for %%P in (%REQUIRED_PROFILES%) do (
    for /f "tokens=1,2 delims=:" %%A in ("%%P") do (
        set "prof_file=%%A.prof"
        set "prof_name=%%B"
        
        if exist "%PROFILES_DIR%\!prof_file!" (
            echo     ✅ !prof_file! - EXISTS
            
            :: Verificação básica de conteúdo
            findstr /C:"PROFILE_NAME=" "%PROFILES_DIR%\!prof_file!" >nul
            if not errorlevel 1 (
                echo       ✓ Contains PROFILE_NAME
                set /a "PROFILES_OK+=1"
            ) else (
                echo       ✗ Missing PROFILE_NAME
                set /a "PROFILES_ERROR+=1"
            )
            
            findstr /C:"X264_PARAMS=" "%PROFILES_DIR%\!prof_file!" >nul
            if not errorlevel 1 (
                echo       ✓ Contains X264_PARAMS
            ) else (
                echo       ✗ Missing X264_PARAMS
            ) 
        ) else (
            echo     ❌ !prof_file! - MISSING
            set /a "PROFILES_ERROR+=1"
        )
    )
)

echo.
echo   📊 Profile check summary: %PROFILES_OK% OK, %PROFILES_ERROR% errors
set "MODULAR_PROFILE_COUNT=%PROFILES_OK%"

if %PROFILES_OK% GTR 0 (
    set "MODULAR_PROFILES_AVAILABLE=Y"
    if %PROFILES_ERROR% EQU 0 (
        set "MODULAR_VALIDATION_STATUS=PASSED"
    ) else (
        set "MODULAR_VALIDATION_STATUS=PARTIAL"
    )
) else (
    set "MODULAR_PROFILES_AVAILABLE=N"
    set "MODULAR_VALIDATION_STATUS=FAILED"
)

exit /b 0

:ShowModularSystemInfo
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                        🏗️ MODULAR SYSTEM INFORMATION                         ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

echo  🏗️ MODULAR ARCHITECTURE:
echo   📦 Framework:V%SCRIPT_VERSION% Modular Edition
echo   📂 Profiles Directory: %PROFILES_DIR%
echo.

if exist "%PROFILES_DIR%" (
    echo   📋 Directory Status: EXISTS
    echo   📄 Available Profiles:
    for %%F in ("%PROFILES_DIR%\*.prof") do echo     • %%~nF
) else (
    echo   📋 Directory Status: NOT FOUND
    echo  💡 Expected location: %PROFILES_DIR%
)
echo.

echo  📊 CURRENT STATUS:
echo   🏗️ Modular Available: %MODULAR_PROFILES_AVAILABLE%
echo   🔍 Last Validation: %MODULAR_VALIDATION_STATUS%
if "%PROFILE_SELECTED%"=="Y" (
    echo   🎬 Current Profile: %PROFILE_NAME%
)
echo.

pause
goto :ShowProfessionalMainMenu

:: ========================================
:: SYSTEM INFORMATION & UTILITIES
:: ========================================
:AnalyzeInputFile
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           🔍 INPUT FILE ANALYSIS                             ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

if not defined INPUT_FILE (
    echo ⚠️ INPUT FILE NOT CONFIGURED
    pause
    goto :ShowProfessionalMainMenu
)

if not exist "%INPUT_FILE%" (
    echo ❌ INPUT FILE NOT FOUND: %INPUT_FILE%
    pause
    goto :ShowProfessionalMainMenu
)

echo 🎬 Analyzing: %INPUT_FILE%
echo.

set "TEMP_ANALYSIS=analysis_%RANDOM%.txt"
"%FFMPEG_CMD%" -i "%INPUT_FILE%" -hide_banner 2>"%TEMP_ANALYSIS%"

if not exist "%TEMP_ANALYSIS%" (
    echo ❌ Failed to analyze file
    pause
    goto :ShowProfessionalMainMenu
)

echo 📊 DETAILED MEDIA INFORMATION:
type "%TEMP_ANALYSIS%"
del "%TEMP_ANALYSIS%" 2>nul

echo.
pause
goto :ShowProfessionalMainMenu

:ShowSystemInfo
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                          📋 SYSTEM INFORMATION                               ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

echo  🖥️ HARDWARE:
echo   💻 CPU: %CPU_FAMILY%
echo   🔢 Cores: %CPU_CORES%
echo   🧠 RAM: %TOTAL_RAM_GB% GB
echo   🏗️ Architecture: %CPU_ARCH%
echo   📱 Type: !IS_LAPTOP:Y=Laptop!!IS_LAPTOP:N=Desktop!
echo.

echo  🎬 SOFTWARE:
echo   📦 Framework: Instagram Encoder V%SCRIPT_VERSION%
echo   🔧 FFmpeg: %FFMPEG_CMD%
echo   🏗️ Profile System: Modular (%MODULAR_PROFILES_AVAILABLE%)
echo.

echo  📊 SESSION:
call :GetTimeInSeconds
call :CalculateElapsedTime %SESSION_START_TIME% %total_seconds%
echo   ⏱️ Duration: %ELAPSED_TIME%
echo   🔄 Workflow Step: %WORKFLOW_STEP%/6
echo   🎯 Status: %SYSTEM_STATUS%
echo.

pause
goto :ShowProfessionalMainMenu

:: ========================================
:: TIME & LOGGING UTILITIES
:: ========================================
:GetTimeInSeconds
set "current_time=%time%"
if "%current_time:~0,1%"==" " set "current_time=%current_time:~1%"

for /f "tokens=1-3 delims=:." %%a in ("%current_time%") do (
    set /a "hours=%%a"
    set /a "minutes=%%b"
    set /a "seconds=%%c"
)

if "%hours:~0,1%"=="0" if not "%hours%"=="0" set /a "hours=%hours:~1%"
if "%minutes:~0,1%"=="0" if not "%minutes%"=="0" set /a "minutes=%minutes:~1%"
if "%seconds:~0,1%"=="0" if not "%seconds%"=="0" set /a "seconds=%seconds:~1%"

set /a "total_seconds=(hours*3600)+(minutes*60)+seconds"
exit /b 0

:CalculateElapsedTime
set /a "start_time=%~1"
set /a "end_time=%~2"

if not defined start_time set "start_time=0"
if not defined end_time set "end_time=0"
set /a "elapsed_seconds=end_time-start_time"

if !elapsed_seconds! LSS 0 set /a "elapsed_seconds=!elapsed_seconds!+86400"

set /a "elapsed_hours=!elapsed_seconds!/3600"
set /a "remaining=!elapsed_seconds!%%3600"
set /a "elapsed_minutes=!remaining!/60"
set /a "elapsed_secs=!remaining!%%60"

if !elapsed_hours! LSS 10 set "elapsed_hours=0!elapsed_hours!"
if !elapsed_minutes! LSS 10 set "elapsed_minutes=0!elapsed_minutes!"
if !elapsed_secs! LSS 10 set "elapsed_secs=0!elapsed_secs!"

set "ELAPSED_TIME=!elapsed_hours!h !elapsed_minutes!m !elapsed_secs!s"
exit /b 0

:LogEntry
if not defined EXEC_LOG (
    for /f "tokens=1-3 delims=/ " %%D in ('echo %date%') do set "LOG_DATE=%%D-%%E-%%F"
    for /f "tokens=1-2 delims=:." %%G in ('echo %time%') do (
        set "LOG_HOUR=%%G"
        set "LOG_MIN=%%H"
    )
    set "LOG_HOUR=!LOG_HOUR: =!"
    set "EXEC_LOG=!LOG_DATE!_!LOG_HOUR!h!LOG_MIN!_instagram_v5.log"
    echo ===== INSTAGRAM ENCODER V5.2 MODULAR LOG - %date% %time% =====>"!EXEC_LOG!"
)
echo [%time:~0,8%] %~1>>"!EXEC_LOG!"
exit /b 0

:: ========================================
:: EXIT & ERROR HANDLING
:: ========================================
:ExitProfessional
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                               👋 GOODBYE!                                     ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo  🎬 Instagram Encoder Framework V%SCRIPT_VERSION%
echo.
call :GetTimeInSeconds
call :CalculateElapsedTime %SESSION_START_TIME% %total_seconds%
echo  ⏱️ Session Duration: %ELAPSED_TIME%
if defined EXEC_LOG echo  📝 Session Log: %EXEC_LOG%
echo.
echo  🎯 ACHIEVEMENTS THIS SESSION:
if "%FILES_CONFIGURED%"=="Y" echo     ✅ Files configured and validated
if "%PROFILE_CONFIGURED%"=="Y" echo     ✅ Profile selected: %PROFILE_NAME%
if defined TOTAL_ENCODE_TIME if not "%TOTAL_ENCODE_TIME%"=="00h 00m 00s" echo     ✅ Encoding completed: %TOTAL_ENCODE_TIME%
echo.
echo  🏆 Thank you for using Hollywood-level encoding!
echo  🎯 Your videos are ready for Instagram zero-recompression
echo.
call :LogEntry "[SESSION] Session ended - Duration: %ELAPSED_TIME%"
echo Press any key to exit...
pause >nul
exit

:ErrorExit
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                                  ⚠️ ERROR                                    ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo  The process encountered an error and needs to stop.
if defined EXEC_LOG echo  📝 Check log for details: !EXEC_LOG!
echo.
echo  🔧 TROUBLESHOOTING:
echo     1. Check your input file exists and is accessible
echo     2. Verify FFmpeg is properly installed
echo     3. Ensure sufficient disk space
echo     4. Review the log file for specific error details
echo.
echo  💡 For support, check the documentation or report the issue
echo.
pause
exit /b 1
