@echo off
setlocal enabledelayedexpansion

:: ================================================================================
:: ADVANCED CUSTOMIZATION MODULE - INSTAGRAM ENCODER FRAMEWORK V5.2
:: Modular Advanced Customization System | Gabriel Schoenardie | 2025
:: ================================================================================

:: Module identification and logging
if not defined EXEC_LOG set "EXEC_LOG=instagram_v5_advanced.log"
echo [%time:~0,8%] [ADVANCED_MODULE] Module loaded - Fixed Integration System>>"!EXEC_LOG!"

:: Create temporary config file for variable passing
set "TEMP_CONFIG=%TEMP%\encoder_advanced_config_%RANDOM%.tmp"

:: ========================================
:: MODULE ENTRY POINT
:: ========================================

:AdvancedCustomizationMain
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
echo  [8] ✅ Apply Customizations ⭐ SAVE AND EXIT
echo  [0] 🔙 Back to Main Menu
echo.
set /p "custom_choice=Select customization option [0-9]: "

if "%custom_choice%"=="1" goto :CustomizePreset
if "%custom_choice%"=="2" goto :CustomizePsychovisual
if "%custom_choice%"=="3" goto :CustomizeGOP
if "%custom_choice%"=="4" goto :CustomizeVBV
if "%custom_choice%"=="5" goto :CustomizeAudio
if "%custom_choice%"=="6" goto :CustomizeColor
if "%custom_choice%"=="7" goto :PreviewAllCustomizations
if "%custom_choice%"=="8" goto :ApplyAdvancedCustomizations
if "%custom_choice%"=="0" goto :ExitAdvancedModule

echo ❌ Invalid choice. Please select 0-8.
pause
goto :AdvancedCustomizationMain

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
if /i "%preset_choice%"=="B" goto :AdvancedCustomizationMain

if defined CUSTOM_PRESET (
    echo ✅ Preset changed to: %CUSTOM_PRESET%
    set "CUSTOMIZATION_ACTIVE=Y"
    echo [%time:~0,8%] [ADVANCED] Preset set to: %CUSTOM_PRESET%>>"!EXEC_LOG!"
    pause
)
goto :AdvancedCustomizationMain

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
echo  [B] Back to Advanced Menu
echo.
set /p "psy_choice=Select psy_rd setting [1-5, B]: "

if "%psy_choice%"=="1" set "CUSTOM_PSY_RD=0.8,0.10"
if "%psy_choice%"=="2" set "CUSTOM_PSY_RD=1.0,0.15"
if "%psy_choice%"=="3" set "CUSTOM_PSY_RD=1.0,0.20"
if "%psy_choice%"=="4" set "CUSTOM_PSY_RD=1.2,0.25"
if "%psy_choice%"=="5" set "CUSTOM_PSY_RD=1.5,0.30"
if /i "%psy_choice%"=="B" goto :AdvancedCustomizationMain

if defined CUSTOM_PSY_RD (
    echo ✅ Psychovisual RD changed to: %CUSTOM_PSY_RD%
    set "CUSTOMIZATION_ACTIVE=Y"
	echo [%time:~0,8%] [ADVANCED] Psy RD set to: %CUSTOM_PSY_RD%>>"!EXEC_LOG!"
    pause
)
goto :AdvancedCustomizationMain

:CustomizeGOP
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       🎬 GOP STRUCTURE CUSTOMIZATION                         ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo  📊 Current GOP: %GOP_SIZE%, Min=%KEYINT_MIN% (keyframe every %GOP_SIZE% frames)
if defined CUSTOM_GOP_SIZE echo  🎛️ Active: %GOP_PRESET_NAME% (GOP=%CUSTOM_GOP_SIZE%, Min=%CUSTOM_KEYINT_MIN%)
echo.
echo  🎬 GOP (Group of Pictures):
echo   • GOP Size = Distance between keyframes (I-frames)
echo   • Lower values = More keyframes = Better seeking + Larger files
echo   • Higher values = Fewer keyframes = Smaller files + Less seeking precision
echo   • Instagram optimized: GOP 48-60 recommended for most social media content for 30fps
echo.
echo  ┌─────────────────────────────────────────────────────────────────┐
echo  │ 📊 PROFESSIONAL GOP PRESETS                                     │
echo  └─────────────────────────────────────────────────────────────────┘
echo.
echo  [1] 🏃 High Motion (GOP: 24, Min: 12) - Sports, action, fast movement
echo  [2] 📱 Social Media (GOP: 48, Min: 24) - Instagram content ⭐
echo  [3] 🎬 Cinematic (GOP: 72, Min: 24) - Film-like, slow movement
echo  [4] 📺 Streaming (GOP: 60, Min: 30) - Web playback optimized
echo  [5] 🎮 Gaming (GOP: 30, Min: 15) - Screen recording, fast changes
echo  [6] 🎵 Music Video (GOP: 96, Min: 24) - Less motion, artistic content
echo  [B] 🔙 Back to Advanced Menu
echo  [C] 📊 GOP Comparison
echo.
set /p "gop_choice=Select GOP preset [1-6, B, C]: "

if "%gop_choice%"=="1" call :SetGOPValues 24 12 "High Motion"
if "%gop_choice%"=="2" call :SetGOPValues 48 24 "Social Media"
if "%gop_choice%"=="3" call :SetGOPValues 72 24 "Cinematic"
if "%gop_choice%"=="4" call :SetGOPValues 60 30 "Streaming"
if "%gop_choice%"=="5" call :SetGOPValues 30 15 "Gaming"
if "%gop_choice%"=="6" call :SetGOPValues 96 24 "Music Video"
if "%gop_choice%"=="C" goto :CompareGOPPresets
if /i "%gop_choice%"=="B" goto :AdvancedCustomizationMain

if defined GOP_PRESET_NAME (
    echo ✅ GOP set to: %GOP_PRESET_NAME% (%CUSTOM_GOP_SIZE%/%CUSTOM_KEYINT_MIN%)
    set "CUSTOMIZATION_ACTIVE=Y"
    pause
)
goto :AdvancedCustomizationMain

:SetGOPValues
set "CUSTOM_GOP_SIZE=%~1"
set "CUSTOM_KEYINT_MIN=%~2"
set "GOP_PRESET_NAME=%~3"
:: CALCULATE KEYFRAME TIMING FOR DISPLAY
set "keyframe_display=2.0"
if "%CUSTOM_GOP_SIZE%"=="24" set "keyframe_display=0.8"
if "%CUSTOM_GOP_SIZE%"=="30" set "keyframe_display=1.0"
if "%CUSTOM_GOP_SIZE%"=="48" set "keyframe_display=1.6"
if "%CUSTOM_GOP_SIZE%"=="60" set "keyframe_display=2.0"
if "%CUSTOM_GOP_SIZE%"=="72" set "keyframe_display=2.4"
if "%CUSTOM_GOP_SIZE%"=="96" set "keyframe_display=3.2"

