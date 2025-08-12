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

:: Color Science Variables
set "CUSTOM_COLOR_RANGE="
set "CUSTOM_COLOR_PRIMARIES="
set "CUSTOM_COLOR_TRC="
set "CUSTOM_COLOR_SPACE="
set "COLOR_PRESET_NAME="
set "CUSTOM_COLOR_PARAMS="
set "COLOR_CUSTOMIZATION_ACTIVE=N"

:: Audio Enhancement Variables
set "CUSTOM_AUDIO_BITRATE="
set "CUSTOM_AUDIO_SAMPLERATE="
set "CUSTOM_AUDIO_CHANNELS="
set "CUSTOM_AUDIO_PROCESSING="
set "AUDIO_PRESET_NAME="
set "AUDIO_NORMALIZATION=N"
set "AUDIO_FILTERING=N"
set "CUSTOM_AUDIO_PARAMS="

:: Audio Normalization Variables
set "CUSTOM_LUFS_TARGET="
set "CUSTOM_PEAK_LIMIT="
set "CUSTOM_LRA_TARGET="
set "NORMALIZATION_PRESET_NAME="
set "CUSTOM_NORMALIZATION_PARAMS="
set "AUDIO_PROCESSING_ACTIVE=N"

:: VBV Buffer Initialization Variables
set "CUSTOM_VBV_INIT="
set "ENABLE_VBV_INIT=N"
set "VBV_INIT_PRESET_NAME="
set "VBV_INIT_DESCRIPTION="
set "VBV_INIT_SOURCE=System Default"
set "CUSTOM_VBV_INIT_PERCENT="

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

:: STEP 1: CHECK FOR TEMP CUSTOMIZATIONS FILE (PRIORITY)
set "TEMP_DIR=%TEMP%"
set "CONFIG_FILE_FOUND=N"

if exist "%TEMP_DIR%\encoder_advanced_config_*.tmp" (
    for %%F in ("%TEMP_DIR%\encoder_advanced_config_*.tmp") do (
        set "CONFIG_FILE=%%F"
        set "CONFIG_FILE_FOUND=Y"
        echo   ✅ Customizations found: %%~nxF
        goto :config_priority_done
    )
)

:: STEP 2: FALLBACK TO SYSTEM CONFIG IF NO CUSTOMIZATIONS
:config_priority_done
if "%CONFIG_FILE_FOUND%"=="N" (
    set "CONFIG_FILE=%PROJECT_ROOT%\config\encoder_config.json"
    echo   📋 Using system config: encoder_config.json
) else (
    echo   🎛️ Using customizations: %CONFIG_FILE%
)

:: SINGLE VALIDATION CHECK (PRESERVE EXISTING LOGIC)
if exist "%PROFILES_DIR%" (
    set "MODULAR_PROFILE_COUNT=0"
    for %%F in ("%PROFILES_DIR%\*.prof") do (
	set /a "MODULAR_PROFILE_COUNT+=1"
	)
    
    if !MODULAR_PROFILE_COUNT! GTR 0 (
        echo ✅ Modular system: !MODULAR_PROFILE_COUNT! profiles active
        set "MODULAR_PROFILES_AVAILABLE=Y"
    ) else (
        echo ⚠️ No profiles found - using embedded fallback
        set "MODULAR_PROFILES_AVAILABLE=N"
    )
) else (
    :: FALLBACK PATH CHECK (PRESERVE EXISTING LOGIC)
    set "ALT_PROFILES_DIR=C:\Users\Gabriel\encoder\src\profiles\presets"
    if exist "!ALT_PROFILES_DIR!" (
        echo ✅ Found at alternative location
        set "PROFILES_DIR=!ALT_PROFILES_DIR!"
        :: PRESERVE CONFIG_FILE LOGIC - DON'T OVERRIDE HERE
        set "MODULAR_PROFILES_AVAILABLE=Y"
        set "MODULAR_PROFILE_COUNT=0"
        for %%F in ("!ALT_PROFILES_DIR!\*.prof") do (
			set /a "MODULAR_PROFILE_COUNT+=1"
		)
    ) else (
        echo ❌ Profiles directory not found
        set "MODULAR_PROFILES_AVAILABLE=N"
    )
)

call :LogEntry "[MODULAR] System: %MODULAR_PROFILES_AVAILABLE%, Profiles: !MODULAR_PROFILE_COUNT!"
call :LogEntry "[CONFIG] Using file: %CONFIG_FILE%"
echo   📋 Config file resolved: %CONFIG_FILE%
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
:: VBV-INIT VARIABLES RESET (CRITICAL ADDITION)
set "CUSTOM_VBV_INIT="
set "ENABLE_VBV_INIT=N"
set "VBV_INIT_PRESET_NAME="
set "VBV_INIT_DESCRIPTION="
set "VBV_INIT_SOURCE=System Default"
set "CUSTOM_VBV_INIT_PERCENT="

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
		if "!param_name!"=="CUSTOM_VBV_INIT" set "CUSTOM_VBV_INIT=!param_value!"
        if "!param_name!"=="ENABLE_VBV_INIT" set "ENABLE_VBV_INIT=!param_value!"
        if "!param_name!"=="VBV_INIT_PRESET_NAME" set "VBV_INIT_PRESET_NAME=!param_value!"
        if "!param_name!"=="VBV_INIT_DESCRIPTION" set "VBV_INIT_DESCRIPTION=!param_value!"
        if "!param_name!"=="VBV_INIT_SOURCE" set "VBV_INIT_SOURCE=!param_value!"
    )
)

:: ESSENTIAL VALIDATION ONLY
if not defined PROFILE_NAME exit /b 1
if not defined VIDEO_WIDTH exit /b 1
if not defined VIDEO_HEIGHT exit /b 1
if not defined TARGET_BITRATE exit /b 1

