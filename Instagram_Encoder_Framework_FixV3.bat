@echo off
setlocal enabledelayedexpansion

:: ----------------------------------------------------------------------------
:: Instagram_Encoder_Framework_FullFixV2.bat
:: Versão: 1.2 (arquivo completo, sem reticências “...”)
:: Descrição: Framework para codificar em H.264 (Two-Pass ou CRF) para Instagram,
::            com parâmetros “Hollywood” e compatibilidade máxima.
:: Autor:    (adicione seu nome aqui)
:: Data:     Junho/2025
:: ----------------------------------------------------------------------------

::-----------------------------
:: 1. Definições Iniciais
::-----------------------------
title Instagram Encoder Framework - Nivel Hollywood/Instagram (FullFixV2)

:: Variável para registrar o log de execução (nome gerado na primeira chamada)
set "EXEC_LOG="

:: Registra linha de início no arquivo de log
call :LogEntry "===== INICIO DE EXECUCAO (%date% %time%) ====="

::-----------------------------
:: 2. Checar Existência do FFmpeg
::-----------------------------
call :CheckFFmpeg
if errorlevel 1 (
    call :LogEntry "[ERRO] FFmpeg não encontrado. Abortando."
    goto :EOF
)
call :LogEntry "[OK] FFmpeg localizado: !FFMPEG_CMD!"

::-----------------------------
:: 3. Obter Arquivo de Entrada
::-----------------------------
call :GetInputFile
call :LogEntry "[OK] Arquivo de entrada: !ARQUIVO_ENTRADA!"

::-----------------------------
:: 4. Obter Arquivo de Saída
::-----------------------------
call :GetOutputFile
call :LogEntry "[OK] Arquivo de saída definido: !ARQUIVO_SAIDA!"

::-----------------------------
:: 5. Escolher Resolução/Proporção (9:16 ou 16:9)
::-----------------------------
call :GetResolution
call :LogEntry "[OK] Resolução escolhida: !VIDEO_ESCALA!"

::-----------------------------
:: 6. Escolher Modo de Encoding (2PASS ou CRF)
::-----------------------------
call :GetEncodingMode
call :LogEntry "[OK] Modo de encoding escolhido: !ENCODE_MODE!"

::-----------------------------
:: 7. Configurar Parâmetros Avançados
::-----------------------------
call :GetAdvancedParams
if errorlevel 1 (
    call :LogEntry "[ERRO] Falha em GetAdvancedParams. Abortando."
    goto :EOF
)
call :LogEntry "[OK] Parâmetros avançados capturados."

::-----------------------------
:: 8. Executar Encoding
::-----------------------------
if /I "%ENCODE_MODE%"=="2PASS" (
    call :EncodeTwoPass
) else (
    call :EncodeCRF
)

::-----------------------------
:: 9. Limpeza Opcional de Logs (apenas em 2PASS)
::-----------------------------
if /I "%ENCODE_MODE%"=="2PASS" (
    call :CleanupLogs
)

::-----------------------------
:: 10. Mensagem de Conclusão
::-----------------------------
echo.
echo =========================================================================
echo          CODIFICACAO CONCLUIDA COM SUCESSO!
echo          Seu arquivo: "!ARQUIVO_SAIDA!"
echo          Log de execucao: "!EXEC_LOG!"
echo =========================================================================
echo.
call :LogEntry "===== FIM DE EXECUCAO (%date% %time%) ====="
echo Pressione qualquer tecla para fechar esta janela.
pause >nul

:end
exit /b 0

::=============================================================================
::                               SUB-ROTINAS
::=============================================================================