echo.
echo ✅ %GOP_PRESET_NAME% applied: GOP=%CUSTOM_GOP_SIZE%, Min=%CUSTOM_KEYINT_MIN% (keyframe every %keyframe_display%s)

set "CUSTOMIZATION_ACTIVE=Y"
echo [%time:~0,8%] [ADVANCED] GOP set: %GOP_PRESET_NAME% (%CUSTOM_GOP_SIZE%/%CUSTOM_KEYINT_MIN%)>>"!EXEC_LOG!"
pause
goto :AdvancedCustomizationMain

:CompareGOPPresets
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                     📊 GOP STRUCTURE COMPARISON                              ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo ┌─────────────────┬─────────┬─────────┬─────────────┬─────────────────────────┐
echo │     PRESET      │   GOP   │   MIN   │  KEYFRAME   │       BEST FOR          │
echo ├─────────────────┼─────────┼─────────┼─────────────┼─────────────────────────┤
echo │ High Motion     │   24    │   12    │   0.8s      │ Sports, action          │
echo │ Social Media    │   48    │   24    │   1.6s      │ Instagram content       │
echo │ Cinematic       │   72    │   24    │   2.4s      │ Film-like content       │
echo │ Streaming       │   60    │   30    │   2.0s      │ Web playback            │
echo │ Gaming          │   30    │   15    │   1.0s      │ Screen recording        │
echo │ Music Video     │   96    │   24    │   3.2s      │ Artistic content        │
echo └─────────────────┴─────────┴─────────┴─────────────┴─────────────────────────┘
echo.
echo  📱 All presets optimized for Instagram zero-recompression
echo  🎬 Lower GOP = More keyframes = Better seeking + Larger files
echo  🚀 Higher GOP = Fewer keyframes = Smaller files + Less seeking precision
echo.
pause
goto :CustomizeGOP

:CustomizeVBV
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                     📊 VBV BUFFER SETTINGS CUSTOMIZATION                     ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo  📊 Current: Target=%TARGET_BITRATE%, Max=%MAX_BITRATE%, Buffer=%BUFFER_SIZE%
if defined CUSTOM_MAX_BITRATE echo  🎛️ Active: %VBV_PRESET_NAME% (Max=%CUSTOM_MAX_BITRATE%, Buf=%CUSTOM_BUFFER_SIZE%)
echo.
echo  ┌─────────────────────────────────────────────────────────────────┐
echo  │ 📊 PROFESSIONAL VBV PRESETS                                     │
echo  └─────────────────────────────────────────────────────────────────┘
echo.
echo  [1] 🚗 High Motion (1.7x) - Cars, viral, speedramp
echo  [2] 📱 Social Media (1.5x) - Instagram optimized ⭐
echo  [3] 📺 Streaming (1.8x) - Adaptive bitrate, web delivery
echo  [4] 🎬 Cinematic (2.2x) - Film quality, smooth encoding
echo  [5] 🌐 Universal (1.3x) - Maximum compatibility
echo  [6] ⚡ Fast Network (2.5x) - High bandwidth, premium quality
echo  [B] 🔙 Back to Advanced Menu
echo.
set /p "vbv_choice=Select VBV preset [1-6, B]: "

if "%vbv_choice%"=="1" call :SetVBVValues 1.7 "High Motion"
if "%vbv_choice%"=="2" call :SetVBVValues 1.5 "Social Media"
if "%vbv_choice%"=="3" call :SetVBVValues 1.8 "Streaming"
if "%vbv_choice%"=="4" call :SetVBVValues 2.2 "Cinematic"
if "%vbv_choice%"=="5" call :SetVBVValues 1.3 "Universal"
if "%vbv_choice%"=="6" call :SetVBVValues 2.5 "Fast Network"
if /i "%vbv_choice%"=="B" goto :AdvancedCustomizationMain

echo ❌ Invalid choice.
pause
goto :AdvancedCustomizationMain

:SetVBVValues
set "vbv_multiplier=%~1"
set "VBV_PRESET_NAME=%~2"

echo   🔧 Applying %VBV_PRESET_NAME% preset...

set "target_numeric=%TARGET_BITRATE%"

:: Calculate custom maxrate and buffer based on multiplier
if "%vbv_multiplier%"=="1.7" (
    set /a "custom_maxrate=%target_numeric%*17/10"
    set /a "custom_buffer=%target_numeric%*10/10"
) else if "%vbv_multiplier%"=="1.5" (
    set /a "custom_maxrate=%target_numeric%*15/10" 
    set /a "custom_buffer=%target_numeric%*10/10"
) else if "%vbv_multiplier%"=="1.8" (
    set /a "custom_maxrate=%target_numeric%*18/10"
    set /a "custom_buffer=%target_numeric%*10/10"
) else if "%vbv_multiplier%"=="2.2" (
    set /a "custom_maxrate=%target_numeric%*22/10"
    set /a "custom_buffer=%target_numeric%*10/10"
) else if "%vbv_multiplier%"=="1.3" (
    set /a "custom_maxrate=%target_numeric%*13/10"
    set /a "custom_buffer=%target_numeric%*10/10"
) else if "%vbv_multiplier%"=="2.5" (
    set /a "custom_maxrate=%target_numeric%*25/10"
    set /a "custom_buffer=%target_numeric%*10/10"
) else (
    :: Fallback to target values
    set /a "custom_maxrate=%target_numeric%"
    set /a "custom_buffer=%target_numeric%"
)
:: CORRECTED SUFFIX - Use 'k' for kilobits (FFmpeg standard)
set "CUSTOM_MAX_BITRATE=%custom_maxrate%k"
set "CUSTOM_BUFFER_SIZE=%custom_buffer%k"
echo.
echo ✅ %VBV_PRESET_NAME% applied: Max=%CUSTOM_MAX_BITRATE%, Buf=%CUSTOM_BUFFER_SIZE% (%vbv_multiplier%x ratio)

set "CUSTOMIZATION_ACTIVE=Y"
echo [%time:~0,8%] [ADVANCED] VBV set: %VBV_PRESET_NAME% (Max:%CUSTOM_MAX_BITRATE%, Buf:%CUSTOM_BUFFER_SIZE%)>>"!EXEC_LOG!"
pause
goto :AdvancedCustomizationMain

:CustomizeAudio
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       🎵 AUDIO ENHANCEMENT SYSTEM                            ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo  📊 Current: AAC-LC 256k, 48kHz, Stereo (Instagram compliant)
if defined AUDIO_PRESET_NAME         echo  🎬 Active: %AUDIO_PRESET_NAME%
if defined NORMALIZATION_PRESET_NAME echo  🔊 Normalization: %NORMALIZATION_PRESET_NAME% (%CUSTOM_LUFS_TARGET% LUFS)
echo.
echo  ┌─────────────────────────────────────────────────────────────────┐
echo  │ 🎵 PROFESSIONAL AUDIO OPTIONS                                   │
echo  └─────────────────────────────────────────────────────────────────┘
echo.
echo  [1] 🎬 Professional Audio Presets ⭐ RECOMMENDED
echo  [2] ⚡ Audio Processing (Normalization + Noise Reduction)
echo  [3] 🎵 Advanced Audio Parameters (Coming Soon)
echo  [4] 📋 Preview Audio Settings
echo  [5] 🔄 Reset to Default
echo  [6] ✅ Apply Enhancement
echo  [B] 🔙 Back to Advanced Menu
echo.
set /p "audio_choice=Select audio enhancement option [1-6, B]: "

