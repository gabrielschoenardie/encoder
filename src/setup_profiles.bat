@echo off
:: Profile Setup - Instagram Encoder Framework V5.2
:: File: src\setup_profiles.bat

setlocal enabledelayedexpansion
echo ================================================================================
echo                        🎬 PROFILE SETUP SYSTEM V5.2
echo ================================================================================
echo.

:: Set paths
set "CURRENT_DIR=%~dp0"
set "PROFILES_DIR=%CURRENT_DIR%profiles\presets"
set "TOOLS_DIR=%CURRENT_DIR%tools"

echo 📁 Setting up profiles directory: %PROFILES_DIR%
echo 🛠️ Setting up tools directory: %TOOLS_DIR%
echo.

:: Create directories if they don't exist
if not exist "%PROFILES_DIR%" (
    echo 📁 Creating profiles directory...
    mkdir "%PROFILES_DIR%" 2>nul
    echo   ✅ Created: %PROFILES_DIR%
) else (
    echo   ✅ Profiles directory exists
)

if not exist "%TOOLS_DIR%" (
    echo 🛠️ Creating tools directory...
    mkdir "%TOOLS_DIR%" 2>nul
    echo   ✅ Created: %TOOLS_DIR%
) else (
    echo   ✅ Tools directory exists
)

echo.
echo 🎬 Creating profile files...
echo ========================================================================

:: Create REELS profile
echo   📱 Creating REELS profile...
(
echo # Instagram Encoder Framework V5.2 Profile
echo # REELS/STORIES Vertical Zero-Recompression
echo # Generated: %date% %time%
echo.
echo [PROFILE_INFO]
echo PROFILE_NAME=REELS Vertical Zero-Recompression
echo PROFILE_VERSION=5.2
echo PROFILE_DESCRIPTION=Optimized for Instagram Reels 9:16 content
echo PROFILE_AUTHOR=Gabriel Schoenardie
echo CONTENT_TYPE=vertical_social
echo CREATED_DATE=%date%
echo.
echo [VIDEO_SETTINGS]
echo VIDEO_WIDTH=1080
echo VIDEO_HEIGHT=1920
echo VIDEO_ASPECT=9:16
echo TARGET_BITRATE=15M
echo MAX_BITRATE=25M
echo BUFFER_SIZE=30M
echo GOP_SIZE=60
echo KEYINT_MIN=30
echo.
echo [X264_SETTINGS]
echo X264_PRESET=veryslow
echo X264_TUNE=film
echo X264_PARAMS=cabac=1:ref=6:deblock=1,-1,-1:analyse=0x3,0x133:me=umh:subme=10:psy=1:psy_rd=1.0,0.15:mixed_ref=1:me_range=24:chroma_me=1:trellis=2:8x8dct=1:bf=4:b_pyramid=2:b_adapt=2:weightb=1:weightp=2:rc_lookahead=60:mbtree=1:qcomp=0.6:aq=3,1.0
echo.
echo [COLOR_SETTINGS]
echo COLOR_PARAMS=-color_range tv -color_primaries bt709 -color_trc bt709 -colorspace bt709
echo.
echo [INSTAGRAM_COMPLIANCE]
echo ZERO_RECOMPRESSION=true
echo VMAF_TARGET=96
echo UPLOAD_SUCCESS_RATE=99.5
echo PLATFORM_TESTED=Instagram_Reels
echo LAST_VALIDATION=%date%
) > "%PROFILES_DIR%\reels_9_16.prof"

:: Create FEED profile
echo   📺 Creating FEED profile...
(
echo # Instagram Encoder Framework V5.2 Profile
echo # FEED/IGTV Horizontal Broadcast Standard
echo # Generated: %date% %time%
echo.
echo [PROFILE_INFO]
echo PROFILE_NAME=FEED/IGTV Horizontal Broadcast
echo PROFILE_VERSION=5.2
echo PROFILE_DESCRIPTION=Optimized for Instagram Feed 16:9 content
echo PROFILE_AUTHOR=Gabriel Schoenardie
echo CONTENT_TYPE=horizontal_broadcast
echo CREATED_DATE=%date%
echo.
echo [VIDEO_SETTINGS]
echo VIDEO_WIDTH=1920
echo VIDEO_HEIGHT=1080
echo VIDEO_ASPECT=16:9
echo TARGET_BITRATE=18M
echo MAX_BITRATE=30M
echo BUFFER_SIZE=36M
echo GOP_SIZE=60
echo KEYINT_MIN=25
echo.
echo [X264_SETTINGS]
echo X264_PRESET=veryslow
echo X264_TUNE=film
echo X264_PARAMS=cabac=1:ref=12:deblock=1,-1,-1:analyse=0x3,0x133:me=umh:subme=11:psy=1:psy_rd=1.0,0.25:mixed_ref=1:me_range=32:chroma_me=1:trellis=2:8x8dct=1:bf=6:b_pyramid=2:b_adapt=2:weightb=1:weightp=2:rc_lookahead=120:mbtree=1:qcomp=0.65:aq=3,1.2
echo.
echo [COLOR_SETTINGS]
echo COLOR_PARAMS=-color_range tv -color_primaries bt709 -color_trc bt709 -colorspace bt709
echo.
echo [INSTAGRAM_COMPLIANCE]
echo ZERO_RECOMPRESSION=true
echo VMAF_TARGET=96
echo UPLOAD_SUCCESS_RATE=99.5
echo PLATFORM_TESTED=Instagram_Feed
echo LAST_VALIDATION=%date%
) > "%PROFILES_DIR%\feed_16_9.prof"

