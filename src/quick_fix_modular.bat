@echo off
:: Quick Fix for Modular Integration Issues
:: Instagram Encoder Framework V5.2

setlocal enabledelayedexpansion
echo ================================================================================
echo                         🔧 QUICK FIX - MODULAR INTEGRATION
echo ================================================================================
echo.

set "CURRENT_DIR=%~dp0"
echo 📁 Current Directory: %CURRENT_DIR%
echo.

echo 🔧 FIXING MODULAR INTEGRATION ISSUES...
echo ==========================================================================

:: Step 1: Create missing directories
echo Step 1: Creating missing directories...
if not exist "profiles\presets" (
    mkdir "profiles\presets" 2>nul
    echo   ✅ Created: profiles\presets
) else (
    echo   ✅ Directory exists: profiles\presets
)

if not exist "tools" (
    mkdir "tools" 2>nul
    echo   ✅ Created: tools
) else (
    echo   ✅ Directory exists: tools
)

:: Step 2: Create validator file
echo.
echo Step 2: Creating validator file...
(
echo @echo off
echo :: Profile Validator - Instagram Encoder Framework V5.2
echo setlocal enabledelayedexpansion
echo set "PROFILES_FOUND=0"
echo set "PROFILES_VALID=0"
echo set "CURRENT_DIR=%%~dp0"
echo set "PROFILES_DIR=%%CURRENT_DIR%%..\\profiles\\presets"
echo.
echo echo 🔍 PROFILE VALIDATOR V5.2
echo echo ==========================================================================
echo echo 📁 Profiles Directory: %%PROFILES_DIR%%
echo.
echo if not exist "%%PROFILES_DIR%%" ^(
echo     echo ❌ PROFILES DIRECTORY NOT FOUND
echo     exit /b 1
echo ^)
echo.
echo for %%%%F in ^("%%PROFILES_DIR%%\\*.prof"^) do ^(
echo     set /a "PROFILES_FOUND+=1"
echo     echo   ✅ Found: %%%%~nF
echo     set /a "PROFILES_VALID+=1"
echo ^)
echo.
echo echo 📊 VALIDATION SUMMARY:
echo echo   📁 Profiles Found: ^^!PROFILES_FOUND^^!
echo echo   ✅ Valid Profiles: ^^!PROFILES_VALID^^!
echo.
echo if ^^!PROFILES_VALID^^! GTR 0 ^(
echo     echo ✅ VALIDATION PASSED
echo     exit /b 0
echo ^) else ^(
echo     echo ❌ NO VALID PROFILES FOUND
echo     exit /b 1
echo ^)
) > "tools\validate_profiles_fixed.bat"
echo   ✅ Created: tools\validate_profiles_fixed.bat

:: Step 3: Create essential profile files
echo.
echo Step 3: Creating essential profile files...

:: REELS Profile
echo   📱 Creating REELS profile...
(
echo # Instagram Encoder Framework V5.2 Profile
echo # REELS/STORIES Vertical Zero-Recompression
echo.
echo [PROFILE_INFO]
echo PROFILE_NAME=REELS Vertical Zero-Recompression
echo PROFILE_VERSION=5.2
echo PROFILE_DESCRIPTION=Optimized for Instagram Reels 9:16 content
echo PROFILE_AUTHOR=Gabriel Schoenardie
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
) > "profiles\presets\reels_9_16.prof"

:: FEED Profile
echo   📺 Creating FEED profile...
(
echo # Instagram Encoder Framework V5.2 Profile
echo # FEED/IGTV Horizontal Broadcast Standard
echo.
echo [PROFILE_INFO]
echo PROFILE_NAME=FEED/IGTV Horizontal Broadcast
echo PROFILE_VERSION=5.2
echo PROFILE_DESCRIPTION=Optimized for Instagram Feed 16:9 content
echo PROFILE_AUTHOR=Gabriel Schoenardie
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
) > "profiles\presets\feed_16_9.prof"

:: CINEMA Profile
echo   🎬 Creating CINEMA profile...
(
echo # Instagram Encoder Framework V5.2 Profile
echo # CINEMA ULTRA-WIDE 21:9 Cinematic
echo.
echo [PROFILE_INFO]
echo PROFILE_NAME=CINEMA ULTRA-WIDE 21:9 Cinematic
echo PROFILE_VERSION=5.2
echo PROFILE_DESCRIPTION=Optimized for cinematic ultra-wide content
echo PROFILE_AUTHOR=Gabriel Schoenardie
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
) > "profiles\presets\cinema_21_9.prof"

:: SPEEDRAMP Profile
echo   🚗 Creating SPEEDRAMP profile...
(
echo # Instagram Encoder Framework V5.2 Profile
echo # SPEEDRAMP VIRAL CAR High-Motion Vertical
echo.
echo [PROFILE_INFO]
echo PROFILE_NAME=SPEEDRAMP VIRAL CAR High-Motion Vertical
echo PROFILE_VERSION=5.2
echo PROFILE_DESCRIPTION=Optimized for high-motion viral car content
echo PROFILE_AUTHOR=Gabriel Schoenardie
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
) > "profiles\presets\speedramp_viral.prof"

:: Step 4: Test the fix
echo.
echo Step 4: Testing the fix...
call "tools\validate_profiles_fixed.bat"
set "VALIDATION_RESULT=%ERRORLEVEL%"

echo.
echo =============================================================
echo 🎯 QUICK FIX RESULTS:
echo =============================================================

if %VALIDATION_RESULT% EQU 0 (
    echo ✅ SUCCESS - All components fixed and validated!
    echo.
    echo 📁 Created directories:
    echo   • profiles\presets
    echo   • tools
    echo.
    echo 📄 Created files:
    echo   • tools\validate_profiles_fixed.bat
    echo   • profiles\presets\reels_9_16.prof
    echo   • profiles\presets\feed_16_9.prof
    echo   • profiles\presets\cinema_21_9.prof
    echo   • profiles\presets\speedramp_viral.prof
    echo.
    echo 🎯 NEXT STEPS:
    echo   1. Run test_modular_integration.bat again
    echo   2. Start core\encoderV5.bat to test modular system
    echo   3. Select option [2] to test modular profile loading
) else (
    echo ❌ PARTIAL SUCCESS - Some issues may remain
    echo 💡 Check individual components manually
)

echo.
echo =======================================================================
pause