if "%audio_choice%"=="1" goto :AudioProfessionalPresets
if "%audio_choice%"=="2" goto :AudioProcessingOptions
if "%audio_choice%"=="3" goto :AudioAdvancedParameters
if "%audio_choice%"=="4" goto :PreviewAudioSettings
if "%audio_choice%"=="5" goto :ResetAudioToDefault
if "%audio_choice%"=="6" goto :ApplyAudioEnhancement
if /i "%audio_choice%"=="B" goto :AdvancedCustomizationMain

if defined AUDIO_PRESET_NAME (
    set "CUSTOM_AUDIO_SAMPLERATE=48000"
    echo ✅ Audio set to: %AUDIO_PRESET_NAME% (%CUSTOM_AUDIO_BITRATE%)
    set "CUSTOMIZATION_ACTIVE=Y"
    pause
)
goto :AdvancedCustomizationMain

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
echo  [1] 🎤 Voice/Podcast (128k, 48kHz, Mono) - Minimal size
echo  [2] 🗣️ Speech Content (160k, 48kHz, Stereo) - Speech + Music
echo  [3] 📱 Social Media (256k, 48kHz, Stereo) - Instagram Standard ⭐
echo  [4] 🎵 Music Video (320k, 48kHz, Stereo) - Premium quality
echo  [5] 🎬 Cinematic (320k, 48kHz, Stereo) - Film quality
echo  [6] 📋 Profile Default - Keep existing
echo  [B] 🔙 Back to Audio Menu
echo.
set /p "preset_choice=Select audio preset [1-7, B]: "

if "%preset_choice%"=="1" call :SetAudioPreset "128k" "48000" "1" "Voice/Podcast"
if "%preset_choice%"=="2" call :SetAudioPreset "160k" "48000" "2" "Speech Content"
if "%preset_choice%"=="3" call :SetAudioPreset "256k" "48000" "2" "Social Media"
if "%preset_choice%"=="4" call :SetAudioPreset "320k" "48000" "2" "Music Video"
if "%preset_choice%"=="5" call :SetAudioPreset "320k" "48000" "2" "Cinematic"
if "%preset_choice%"=="6" goto :ResetAudioPresetToDefault
if /i "%preset_choice%"=="B" goto :CustomizeAudio

pause
goto :AudioProfessionalPresets

:SetAudioPreset
set "CUSTOM_AUDIO_BITRATE=%~1"
set "CUSTOM_AUDIO_SAMPLERATE=%~2"
set "CUSTOM_AUDIO_CHANNELS=%~3"
set "AUDIO_PRESET_NAME=%~4"
echo.
echo   ✅ Audio preset applied: %AUDIO_PRESET_NAME%
echo   🎯 Bitrate: %CUSTOM_AUDIO_BITRATE%
echo   📻 Sample Rate: %CUSTOM_AUDIO_SAMPLERATE%Hz
echo   🔊 Channels: %CUSTOM_AUDIO_CHANNELS%
echo.
set "CUSTOMIZATION_ACTIVE=Y"
echo [%time:~0,8%] [ADVANCED] Audio preset: %AUDIO_PRESET_NAME% (%CUSTOM_AUDIO_BITRATE%, %CUSTOM_AUDIO_SAMPLERATE%Hz, %CUSTOM_AUDIO_CHANNELS%ch)>>"!EXEC_LOG!"
pause
goto :CustomizeAudio

:ResetAudioPresetToDefault
echo.
echo 🔄 Resetting to profile defaults...
set "CUSTOM_AUDIO_BITRATE="
set "CUSTOM_AUDIO_SAMPLERATE="
set "CUSTOM_AUDIO_CHANNELS="
set "AUDIO_PRESET_NAME="
echo ✅ Audio preset reset to profile default
echo [%time:~0,8%] [ADVANCED] Audio preset reset to defaults>>"!EXEC_LOG!"
pause
goto :AudioProfessionalPresets

:AudioProcessingOptions
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       ⚡ AUDIO PROCESSING OPTIONS                            ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
if defined CUSTOM_AUDIO_BITRATE      echo   🎯 Bitrate: %CUSTOM_AUDIO_BITRATE%
if defined AUDIO_PRESET_NAME         echo   🎬 Audio Preset: %AUDIO_PRESET_NAME%
if defined NORMALIZATION_PRESET_NAME echo   🔊 Normalization: %NORMALIZATION_PRESET_NAME% (%CUSTOM_LUFS_TARGET% LUFS)
echo.
echo  [1] 🔊 Audio Normalization (LUFS Standards)
echo  [2] 🎛️ Noise Reduction (Coming Soon)
echo  [3] 📋 Preview Processing
echo  [4] 🔄 Reset Processing
echo  [5] ✅ Apply Processing
echo  [B] 🔙 Back to Audio Enhancement
echo.
set /p "processing_choice=Select processing option [1-5, B]: "

if "%processing_choice%"=="1" goto :AudioNormalizationPresets
if "%processing_choice%"=="2" goto :NoiseReductionOptions
if "%processing_choice%"=="3" goto :PreviewAudioProcessing
if "%processing_choice%"=="4" goto :ResetAudioProcessing
if "%processing_choice%"=="5" goto :ApplyAudioProcessing
if /i "%processing_choice%"=="B" goto :CustomizeAudio

pause
goto :AudioProcessingOptions

:AudioNormalizationPresets
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                    🔊 PROFESSIONAL AUDIO NORMALIZATION                       ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
if defined NORMALIZATION_PRESET_NAME (
    echo   🎛️ Active: %NORMALIZATION_PRESET_NAME% (%CUSTOM_LUFS_TARGET% LUFS, %CUSTOM_PEAK_LIMIT% TP)
) else (
    echo   🎛️ Status: No normalization active
)
echo.
echo  [1] 📺 Broadcast Standard (-23 LUFS, -2 TP) - EBU R128
echo  [2] 📱 Instagram Optimized (-18 LUFS, -1 TP) - Social media ⭐
echo  [3] 🎬 YouTube Platform (-14 LUFS, -1 TP) - YouTube recommended
echo  [4] 🎤 Podcast Standard (-19 LUFS, -2 TP) - Voice content
echo  [5] 🔄 Disable Normalization
echo  [B] 🔙 Back to Processing
echo.
set /p "norm_choice=Select preset [1-5, B]: "

