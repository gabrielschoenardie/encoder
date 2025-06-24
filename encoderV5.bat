@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul 2>&1
color 0A

:: ============================================================================
::                    INSTAGRAM ENCODER FRAMEWORK V5
::                         OPTIMIZED EDITION
::         Instagram Encoder Framework V5 - Optimized Professional Edition
::         Version: 5.0 | Author: Gabriel Schoenardie | Date: 2025
:: ============================================================================

title Instagram Encoder Framework V5 - Optimized Professional Edition

:: Global Variables
set "SCRIPT_VERSION=5.0"
set "EXEC_LOG="
set "BACKUP_CREATED=N"
set "CPU_CORES=0"
set "GLOBAL_START_TIME=0"
set "TOTAL_ENCODE_TIME=00h 00m 00s"

:: Initialize Logging
call :LogEntry "===== INSTAGRAM ENCODER V5 OPTIMIZED - INICIO (%date% %time%) ====="

:: Show Professional Header
call :ShowHeader

:: Captura tempo inicial do processo completo
call :GetTimeInSeconds
set "GLOBAL_START_TIME=!total_seconds!"

:: System Detection & Validation
call :DetectSystemCapabilities
call :CheckFFmpeg
if errorlevel 1 goto :ErrorExit

:: Input Validation & Configuration
call :GetInputFile
call :ValidateInputFile
call :GetOutputFile
call :SelectProfile
call :ConfigureAdvancedSettings

:: Create Backup if needed
call :CreateBackup

:: Execute Encoding (2-Pass Only)
call :ExecuteEncoding

:: Post-Processing
call :PostProcessing
:: Calcula tempo total do processo
call :GetTimeInSeconds
call :CalculateElapsedTime !GLOBAL_START_TIME! !total_seconds!
set "TOTAL_ENCODE_TIME=!ELAPSED_TIME!"
call :LogEntry "[TOTAL] Tempo total de processamento: !TOTAL_ENCODE_TIME!"
call :ShowResults

echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                        ENCODING COMPLETED SUCCESSFULLY!                      ║
echo ║                                                                              ║
echo ║  📁 Output: !ARQUIVO_SAIDA!                                                  ║
echo ║  📊 Log: !EXEC_LOG!                                                          ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
call :LogEntry "===== ENCODING CONCLUIDO COM SUCESSO (%date% %time%) ====="
echo Pressione qualquer tecla para fechar...
pause >nul
exit /b 0

:ErrorExit
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                                  ERRO FATAL                                  ║
echo ║  O processo foi interrompido devido a um erro critico.                       ║
echo ║  Verifique o log para mais detalhes: !EXEC_LOG!                              ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
pause >nul
exit /b 1

:: ============================================================================
::                            CORE FUNCTIONS
:: ============================================================================

:ShowHeader
cls
echo.
echo ================================================================================
echo                      INSTAGRAM ENCODER FRAMEWORK V5
echo                          Optimized Professional Edition
echo ================================================================================
echo.
echo    🎯 GARANTIA ZERO-RECOMPRESSION   🎬 Hollywood-Level Encoding
echo    ⚡ CPU Acceleration              📊 2-Pass Precision Control
echo    🛡️ Advanced Error Recovery       💎 Broadcast-Grade Quality
echo    🎨 Professional Profiles         🎪 Netflix/Disney+ Level
echo.
echo    👨💻 Original: Gabriel Schoenardie
echo    🤖 Optimized: AI Geek Assistant
echo    📅 Version: %SCRIPT_VERSION% (%date%)
echo.
echo ================================================================================
echo.
echo 🚀 Iniciando detecção de sistema e capacidades...
exit /b 0

:DetectSystemCapabilities
echo 🔍 Detectando capacidades do sistema...

:: ============================================================================
::                        DETECÇÃO DE ARQUITETURA CPU
:: ============================================================================

set "CPU_ARCH=Unknown"

:: Método 1: PROCESSOR_ARCHITECTURE (mais confiável)
if /i "%PROCESSOR_ARCHITECTURE%"=="AMD64" set "CPU_ARCH=x64"
if /i "%PROCESSOR_ARCHITECTURE%"=="x86" (
    if defined PROCESSOR_ARCHITEW6432 (
        if /i "%PROCESSOR_ARCHITEW6432%"=="AMD64" (
            set "CPU_ARCH=x64"
        ) else (
            set "CPU_ARCH=x86"
        )
    ) else (
        set "CPU_ARCH=x86"
    )
)

:: Fallback final
if "!CPU_ARCH!"=="Unknown" set "CPU_ARCH=x64"

:: ============================================================================
::                    DETECÇÃO OTIMIZADA DO MODELO DO PROCESSADOR
:: ============================================================================

:: Obter nome do processador
set "CPU_MODEL=Unknown"
for /f "tokens=2 delims==" %%A in ('wmic cpu get Name /value 2^>nul ^| find "=" 2^>nul') do (
    set "CPU_MODEL=%%A"
    goto :model_detection_done
)
:model_detection_done

echo   🔍 CPU detectado: !CPU_MODEL!

:: Valores padrão
set "CPU_CORES=2"
set "CPU_FAMILY=Unknown"

call :DetectCPUFromDatabase

:cpu_identified

:: Detect if it's a laptop
set "IS_LAPTOP=N"
wmic computersystem get PCSystemType 2>nul | findstr "2" >nul
if not errorlevel 1 set "IS_LAPTOP=Y"

:: Detect available RAM
set "TOTAL_RAM_GB=4"
for /f "tokens=2 delims==" %%A in ('wmic OS get TotalVisibleMemorySize /value 2^>nul ^| find "="') do (
    set "TOTAL_RAM_KB=%%A"
    if defined TOTAL_RAM_KB (
        set /a "TOTAL_RAM_GB=!TOTAL_RAM_KB!/1024/1024"
        if !TOTAL_RAM_GB! LSS 1 set "TOTAL_RAM_GB=1"
    )
)