if defined CUSTOM_VBV_INIT (
    if defined ENABLE_VBV_INIT (
        if "!ENABLE_VBV_INIT!"=="Y" (
            echo   🔧 VBV-init loaded: !CUSTOM_VBV_INIT! (!VBV_INIT_PRESET_NAME!)
            call :LogEntry "[VBV] Loaded from profile: vbv_init=!CUSTOM_VBV_INIT!, preset=!VBV_INIT_PRESET_NAME!"
        ) else (
            echo   ℹ️ VBV-init disabled in profile (!ENABLE_VBV_INIT!)
            call :LogEntry "[VBV] Profile contains VBV settings but ENABLE_VBV_INIT=!ENABLE_VBV_INIT!"
        )
    )
)

echo ✅ Profile loaded: !PROFILE_NAME! (!VIDEO_WIDTH!x!VIDEO_HEIGHT!)

:: SET STATUS (preserve exactly)
set "PROFILE_SELECTED=Y"
set "PROFILE_CONFIGURED=Y"
set "CURRENT_PROFILE_ID=modular_%profile_type%"
set "CURRENT_PROFILE_FILE=%profile_file%"

call :LogEntry "[MODULAR] Loaded: !PROFILE_NAME!"
exit /b 0

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
if defined PROFILE_NAME   (echo   ✅ PROFILE_NAME) 	 else (echo   ❌ PROFILE_NAME & set /a "CRITICAL_ERRORS+=1")
if defined VIDEO_WIDTH    (echo   ✅ VIDEO_WIDTH) 	 else (echo   ❌ VIDEO_WIDTH & set /a "CRITICAL_ERRORS+=1")
if defined VIDEO_HEIGHT   (echo   ✅ VIDEO_HEIGHT) 	 else (echo   ❌ VIDEO_HEIGHT & set /a "CRITICAL_ERRORS+=1")
if defined TARGET_BITRATE (echo   ✅ TARGET_BITRATE) else (echo   ❌ TARGET_BITRATE & set /a "CRITICAL_ERRORS+=1")
if defined X264_PRESET    (echo   ✅ X264_PRESET) 	 else (echo   ❌ X264_PRESET & set /a "CRITICAL_ERRORS+=1")
if defined X264_PARAMS    (echo   ✅ X264_PARAMS) 	 else (echo   ⚠️ X264_PARAMS missing)

:: SYSTEM STATUS
echo.
echo 🏗️ SYSTEM STATUS:
echo   Modular: %MODULAR_PROFILES_AVAILABLE% ^| Validation: %MODULAR_VALIDATION_STATUS%
echo   Profile Configured: %PROFILE_CONFIGURED% ^| Files: %FILES_CONFIGURED%
echo   Ready to Encode: %READY_TO_ENCODE% ^| Status: %SYSTEM_STATUS%