if "%norm_choice%"=="1" call :SetNormalizationPreset "broadcast" "Broadcast Standard"
if "%norm_choice%"=="2" call :SetNormalizationPreset "instagram" "Instagram Optimized"
if "%norm_choice%"=="3" call :SetNormalizationPreset "youtube" "YouTube Platform"
if "%norm_choice%"=="4" call :SetNormalizationPreset "podcast" "Podcast Standard"
if "%norm_choice%"=="5" goto :DisableNormalization
if /i "%norm_choice%"=="B" goto :AudioProcessingOptions

pause
goto :AudioNormalizationPresets

:SetNormalizationPreset
set "preset_id=%~1"
set "NORMALIZATION_PRESET_NAME=%~2"
echo.
echo 🔊 Applying %NORMALIZATION_PRESET_NAME%...

if "%preset_id%"=="broadcast" (
    set "CUSTOM_LUFS_TARGET=-23"
    set "CUSTOM_PEAK_LIMIT=-2"
    set "CUSTOM_LRA_TARGET=11"
)

if "%preset_id%"=="instagram" (
    set "CUSTOM_LUFS_TARGET=-18"
    set "CUSTOM_PEAK_LIMIT=-1"
    set "CUSTOM_LRA_TARGET=9"
)

if "%preset_id%"=="youtube" (
    set "CUSTOM_LUFS_TARGET=-14"
    set "CUSTOM_PEAK_LIMIT=-1"
    set "CUSTOM_LRA_TARGET=8"
)

if "%preset_id%"=="podcast" (
    set "CUSTOM_LUFS_TARGET=-19"
    set "CUSTOM_PEAK_LIMIT=-2"
    set "CUSTOM_LRA_TARGET=12"
)

call :BuildNormalizationCommand
if not errorlevel 1 (
    echo   ✅ %NORMALIZATION_PRESET_NAME% applied successfully
    set "AUDIO_PROCESSING_ACTIVE=Y"
    set "CUSTOMIZATION_ACTIVE=Y"
    echo [%time:~0,8%] [ADVANCED] Normalization: %NORMALIZATION_PRESET_NAME%>>"!EXEC_LOG!"
) else (
    echo   ❌ Failed to build normalization command
    call :ResetNormalizationToDefault
)

pause
goto :AudioProcessingOptions

:BuildNormalizationCommand
echo   🔧 Building FFmpeg normalization command...

if not defined CUSTOM_LUFS_TARGET exit /b 1
if not defined CUSTOM_PEAK_LIMIT exit /b 1
if not defined CUSTOM_LRA_TARGET exit /b 1

set "CUSTOM_NORMALIZATION_PARAMS=-af loudnorm=I=%CUSTOM_LUFS_TARGET%:TP=%CUSTOM_PEAK_LIMIT%:LRA=%CUSTOM_LRA_TARGET%:print_format=summary"

echo     ✅ Normalization command built successfully
echo     📋 FFmpeg filter: %CUSTOM_NORMALIZATION_PARAMS%
echo [%time:~0,8%] [ADVANCED] Normalization command built>>"!EXEC_LOG!"
exit /b 0

:DisableNormalization
echo.
echo 🔄 Disabling normalization...
set "CUSTOM_LUFS_TARGET="
set "CUSTOM_PEAK_LIMIT="
set "CUSTOM_LRA_TARGET="
set "NORMALIZATION_PRESET_NAME="
set "CUSTOM_NORMALIZATION_PARAMS="
echo ✅ Audio normalization disabled - using raw audio levels
echo [%time:~0,8%] [ADVANCED] Normalization disabled>>"!EXEC_LOG!"
pause
goto :AudioNormalizationPresets

:: FUTURE IMPLEMENTATION STUBS
::========================================
:NoiseReductionOptions
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       🎛️ NOISE REDUCTION OPTIONS                             ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo  🔮 FUTURE IMPLEMENTATION:
echo   ⏳ [1] Spectral Noise Reduction (FFmpeg afftdn filter)
echo   ⏳ [2] Background Noise Suppression (Professional algorithms)
echo   ⏳ [3] Wind/Handling Noise Filter (High-pass + dynamic filtering)
echo   ⏳ [4] Adaptive Noise Gate (Intelligent silence detection)
echo.
echo  [B] 🔙 Back to Audio Processing
pause
goto :AudioProcessingOptions

:ResetAudioProcessing
echo.
echo 🔄 Resetting audio processing...
set "CUSTOM_LUFS_TARGET="
set "CUSTOM_PEAK_LIMIT="
set "CUSTOM_LRA_TARGET="
set "NORMALIZATION_PRESET_NAME="
set "CUSTOM_NORMALIZATION_PARAMS="
set "AUDIO_PROCESSING_ACTIVE=N"
echo ✅ Audio processing reset - Audio Enhancement settings preserved
echo [%time:~0,8%] [ADVANCED] Audio processing reset>>"!EXEC_LOG!"
pause
goto :AudioProcessingOptions

:ApplyAudioProcessing
if "%AUDIO_PROCESSING_ACTIVE%"=="N" (
    echo.
    echo ⚠️ No audio processing options active
    pause
    goto :AudioProcessingOptions
)

echo.
echo ✅ Applying audio processing configuration...
if defined NORMALIZATION_PRESET_NAME (
    echo   🔊 Normalization: %NORMALIZATION_PRESET_NAME% (%CUSTOM_LUFS_TARGET% LUFS)
)
echo ✅ Audio processing applied successfully!

set "CUSTOMIZATION_ACTIVE=Y"
echo [%time:~0,8%] [ADVANCED] Audio processing applied>>"!EXEC_LOG!"
pause
goto :AdvancedCustomizationMain

:PreviewAudioProcessing
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                    📋 AUDIO PROCESSING PREVIEW                               ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

echo  🎵 AUDIO ENHANCEMENT:
if defined AUDIO_PRESET_NAME (
    echo   🎬 Preset: %AUDIO_PRESET_NAME% (%CUSTOM_AUDIO_BITRATE%, %CUSTOM_AUDIO_SAMPLERATE%Hz, %CUSTOM_AUDIO_CHANNELS%ch)
) else (
    echo   🎵 Default: 256k, 48kHz, Stereo
)

echo.
echo  🔊 NORMALIZATION:
if defined NORMALIZATION_PRESET_NAME (
    echo   🎯 Preset: %NORMALIZATION_PRESET_NAME% (%CUSTOM_LUFS_TARGET% LUFS, %CUSTOM_PEAK_LIMIT% TP)
    echo   🔧 Filter: %CUSTOM_NORMALIZATION_PARAMS%
) else (
    echo   🔊 Disabled (using raw audio levels)
)

echo.
if "%AUDIO_PROCESSING_ACTIVE%"=="Y" (
    echo   ✅ Status: Audio processing ACTIVE - ready for encoding
) else (
    echo   ⚠️ Status: No processing active - using defaults
)