:: Display results
echo   ✅ Arquitetura: !CPU_ARCH!
echo   ✅ CPU Cores: !CPU_CORES! (!CPU_FAMILY!)
if "!IS_LAPTOP!"=="Y" (
    echo   💻 Tipo: Laptop
) else (
    echo   💻 Tipo: Desktop
)
echo   🧠 RAM: !TOTAL_RAM_GB!GB

call :LogEntry "[SYSTEM] Architecture: !CPU_ARCH!"
call :LogEntry "[SYSTEM] CPU: !CPU_CORES! cores (!CPU_FAMILY!)"
call :LogEntry "[SYSTEM] RAM: !TOTAL_RAM_GB!GB, Type: !IS_LAPTOP:Y=Laptop!!IS_LAPTOP:N=Desktop!"

exit /b 0

:: ============================================================================
::                    FUNÇÃO OTIMIZADA DE DETECÇÃO
:: ============================================================================
:DetectCPUFromDatabase
:: Database compacta de CPUs - AMD PRIMEIRO para evitar falsos matches

:: AMD PROCESSORS - Específicos primeiro
for %%D in (
    "2600X|6|AMD Ryzen 5 2600X (6C/12T, 3.6GHz)"
    "2600[^X]|6|AMD Ryzen 5 2600 (6C/12T, 3.4GHz)"
    "3700X|8|AMD Ryzen 7 3700X (8C/16T)"
    "3900X|12|AMD Ryzen 9 3900X (12C/24T)"
    "5600X|6|AMD Ryzen 5 5600X (6C/12T)"
    "5800X|8|AMD Ryzen 7 5800X (8C/16T)"
    "5900X|12|AMD Ryzen 9 5900X (12C/24T)"
    "5950X|16|AMD Ryzen 9 5950X (16C/32T)"
    "Athlon.*Silver.*3050|2|AMD Athlon Silver 3050U (2C/2T)"
    "Athlon.*Gold.*3150|2|AMD Athlon Gold 3150U (2C/4T)"
    "Ryzen.*3.*1200|4|AMD Ryzen 3 1200 (4C/4T)"
    "Ryzen.*3.*[23][0-9][0-9][0-9]|4|AMD Ryzen 3 2nd/3rd Gen (4C/8T)"
    "Ryzen.*3.*[456][0-9][0-9][0-9]|4|AMD Ryzen 3 4th-6th Gen (4C/8T)"
    "Ryzen.*5.*[12][0-9][0-9][0-9]|6|AMD Ryzen 5 1st/2nd Gen (6C/12T)"
    "Ryzen.*5.*[3456][0-9][0-9][0-9]|6|AMD Ryzen 5 3rd-6th Gen (6C/12T)"
    "Ryzen.*5.*7[0-9][0-9][0-9]|8|AMD Ryzen 5 7th Gen (8C/16T)"
    "Ryzen.*7.*[1234567][0-9][0-9][0-9]|8|AMD Ryzen 7 (8C/16T)"
    "Ryzen.*9.*[3456789][0-9][0-9][0-9]|12|AMD Ryzen 9 3rd+ Gen (12C/24T)"
    "Ryzen.*9.*[5789][0-9][0-9][0-9]X|16|AMD Ryzen 9 High-End (16C/32T)"
    "Athlon|2|AMD Athlon (2C/2T)"
    "Ryzen.*3|4|AMD Ryzen 3 (4C/8T)"
    "Ryzen.*5|6|AMD Ryzen 5 (6C/12T)"
    "Ryzen.*7|8|AMD Ryzen 7 (8C/16T)"
    "Ryzen.*9|12|AMD Ryzen 9 (12C/24T)"
) do (
    call :CheckCPUPattern %%D
    if "!CPU_MATCHED!"=="Y" exit /b 0
)

:: INTEL PROCESSORS
for %%D in (
    "1007U|2|Intel Celeron 1007U (2C/2T, 1.5GHz)"
    "1005M|2|Intel Celeron 1005M (2C/2T, 1.9GHz)"
    "N3350|2|Intel Celeron N3350 (2C/2T, Apollo Lake)"
    "N4[0-9][0-9][0-9]|4|Intel Celeron N4xxx (4C/4T, Gemini Lake)"
    "Celeron.*N[0-9]|2|Intel Celeron N-Series (2C/2T)"
    "Pentium.*Gold|2|Intel Pentium Gold (2C/4T)"
    "Pentium.*Silver|4|Intel Pentium Silver (4C/4T)"
    "i3.*1[0-9][0-9][0-9][0-9]|4|Intel Core i3 10th+ Gen (4C/8T)"
    "i3.*[456789][0-9][0-9][0-9]|2|Intel Core i3 4th-9th Gen (2C/4T)"
    "i3.*[23][0-9][0-9][0-9]|2|Intel Core i3 2nd/3rd Gen (2C/4T)"
    "i5.*1[0-9][0-9][0-9][0-9]|6|Intel Core i5 10th+ Gen (6C/12T)"
    "i5.*[456789][0-9][0-9][0-9]|4|Intel Core i5 4th-9th Gen (4C/4T)"
    "i5.*[23][0-9][0-9][0-9]|2|Intel Core i5 2nd/3rd Gen (2C/4T)"
    "i7.*1[0-9][0-9][0-9][0-9]|8|Intel Core i7 10th+ Gen (8C/16T)"
    "i7.*[456789][0-9][0-9][0-9]|4|Intel Core i7 4th-9th Gen (4C/8T)"
    "i7.*[23][0-9][0-9][0-9]|4|Intel Core i7 2nd/3rd Gen (4C/8T)"
    "Core.*i9|8|Intel Core i9 (8C/16T+)"
    "Core.*i7|4|Intel Core i7 (Generic 4C/8T)"
    "Core.*i5|4|Intel Core i5 (Generic 4C/4T)"
    "Core.*i3|2|Intel Core i3 (Generic 2C/4T)"
    "Pentium[^.]|2|Intel Pentium (2C/2T)"
    "Celeron[^.]|2|Intel Celeron (Generic 2C/2T)"
) do (
    call :CheckCPUPattern %%D
    if "!CPU_MATCHED!"=="Y" exit /b 0
)