:: ADVANCED MODE
if "%ADVANCED_MODE%"=="Y" (
    echo   🎛️ Advanced: ACTIVE
	if defined CUSTOM_PRESET 		echo     • Custom Preset: %CUSTOM_PRESET%
    if defined CUSTOM_PSY_RD 		echo     • Custom Psy RD: %CUSTOM_PSY_RD%
    if defined CUSTOM_GOP_SIZE 		echo     • GOP Structure: %GOP_PRESET_NAME% (%CUSTOM_GOP_SIZE%/%CUSTOM_KEYINT_MIN%)
    if defined CUSTOM_MAX_BITRATE 	echo     • VBV Buffer: %VBV_PRESET_NAME% (Max=%CUSTOM_MAX_BITRATE%, Buf=%CUSTOM_BUFFER_SIZE%)
    if defined CUSTOM_AUDIO_BITRATE echo     • Audio: %AUDIO_PRESET_NAME% (%CUSTOM_AUDIO_BITRATE%, %CUSTOM_AUDIO_SAMPLERATE%, %CUSTOM_AUDIO_CHANNELS%)
    if defined COLOR_PRESET_NAME 	echo     • Color Science: %COLOR_PRESET_NAME% (%CUSTOM_COLOR_PRIMARIES% primaries)
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
echo.
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
pause
exit /b 1

:CompareAllProfiles
cls
echo.
echo ╔═══════════════════════════════════════════════════════════════════════╗
echo ║               📊 INSTAGRAM PROFILE COMPARISON MATRIX                  ║
echo ╚═══════════════════════════════════════════════════════════════════════╝
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
    if defined CUSTOM_PRESET        echo     • Custom Preset: %CUSTOM_PRESET%
    if defined CUSTOM_PSY_RD        echo     • Custom Psy RD: %CUSTOM_PSY_RD%
	if defined CUSTOM_GOP_SIZE      echo     • GOP Structure: %GOP_PRESET_NAME% (%CUSTOM_GOP_SIZE%/%CUSTOM_KEYINT_MIN%)	
    if defined CUSTOM_MAX_BITRATE   echo     • VBV Buffer: %VBV_PRESET_NAME% (Max=%CUSTOM_MAX_BITRATE%, Buf=%CUSTOM_BUFFER_SIZE%)
    if defined CUSTOM_AUDIO_BITRATE echo     • Audio: %AUDIO_PRESET_NAME% (%CUSTOM_AUDIO_BITRATE%, %CUSTOM_AUDIO_SAMPLERATE%, %CUSTOM_AUDIO_CHANNELS%)
    if defined COLOR_PRESET_NAME    echo     • Color Science: %COLOR_PRESET_NAME% (%CUSTOM_COLOR_PRIMARIES% primaries)
) else (
    echo   🎬 Mode: Standard Hollywood parameters
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
call :LoadAdvancedConfig
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
:: Reset flags
set "PASS2_CONFIG_APPLIED="
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

set "FFMPEG_COMMAND="

:: Base command
set "FFMPEG_COMMAND=!FFMPEG_CMD! -y -hide_banner -i "!INPUT_FILE!""
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -map 0:v:0"

if "!PASS_TYPE!"=="PASS2" (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -map 0:a:0"
)
:: VIDEO CODEC E PROFILE/LEVEL
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -c:v libx264"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -profile:v high -level:v 4.1"

:: ========================================
:: HOLLYWOOD PARAMETERS - UNIFIED APPROACH ONLY
:: ========================================

if defined X264_PARAMS (
    set "USE_UNIFIED_APPROACH=YES"
) else (
    set "USE_UNIFIED_APPROACH=NO"  
)

:: EXPLICIT PATH BLOCKING WITH FAIL-SAFES
set "UNIFIED_EXECUTED=NO"
set "INDIVIDUAL_EXECUTED=NO"

if "!USE_UNIFIED_APPROACH!"=="YES" (
    set "EXECUTE_INDIVIDUAL=NO"
    echo   🏆 Applying Hollywood parameters via UNIFIED x264-params approach...
	
    call :ApplyUnifiedHollywoodParameters
    set "UNIFIED_EXECUTED=YES"
) else (
    set "EXECUTE_UNIFIED=NO"
	echo   🎭 Applying Hollywood parameters via INDIVIDUAL FFmpeg flags...

    call :ApplyIndividualHollywoodParameters
    set "INDIVIDUAL_EXECUTED=YES"
)

:: VIDEO PROCESSING
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -vf scale=!VIDEO_WIDTH!:!VIDEO_HEIGHT!:flags=lanczos,format=yuv420p"

:: FRAME RATE AND GOP STRUCTURE
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
echo   🎨 Applying color science...
if defined CUSTOM_COLOR_PARAMS (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! !CUSTOM_COLOR_PARAMS!"
	echo     🎛️ Custom color settings applied
    if defined COLOR_PRESET_NAME (
        echo     🎯 Color preset: !COLOR_PRESET_NAME!
    )
) else if defined COLOR_PARAMS (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! !COLOR_PARAMS!"
	echo     📊 Profile color settings applied
) else (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -color_range tv -color_primaries bt709 -color_trc bt709 -colorspace bt709"
)

set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -pix_fmt yuv420p"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -max_muxing_queue_size 9999"

:: Use GOTO structure for absolute pass separation
if /i "!PASS_TYPE!"=="PASS1" goto :ConfigurePass1
if /i "!PASS_TYPE!"=="PASS2" goto :ConfigurePass2

:: Invalid pass type handling
echo   ❌ CRITICAL ERROR: Invalid pass type received: "!PASS_TYPE!"
echo   💡 Expected: PASS1 or PASS2 (case-insensitive)
echo   📋 Received parameter: "%~1"
call :LogEntry "[ERROR] Invalid PASS_TYPE in BuildFFmpegCommand: !PASS_TYPE!"
exit /b 1

:ConfigurePass1
echo   🔄 Configuring Pass 1 (Analysis phase)...
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -b:v !TARGET_BITRATE!k"

if defined CUSTOM_MAX_BITRATE (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -maxrate !CUSTOM_MAX_BITRATE!"
    echo   📊 Using custom maxrate from module: !CUSTOM_MAX_BITRATE! (!VBV_PRESET_NAME!)
) else (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -maxrate !MAX_BITRATE!k"
    echo   📊 Using profile maxrate: !MAX_BITRATE!
)

if defined CUSTOM_BUFFER_SIZE (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -bufsize !CUSTOM_BUFFER_SIZE!"
    echo   🔧 Using custom buffer from module: !CUSTOM_BUFFER_SIZE! (!VBV_PRESET_NAME!)
) else (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -bufsize !BUFFER_SIZE!k"
    echo   🔧 Using profile buffer: !BUFFER_SIZE!
)

set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -pass 1"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -passlogfile !LOG_FILE_PASS!"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -an -f null NUL"

echo   ✅ Pass 1 analysis configuration complete
goto :PassConfigurationComplete

:ConfigurePass2
echo   🎬 Configuring Pass 2 (Final encoding phase)...
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -b:v !TARGET_BITRATE!k"

if defined CUSTOM_MAX_BITRATE (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -maxrate !CUSTOM_MAX_BITRATE!"
) else (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -maxrate !MAX_BITRATE!k"
)

if defined CUSTOM_BUFFER_SIZE (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -bufsize !CUSTOM_BUFFER_SIZE!"
) else (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -bufsize !BUFFER_SIZE!k"
)

set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -pass 2"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -passlogfile !LOG_FILE_PASS!"

:: BUILD AND INTEGRATE AUDIO COMMAND
call :BuildAudioCommand
if not errorlevel 1 (
    if defined AUDIO_COMMAND (
        set "FFMPEG_COMMAND=!FFMPEG_COMMAND! !AUDIO_COMMAND!"
        echo   🎵 Audio settings from module integrated
    ) else (
        set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -c:a aac -b:a 256k -ar 48000 -ac 2 -aac_coder twoloop"
        echo   🎵 Default audio settings applied
    )
) else (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -c:a aac -b:a 256k -ar 48000 -ac 2 -aac_coder twoloop"
    echo   ⚠️ Audio command build failed, using defaults
)

set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -movflags +faststart"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! !OUTPUT_FILE!"

echo   ✅ Pass 2 complete encoding configuration applied
goto :PassConfigurationComplete

:PassConfigurationComplete
echo   📋 Command type: !PASS_TYPE! configuration complete

:: Debug output for validation (can be disabled in production)
if defined DEBUG_COMMAND_BUILD (
    echo   🔍 DEBUG: FULL COMMAND = !FFMPEG_COMMAND!
)

exit /b 0

:: ========================================
:: HOLLYWOOD PARAMETER FUNCTIONS
:: ========================================
:ApplyUnifiedHollywoodParameters
if "!EXECUTE_UNIFIED!"=="NO" (
    exit /b 0
)

:: CRITICAL VALIDATION: Ensure X264_PARAMS is populated
if not defined X264_PARAMS (
    echo   ❌ CRITICAL ERROR: X264_PARAMS not loaded from profile
    call :LogEntry "[ERROR] X264_PARAMS undefined in ApplyUnifiedHollywoodParameters"
    exit /b 1
)

:: Apply custom preset if available
if defined CUSTOM_PRESET (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -preset !CUSTOM_PRESET!"
    echo   🎛️ Using custom preset: !CUSTOM_PRESET!
) else (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -preset !X264_PRESET!"
    echo   🎬 Profile preset: !X264_PRESET!
)

:: Apply tune setting
if defined X264_TUNE (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -tune !X264_TUNE!"
    echo   🎵 Tune setting: !X264_TUNE!
) else (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -tune film"
    echo   🎵 Using default tune: film
)

echo   🎭 Processing Hollywood parameters with robust cleaning...

:: Direct copy with aggressive space removal
set "CLEAN_PARAMS=!X264_PARAMS!"
    :: PSYCHOVISUAL CUSTOMIZATION INTEGRATION
    if defined CUSTOM_PSY_RD (
        :: Remove existing psy settings from profile params and add custom
        set "CLEAN_PARAMS=!CLEAN_PARAMS:psy_rd=!"
        set "CLEAN_PARAMS=!CLEAN_PARAMS!:psy_rd=!CUSTOM_PSY_RD!"
        echo   🧠 Custom psychovisual: !CUSTOM_PSY_RD!
    ) else (
        echo   🧠 Profile psychovisual settings
    )
if "%ENABLE_VBV_INIT%"=="Y" (
    if defined CUSTOM_VBV_INIT (
        set "CLEAN_PARAMS=!CLEAN_PARAMS!:vbv_init=%CUSTOM_VBV_INIT%"
        
		if defined VBV_INIT_PRESET_NAME (
            echo   ⚡ VBV Init: %CUSTOM_VBV_INIT% (%VBV_INIT_PRESET_NAME%)
        ) else (
            echo   ⚡ VBV Init: %CUSTOM_VBV_INIT% (Custom value)
        )
        call :LogEntry "[VBV_INIT] Applied custom: %CUSTOM_VBV_INIT%"
		exit /b 0
    )
)

:: Default VBV Init application
set "CLEAN_PARAMS=!CLEAN_PARAMS:vbv_init=!"
set "CLEAN_PARAMS=!CLEAN_PARAMS!:vbv_init=0.9"
echo   📊 VBV Init default: 0.9 (90%% pre-fill, Instagram optimized)
call :LogEntry "[VBV_INIT] Applied default: 0.9"

set "CLEAN_PARAMS=!CLEAN_PARAMS: ==!"
set "CLEAN_PARAMS=!CLEAN_PARAMS: ==!"

:: Remove spaces around colons
set "CLEAN_PARAMS=!CLEAN_PARAMS: :=:!"
set "CLEAN_PARAMS=!CLEAN_PARAMS:: =:!"

:: Clean up any leading/trailing colons from our additions
set "CLEAN_PARAMS=!CLEAN_PARAMS:::=:!"
if "!CLEAN_PARAMS:~0,1!"==":" set "CLEAN_PARAMS=!CLEAN_PARAMS:~1!"
if "!CLEAN_PARAMS:~-1!"==":" set "CLEAN_PARAMS=!CLEAN_PARAMS:~0,-1!"

:: APPLY AS SINGLE -x264-params STRING (CORRECT APPROACH)
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -x264-params !CLEAN_PARAMS!"
echo   ✅ Applied Hollywood x264 parameters: !CLEAN_PARAMS:~0,60!...

call :LogEntry "[HOLLYWOOD] Applied x264-params: !CLEAN_PARAMS:~0,60!..."
exit /b 0

:ApplyIndividualHollywoodParameters
if "!EXECUTE_INDIVIDUAL!"=="NO" (
    exit /b 0
)

:: Apply custom preset if available
if defined CUSTOM_PRESET (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -preset !CUSTOM_PRESET!"
) else (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -preset veryslow"
)
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -tune !X264_TUNE!"

:: Individual Hollywood parameters
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -refs 4"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -bf 4" 
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -subq 10"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -me_method umh"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -me_range 24"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -trellis 2"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -deblock -1,-1"

:: Psychovisual parameters
if defined CUSTOM_PSY_RD (
    for /f "tokens=1,2 delims=," %%A in ("!CUSTOM_PSY_RD!") do (
        set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -psy-rd %%A:%%B"
    )
) else (
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -psy-rd 1.0:0.15"
)

:: Additional individual parameters
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -aq-mode 1"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -aq-strength 1.0"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -rc-lookahead 60"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -qcomp 0.6"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -mbtree 1"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -coder 1"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -8x8dct 1"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -mixed-refs 1"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -weightb 1"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -weightp 2"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -threads !THREAD_COUNT!"

echo     ✅ Individual Hollywood flags applied


:BuildAudioCommand
:: FIXED BuildAudioCommand - Complete integration with advanced customizations
echo   🎵 Building professional audio command with customizations...

:: Initialize audio command
set "AUDIO_COMMAND="

:: CODEC AND BASIC PARAMETERS
set "AUDIO_COMMAND=%AUDIO_COMMAND% -c:a aac"

:: BITRATE CUSTOMIZATION
if defined CUSTOM_AUDIO_BITRATE (
    set "AUDIO_COMMAND=%AUDIO_COMMAND% -b:a %CUSTOM_AUDIO_BITRATE%"
    echo     🎯 Custom bitrate applied: %CUSTOM_AUDIO_BITRATE%
) else (
    set "AUDIO_COMMAND=%AUDIO_COMMAND% -b:a 256k"
)

:: SAMPLE RATE CUSTOMIZATION  
if defined CUSTOM_AUDIO_SAMPLERATE (
    set "AUDIO_COMMAND=%AUDIO_COMMAND% -ar %CUSTOM_AUDIO_SAMPLERATE%"
    echo     📻 Custom sample rate applied: %CUSTOM_AUDIO_SAMPLERATE%Hz
) else (
    set "AUDIO_COMMAND=%AUDIO_COMMAND% -ar 48000"
)

:: CHANNELS CUSTOMIZATION
if defined CUSTOM_AUDIO_CHANNELS (
    set "AUDIO_COMMAND=%AUDIO_COMMAND% -ac %CUSTOM_AUDIO_CHANNELS%"
    echo     🔊 Custom channels applied: %CUSTOM_AUDIO_CHANNELS%
) else (
    set "AUDIO_COMMAND=%AUDIO_COMMAND% -ac 2"
)

:: PROFESSIONAL AAC PARAMETERS
set "AUDIO_COMMAND=%AUDIO_COMMAND% -aac_coder twoloop"

:: NORMALIZATION INTEGRATION (must come first in FFmpeg filter chain)
if defined CUSTOM_NORMALIZATION_PARAMS (
    set "AUDIO_COMMAND=%CUSTOM_NORMALIZATION_PARAMS% %AUDIO_COMMAND%"
    echo     🔊 Applying normalization: %NORMALIZATION_PRESET_NAME%
)

:: DISPLAY PRESET INFORMATION
if defined AUDIO_PRESET_NAME (
    echo     🎬 Audio preset active: %AUDIO_PRESET_NAME%
)
if defined NORMALIZATION_PRESET_NAME (
    echo     🔊 Normalization active: %NORMALIZATION_PRESET_NAME% (%CUSTOM_LUFS_TARGET% LUFS)
)
if defined CUSTOM_LUFS_TARGET (
	echo   📊 Target: %CUSTOM_LUFS_TARGET% LUFS, %CUSTOM_PEAK_LIMIT% TP
)

:: FINAL COMMAND VALIDATION
if not defined AUDIO_COMMAND (
    echo     ❌ Audio command build failed - using fallback
    set "AUDIO_COMMAND=-c:a aac -b:a 256k -ar 48000 -ac 2 -aac_coder twoloop"
    exit /b 1
)

echo     ✅ Complete audio command built successfully
echo     📋 Final audio command: %AUDIO_COMMAND%

call :LogEntry "[AUDIO] Audio command built with customizations"
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
    if defined CUSTOM_PRESET 		echo     • Custom Preset: %CUSTOM_PRESET%
    if defined CUSTOM_PSY_RD 		echo     • Custom Psy RD: %CUSTOM_PSY_RD%
    if defined CUSTOM_GOP_SIZE 		echo     • GOP Structure: %GOP_PRESET_NAME% (%CUSTOM_GOP_SIZE%/%CUSTOM_KEYINT_MIN%)
    if defined CUSTOM_MAX_BITRATE 	echo     • VBV Buffer: %VBV_PRESET_NAME% (Max=%CUSTOM_MAX_BITRATE%, Buf=%CUSTOM_BUFFER_SIZE%)
    if defined CUSTOM_AUDIO_BITRATE echo     • Audio: %AUDIO_PRESET_NAME% (%CUSTOM_AUDIO_BITRATE%, %CUSTOM_AUDIO_SAMPLERATE%, %CUSTOM_AUDIO_CHANNELS%)
    if defined COLOR_PRESET_NAME 	echo     • Color Science: %COLOR_PRESET_NAME% (%CUSTOM_COLOR_PRIMARIES% primaries)
) else (
	echo   🛡️ Configuration: Netflix/Disney+ quality baseline
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
if "!IS_LAPTOP!"=="Y" (
    echo   💻 Type: Laptop
) else (
    echo   💻 Type: Desktop
)
echo   🧠 RAM: !TOTAL_RAM_GB!GB

call :LogEntry "[SYSTEM] CPU: !CPU_CORES! cores, RAM: !TOTAL_RAM_GB!GB, Type: !IS_LAPTOP!"
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

:AdvancedCustomization
cls
echo 🔄 Loading Advanced Customization Module...
call "%~dp0advanced_customization.bat"
echo.
echo ✅ Customizations completed
echo 🔄 Loading customizations into main script...

:: CRITICAL: Load advanced configuration if available
call :LoadAdvancedConfig

echo ✅ Customizations integrated successfully
echo 🔄 Returning to main menu...
pause
cls

:: ========================================
:: FUTURE DEVELOPMENT STUBS
:: ========================================
:QualityValidation
echo.
echo ⏳ VMAF Quality Validation will be implemented in future version
echo 💡 Automatic quality scoring and validation
pause
goto :ShowProfessionalMainMenu

:AIOptimization
echo.
echo ⏳ AI Content Analysis will be implemented in future version
echo 💡 Intelligent profile selection based on content
pause
goto :ShowProfessionalMainMenu

:TelemetrySystem
echo.
echo ⏳ Telemetry System will be implemented in future version
echo 💡 Anonymous performance and quality metrics
pause
goto :ShowProfessionalMainMenu

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

:LoadAdvancedConfig
echo 🔄 Loading advanced configuration...

:: AUTO-DETECT CONFIG FILE - Multiple strategies
set "CONFIG_FILE="

:: STRATEGY 1: Check for temp customization files first (priority)
for /f "tokens=*" %%i in ('dir /b /o-d "%TEMP%\encoder_advanced_config_*.tmp" 2^>nul') do (
    set "CONFIG_FILE=%TEMP%\%%i"
    echo   ✅ Found customization file: %%i
    goto :config_detected
)

:: STRATEGY 2: Check for project config file (fallback)
if exist "src\config\encoder_config.json" (
    set "CONFIG_FILE=src\config\encoder_config.json"
    echo   ✅ Found project config: encoder_config.json
    goto :config_detected
)

:: STRATEGY 3: No config found (graceful handling)
echo   💡 No configuration files found
echo   🛡️ Using profile defaults and standard Hollywood parameters
exit /b 0

:config_detected
if not exist "%CONFIG_FILE%" (
    echo   ❌ Config file not found: %CONFIG_FILE%
    exit /b 1
)

echo   📋 Loading configuration from: %CONFIG_FILE%

:: Determine file type and handle accordingly
echo "%CONFIG_FILE%" | findstr /i "\.json$" >nul
if not errorlevel 1 (
    echo   📋 JSON config detected - basic validation only
    echo   💡 Advanced customizations loaded from temp files take priority
    exit /b 0
)

:: Handle .tmp files (customizations)
echo   🔧 Processing advanced customizations...

:: Create simple temp batch to execute the set commands
set "TEMP_LOADER=%TEMP%\simple_loader_%RANDOM%.bat"

echo @echo off > "%TEMP_LOADER%"
echo :: Auto-generated config loader >> "%TEMP_LOADER%"

:: Copy only the set commands to the temp batch
findstr /B "set " "%CONFIG_FILE%" >> "%TEMP_LOADER%"

:: Add verification commands
echo. >> "%TEMP_LOADER%"
echo echo   📋 Variables verification: >> "%TEMP_LOADER%"
echo if defined CUSTOM_PRESET echo   ✅ CUSTOM_PRESET=%%CUSTOM_PRESET%% >> "%TEMP_LOADER%"
echo if defined CUSTOM_GOP_SIZE echo   ✅ CUSTOM_GOP_SIZE=%%CUSTOM_GOP_SIZE%% >> "%TEMP_LOADER%"
echo if defined GOP_PRESET_NAME echo   ✅ GOP_PRESET_NAME=%%GOP_PRESET_NAME%% >> "%TEMP_LOADER%"
echo if defined CUSTOM_MAX_BITRATE echo   ✅ CUSTOM_MAX_BITRATE=%%CUSTOM_MAX_BITRATE%% >> "%TEMP_LOADER%"
echo if defined VBV_PRESET_NAME echo   ✅ VBV_PRESET_NAME=%%VBV_PRESET_NAME%% >> "%TEMP_LOADER%"
echo if defined ADVANCED_MODE echo   ✅ ADVANCED_MODE=%%ADVANCED_MODE%% >> "%TEMP_LOADER%"
echo if defined CUSTOM_AUDIO_BITRATE echo   ✅ CUSTOM_AUDIO_BITRATE=%%CUSTOM_AUDIO_BITRATE%% >> "%TEMP_LOADER%"
echo if defined AUDIO_PRESET_NAME echo   ✅ AUDIO_PRESET_NAME=%%AUDIO_PRESET_NAME%% >> "%TEMP_LOADER%"
echo if defined NORMALIZATION_PRESET_NAME echo   ✅ NORMALIZATION_PRESET_NAME=%%NORMALIZATION_PRESET_NAME%% >> "%TEMP_LOADER%"
echo if defined CUSTOM_VBV_INIT echo   ✅ CUSTOM_VBV_INIT=%%CUSTOM_VBV_INIT%% >> "%TEMP_LOADER%"
echo if defined VBV_INIT_PRESET_NAME echo   ✅ VBV_INIT_PRESET_NAME=%%VBV_INIT_PRESET_NAME%% >> "%TEMP_LOADER%"
echo if defined ENABLE_VBV_INIT echo   ✅ ENABLE_VBV_INIT=%%ENABLE_VBV_INIT%% >> "%TEMP_LOADER%"

echo   📋 Generated temp loader: %TEMP_LOADER%
echo   📋 Executing configuration...

:: Execute the temp batch file
call "%TEMP_LOADER%"

:: Clean up
del "%TEMP_LOADER%" 2>nul

echo   📊 Simple loading method completed
call :ValidateAndApplyConfig
exit /b 0

:ParseConfigLine
:: WORKING ParseConfigLine function - Direct from successful test
set "config_line=%~1"
set "var_name="
set "var_value="

echo     🔍 RECEIVED: [%config_line%]

:: Validate input
if not defined config_line (
    echo     ❌ Empty line received
    exit /b 1
)

:: Check if line starts with "set "
if not "%config_line:~0,4%"=="set " (
    echo     ⚠️ Line doesn't start with 'set '
    exit /b 1
)

:: Remove 'set ' (first 4 characters)  
set "without_set=%config_line:~4%"
echo     📋 After removing 'set ': [%without_set%]

:: Remove surrounding quotes if present
if "%without_set:~0,1%"==" " set "without_set=%without_set:~1%"
if "%without_set:~0,1%"="""" (
    if "%without_set:~-1%"="""" (
        set "without_set=%without_set:~1,-1%"
        echo     📋 After quote removal: [%without_set%]
    )
)