echo.
pause
goto :AudioProcessingOptions

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
echo  [B] 🔙 Back to Audio Menu
echo.
set /p "advanced_choice=Press B to return or Enter to continue: "
goto :CustomizeAudio

:PreviewAudioSettings
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                          📋 PREVIEW AUDIO SETTINGS                           ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
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

if defined AUDIO_PRESET_NAME (
    echo   🎬 Audio Preset: %AUDIO_PRESET_NAME% ^(Professional preset applied^)
)

if defined NORMALIZATION_PRESET_NAME (
    echo   🔊 Normalization: %NORMALIZATION_PRESET_NAME% ^(%CUSTOM_LUFS_TARGET% LUFS^)
)

echo.
echo  🔧 FFMPEG INTEGRATION:
echo   Codec: AAC-LC (Instagram native)
if defined CUSTOM_NORMALIZATION_PARAMS echo   Normalization: %CUSTOM_NORMALIZATION_PARAMS%
echo.

if "%CUSTOMIZATION_ACTIVE%"=="Y" (
    echo   ✅ Audio customizations are ACTIVE
    echo   🎛️ Changes will be applied on encoding
) else (
    echo   🛡️ No audio customizations active
    echo   🎵 Will use profile default audio settings
)
echo.
pause
goto :CustomizeAudio

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
set "CUSTOM_LUFS_TARGET="
set "CUSTOM_PEAK_LIMIT="
set "CUSTOM_LRA_TARGET="
set "NORMALIZATION_PRESET_NAME="
set "CUSTOM_NORMALIZATION_PARAMS="
set "AUDIO_PROCESSING_ACTIVE=N"
echo ✅ All audio settings restored to profile defaults
echo   🎵 Codec: AAC-LC (Advanced Audio Codec)
echo   🎯 Bitrate: 256k (Instagram standard)
echo   📻 Sample Rate: 48000Hz (Instagram native)
echo   🔊 Channels: 2 (Stereo)
echo [%time:~0,8%] [ADVANCED] All audio settings reset>>"!EXEC_LOG!"
pause
goto :CustomizeAudio

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
if defined NORMALIZATION_PRESET_NAME echo   🔊 Normalization: %NORMALIZATION_PRESET_NAME%
echo.
echo ✅ Audio enhancement applied successfully!
echo 🎵 Audio settings will be used in the next encoding
echo 🏆 Instagram compliance maintained
echo.
echo [%time:~0,8%] [ADVANCED] Audio enhancement applied>>"!EXEC_LOG!"
pause
goto :AdvancedCustomizationMain

:CustomizeColor
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       🎨 COLOR SCIENCE ADJUSTMENTS                           ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo  📊 Current: Profile default (BT.709 TV Range)
if defined COLOR_PRESET_NAME echo  🎛️ Active: %COLOR_PRESET_NAME%
if defined CUSTOM_COLOR_PARAMS echo  🌈 Custom: %CUSTOM_COLOR_PARAMS%
echo.
echo  ┌─────────────────────────────────────────────────────────────────┐
echo  │ 🎨 PROFESSIONAL COLOR PRESETS                                   │
echo  └─────────────────────────────────────────────────────────────────┘
echo.
echo  [1] 📱 Instagram Native - BT.709 TV (guaranteed compliance)
echo  [2] 📺 TV LED 4K - BT.2020 enhanced (non-HDR)
echo  [3] 🎬 YouTube Platform - YT optimized
echo  [4] 🎮 sRGB Standard - Gaming/streaming
echo  [5] 🔄 Reset to Default
echo  [B] 🔙 Back to Advanced Menu
echo.
set /p "color_choice=Select color preset [1-7, B]: "

if "%color_choice%"=="1" call :SetColorPreset "instagram_native" "Instagram Native"
if "%color_choice%"=="2" call :SetColorPreset "tv_led_4k" "TV LED 4K"
if "%color_choice%"=="3" call :SetColorPreset "youtube_platform" "YouTube Platform"
if "%color_choice%"=="4" call :SetColorPreset "srgb_standard" "sRGB Standard"
if "%color_choice%"=="5" goto :ResetColorToDefault
if /i "%color_choice%"=="B" goto :AdvancedCustomizationMain

if defined COLOR_PRESET_NAME (
    echo ✅ Color set to: %COLOR_PRESET_NAME%
    set "CUSTOMIZATION_ACTIVE=Y"
    pause
)
goto :AdvancedCustomizationMain

:SetColorPreset
set "preset_id=%~1"
set "COLOR_PRESET_NAME=%~2"

if "%preset_id%"=="instagram_native" goto :ApplyInstagramNative
if "%preset_id%"=="tv_led_4k" goto :ApplyTVLED4K  
if "%preset_id%"=="youtube_platform" goto :ApplyYouTubePlatform
if "%preset_id%"=="srgb_standard" goto :ApplySRGBStandard

echo ❌ Unknown preset ID: %preset_id%
pause
goto :AdvancedCustomizationMain

:ApplyInstagramNative
set "CUSTOM_COLOR_RANGE=tv"
set "CUSTOM_COLOR_PRIMARIES=bt709"
set "CUSTOM_COLOR_TRC=bt709"
set "CUSTOM_COLOR_SPACE=bt709"
goto :SetColorPresetComplete

:ApplyTVLED4K
set "CUSTOM_COLOR_RANGE=tv"
set "CUSTOM_COLOR_PRIMARIES=bt2020"
set "CUSTOM_COLOR_TRC=bt709"
set "CUSTOM_COLOR_SPACE=bt2020nc"
goto :SetColorPresetComplete

:ApplyYouTubePlatform
set "CUSTOM_COLOR_RANGE=tv"
set "CUSTOM_COLOR_PRIMARIES=bt709"
set "CUSTOM_COLOR_TRC=bt709"
set "CUSTOM_COLOR_SPACE=bt709"
goto :SetColorPresetComplete

:ApplySRGBStandard
set "CUSTOM_COLOR_RANGE=pc"
set "CUSTOM_COLOR_PRIMARIES=bt709"
set "CUSTOM_COLOR_TRC=iec61966-2-1"
set "CUSTOM_COLOR_SPACE=bt709"
goto :SetColorPresetComplete

:SetColorPresetComplete
call :BuildColorCommand
if not errorlevel 1 (
    echo   ✅ Color preset applied successfully: %COLOR_PRESET_NAME%
    set "COLOR_CUSTOMIZATION_ACTIVE=Y"
    set "CUSTOMIZATION_ACTIVE=Y"
    echo [%time:~0,8%] [ADVANCED] Color preset: %COLOR_PRESET_NAME%>>"!EXEC_LOG!"
) else (
    echo   ❌ Failed to build color command
    call :ResetColorToDefault
)

pause
goto :AdvancedCustomizationMain