::-----------------------------------------------------------------------------
:: :LogEntry
::   Cria ou anexa ao arquivo de log de execução. Na primeira chamada, gera
::   o nome do arquivo com data e hora. Cada linha de log é gravada nele.
::-----------------------------------------------------------------------------
:LogEntry
if not defined EXEC_LOG (
    for /f "tokens=1-4 delims=/ " %%D in ('date /t') do (
        set "DIA=%%D"
        set "MES=%%E"
        set "ANO=%%F"
    )
    for /f "tokens=1-2 delims=: " %%H in ('time /t') do (
        set "HOR=%%H"
        set "MIN=%%I"
    )
    set "EXEC_LOG=%DIA%-%MES%-%ANO%_%HOR%h%MIN%_instagram_exec.txt"
    echo ===== LOG DE EXECUCAO - %date% %time% =====>"%EXEC_LOG%"
)
echo %~1>>"%EXEC_LOG%"
exit /b 0

::-----------------------------------------------------------------------------
:: :CheckFFmpeg
::   Verifica se o comando “ffmpeg” está no PATH. Caso contrário, pede o
::   caminho completo para o executável. Se não existir, sai com errorlevel=1.
::-----------------------------------------------------------------------------
:CheckFFmpeg
set "FFMPEG_CMD=ffmpeg"
%FFMPEG_CMD% -version >nul 2>&1
if errorlevel 1 (
    echo.
    echo === ATENCAO: ffmpeg nao encontrado no PATH. ===
    set /p "FFMPEG_CMD_PATH=Digite o caminho completo para ffmpeg.exe (ex: C:\ffmpeg\bin\ffmpeg.exe): "
    if not exist "%FFMPEG_CMD_PATH%" (
        echo === ERRO: Caminho do ffmpeg.exe invalido! Abortando. ===
        exit /b 1
    )
    set "FFMPEG_CMD="%FFMPEG_CMD_PATH%""
)
exit /b 0

::-----------------------------------------------------------------------------
:: :GetInputFile
::   Pergunta pelo arquivo de entrada até que um nome válido seja digitado.
::-----------------------------------------------------------------------------
:GetInputFile
:loop_input
set "ARQUIVO_ENTRADA="
set /p "ARQUIVO_ENTRADA=Digite o nome (ou caminho) do arquivo de entrada (ex: video_original.mp4): "
if "%ARQUIVO_ENTRADA%"=="" (
    echo === ERRO: Nome do arquivo de entrada nao pode ser vazio! Tente novamente. ===
    goto loop_input
)
if not exist "%ARQUIVO_ENTRADA%" (
    echo === ERRO: Arquivo '%ARQUIVO_ENTRADA%' nao encontrado! Tente novamente. ===
    goto loop_input
)
exit /b 0

::-----------------------------------------------------------------------------
:: :GetOutputFile
::   Pergunta pelo nome do arquivo de saída (forçando .mp4 se faltar) e
::   em caso de existir, pergunta se deve sobrescrever. Também extrai nome-base
::   para ser usado nos logs de 2PASS.
::-----------------------------------------------------------------------------
:GetOutputFile
:loop_output
set "ARQUIVO_SAIDA="
set /p "ARQUIVO_SAIDA=Digite o nome desejado para o arquivo de saída (ex: video_instagram.mp4): "
if "%ARQUIVO_SAIDA%"=="" (
    echo === ERRO: Nome do arquivo de saída nao pode ser vazio! Tente novamente. ===
    goto loop_output
)
:: Garante extensão .mp4
if /I not "%ARQUIVO_SAIDA:~-4%"==".mp4" (
    set "ARQUIVO_SAIDA=%ARQUIVO_SAIDA%.mp4"
)
:: Se já existir no disco, confirmar sobrescrita
if exist "%ARQUIVO_SAIDA%" (
    set "RESPOSTA="
    where choice >nul 2>&1
    if errorlevel 1 (
        set /p "RESPOSTA=Arquivo '%ARQUIVO_SAIDA%' já existe. Deseja sobrescrever? (S/N): "
        set "RESPOSTA=%RESPOSTA:~0,1%"
    ) else (
        choice /C SN /M "Arquivo '%ARQUIVO_SAIDA%' já existe. Deseja sobrescrever? [S/N]"
        if errorlevel 2 set "RESPOSTA=N"
        if errorlevel 1 set "RESPOSTA=S"
    )
    if /I not "%RESPOSTA%"=="S" (
        echo Informe outro nome de saída.
        goto loop_output
    )
)
:: Extrair nome-base (sem extensão) para prefixo de logs de 2PASS
for %%A in ("%ARQUIVO_SAIDA%") do set "NOME_BASE_SAIDA=%%~nA"
set "ARQUIVO_LOG_PASSAGEM=%NOME_BASE_SAIDA%_ffmpeg_passlog"
exit /b 0