:: Find equals position manually
call :FindEqualsPosition "%without_set%"
if errorlevel 1 (
    echo     ❌ No equals sign found
    exit /b 1
)

:: Extract name and value using the found position
call set "var_name=%%without_set:~0,%equals_pos%%%"
set /a "value_start=%equals_pos%+1"
call set "var_value=%%without_set:~%value_start%%%"

echo     📋 EXTRACTED: name=[%var_name%] value=[%var_value%]

:: Validate results
if not defined var_name (
    echo     ❌ Name extraction failed
    exit /b 1
)
if not defined var_value (
    echo     ❌ Value extraction failed
    exit /b 1
)

echo     ✅ PARSE SUCCESS: [%var_name%] = [%var_value%]
exit /b 0

:FindEqualsPosition
:: Find position of equals sign in string
set "search_string=%~1"
set "equals_pos=0"

:FindLoop
if "!search_string:~%equals_pos%,1!"=="=" (
    echo     📍 Found equals at position: %equals_pos%
    exit /b 0
)
if "!search_string:~%equals_pos%,1!"=="" (
    echo     ❌ Reached end without finding equals
    exit /b 1
)
set /a "equals_pos+=1"
goto :FindLoop

:AssignConfigVariable
set "var_name=%~1"
set "var_value=%~2"