:BuildColorCommand
if not defined CUSTOM_COLOR_RANGE exit /b 1
if not defined CUSTOM_COLOR_PRIMARIES exit /b 1
if not defined CUSTOM_COLOR_TRC exit /b 1
if not defined CUSTOM_COLOR_SPACE exit /b 1

set "CUSTOM_COLOR_PARAMS=-color_range %CUSTOM_COLOR_RANGE%"
set "CUSTOM_COLOR_PARAMS=%CUSTOM_COLOR_PARAMS% -color_primaries %CUSTOM_COLOR_PRIMARIES%"
set "CUSTOM_COLOR_PARAMS=%CUSTOM_COLOR_PARAMS% -color_trc %CUSTOM_COLOR_TRC%"
set "CUSTOM_COLOR_PARAMS=%CUSTOM_COLOR_PARAMS% -colorspace %CUSTOM_COLOR_SPACE%"

echo     ✅ Color command built successfully
echo     📋 Parameters: %CUSTOM_COLOR_PARAMS%
echo [%time:~0,8%] [ADVANCED] Color command built>>"!EXEC_LOG!"
exit /b 0

:ResetColorToDefault
echo.
echo 🔄 Resetting color to profile default...
set "CUSTOM_COLOR_RANGE="
set "CUSTOM_COLOR_PRIMARIES="
set "CUSTOM_COLOR_TRC="
set "CUSTOM_COLOR_SPACE="
set "COLOR_PRESET_NAME="
set "CUSTOM_COLOR_PARAMS="
set "COLOR_CUSTOMIZATION_ACTIVE=N"
echo ✅ Color settings reset to BT.709 TV Range (Instagram compliance guaranteed)
echo [%time:~0,8%] [ADVANCED] Color reset to defaults>>"!EXEC_LOG!"
pause
goto :CustomizeColor

:PreviewAllCustomizations
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                          📋 PREVIEW ALL SETTINGS                             ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo  🎬 PROFILE BASE: %PROFILE_NAME%
echo  📐 Resolution: %VIDEO_WIDTH%x%VIDEO_HEIGHT% (%VIDEO_ASPECT%)
echo  🎯 Bitrate: %TARGET_BITRATE% target / %MAX_BITRATE% max
echo.
echo  ┌─────────────────────────────────────────────────────────────────────────────┐
echo  │   CONFIGURATION SUMMARY                                                     │
echo  └─────────────────────────────────────────────────────────────────────────────┘
echo.
echo 🎭 x264 Preset:
if defined CUSTOM_PRESET (
    echo     Custom preset: %CUSTOM_PRESET% → will be applied
) else (
    echo     Current: %X264_PRESET% (unchanged)
)
echo.
echo 🧠 Psychovisual:
if defined CUSTOM_PSY_RD (
    echo     Custom psy_rd: %CUSTOM_PSY_RD% → will be applied
) else (
    echo     Using profile default (unchanged)
)
echo.
echo 🎬 GOP Structure:
if defined CUSTOM_GOP_SIZE (
    if defined CUSTOM_KEYINT_MIN (
        echo     Custom: %GOP_PRESET_NAME% GOP=%CUSTOM_GOP_SIZE%, Min=%CUSTOM_KEYINT_MIN% → will be applied
        if "%CUSTOM_GOP_SIZE%"=="48" set "keyframe_display=1.6"
        if "%CUSTOM_GOP_SIZE%"=="60" set "keyframe_display=2.0"
        if "%CUSTOM_GOP_SIZE%"=="72" set "keyframe_display=2.4"
        if "%CUSTOM_GOP_SIZE%"=="30" set "keyframe_display=1.0"
        if "%CUSTOM_GOP_SIZE%"=="24" set "keyframe_display=0.8"
        if not defined keyframe_display set "keyframe_display=2.0"
        echo    ⚡ Technical: Keyframe every %keyframe_display%s at 30fps
    )
) else (
    echo     Current: GOP=%GOP_SIZE%, Min=%KEYINT_MIN% (unchanged)
)
echo.
echo 📊 VBV Buffer:
if defined CUSTOM_MAX_BITRATE (
    if defined CUSTOM_BUFFER_SIZE (
        echo     Custom: %VBV_PRESET_NAME% Max=%CUSTOM_MAX_BITRATE%, Buf=%CUSTOM_BUFFER_SIZE% → will be applied
        if "%VBV_PRESET_NAME%"=="High Motion" (
            echo    🚗 Analysis: 1.7x ratio optimized for cars/viral content
        ) else if "%VBV_PRESET_NAME%"=="Social Media" (
            echo    📱 Analysis: 1.5x ratio balanced for Instagram content
        ) else if "%VBV_PRESET_NAME%"=="Streaming" (
            echo    📺 Analysis: 1.8x ratio optimized for web delivery
        ) else if "%VBV_PRESET_NAME%"=="Cinematic" (
            echo    🎬 Analysis: 2.2x ratio for film-quality smoothness
        ) else if "%VBV_PRESET_NAME%"=="Universal" (
            echo    🌐 Analysis: 1.3x ratio maximum compatibility
        ) else if "%VBV_PRESET_NAME%"=="Fast Network" (
            echo    ⚡ Analysis: 2.5x ratio high bandwidth premium
        ) else (
            echo     Analysis: Custom buffer configuration
        )
    )
) else (
    echo     Current: MaxRate=%MAX_BITRATE%k, Buffer=%BUFFER_SIZE%k (profile default)
)
echo.
echo 🎵 Audio Enhancement:
if defined AUDIO_PRESET_NAME (
    echo     Active Preset: %AUDIO_PRESET_NAME%
    echo     Configuration: %CUSTOM_AUDIO_BITRATE%, %CUSTOM_AUDIO_SAMPLERATE%Hz, %CUSTOM_AUDIO_CHANNELS% channels
) else (
    echo     Profile Default: 256k, 48000Hz, 2 channels (Stereo)
)