::-----------------------------------------------------------------------------
:: :GetResolution
::   Pergunta se o usuário quer vertical (1080x1920) ou horizontal (1920x1080).
::-----------------------------------------------------------------------------
:GetResolution
echo.
echo Escolha a resolucao/proporcao para o Instagram (videos Full HD 30fps):
echo   1. Reels/Stories (Vertical 9:16)    - 1080x1920
echo   2. Feed Paisagem (Horizontal 16:9)  - 1920x1080

:loop_resolution
set "ESCOLHA_RES="
set "VIDEO_ESCALA="
set /p "ESCOLHA_RES=Digite o numero da sua escolha (1 ou 2): "
if "%ESCOLHA_RES%"=="1" (
    set "VIDEO_ESCALA=1080:1920"
) else if "%ESCOLHA_RES%"=="2" (
    set "VIDEO_ESCALA=1920:1080"
) else (
    echo === ERRO: Opcao inválida. Digite 1 ou 2. ===
    goto loop_resolution
)
exit /b 0

::-----------------------------------------------------------------------------
:: :GetEncodingMode
::   Pergunta se o usuário quer codificar em Two-Pass (2PASS) ou CRF (CRF).
::-----------------------------------------------------------------------------
:GetEncodingMode
echo.
echo Deseja codificar em 2-PASS (otimizado para bitrate) ou CRF (controle de qualidade)?
echo   D = 2-PASS (duas passagens, gera logs intermediarios)
echo   C = CRF   (uma unica passada, mais rapido)
:loop_enc_mode
set "ENCODE_MODE="
set /p "ENCODE_MODE=Digite D para 2-PASS ou C para CRF (padrao: D): "
if "%ENCODE_MODE%"=="" set "ENCODE_MODE=D"
set "ENCODE_MODE=%ENCODE_MODE:~0,1%"
if /I "%ENCODE_MODE%"=="D" (
    set "ENCODE_MODE=2PASS"
) else if /I "%ENCODE_MODE%"=="C" (
    set "ENCODE_MODE=CRF"
) else (
    echo === ERRO: Opcao inválida. Digite 'D' ou 'C'. ===
    goto loop_enc_mode
)
exit /b 0

::-----------------------------------------------------------------------------
:: :GetAdvancedParams
::   Coleta todos os parâmetros avançados, aceitando ENTER para padrão,
::   sem jamais encerrar o .bat antes do esperado.
::   1) Preset x264
::   2) Bitrate de Áudio
::   3) Se modo=2PASS:
::        - Bitrate de Vídeo Alvo
::        - Bitrate de Vídeo Máximo
::        - Bufsize VBV
::   4) Se modo=CRF:
::        - Valor de CRF (0–51)
::   Ao final, exibe resumo e faz pause.
::-----------------------------------------------------------------------------
:GetAdvancedParams
echo.
echo --------------------------------------------------------------------
echo       CONFIGURACAO AVANCADA DE CODIFICACAO
echo  (Pressione ENTER para usar o valor padrao entre colchetes)
echo --------------------------------------------------------------------
echo.

::--- 1) Preset x264
set "PRESET_X264_PADRAO=slower"
set "PRESET_X264_ESCOLHIDO="
set /p "PRESET_X264_ESCOLHIDO=Preset do x264 (medium, slow, slower, veryslow) [%PRESET_X264_PADRAO%]: "
if "%PRESET_X264_ESCOLHIDO%"=="" set "PRESET_X264_ESCOLHIDO=%PRESET_X264_PADRAO%"