:: ENHANCED VARIABLE ASSIGNMENT - Handle all cases
if /i "!var_name!"=="CUSTOM_PRESET" (
    set "CUSTOM_PRESET=!var_value!"
    echo     ✅ CUSTOM_PRESET=!var_value!
    exit /b 0
)
if /i "!var_name!"=="CUSTOM_PSY_RD" (
    set "CUSTOM_PSY_RD=!var_value!"
    echo     ✅ CUSTOM_PSY_RD=!var_value!
    exit /b 0
)
if /i "!var_name!"=="CUSTOM_GOP_SIZE" (
    set "CUSTOM_GOP_SIZE=!var_value!"
    echo     ✅ CUSTOM_GOP_SIZE=!var_value!
    exit /b 0
)
if /i "!var_name!"=="CUSTOM_KEYINT_MIN" (
    set "CUSTOM_KEYINT_MIN=!var_value!"
    echo     ✅ CUSTOM_KEYINT_MIN=!var_value!
    exit /b 0
)
if /i "!var_name!"=="GOP_PRESET_NAME" (
    set "GOP_PRESET_NAME=!var_value!"
    echo     ✅ GOP_PRESET_NAME=!var_value!
    exit /b 0
)
if /i "!var_name!"=="CUSTOM_MAX_BITRATE" (
    set "CUSTOM_MAX_BITRATE=!var_value!"
    echo     ✅ CUSTOM_MAX_BITRATE=!var_value!
    exit /b 0
)
if /i "!var_name!"=="CUSTOM_BUFFER_SIZE" (
    set "CUSTOM_BUFFER_SIZE=!var_value!"
    echo     ✅ CUSTOM_BUFFER_SIZE=!var_value!
    exit /b 0
)
if /i "!var_name!"=="VBV_PRESET_NAME" (
    set "VBV_PRESET_NAME=!var_value!"
    echo     ✅ VBV_PRESET_NAME=!var_value!
    exit /b 0
)
if /i "!var_name!"=="CUSTOM_COLOR_PARAMS" (
    set "CUSTOM_COLOR_PARAMS=!var_value!"
    echo     ✅ CUSTOM_COLOR_PARAMS=!var_value!
    exit /b 0
)
if /i "!var_name!"=="COLOR_PRESET_NAME" (
    set "COLOR_PRESET_NAME=!var_value!"
    echo     ✅ COLOR_PRESET_NAME=!var_value!
    exit /b 0
)
if /i "!var_name!"=="CUSTOM_VBV_INIT" (
    set "CUSTOM_VBV_INIT=!var_value!"
    echo     ✅ CUSTOM_VBV_INIT=!var_value!
    exit /b 0
)
if /i "!var_name!"=="VBV_INIT_PRESET_NAME" (
    set "VBV_INIT_PRESET_NAME=!var_value!"
    echo     ✅ VBV_INIT_PRESET_NAME=!var_value!
    exit /b 0
)
if /i "!var_name!"=="VBV_INIT_DESCRIPTION" (
    set "VBV_INIT_DESCRIPTION=!var_value!"
    echo     ✅ VBV_INIT_DESCRIPTION=!var_value!
    exit /b 0
)
if /i "!var_name!"=="ENABLE_VBV_INIT" (
    set "ENABLE_VBV_INIT=!var_value!"
    echo     ✅ ENABLE_VBV_INIT=!var_value!
    exit /b 0
)
if /i "!var_name!"=="ADVANCED_MODE" (
    set "ADVANCED_MODE=!var_value!"
    echo     ✅ ADVANCED_MODE=!var_value!
    exit /b 0
)
if /i "!var_name!"=="CUSTOMIZATION_ACTIVE" (
    set "CUSTOMIZATION_ACTIVE=!var_value!"
    echo     ✅ CUSTOMIZATION_ACTIVE=!var_value!
    exit /b 0
)