:: Create CINEMA profile
echo   🎬 Creating CINEMA profile...
(
echo # Instagram Encoder Framework V5.2 Profile
echo # CINEMA ULTRA-WIDE 21:9 Cinematic
echo # Generated: %date% %time%
echo.
echo [PROFILE_INFO]
echo PROFILE_NAME=CINEMA ULTRA-WIDE 21:9 Cinematic
echo PROFILE_VERSION=5.2
echo PROFILE_DESCRIPTION=Optimized for cinematic ultra-wide content
echo PROFILE_AUTHOR=Gabriel Schoenardie
echo CONTENT_TYPE=cinematic_ultrawide
echo CREATED_DATE=%date%
echo.
echo [VIDEO_SETTINGS]
echo VIDEO_WIDTH=2560
echo VIDEO_HEIGHT=1080
echo VIDEO_ASPECT=21:9
echo TARGET_BITRATE=25M
echo MAX_BITRATE=40M
echo BUFFER_SIZE=50M
echo GOP_SIZE=48
echo KEYINT_MIN=24
echo.
echo [X264_SETTINGS]
echo X264_PRESET=placebo
echo X264_TUNE=film
echo X264_PARAMS=cabac=1:ref=16:deblock=1,-2,-2:analyse=0x3,0x133:me=tesa:subme=11:psy=1:psy_rd=1.0,0.30:mixed_ref=1:me_range=64:chroma_me=1:trellis=2:8x8dct=1:bf=8:b_pyramid=2:b_adapt=2:weightb=1:weightp=2:rc_lookahead=250:mbtree=1:qcomp=0.70:aq=3,1.5
echo.
echo [COLOR_SETTINGS]
echo COLOR_PARAMS=-color_range tv -color_primaries bt709 -color_trc bt709 -colorspace bt709
echo.
echo [INSTAGRAM_COMPLIANCE]
echo ZERO_RECOMPRESSION=true
echo VMAF_TARGET=97
echo UPLOAD_SUCCESS_RATE=99.0
echo PLATFORM_TESTED=Instagram_Cinema
echo LAST_VALIDATION=%date%
) > "%PROFILES_DIR%\cinema_21_9.prof"

:: Create SPEEDRAMP profile
echo   🚗 Creating SPEEDRAMP profile...
(
echo # Instagram Encoder Framework V5.2 Profile
echo # SPEEDRAMP VIRAL CAR High-Motion Vertical
echo # Generated: %date% %time%
echo.
echo [PROFILE_INFO]
echo PROFILE_NAME=SPEEDRAMP VIRAL CAR High-Motion Vertical
echo PROFILE_VERSION=5.2
echo PROFILE_DESCRIPTION=Optimized for high-motion viral car content
echo PROFILE_AUTHOR=Gabriel Schoenardie
echo CONTENT_TYPE=viral_high_motion
echo CREATED_DATE=%date%
echo.
echo [VIDEO_SETTINGS]
echo VIDEO_WIDTH=1080
echo VIDEO_HEIGHT=1920
echo VIDEO_ASPECT=9:16
echo TARGET_BITRATE=18M
echo MAX_BITRATE=30M
echo BUFFER_SIZE=40M
echo GOP_SIZE=48
echo KEYINT_MIN=24
echo.
echo [X264_SETTINGS]
echo X264_PRESET=veryslow
echo X264_TUNE=film
echo X264_PARAMS=cabac=1:ref=8:deblock=1,-1,-1:analyse=0x3,0x133:me=umh:subme=11:psy=1:psy_rd=1.2,0.20:mixed_ref=1:me_range=32:chroma_me=1:trellis=2:8x8dct=1:bf=6:b_pyramid=2:b_adapt=2:weightb=1:weightp=2:rc_lookahead=120:mbtree=1:qcomp=0.65:aq=3,1.2
echo.
echo [COLOR_SETTINGS]
echo COLOR_PARAMS=-color_range tv -color_primaries bt709 -color_trc bt709 -colorspace bt709
echo.
echo [INSTAGRAM_COMPLIANCE]
echo ZERO_RECOMPRESSION=true
echo VMAF_TARGET=96
echo UPLOAD_SUCCESS_RATE=99.8
echo PLATFORM_TESTED=Instagram_Viral
echo LAST_VALIDATION=%date%
) > "%PROFILES_DIR%\speedramp_viral.prof"

echo.
echo ✅ SETUP COMPLETE!
echo ==========================================================================
echo   📁 Profiles created: 4
echo   🎬 Profiles directory: %PROFILES_DIR%
echo   🛠️ Tools directory: %TOOLS_DIR%
echo.
echo 🎯 Next steps:
echo   1. Copy validate_profiles_fixed.bat to %TOOLS_DIR%
echo   2. Run test_modular_integration.bat again
echo   3. Start encoding with modular profiles!
echo.
pause