::--- 2) Bitrate de Áudio
set "BITRATE_AUDIO_PADRAO=192k"
set "BITRATE_AUDIO_ESCOLHIDO="
set /p "BITRATE_AUDIO_ESCOLHIDO=Bitrate de Audio (ex: 128k, 192k, 256k) [%BITRATE_AUDIO_PADRAO%]: "
if "%BITRATE_AUDIO_ESCOLHIDO%"=="" set "BITRATE_AUDIO_ESCOLHIDO=%BITRATE_AUDIO_PADRAO%"

::--- 3) Se modo = 2PASS, ler parâmetros de vídeo
if /I "%ENCODE_MODE%"=="2PASS" (

    :: 3.1) Bitrate de Vídeo Alvo
    set "BITRATE_VIDEO_ALVO_PADRAO=15M"
    set "BITRATE_VIDEO_ALVO_ESCOLHIDO="
    set /p "BITRATE_VIDEO_ALVO_ESCOLHIDO=Bitrate de Video Alvo (ex: 10M, 15M) [%BITRATE_VIDEO_ALVO_PADRAO%]: "
    if "%BITRATE_VIDEO_ALVO_ESCOLHIDO%"=="" set "BITRATE_VIDEO_ALVO_ESCOLHIDO=%BITRATE_VIDEO_ALVO_PADRAO%"

    :: 3.2) Bitrate de Vídeo Máximo
    set "BITRATE_VIDEO_MAX_PADRAO=25M"
    set "BITRATE_VIDEO_MAX_ESCOLHIDO="
    set /p "BITRATE_VIDEO_MAX_ESCOLHIDO=Bitrate de Video Maximo (ex: 20M, 25M) [%BITRATE_VIDEO_MAX_PADRAO%]: "
    if "%BITRATE_VIDEO_MAX_ESCOLHIDO%"=="" set "BITRATE_VIDEO_MAX_ESCOLHIDO=%BITRATE_VIDEO_MAX_PADRAO%"

    :: 3.3) Bufsize VBV
    set "BUFSIZE_VIDEO_PADRAO=30M"
    set "BUFSIZE_VIDEO_ESCOLHIDO="
    set /p "BUFSIZE_VIDEO_ESCOLHIDO=Bufsize de Video (ex: 20M, 30M, 40M) [%BUFSIZE_VIDEO_PADRAO%]: "
    if "%BUFSIZE_VIDEO_ESCOLHIDO%"=="" set "BUFSIZE_VIDEO_ESCOLHIDO=%BUFSIZE_VIDEO_PADRAO%"

) else (

    ::--- 4) Modo CRF: solicitar CRF entre 0 e 51
    set "CRF_PADRAO=18"
    set "CRF_ESCOLHIDO="
    :loop_crf
    set /p "CRF_ESCOLHIDO=Qual CRF usar (0-51) [%CRF_PADRAO%]: "
    if "%CRF_ESCOLHIDO%"=="" set "CRF_ESCOLHIDO=%CRF_PADRAO%"
    :: Verificar se tem somente dígitos e se está entre 0 e 51
    for /f "delims=0123456789" %%x in ("%CRF_ESCOLHIDO%") do (
        echo === ERRO: CRF deve ser um numero inteiro entre 0 e 51. Tente novamente. ===
        goto loop_crf
    )
    if %CRF_ESCOLHIDO% GEQ 0 if %CRF_ESCOLHIDO% LEQ 51 (
        rem CRF OK
    ) else (
        echo === ERRO: CRF fora do intervalo valido (0-51). Tente novamente. ===
        goto loop_crf
    )

)