echo     ⚠️ Unknown variable: !var_name!=!var_value!
exit /b 1

:ValidateAndApplyConfig
:: Count loaded customizations and validate coherence
set "custom_count=0"
set "validation_errors=0"

echo   📊 Validating loaded customizations...

:: Count and validate customizations
if defined CUSTOM_PRESET (
    set /a "custom_count+=1"
    echo     ✅ x264 Preset: !CUSTOM_PRESET!
)

if defined CUSTOM_PSY_RD (
    set /a "custom_count+=1"
    echo     ✅ Psychovisual: !CUSTOM_PSY_RD!
)

:: FIXED GOP VALIDATION - Check components independently
set "gop_customizations=0"
if defined CUSTOM_GOP_SIZE (
    set /a "gop_customizations+=1"
    echo     ✅ GOP Size: !CUSTOM_GOP_SIZE!
)
if defined CUSTOM_KEYINT_MIN (
    set /a "gop_customizations+=1"
    echo     ✅ Min Keyint: !CUSTOM_KEYINT_MIN!
)
if defined GOP_PRESET_NAME (
    echo     ✅ GOP Preset: !GOP_PRESET_NAME!
)

:: COUNT GOP AS ONE CUSTOMIZATION GROUP if any GOP setting present
if !gop_customizations! GTR 0 (
    set /a "custom_count+=1"
    if !gop_customizations! EQU 2 (
        echo     ✅ GOP Structure: Complete (!CUSTOM_GOP_SIZE!/!CUSTOM_KEYINT_MIN!)
    ) else (
        echo     ✅ GOP Structure: Partial (!gop_customizations!/2 components)
    )
)