if defined NORMALIZATION_PRESET_NAME (
    echo    🔊 Normalization: %NORMALIZATION_PRESET_NAME% (%CUSTOM_LUFS_TARGET% LUFS)
) else (
    echo    🔇 Normalization: Disabled (raw audio levels)
)
echo.
echo 🎨 Color Science Settings:
if defined COLOR_PRESET_NAME (
    echo     Active Preset: %COLOR_PRESET_NAME% → will be applied
    echo     Configuration: %CUSTOM_COLOR_PARAMS%
    if defined CUSTOM_COLOR_RANGE     echo   ├── Range: %CUSTOM_COLOR_RANGE% (luminance levels)
    if defined CUSTOM_COLOR_PRIMARIES echo   ├── Primaries: %CUSTOM_COLOR_PRIMARIES% (color gamut)
    if defined CUSTOM_COLOR_TRC       echo   ├── Transfer: %CUSTOM_COLOR_TRC% (gamma curve)
    if defined CUSTOM_COLOR_SPACE     echo   ├── Matrix: %CUSTOM_COLOR_SPACE% (YUV conversion)
)
echo.
if "%CUSTOMIZATION_ACTIVE%"=="Y" (
    echo   ✅ Status: Advanced customizations ACTIVE - Hollywood baseline + enhancements
) else (
    echo  🛡️ Status: Standard Hollywood parameters - No customizations active
)
echo.
pause
goto :AdvancedCustomizationMain

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
set "CUSTOM_COLOR_RANGE="
set "CUSTOM_COLOR_PRIMARIES="
set "CUSTOM_COLOR_TRC="
set "CUSTOM_COLOR_SPACE="
set "COLOR_PRESET_NAME="
set "CUSTOM_COLOR_PARAMS="
set "COLOR_CUSTOMIZATION_ACTIVE=N"
set "CUSTOM_AUDIO_BITRATE="
set "CUSTOM_AUDIO_SAMPLERATE="
set "CUSTOM_AUDIO_CHANNELS="
set "CUSTOM_AUDIO_PROCESSING="
set "AUDIO_PRESET_NAME="
set "AUDIO_NORMALIZATION=N"
set "AUDIO_FILTERING=N"
set "CUSTOM_AUDIO_PARAMS="
set "CUSTOM_LUFS_TARGET="
set "CUSTOM_PEAK_LIMIT="
set "CUSTOM_LRA_TARGET="
set "NORMALIZATION_PRESET_NAME="
set "CUSTOM_NORMALIZATION_PARAMS="
set "AUDIO_PROCESSING_ACTIVE=N"
set "CUSTOMIZATION_ACTIVE=N"
set "ADVANCED_MODE=N"
echo ✅ Profile restored to standard Hollywood settings
echo [%time:~0,8%] [ADVANCED] Profile restored to original settings>>"!EXEC_LOG!"
pause
goto :AdvancedCustomizationMain

:: ========================================
:: PROFILE MANAGEMENT STUB
:: ========================================
:ProfileManagementStub
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
echo   ✅ File-based profiles: Available
echo   📂 Profiles directory: Working
echo.
echo  🔮 FUTURE FEATURES (Coming Soon):
echo   ⏳ [1] Export Current Profile
echo   ⏳ [2] Import Profile from File
echo   ⏳ [3] Browse Profile Library
echo   ⏳ [4] Create Profile Template
echo   ⏳ [5] Profile Validation
echo   ⏳ [6] Profile Sharing
echo.
echo  💡 Currently, profiles are managed through .prof files in the profiles directory.
echo.
echo  [B] 🔙 Back to Advanced Menu
echo.
pause
goto :AdvancedCustomizationMain

:ApplyAdvancedCustomizations
if "%CUSTOMIZATION_ACTIVE%"=="N" (
    echo.
    echo ⚠️ No active customizations to apply
    echo 💡 Use menu options to customize parameters first
    pause
    goto :AdvancedCustomizationMain
)

echo.
echo ✅ Applying advanced customizations...
:: Ativar modo avançado
set "ADVANCED_MODE=Y"

:: Backup original parameters if not already done
if not defined PROFILE_BACKUP (
    set "PROFILE_BACKUP=%X264_PARAMS%"
    set "PRESET_BACKUP=%X264_PRESET%"
)

echo 💾 Saving customizations to config file...
call :SaveAdvancedCustomizations
if errorlevel 1 (
    echo ❌ Failed to save customizations
    pause
    goto :AdvancedCustomizationMain
)

:: NOVO: Carregar configurações do arquivo .temp (aplicar na sessão)
echo 📥 Loading customizations from config file...
call :LoadAdvancedConfigFromModule
if errorlevel 1 (
    echo ❌ Failed to load customizations
    pause
    goto :AdvancedCustomizationMain
)

echo ✅ Customizations applied successfully!
echo 🎬 Ready for encoding with customized parameters!
echo [%time:~0,8%] [ADVANCED] V5.2 Advanced customizations applied successfully>>"!EXEC_LOG!"

echo.
echo 📋 CUSTOMIZATIONS SUMMARY:
if defined CUSTOM_PRESET echo   🎭 x264 Preset: %CUSTOM_PRESET%
if defined CUSTOM_PSY_RD echo   🧠 Psychovisual: %CUSTOM_PSY_RD%
if defined GOP_PRESET_NAME echo   🎬 GOP: %GOP_PRESET_NAME% (%CUSTOM_GOP_SIZE%/%CUSTOM_KEYINT_MIN%)
if defined VBV_PRESET_NAME echo   📊 VBV: %VBV_PRESET_NAME% (%CUSTOM_MAX_BITRATE%/%CUSTOM_BUFFER_SIZE%)
if defined AUDIO_PRESET_NAME echo   🎵 Audio: %AUDIO_PRESET_NAME% (%CUSTOM_AUDIO_BITRATE%)
if defined COLOR_PRESET_NAME echo   🎨 Color: %COLOR_PRESET_NAME%

echo.
echo 🔄 Returning to Advanced Customization menu...
echo 💡 Use [0] to return to main menu with applied customizations
pause

goto :AdvancedCustomizationMain

:SaveAdvancedCustomizations
:: Generate unique config file name with timestamp
for /f "tokens=1-3 delims=:." %%A in ('echo %time%') do (
    set "timestamp=%%A%%B%%C"
)
set "timestamp=%timestamp: =%"
set "CONFIG_FILE=%TEMP%\encoder_advanced_config_%timestamp%.tmp"

echo   📁 Config file: %CONFIG_FILE%