::--- 5) Mostrar resumo dos parâmetros e aguardar ENTER
echo.
echo Revisando configuracoes escolhidas:
echo   FFmpeg           : !FFMPEG_CMD!
echo   Entrada          : !ARQUIVO_ENTRADA!
echo   Saida            : !ARQUIVO_SAIDA!
echo   Resolucao        : !VIDEO_ESCALA! (30 fps)
echo   Modo Encoding    : !ENCODE_MODE!
echo   Preset x264      : !PRESET_X264_ESCOLHIDO!
if /I "%ENCODE_MODE%"=="2PASS" (
    echo   Bitrate Video Alvo   : !BITRATE_VIDEO_ALVO_ESCOLHIDO!
    echo   Bitrate Video Maximo : !BITRATE_VIDEO_MAX_ESCOLHIDO!
    echo   Bufsize VBV          : !BUFSIZE_VIDEO_ESCOLHIDO!
)
if /I "%ENCODE_MODE%"=="CRF" (
    echo   CRF                  : !CRF_ESCOLHIDO!
)
echo   Bitrate Audio         : !BITRATE_AUDIO_ESCOLHIDO!
if /I "%ENCODE_MODE%"=="2PASS" (
    echo   Logs de Passagem     : !ARQUIVO_LOG_PASSAGEM!-*.log
)
echo.
echo Pressione qualquer tecla para continuar com a codificacao...
pause >nul

exit /b 0

::-----------------------------------------------------------------------------
:: :EncodeTwoPass
::   Realiza a codificação em duas passagens (2PASS), gerando logs em
::   !ARQUIVO_LOG_PASSAGEM!-0.log e -0.log.mbtree.
::-----------------------------------------------------------------------------
:EncodeTwoPass
echo.
echo ===================   INICIANDO PASSAGEM 1 (ANALISE)   ===================
echo (Gerando arquivos de log para a segunda passagem…)
echo.

"%FFMPEG_CMD%" -y -i "%ARQUIVO_ENTRADA%" ^
 -c:v libx264 ^
 -preset %PRESET_X264_ESCOLHIDO% ^
 -profile:v high ^
 -level:v 4.1 ^
 -vf "scale=%VIDEO_ESCALA%,format=yuv420p" ^
 -r 30 ^
 -g 30 ^
 -keyint_min 30 ^
 -sc_threshold 0 ^
 -bf 3 ^
 -b_strategy 2 ^
 -refs 5 ^
 -coder ac ^
 -tune film ^
 -aq-mode 2 ^
 -psy-rd 1.0:0.15 ^
 -b:v %BITRATE_VIDEO_ALVO_ESCOLHIDO% ^
 -maxrate %BITRATE_VIDEO_MAX_ESCOLHIDO% ^
 -bufsize %BUFSIZE_VIDEO_ESCOLHIDO% ^
 -pass 1 ^
 -passlogfile "%ARQUIVO_LOG_PASSAGEM%" ^
 -an ^
 -f mp4 NUL

if errorlevel 1 (
    echo.
    echo === ERRO FATAL: FFmpeg encontrou um erro durante a Passagem 1! ===
    call :LogEntry "[ERRO] Passagem 1 falhou."
    pause
    exit /b 1
)

echo.
echo ========== PASSAGEM 1 CONCLUIDA ========== 
echo Logs gerados: "%ARQUIVO_LOG_PASSAGEM%-0.log"
echo.
pause >nul

echo ===================   INICIANDO PASSAGEM 2 (FINAL)   ===================
echo (Gerando arquivo final: "%ARQUIVO_SAIDA%")
echo.

"%FFMPEG_CMD%" -y -i "%ARQUIVO_ENTRADA%" ^
 -c:v libx264 ^
 -preset %PRESET_X264_ESCOLHIDO% ^
 -profile:v high ^
 -level:v 4.1 ^
 -vf "scale=%VIDEO_ESCALA%,format=yuv420p" ^
 -r 30 ^
 -g 30 ^
 -keyint_min 30 ^
 -sc_threshold 0 ^
 -bf 3 ^
 -b_strategy 2 ^
 -refs 5 ^
 -coder ac ^
 -tune film ^
 -aq-mode 2 ^
 -psy-rd 1.0:0.15 ^
 -b:v %BITRATE_VIDEO_ALVO_ESCOLHIDO% ^
 -maxrate %BITRATE_VIDEO_MAX_ESCOLHIDO% ^
 -bufsize %BUFSIZE_VIDEO_ESCOLHIDO% ^
 -pass 2 ^
 -passlogfile "%ARQUIVO_LOG_PASSAGEM%" ^
 -color_primaries bt709 ^
 -color_trc bt709 ^
 -colorspace bt709 ^
 -movflags +faststart ^
 -c:a aac ^
 -b:a %BITRATE_AUDIO_ESCOLHIDO% ^
 -ar 48000 ^
 -ac 2 ^
 "%ARQUIVO_SAIDA%"