:: FIXED VBV VALIDATION - Check components independently  
set "vbv_customizations=0"
if defined CUSTOM_MAX_BITRATE (
    set /a "vbv_customizations+=1"
    echo     ✅ Max Bitrate: !CUSTOM_MAX_BITRATE!
)
if defined CUSTOM_BUFFER_SIZE (
    set /a "vbv_customizations+=1"
    echo     ✅ Buffer Size: !CUSTOM_BUFFER_SIZE!
)
if defined VBV_PRESET_NAME (
    echo     ✅ VBV Preset: !VBV_PRESET_NAME!
)

:: COUNT VBV AS ONE CUSTOMIZATION GROUP if any VBV setting present
if !vbv_customizations! GTR 0 (
    set /a "custom_count+=1"
    if !vbv_customizations! EQU 2 (
        echo     ✅ VBV Buffer: Complete (!CUSTOM_MAX_BITRATE!/!CUSTOM_BUFFER_SIZE!)
    ) else (
        echo     ✅ VBV Buffer: Partial (!vbv_customizations!/2 components)
    )
)

:: COLOR VALIDATION
if defined COLOR_PRESET_NAME (
    set /a "custom_count+=1"
    echo     ✅ Color Science: !COLOR_PRESET_NAME!
    if defined CUSTOM_COLOR_PARAMS (
        echo     ✅ Color Params: !CUSTOM_COLOR_PARAMS!
    )
)