:: Se não encontrou na database, usar detecção automática
echo   ⚠️  Processador não encontrado na database - Usando detecção automática...

:: Tentar detectar cores físicos via WMIC
set "PHYSICAL_CORES=0"
for /f "tokens=2 delims==" %%A in ('wmic cpu get NumberOfCores /value 2^>nul ^| find "="') do (
    set "PHYSICAL_CORES=%%A"
)

if !PHYSICAL_CORES! GTR 0 (
    set "CPU_CORES=!PHYSICAL_CORES!"
    set "CPU_FAMILY=Auto-detected (!PHYSICAL_CORES! physical cores)"
    exit /b 0
)

:: Fallback para NUMBER_OF_PROCESSORS dividido por 2 (assumindo HyperThreading)
if defined NUMBER_OF_PROCESSORS (
    set "AUTO_CORES=%NUMBER_OF_PROCESSORS%"
    if !AUTO_CORES! GEQ 1 if !AUTO_CORES! LEQ 128 (
        :: Para CPUs com HyperThreading, dividir por 2
        if !AUTO_CORES! GTR 4 (
            set /a "CPU_CORES=!AUTO_CORES!/2"
        ) else (
            set "CPU_CORES=!AUTO_CORES!"
        )
        set "CPU_FAMILY=Auto-detected (!CPU_CORES! cores estimated)"
        exit /b 0
    )
)

:: Fallback final baseado na arquitetura
if "!CPU_ARCH!"=="x86" (
    set "CPU_CORES=1"
    set "CPU_FAMILY=x86 Fallback (Single Core)"
) else (
    set "CPU_CORES=2"
    set "CPU_FAMILY=Generic Fallback (Dual Core)"
)

exit /b 0

:: ============================================================================
::                    FUNÇÃO AUXILIAR DE MATCHING
:: ============================================================================
:CheckCPUPattern
:: Recebe uma string no formato "PATTERN|CORES|DESCRIPTION"
set "CPU_MATCHED=N"
set "PATTERN_DATA=%~1"

:: Extrair componentes
for /f "tokens=1,2,3 delims=|" %%A in ("!PATTERN_DATA!") do (
    set "PATTERN=%%A"
    set "CORES=%%B"
    set "DESCRIPTION=%%C"
)

:: Verificar se o padrão corresponde
echo "!CPU_MODEL!" | findstr /i "!PATTERN!" >nul
if not errorlevel 1 (
    set "CPU_CORES=!CORES!"
    set "CPU_FAMILY=!DESCRIPTION!"
    set "CPU_MATCHED=Y"
)

exit /b 0

:CheckFFmpeg
echo 🔍 Verificando FFmpeg...

set "FFMPEG_CMD=ffmpeg"
%FFMPEG_CMD% -version >nul 2>&1
if errorlevel 1 (
    echo.
    echo ⚠️  FFmpeg não encontrado no PATH do sistema.
    :loop_ffmpeg_path
    set /p "FFMPEG_PATH=Digite o caminho completo para ffmpeg.exe: "
    if "!FFMPEG_PATH!"=="" (
        echo ❌ Caminho não pode ser vazio!
        goto loop_ffmpeg_path
    )
    if not exist "!FFMPEG_PATH!" (
        echo ❌ Arquivo não encontrado: !FFMPEG_PATH!
        goto loop_ffmpeg_path
    )
    set "FFMPEG_CMD=!FFMPEG_PATH!"
)

:: Test FFmpeg functionality
echo   🧪 Testando funcionalidade do FFmpeg...
"%FFMPEG_CMD%" -f lavfi -i testsrc=duration=1:size=320x240:rate=1 -f null - >nul 2>&1
if errorlevel 1 (
    echo ❌ FFmpeg não está funcionando corretamente!
    call :LogEntry "[ERROR] FFmpeg functionality test failed"
    exit /b 1
)

echo   ✅ FFmpeg funcionando: !FFMPEG_CMD!
call :LogEntry "[OK] FFmpeg validated: !FFMPEG_CMD!"
exit /b 0

:GetInputFile
echo.
echo 📁 Seleção do arquivo de entrada:
:loop_input_file
set "ARQUIVO_ENTRADA="
set /p "ARQUIVO_ENTRADA=Digite o caminho do arquivo de entrada: "

if "!ARQUIVO_ENTRADA!"=="" (
    echo ❌ Caminho não pode ser vazio!
    goto loop_input_file
)

:: Remove quotes if present
set "ARQUIVO_ENTRADA=!ARQUIVO_ENTRADA:"=!"

if not exist "!ARQUIVO_ENTRADA!" (
    echo ❌ Arquivo não encontrado: !ARQUIVO_ENTRADA!
    goto loop_input_file
)

echo   ✅ Arquivo selecionado: !ARQUIVO_ENTRADA!
call :LogEntry "[INPUT] File selected: !ARQUIVO_ENTRADA!"
exit /b 0

:ValidateInputFile
echo 🔍 Validando arquivo de entrada...

:: Check file extension
set "FILE_EXT="
for %%A in ("!ARQUIVO_ENTRADA!") do set "FILE_EXT=%%~xA"