if errorlevel 1 (
    echo.
    echo === ERRO FATAL: FFmpeg encontrou um erro durante a Passagem 2! ===
    call :LogEntry "[ERRO] Passagem 2 falhou."
    pause
    exit /b 1
)

call :LogEntry "[OK] Codificação 2-pass concluída."
exit /b 0

::-----------------------------------------------------------------------------
:: :EncodeCRF
::   Realiza codificação em modo CRF (single-pass), gerando o arquivo final.
::-----------------------------------------------------------------------------
:EncodeCRF
echo.
echo ===================   INICIANDO CODIFICACAO (CRF)   ===================
echo (Gerando arquivo final: "%ARQUIVO_SAIDA%")
echo.

"%FFMPEG_CMD%" -y -i "%ARQUIVO_ENTRADA%" ^
 -c:v libx264 ^
 -preset %PRESET_X264_ESCOLHIDO% ^
 -crf %CRF_ESCOLHIDO% ^
 -profile:v high ^
 -level:v 4.1 ^
 -vf "scale=%VIDEO_ESCALA%,format=yuv420p" ^
 -r 30 ^
 -g 30 ^
 -keyint_min 30 ^
 -sc_threshold 0 ^
 -bf 3 ^
 -b_strategy 2 ^
 -refs 5 ^
 -coder ac ^
 -tune film ^
 -aq-mode 2 ^
 -psy-rd 1.0:0.15 ^
 -color_primaries bt709 ^
 -color_trc bt709 ^
 -colorspace bt709 ^
 -movflags +faststart ^
 -c:a aac ^
 -b:a %BITRATE_AUDIO_ESCOLHIDO% ^
 -ar 48000 ^
 -ac 2 ^
 "%ARQUIVO_SAIDA%"

if errorlevel 1 (
    echo.
    echo === ERRO FATAL: FFmpeg encontrou um erro durante o modo CRF! ===
    call :LogEntry "[ERRO] CRF encoding falhou."
    pause
    exit /b 1
)

call :LogEntry "[OK] Codificação CRF concluída."
exit /b 0

::-----------------------------------------------------------------------------
:: :CleanupLogs
::   Pergunta se o usuário deseja excluir os arquivos de log gerados no 2PASS.
::-----------------------------------------------------------------------------
:CleanupLogs
echo.
echo =========================================================================
echo Deseja deletar os arquivos de log da codificacao 2-pass?
echo   (%ARQUIVO_LOG_PASSAGEM%-0.log, %ARQUIVO_LOG_PASSAGEM%-0.log.mbtree)
echo =========================================================================
set "DELETAR_LOGS="
where choice >nul 2>&1
if errorlevel 1 (
    set /p "DELETAR_LOGS=Digite S para sim ou N para nao (padrao N): "
    set "DELETAR_LOGS=%DELETAR_LOGS:~0,1%"
) else (
    choice /C SN /M "Deseja deletar os arquivos de log? [S/N]"
    if errorlevel 2 set "DELETAR_LOGS=N"
    if errorlevel 1 set "DELETAR_LOGS=S"
)
if /I "%DELETAR_LOGS%"=="S" (
    echo Deletando arquivos de log...
    del "%ARQUIVO_LOG_PASSAGEM%-0.log" 2>nul
    del "%ARQUIVO_LOG_PASSAGEM%-0.log.mbtree" 2>nul
    echo Logs deletados.
    call :LogEntry "[INFO] Logs 2-pass removidos."
) else (
    echo Logs mantidos: "%ARQUIVO_LOG_PASSAGEM%-0.log" e "%ARQUIVO_LOG_PASSAGEM%-0.log.mbtree"
    call :LogEntry "[INFO] Logs 2-pass mantidos."
)
exit /b 0

::=============================================================================
:: FIM DO SCRIPT
::=============================================================================