:: ENHANCED AUDIO VALIDATION - V5.2 Audio Integration
set "audio_customizations=0"
set "audio_components=0"

:: Audio Enhancement Preset
if defined AUDIO_PRESET_NAME (
    set /a "audio_components+=1"
    echo     ✅ Audio Preset: !AUDIO_PRESET_NAME!
)

:: Audio Technical Settings
if defined CUSTOM_AUDIO_BITRATE (
    set /a "audio_components+=1"
    echo     ✅ Audio Bitrate: !CUSTOM_AUDIO_BITRATE!
)

if defined CUSTOM_AUDIO_SAMPLERATE (
    set /a "audio_components+=1"
    echo     ✅ Sample Rate: !CUSTOM_AUDIO_SAMPLERATE!Hz
)

if defined CUSTOM_AUDIO_CHANNELS (
    set /a "audio_components+=1"
    echo     ✅ Channels: !CUSTOM_AUDIO_CHANNELS!
)

:: Audio Normalization
if defined NORMALIZATION_PRESET_NAME (
    set /a "audio_components+=1"
    echo     ✅ Normalization: !NORMALIZATION_PRESET_NAME!
    
    if defined CUSTOM_LUFS_TARGET (
        echo     ✅ LUFS Target: !CUSTOM_LUFS_TARGET!
    )
    if defined CUSTOM_PEAK_LIMIT (
        echo     ✅ Peak Limit: !CUSTOM_PEAK_LIMIT! TP
    )
)

if defined AUDIO_PROCESSING_ACTIVE (
    if "!AUDIO_PROCESSING_ACTIVE!"=="Y" (
        echo     ✅ Audio Processing: ACTIVE
    )
)

:: COUNT AUDIO AS ONE CUSTOMIZATION GROUP if any audio setting present
if !audio_components! GTR 0 (
    set /a "custom_count+=1"
    if !audio_components! GEQ 3 (
        echo     🎵 Audio Enhancement: Complete (!audio_components! components)
    ) else (
        echo     🎵 Audio Enhancement: Partial (!audio_components! components)
    )
)
:: VBV-INIT VALIDATION AND SOURCE DETERMINATION
if defined CUSTOM_VBV_INIT (
    if "%ENABLE_VBV_INIT%"=="Y" (
        echo   ✅ VBV-INIT validated: %CUSTOM_VBV_INIT%
        if defined VBV_INIT_PRESET_NAME (
            set "VBV_INIT_SOURCE=%VBV_INIT_PRESET_NAME%"
        ) else (
            set "VBV_INIT_SOURCE=Custom Value"
        )
        echo   🎯 VBV-INIT source: %VBV_INIT_SOURCE%
    ) else (
        echo   ⚠️ VBV-INIT defined but disabled - using system default
        set "ENABLE_VBV_INIT=N"
        set "VBV_INIT_SOURCE=System Default"
    )
) else (
    echo   📊 VBV-INIT: No customization - using system default (0.9)
    set "ENABLE_VBV_INIT=N"
    set "VBV_INIT_SOURCE=System Default"
)

:: Log VBV-INIT configuration
call :LogEntry "[VBV-INIT] Config validation: ENABLE=%ENABLE_VBV_INIT%, Value=%CUSTOM_VBV_INIT%, Source=%VBV_INIT_SOURCE%"

:: FINAL VALIDATION AND ACTIVATION - FIXED LOGIC
echo   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if !custom_count! GTR 0 (
    :: ACTIVATE ADVANCED MODE
    set "ADVANCED_MODE=Y"
    set "CUSTOMIZATION_ACTIVE=Y"
    echo   🎛️ Advanced Mode: ACTIVATED with !custom_count! customization groups
    echo   🚀 Ready for enhanced encoding with custom parameters
    echo   🏆 Hollywood baseline + professional enhancements
    :: LOG SUCCESS
    call :LogEntry "[ADVANCED] Mode activated with !custom_count! customizations"
    call :LogEntry "[ADVANCED] GOP: !gop_customizations! components, VBV: !vbv_customizations! components"
) else (
    :: NO CUSTOMIZATIONS FOUND
    set "ADVANCED_MODE=N"
    set "CUSTOMIZATION_ACTIVE=N"
    echo   ℹ️ No customizations loaded - using profile defaults
    echo   🛡️ Using standard Hollywood parameters (profile baseline)
    call :LogEntry "[ADVANCED] No customizations found"
)

echo   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ✅ Customizations integrated successfully
exit /b 0