:: COMPREHENSIVE VARIABLE SAVING - FIXED FORMAT
(
    echo :: Instagram Encoder Framework V5.2 - Advanced Configuration
    echo :: Generated: %date% %time%
    echo :: Variables saved from advanced customization module
    echo.
    
    :: x264 PRESET CUSTOMIZATION
    if defined CUSTOM_PRESET (
        echo set "CUSTOM_PRESET=%CUSTOM_PRESET%"
    )
    :: PSYCHOVISUAL CUSTOMIZATION  
    if defined CUSTOM_PSY_RD (
        echo set "CUSTOM_PSY_RD=%CUSTOM_PSY_RD%"
    )
    :: GOP STRUCTURE CUSTOMIZATION - ENSURE BOTH VALUES SAVED
    if defined CUSTOM_GOP_SIZE (
        echo set "CUSTOM_GOP_SIZE=%CUSTOM_GOP_SIZE%"        
        :: CRITICAL: Ensure CUSTOM_KEYINT_MIN is always saved
        if defined CUSTOM_KEYINT_MIN (
            echo set "CUSTOM_KEYINT_MIN=%CUSTOM_KEYINT_MIN%"
        ) else (
            :: Auto-calculate if missing
            set /a "auto_keyint=%CUSTOM_GOP_SIZE%/2"
            echo set "CUSTOM_KEYINT_MIN=!auto_keyint!"
        )
        
        if defined GOP_PRESET_NAME (
            echo set "GOP_PRESET_NAME=%GOP_PRESET_NAME%"
        )
    )
    :: VBV BUFFER CUSTOMIZATION - ENSURE BOTH VALUES SAVED
    if defined CUSTOM_MAX_BITRATE (
        echo set "CUSTOM_MAX_BITRATE=%CUSTOM_MAX_BITRATE%"
        :: CRITICAL: Ensure CUSTOM_BUFFER_SIZE is always saved
        if defined CUSTOM_BUFFER_SIZE (
            echo set "CUSTOM_BUFFER_SIZE=%CUSTOM_BUFFER_SIZE%"
        ) else (
            :: Use max bitrate as buffer if missing
            echo set "CUSTOM_BUFFER_SIZE=%CUSTOM_MAX_BITRATE%"
        )   
        if defined VBV_PRESET_NAME (
            echo set "VBV_PRESET_NAME=%VBV_PRESET_NAME%"
        )
    )
    
    :: AUDIO CUSTOMIZATION
    if defined CUSTOM_AUDIO_BITRATE (
        echo set "CUSTOM_AUDIO_BITRATE=%CUSTOM_AUDIO_BITRATE%"
    )
    if defined CUSTOM_AUDIO_SAMPLERATE (
        echo set "CUSTOM_AUDIO_SAMPLERATE=%CUSTOM_AUDIO_SAMPLERATE%"
    )
    if defined CUSTOM_AUDIO_CHANNELS (
        echo set "CUSTOM_AUDIO_CHANNELS=%CUSTOM_AUDIO_CHANNELS%"
    )
    if defined AUDIO_PRESET_NAME (
        echo set "AUDIO_PRESET_NAME=%AUDIO_PRESET_NAME%"
    )
    
    :: AUDIO NORMALIZATION VARIABLES
    if defined CUSTOM_LUFS_TARGET (
        echo set "CUSTOM_LUFS_TARGET=%CUSTOM_LUFS_TARGET%"
    )
    if defined CUSTOM_PEAK_LIMIT (
        echo set "CUSTOM_PEAK_LIMIT=%CUSTOM_PEAK_LIMIT%"
    )
    if defined CUSTOM_LRA_TARGET (
        echo set "CUSTOM_LRA_TARGET=%CUSTOM_LRA_TARGET%"
    )
    if defined NORMALIZATION_PRESET_NAME (
        echo set "NORMALIZATION_PRESET_NAME=%NORMALIZATION_PRESET_NAME%"
    )
    if defined CUSTOM_NORMALIZATION_PARAMS (
        echo set "CUSTOM_NORMALIZATION_PARAMS=%CUSTOM_NORMALIZATION_PARAMS%"
    )
    if defined AUDIO_PROCESSING_ACTIVE (
        echo set "AUDIO_PROCESSING_ACTIVE=%AUDIO_PROCESSING_ACTIVE%"
    )
    
    :: COLOR SCIENCE CUSTOMIZATION
    if defined CUSTOM_COLOR_PARAMS (
        echo set "CUSTOM_COLOR_PARAMS=%CUSTOM_COLOR_PARAMS%"
    )
    if defined COLOR_PRESET_NAME (
        echo set "COLOR_PRESET_NAME=%COLOR_PRESET_NAME%"
    )
    
    :: CONTROL FLAGS
    echo set "ADVANCED_MODE=Y"
    echo set "CUSTOMIZATION_ACTIVE=Y"
    echo set "ADVANCED_CONFIG_FILE=%CONFIG_FILE%"
    
    echo.
    echo :: End of configuration file
) > "%CONFIG_FILE%"

:: VERIFICATION OF SAVED CONTENT
if exist "%CONFIG_FILE%" (
    echo   ✅ Configuration saved successfully
    echo   🏆 Instagram optimization: ACTIVE automatically
    echo [%time:~0,8%] [ADVANCED] Config file created: %CONFIG_FILE%>>"!EXEC_LOG!"
    echo [%time:~0,8%] [VBV] Auto-optimized by x264 (no manual config saved)>>"!EXEC_LOG!"
    exit /b 0
) else (
    echo   ❌ Failed to create config file
    exit /b 1
)

:: ========================================
:: SEPARATE FUNCTION - CRITICAL FIX
:: ========================================
:LoadAdvancedConfigFromModule
if not defined CONFIG_FILE (
    echo   ❌ No config file path available
    exit /b 1
)

if not exist "%CONFIG_FILE%" (
    echo   ❌ Configuration file not found: %CONFIG_FILE%
    exit /b 1
)

echo   📥 Loading advanced configuration from: %CONFIG_FILE%

:: Load configuration by calling the temp file
call "%CONFIG_FILE%"
if errorlevel 1 (
    echo   ❌ Failed to load configuration from file
    exit /b 1
)

:: Verify critical variables were loaded
if defined CUSTOM_PRESET (
    echo   ✅ x264 Preset loaded: %CUSTOM_PRESET%
)

if defined GOP_PRESET_NAME (
    echo   ✅ GOP Structure loaded: %GOP_PRESET_NAME%
)

if defined VBV_PRESET_NAME (
    echo   ✅ VBV Buffer loaded: %VBV_PRESET_NAME%
)

echo   ✅ Configuration loaded successfully
echo [%time:~0,8%] [ADVANCED] Config loaded from: %CONFIG_FILE%>>"!EXEC_LOG!"
exit /b 0

:ExitAdvancedModule
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       🏠 RETURNING TO MAIN MENU                              ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

if "%ADVANCED_MODE%"=="Y" (
    echo ✅ ADVANCED CUSTOMIZATIONS ACTIVE
    echo.
    echo 📋 APPLIED SETTINGS:
    if defined CUSTOM_PRESET echo   🎭 x264 Preset: %CUSTOM_PRESET%
    if defined CUSTOM_PSY_RD echo   🧠 Psychovisual: %CUSTOM_PSY_RD%
    if defined GOP_PRESET_NAME echo   🎬 GOP: %GOP_PRESET_NAME% (%CUSTOM_GOP_SIZE%/%CUSTOM_KEYINT_MIN%)
    if defined VBV_PRESET_NAME echo   📊 VBV: %VBV_PRESET_NAME% (%CUSTOM_MAX_BITRATE%/%CUSTOM_BUFFER_SIZE%)
    if defined AUDIO_PRESET_NAME echo   🎵 Audio: %AUDIO_PRESET_NAME% (%CUSTOM_AUDIO_BITRATE%)
    if defined COLOR_PRESET_NAME echo   🎨 Color: %COLOR_PRESET_NAME%
    echo.
    echo 🎬 Ready for encoding with customized parameters!
    echo 🚀 Use [3] START ENCODING in main menu
) else (
    echo 🛡️ Using standard Hollywood parameters
    echo 💡 No customizations were applied
)

echo.
echo 🔄 Returning to main menu...
echo [%time:~0,8%] [ADVANCED] Returning to main menu with advanced mode: %ADVANCED_MODE%>>"!EXEC_LOG!"
pause

exit /b 0  