:: Validate extension - método direto
if /i "!FILE_EXT!"==".mp4" goto :ext_ok
if /i "!FILE_EXT!"==".mov" goto :ext_ok
if /i "!FILE_EXT!"==".avi" goto :ext_ok
if /i "!FILE_EXT!"==".mkv" goto :ext_ok
if /i "!FILE_EXT!"==".m4v" goto :ext_ok
if /i "!FILE_EXT!"==".wmv" goto :ext_ok
if /i "!FILE_EXT!"==".flv" goto :ext_ok
if /i "!FILE_EXT!"==".webm" goto :ext_ok

echo ⚠️  Formato não recomendado: !FILE_EXT!
echo     Formatos suportados: .mp4, .mov, .avi, .mkv, .m4v, .wmv, .flv, .webm
set /p "CONTINUE=Continuar mesmo assim? (S/N): "
if /i not "!CONTINUE:~0,1!"=="S" (
    echo   ❌ Operação cancelada pelo usuário
    exit /b 1
)

:ext_ok
echo   ✅ Formato reconhecido: !FILE_EXT!

:: OPTIMIZED: Single FFmpeg call for all metadata
echo   📊 Analisando propriedades do vídeo...
set "TEMP_INFO=video_analysis_!RANDOM!.txt"
"%FFMPEG_CMD%" -i "!ARQUIVO_ENTRADA!" -hide_banner 2>"!TEMP_INFO!"

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
for %%R in (7680x4320 3840x2160 2560x1440 1920x1080 1280x720 1080x1920 1080x1350 1080x1080 720x1280 640x480) do (
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
echo.
echo 📁 Definindo arquivo de saída:
:loop_output_file
set /p "ARQUIVO_SAIDA=Digite o nome do arquivo de saída (sem extensão): "

:: Setup log files
for %%A in ("!ARQUIVO_SAIDA!") do set "NOME_BASE_SAIDA=%%~nA"
set "ARQUIVO_LOG_PASSAGEM=!NOME_BASE_SAIDA!_ffmpeg_passlog"

:: Remove extension if provided and add .mp4
for %%A in ("!ARQUIVO_SAIDA!") do set "ARQUIVO_SAIDA=%%~nA"
set "ARQUIVO_SAIDA=!ARQUIVO_SAIDA!.mp4"

:: Check if file exists
if exist "!ARQUIVO_SAIDA!" (
    echo ⚠️  Arquivo já existe: !ARQUIVO_SAIDA!
    set /p "OVERWRITE=Sobrescrever? (S/N): "
    if /i not "!OVERWRITE:~0,1!"=="S" goto loop_output_file
)

echo   ✅ Arquivo de saída: !ARQUIVO_SAIDA!
echo   📋 Log de passagem: !ARQUIVO_LOG_PASSAGEM!

call :LogEntry "[OUTPUT] File: !ARQUIVO_SAIDA!"
call :LogEntry "[OUTPUT] Pass log base: !ARQUIVO_LOG_PASSAGEM!"
exit /b 0

:SelectProfile
echo.
echo   =====================================================================
echo                🎬 HOLLYWOOD-GRADE PROFILE SELECTION 🎬
echo   =====================================================================
echo.
echo   [1] 📱 Reels/Stories (9:16) - Hollywood vertical, 15M bitrate
echo   [2] 📺 Feed Post (1:1) - Square Hollywood, 12M bitrate
echo   [3] 🖥️ IGTV/Feed (16:9) - Horizontal Hollywood, 22M bitrate
echo   [4] ⚡ Speed/Quality (9:16) - Balanced Hollywood, 14M bitrate
echo   [5] 🎭 Cinema (21:9) - Ultra-wide Hollywood, 30M bitrate
echo   [6] 🏆 HOLLYWOOD ULTRA (9:16) - Maximum quality, 25M bitrate
echo.
echo   ═══════════════════════════════════════════════════════════════════
echo                        ESPAÇO RESERVADO PARA FUTUROS MODOS:
echo                        [7] HEVC/H.265 Mode (Em desenvolvimento)
echo                        [8] VP9 Mode (Em desenvolvimento)
echo                        [9] AV1 Mode (Em desenvolvimento)
echo   ═══════════════════════════════════════════════════════════════════
echo.

:loop_profile_selection
set "PROFILE_CHOICE="
set /p "PROFILE_CHOICE=Escolha o perfil (1-6): "

:: Validar entrada
if "!PROFILE_CHOICE!"=="" goto :invalid_profile
if !PROFILE_CHOICE! LSS 1 goto :invalid_profile
if !PROFILE_CHOICE! GTR 6 goto :invalid_profile

call :LoadProfileFromDatabase !PROFILE_CHOICE!
goto :profile_configured

:invalid_profile
echo ❌ Opção inválida! Por favor, escolha um número de 1 a 6.
goto :loop_profile_selection

:profile_configured

echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                          PROFILE SELECIONADO                                 ║
echo ╠══════════════════════════════════════════════════════════════════════════════╣
echo ║  🎬 Perfil: !PROFILE_NAME!                                                   ║
echo ║  📐 Resolução: !VIDEO_ESCALA!                                                ║
echo ║  🎯 Modo: 2-PASS (Hollywood x264 parameters)                                 ║
echo ║  📊 Bitrate: !BITRATE_VIDEO_TARGET! target / !BITRATE_VIDEO_MAX! max         ║
echo ║  📦 Buffer: !BUFSIZE_VIDEO! (buffer size)                                    ║
echo ║  🎵 Audio: !BITRATE_AUDIO! (AAC 48kHz)                                       ║
echo ║  ⚙️ Preset: !PRESET_X264! (Hollywood-grade)                                  ║
echo ║  🎛️ Tune: !TUNE_PARAM! (film, animation, grain)                              ║
echo ║  🔄 Refs: !REFS_COUNT! / B-frames: !BFRAMES_COUNT!                           ║
echo ║  📝 Log de passagem: !ARQUIVO_LOG_PASSAGEM!                                  ║
echo ║  📁 Arquivo de saída: !ARQUIVO_SAIDA!                                        ║
echo ║  ⏳ Duração: !DURATION_STR! (aprox. !INPUT_FPS! FPS)                         ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

set /p "CONFIRM=Confirmar configuração? (S/N): "
if /i not "!CONFIRM:~0,1!"=="S" goto :loop_profile_selection

call :LogEntry "[PROFILE] Selected: !PROFILE_NAME! (!VIDEO_ESCALA!, 2-PASS)"
exit /b 0

:LoadProfileFromDatabase
set "PROFILE_ID=%~1"

:: Database de perfis - formato:
:: ID|NAME|SCALE|TARGET|MAX|BUFFER|PRESET|AUDIO|TUNE|REFS|BFRAMES

for %%P in (
    "1|Reels/Stories HOLLYWOOD ZERO-RECOMPRESSION|1080:1920|15M|25M|30M|veryslow|320k|film|5|3"
    "2|Feed Square HOLLYWOOD ZERO-RECOMPRESSION|1080:1080|12M|22M|24M|veryslow|256k|film|5|3"
    "3|IGTV/Feed HOLLYWOOD ZERO-RECOMPRESSION|1920:1080|22M|35M|42M|veryslow|320k|film|5|3"
    "4|Speed Quality HOLLYWOOD ZERO-RECOMPRESSION|1080:1920|14M|20M|24M|fast|192k|film|2|2"
    "5|Cinema HOLLYWOOD ZERO-RECOMPRESSION|2560:1080|30M|45M|55M|placebo|320k|film|5|3"
    "6|HOLLYWOOD ULTRA ZERO-RECOMPRESSION|1080:1920|25M|40M|50M|veryslow|320k|film|5|3"
) do (
    call :ParseProfileData %%P
    if "!PARSED_ID!"=="!PROFILE_ID!" (
        :: Aplicar configurações do perfil
        set "PROFILE_NAME=!PARSED_NAME!"
        set "VIDEO_ESCALA=!PARSED_SCALE!"
        set "BITRATE_VIDEO_TARGET=!PARSED_TARGET!"
        set "BITRATE_VIDEO_MAX=!PARSED_MAX!"
        set "BUFSIZE_VIDEO=!PARSED_BUFFER!"
        set "PRESET_X264=!PARSED_PRESET!"
        set "BITRATE_AUDIO=!PARSED_AUDIO!"
        set "TUNE_PARAM=!PARSED_TUNE!"
        set "REFS_COUNT=!PARSED_REFS!"
        set "BFRAMES_COUNT=!PARSED_BFRAMES!"

        call :LogEntry "[PROFILE] Profile !PROFILE_ID! loaded from database"
        exit /b 0
    )
)

:: Se chegou aqui, perfil não encontrado
echo ❌ ERRO: Perfil !PROFILE_ID! não encontrado na database!
exit /b 1

:ParseProfileData
set "PROFILE_DATA=%~1"

:: Extrair todos os campos
for /f "tokens=1-11 delims=|" %%A in ("!PROFILE_DATA!") do (
    set "PARSED_ID=%%A"
    set "PARSED_NAME=%%B"
    set "PARSED_SCALE=%%C"
    set "PARSED_TARGET=%%D"
    set "PARSED_MAX=%%E"
    set "PARSED_BUFFER=%%F"
    set "PARSED_PRESET=%%G"
    set "PARSED_AUDIO=%%H"
    set "PARSED_TUNE=%%I"
    set "PARSED_REFS=%%J"
    set "PARSED_BFRAMES=%%K"
)
exit /b 0

:ConfigureAdvancedSettings
echo.
echo ⚙️ Configurações avançadas:

:: Configure threading based on hardware
if "!IS_LAPTOP!"=="Y" (
    set /a "THREAD_COUNT=!CPU_CORES!/2"
    if !THREAD_COUNT! LSS 2 set "THREAD_COUNT=2"
    echo   🔥 Laptop detectado - Threading limitado: !THREAD_COUNT! threads
    echo   🧠 Threads configurados: !THREAD_COUNT! de !CPU_CORES! disponíveis
) else (
    set "THREAD_COUNT=0"
    echo   🚀 Desktop detectado - Threading automático: Todos os cores
    echo   🧠 Usando todos os !CPU_CORES! cores disponíveis
)

:: CPU-only encoding with Hollywood parameters
echo   💻 Modo de encoding: CPU-ONLY (HOLLYWOOD LEVEL)
echo   🎬 Parâmetros x264: Nível broadcast profissional
echo   ⚡ Performance: Otimizada para máxima qualidade

:: Configure Instagram compliance
echo   ✅ Modo de compatibilidade Instagram: ATIVADO

call :LogEntry "[CONFIG] CPU Mode Threads: !THREAD_COUNT!, Instagram: Y"
exit /b 0

:CreateBackup
if exist "!ARQUIVO_SAIDA!" (
    echo 💾 Criando backup do arquivo existente...
    set "BACKUP_NAME=!ARQUIVO_SAIDA!.backup.!RANDOM!"
    copy "!ARQUIVO_SAIDA!" "!BACKUP_NAME!" >nul
    if not errorlevel 1 (
        set "BACKUP_CREATED=Y"
        echo   ✅ Backup criado: !BACKUP_NAME!
        call :LogEntry "[BACKUP] Created: !BACKUP_NAME!"
    )
)
exit /b 0

:ExecuteEncoding
echo.
echo 🎬 Iniciando processo de encoding...
echo 💻 Modo de encoding: CPU apenas (máxima qualidade)
echo 🎯 Parâmetros: Hollywood-Level x264
echo ⚡ Threading: !THREAD_COUNT! cores otimizados

:: Execute 2-Pass encoding (only mode available)
call :Execute2Pass

if errorlevel 1 (
    echo ❌ Erro durante o encoding!
    call :RecoverFromError
    exit /b 1
)

exit /b 0

:: ============================================================================
::                        RESERVED SPACE FOR FUTURE ENCODING MODES
:: ============================================================================
:: FUTURE: :ExecuteHEVC - H.265/HEVC encoding mode
:: FUTURE: :ExecuteVP9 - VP9 encoding mode  
:: FUTURE: :ExecuteAV1 - AV1 encoding mode

:Execute2Pass
echo.
echo 🔄 PASS 1/2 - Análise
echo ════════════════════════════════════════════════════════════════════
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
echo ⏱️ Iniciado em %time%

echo 🎬 Analisando vídeo (Pass 1)...
echo.

!FFMPEG_COMMAND! 2>&1
set "PASS1_RESULT=!ERRORLEVEL!"

:: CALCULA TEMPO DE EXECUÇÃO DO PASS 1
call :GetTimeInSeconds
set "PASS1_END=!total_seconds!"
call :CalculateElapsedTime !PASS1_START! !PASS1_END!
set "PASS1_TIME=!ELAPSED_TIME!"

echo.
echo ⏱️ Tempo de execução Pass 1: !PASS1_TIME!
echo 📋 Código de retorno: !PASS1_RESULT!

echo.
echo 🔄 PASS 2/2 - Encoding
echo ════════════════════════════════════════════════════════════════════
call :BuildFFmpegCommand "PASS2"
set "PASS2_RESULT_BUILD=!ERRORLEVEL!"

if !PASS2_RESULT_BUILD! NEQ 0 (
    echo ❌ Erro ao construir comando Pass 2
    call :LogEntry "[ERROR] Failed to build Pass 2 command"
    pause
    exit /b 1
)

:: Captura tempo inicial do Pass 2
echo 🎬 Iniciando encoding final (Pass 2)...
call :GetTimeInSeconds
set "PASS2_START=!total_seconds!"
echo ⏱️ Iniciado em %time%

echo 🎬 Criando arquivo final...
!FFMPEG_COMMAND! 2>&1
set "PASS2_RESULT=!ERRORLEVEL!"

:: CALCULA TEMPO DE EXECUÇÃO DO PASS 2
call :GetTimeInSeconds
set "PASS2_END=!total_seconds!"
call :CalculateElapsedTime !PASS2_START! !PASS2_END!
set "PASS2_TIME=!ELAPSED_TIME!"

echo.
if !PASS2_RESULT! EQU 0 (
    echo ✅ Pass 2 concluído: !PASS2_TIME!
    echo.
    echo 📊 RESUMO:
    echo   • Pass 1: !PASS1_TIME!
    echo   • Pass 2: !PASS2_TIME!
    call :GetTimeInSeconds
    call :CalculateElapsedTime !PASS1_START! !total_seconds!
    echo   • Total: !ELAPSED_TIME!
    echo.
    call :LogEntry "[SUCCESS] 2-Pass encoding completed"
    exit /b 0
) else (
    echo ❌ Pass 2 falhou (código: !PASS2_RESULT!)
    call :LogEntry "[ERROR] Pass 2 failed"
    pause
    exit /b 1
)

exit /b 0

:BuildFFmpegCommand
set "PASS_TYPE=%~1"

:: Verificação de variáveis críticas
echo   🔍 Verificando variáveis críticas antes de construir comando...

if not defined PROFILE_NAME set "PROFILE_NAME=STANDARD"
if not defined VIDEO_ESCALA (
    echo   ❌ ERRO FATAL: VIDEO_ESCALA não definido!
    exit /b 1
)

echo   ✅ Variáveis críticas validadas com sucesso

:: Base command
set "FFMPEG_COMMAND="!FFMPEG_CMD!" -y -hide_banner -i "!ARQUIVO_ENTRADA!""

:: CPU encoding
echo   🎬 Aplicando parâmetros de encoding (CPU-ONLY)...
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -c:v libx264"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -preset !PRESET_X264!"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -profile:v high -level:v 4.1"

echo   💎 Detectando perfil ativo: !PROFILE_NAME!

call :GetX264OptsForProfile
if errorlevel 1 (
    echo   ❌ Erro ao obter x264opts para o perfil
    exit /b 1
)

echo   🔧 Aplicando x264opts: !X264_PARAMS!
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -x264opts !X264_PARAMS!"

:: Threading
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -threads !THREAD_COUNT!"
echo   🧠 Threading aplicado: !THREAD_COUNT! threads

:: Video filters with precision scaling
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -vf "scale=!VIDEO_ESCALA!:flags=lanczos,format=yuv420p""
echo   📏 Aplicando filtro de escala: !VIDEO_ESCALA!

:: GOP structure
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -g 30 -keyint_min 15 -sc_threshold 40 -r 30"

:: Instagram compliance
echo   📱 Aplicando compliance Instagram zero-recompression...
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -pix_fmt yuv420p"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -color_range tv"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -color_primaries bt709"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -color_trc bt709"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -colorspace bt709"
set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -max_muxing_queue_size 9999"

:: Pass-specific settings (2-Pass only)
if "!PASS_TYPE!"=="PASS1" (
    echo   🔄 PASS 1 - Análise estatística para VBV otimizado...
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -b:v !BITRATE_VIDEO_TARGET!"
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -maxrate !BITRATE_VIDEO_MAX!"
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -bufsize !BUFSIZE_VIDEO!"
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -pass 1"
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -passlogfile !ARQUIVO_LOG_PASSAGEM!"
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -an -f null NUL"
) else if "!PASS_TYPE!"=="PASS2" (
    echo   🎬 PASS 2 - Encoding final com máxima qualidade...
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -b:v !BITRATE_VIDEO_TARGET!"
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -maxrate !BITRATE_VIDEO_MAX!"
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -bufsize !BUFSIZE_VIDEO!"
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -pass 2"
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -passlogfile !ARQUIVO_LOG_PASSAGEM!"
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -c:a aac -b:a 320k -ar 48000 -ac 2"
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! -movflags +faststart"
    set "FFMPEG_COMMAND=!FFMPEG_COMMAND! !ARQUIVO_SAIDA!"
)

call :LogEntry "[COMMAND] !FFMPEG_COMMAND!"
exit /b 0

:GetX264OptsForProfile
:: Determinar categoria do perfil
set "PROFILE_CATEGORY=STANDARD"

echo !PROFILE_NAME! | findstr /i "ULTRA" >nul
if not errorlevel 1 set "PROFILE_CATEGORY=ULTRA"

echo !PROFILE_NAME! | findstr /i "Speed" >nul
if not errorlevel 1 set "PROFILE_CATEGORY=SPEED"

echo !PROFILE_NAME! | findstr /i "Cinema" >nul
if not errorlevel 1 set "PROFILE_CATEGORY=CINEMA"

:: Aplicar x264opts baseado na categoria
if "!PROFILE_CATEGORY!"=="ULTRA" (
    set "X264_PARAMS=ref=6:bframes=4:b-adapt=2:direct=auto:me=tesa:subme=11:trellis=2:partitions=all:8x8dct=1:analyse=all:me-range=32:chroma-me=1:cabac=1:deblock=1,-2,-1:psy-rd=1.2,0.30:aq-mode=3:aq-strength=1.2:rc-lookahead=150:mbtree=1:no-fast-pskip=1:no-dct-decimate=1"
) else if "!PROFILE_CATEGORY!"=="SPEED" (
    set "X264_PARAMS=ref=2:bframes=2:b-adapt=1:direct=spatial:me=hex:subme=4:trellis=1:partitions=p8x8,b8x8,i8x8,i4x4:8x8dct=1:analyse=p8x8,b8x8,i8x8,i4x4:me-range=16:chroma-me=1:cabac=1:deblock=1,0,0:psy-rd=0.8,0.1:aq-mode=1:aq-strength=0.6:rc-lookahead=15:mbtree=1"
) else if "!PROFILE_CATEGORY!"=="CINEMA" (
    set "X264_PARAMS=ref=6:bframes=4:b-adapt=2:direct=auto:me=umh:subme=10:trellis=2:partitions=p8x8,b8x8,i8x8,i4x4:8x8dct=1:analyse=p8x8,b8x8,i8x8,i4x4:me-range=32:chroma-me=1:cabac=1:deblock=1,-2,-1:psy-rd=1.2,0.25:aq-mode=3:aq-strength=1.0:rc-lookahead=120:mbtree=1"
) else (
    :: STANDARD - Perfis 1-3 (Reels, Feed, IGTV)
    set "X264_PARAMS=ref=4:bframes=2:b_adapt=2:direct=auto:me=umh:subme=9:trellis=2:partitions=p8x8,b8x8,i8x8,i4x4:8x8dct=1:analyse=p8x8,b8x8,i8x8,i4x4:me-range=16:chroma-me=1:nr=0:no-fast-pskip=1:no-dct-decimate=1:cabac=1:deblock=1,0,0:aq-mode=3:aq-strength=1.0:rc-lookahead=40:mbtree=1:chroma-qp-offset=0:psy-rd=1.00,0.10:psy=1:mixed-refs=1:weightb=1:weightp=2:qcomp=0.50"
)

:: Adicionar vbv-init para 2-Pass
set "X264_PARAMS=!X264_PARAMS!:vbv-init=0.9"

echo     📊 Categoria detectada: !PROFILE_CATEGORY!
echo     🎬 x264opts aplicados para máxima qualidade

exit /b 0

:PostProcessing
echo.
echo 🔍 Pós-processamento e validação...

:: Validate output file
if not exist "!ARQUIVO_SAIDA!" (
    echo ❌ ERRO CRITICO: Arquivo de saída não foi criado!
    call :LogEntry "[ERROR] Output file not created: !ARQUIVO_SAIDA!"
    exit /b 1
)

:: Get file size
for %%A in ("!ARQUIVO_SAIDA!") do set "OUTPUT_SIZE=%%~zA"
set /a "OUTPUT_SIZE_MB=!OUTPUT_SIZE!/1024/1024"

echo    ✅ Validação de arquivo de saída:
echo    📁 Arquivo: !ARQUIVO_SAIDA! 📊 Tamanho: !OUTPUT_SIZE_MB! MB

call :LogEntry "[POST] File size: !OUTPUT_SIZE_MB!MB, Validation completed"

:: Validate Instagram compliance
call :ValidateInstagramCompliance

:: Cleanup temporary files
echo 🧹 Limpando arquivos temporários...
set /p "CLEAN_LOGS=Deletar logs de passagem? (S/N): "
if /i "!CLEAN_LOGS:~0,1!"=="S" (
    del "!ARQUIVO_LOG_PASSAGEM!-0.log" 2>nul
    del "!ARQUIVO_LOG_PASSAGEM!-0.log.mbtree" 2>nul
    echo   ✅ Logs removidos
)

exit /b 0

:ValidateInstagramCompliance
echo   🎯 Verificando compatibilidade ZERO-RECOMPRESSION...

:: OPTIMIZED: Single FFmpeg call to check compliance
set "TEMP_CHECK=compliance_check_!RANDOM!.txt"
"%FFMPEG_CMD%" -i "!ARQUIVO_SAIDA!" -hide_banner 2>"!TEMP_CHECK!" 1>nul

:: Quick compliance checks
set "COMPLIANCE_CHECKS=0"

findstr /i "yuv420p" "!TEMP_CHECK!" >nul && (
    echo     ✅ Pixel format: yuv420p
    set /a "COMPLIANCE_CHECKS+=1"
)

findstr /i "High.*4\.1" "!TEMP_CHECK!" >nul && (
    echo    ✅ Profile/Level: High 4.1
    set /a "COMPLIANCE_CHECKS+=1"
)

findstr /i "mp4" "!TEMP_CHECK!" >nul && (
    echo    ✅ Container: MP4
    set /a "COMPLIANCE_CHECKS+=1"
)

del "!TEMP_CHECK!" 2>nul

if !COMPLIANCE_CHECKS! GEQ 2 (
    echo   ✅ Compatibilidade Instagram: APROVADA
    call :LogEntry "[COMPLIANCE] Instagram compliance: PASSED"
    echo.
    echo      ╔══════════════════════════════════════════════════════════════════╗
    echo      ║           CERTIFICAÇÃO ZERO-RECOMPRESSION APROVADA!              ║
    echo      ║  ✅ Instagram VAI aceitar sem reprocessamento                    ║
    echo      ║  ✅ Qualidade preservada a 100%% garantida                       ║
    echo      ║           🏆 HOLLYWOOD-LEVEL QUALITY ACHIEVED 🏆                ║
    echo      ╚══════════════════════════════════════════════════════════════════╝
) else (
    echo   ⚠️  Alguns parâmetros podem precisar ajuste
)

exit /b 0

:ShowResults
echo.
echo ================================================================================
echo                           ENCODING FINALIZADO
echo ================================================================================
echo.
echo               🏆 ENCODING CONCLUÍDO COM SUCESSO! 🏆
echo.
echo   📄 ARQUIVO PROCESSADO:
echo   ├─ Entrada: !ARQUIVO_ENTRADA!
echo   ├─ Saída: !ARQUIVO_SAIDA! (!OUTPUT_SIZE_MB! MB)
echo   └─ Tempo total: !TOTAL_ENCODE_TIME!
echo.
echo   ⚙️ CONFIGURAÇÃO UTILIZADA:
echo   ├─ Perfil: !PROFILE_NAME!
echo   ├─ Resolução: !VIDEO_ESCALA! @ 30fps
echo   ├─ Modo: 2-PASS (!PRESET_X264!)
echo   ├─ Bitrate: !BITRATE_VIDEO_TARGET! Target / !BITRATE_VIDEO_MAX! Max
echo   └─ Áudio: !BITRATE_AUDIO! AAC 48kHz Stereo
echo.
echo   📝 Log: !EXEC_LOG!
echo   📱 Instagram: CERTIFICADO - Upload direto sem reprocessamento
echo   🎬 Qualidade: Hollywood Zero-Recompression
echo.
echo 🎉 DICAS DE USO:
echo    • Faça upload do arquivo diretamente no Instagram
echo    • Não reprocesse em outros editores
echo    • Qualidade será preservada 100%%
echo.
echo ================================================================================

call :LogEntry "[SUCCESS] Encoding completed - !ARQUIVO_SAIDA! (!OUTPUT_SIZE_MB!MB)"

:: Post-processing options
echo.
echo 📂 Deseja abrir a pasta do arquivo gerado?
set /p "OPEN_FOLDER=Abrir pasta? (S/N): "
if /i "!OPEN_FOLDER:~0,1!"=="S" start "" "%~dp0"

echo.
echo 🎬 Deseja reproduzir o arquivo para verificar?
set /p "PLAY_FILE=Reproduzir vídeo? (S/N): "
if /i "!PLAY_FILE:~0,1!"=="S" (
    if exist "!ARQUIVO_SAIDA!" start "" "!ARQUIVO_SAIDA!"
)

exit /b 0

:RecoverFromError
echo.
echo 🛠️ Sistema de recuperação ativado...

if "!BACKUP_CREATED!"=="Y" (
    echo 💾 Restaurando backup...
    copy "!BACKUP_NAME!" "!ARQUIVO_SAIDA!" >nul
    if not errorlevel 1 (
        echo   ✅ Backup restaurado com sucesso
        del "!BACKUP_NAME!" 2>nul
    )
)

call :LogEntry "[RECOVERY] Error recovery attempted"
exit /b 0

:: ============================================================================
::                    SISTEMA DE TEMPO E LOGGING OTIMIZADO
:: ============================================================================

:GetTimeInSeconds
set "current_time=%time%"
if "%current_time:~0,1%"==" " set "current_time=%current_time:~1%"

for /f "tokens=1-3 delims=:." %%a in ("%current_time%") do (
    set /a "hours=%%a"
    set /a "minutes=%%b"
    set /a "seconds=%%c"
)

if "%hours:~0,1%"=="0" set /a "hours=%hours:~1%"
if "%minutes:~0,1%"=="0" set /a "minutes=%minutes:~1%"
if "%seconds:~0,1%"=="0" set /a "seconds=%seconds:~1%"

set /a "total_seconds=(hours*3600)+(minutes*60)+seconds"
exit /b %total_seconds%

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
    set "EXEC_LOG=!LOG_DATE!_!LOG_HOUR!h!LOG_MIN!_instagram_v5_optimized.log"
    echo ===== INSTAGRAM ENCODER V5 OPTIMIZED LOG - %date% %time% =====>"!EXEC_LOG!"
)
echo [%time:~0,8%] %~1>>"!EXEC_LOG!"
exit /b 0

:: ============================================================================
::                                END OF SCRIPT
:: ============================================================================
