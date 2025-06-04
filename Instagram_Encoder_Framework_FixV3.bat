@echo on
setlocal enabledelayedexpansion

:: ----------------------------------------------------------------------------
:: Instagram_Encoder_Framework_FullFixV2.bat
:: Versao: 1.2
:: Descricao: Framework para codificar em H.264 (Two-Pass ou CRF) para Instagram,
:: com parametros de Hollywood e compatibilidade maxima.
:: Autor:    Gabriel Schoenardie
:: Data:     Junho/2025
:: ----------------------------------------------------------------------------

::-----------------------------
:: 1. Definicoes Iniciais
::-----------------------------
title Instagram Encoder Framework - Nivel Hollywood/Instagram (FullFixV2)

:: Variavel para registrar o log de execucao (nome gerado na primeira chamada)
set "EXEC_LOG="

:: Registra linha de inicio no arquivo de log
call :LogEntry "===== INICIO DE EXECUCAO (%date% %time%) ====="

::-----------------------------
:: 2. Checar Existencia do FFmpeg
::-----------------------------
call :CheckFFmpeg
if errorlevel 1 (
    call :LogEntry "[ERRO] FFmpeg nao encontrado. Abortando."
    goto :EOF
)
call :LogEntry "[OK] FFmpeg localizado: !FFMPEG_CMD!"

::-----------------------------
:: 3. Obter Arquivo de Entrada
::-----------------------------
call :GetInputFile
call :LogEntry "[OK] Arquivo de entrada: !ARQUIVO_ENTRADA!"

::-----------------------------
:: 4. Obter Arquivo de Saida
::-----------------------------
call :GetOutputFile
call :LogEntry "[OK] Arquivo de saida definido: !ARQUIVO_SAIDA!"

::-----------------------------
:: 5. Escolher Resolucao/Proporcao (9:16 ou 16:9)
::-----------------------------
call :GetResolution
call :LogEntry "[OK] Resolucao escolhida: !VIDEO_ESCALA!"

::-----------------------------
:: 6. Escolher Modo de Encoding (2PASS ou CRF)
::-----------------------------
echo DEBUG: Antes de chamar :GetEncodingMode
pause
call :GetEncodingMode
echo DEBUG: Retornou de :GetEncodingMode. ENCODE_MODE aqui e [%ENCODE_MODE%]
pause

echo DEBUG: Antes de chamar :LogEntry para modo de encoding
pause
call :LogEntry "[OK] Modo de encoding escolhido: !ENCODE_MODE!"
echo DEBUG: Retornou de :LogEntry para modo de encoding
pause

::-----------------------------
:: 7. Configurar Parametros Avancados
::-----------------------------
echo DEBUG: Antes de chamar :GetAdvancedParams
pause
call :GetAdvancedParams
echo DEBUG: Retornou de :GetAdvancedParams (se nao houve erro dentro dela)
pause
if errorlevel 1 (
    call :LogEntry "[ERRO] Falha em GetAdvancedParams. Abortando."
    goto :EOF
)
call :LogEntry "[OK] Parametros avancados capturados."

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
:: 10. Mensagem de Conclusao
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
::   Cria ou anexa ao arquivo de log de execucao. Na primeira chamada, gera
::   o nome do arquivo com data e hora. Cada linha de log gravada nele.
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
::   Verifica se o comando ffmpeg esta no PATH. Caso contrario, pede o
::   caminho completo para o executavel. Se nao existir, sai com errorlevel=1.
::-----------------------------------------------------------------------------
:CheckFFmpeg
set "FFMPEG_CMD=ffmpeg"
%FFMPEG_CMD% -version >nul 2>&1
if errorlevel 1 (
    echo.
    echo === ATENCAO: ffmpeg nao encontrado no PATH. ===
    :loop_ffmpeg
    set /p "FFMPEG_CMD_PATH=Digite o caminho completo do ffmpeg.exe: "
    if "%FFMPEG_CMD_PATH%"=="" (
        echo === ERRO: Caminho nao pode ser vazio. Tente novamente. ===
        goto loop_ffmpeg
    )
    if not exist "%FFMPEG_CMD_PATH%" (
        echo === ERRO: Caminho do ffmpeg.exe invalido! Tente novamente. ===
        goto loop_ffmpeg
    )
    set "FFMPEG_CMD=%FFMPEG_CMD_PATH%"
)
exit /b 0

::-----------------------------------------------------------------------------
:: :GetInputFile
::   Pergunta pelo arquivo de entrada um nome valido seja digitado.
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
::   Pergunta pelo nome do arquivo de saida (forcando .mp4 se faltar) e
::   em caso de existir, pergunta se deve sobrescrever. Tambem extrai nome-base
::   para ser usado nos logs de 2PASS.
::-----------------------------------------------------------------------------
:GetOutputFile
:loop_output
set "ARQUIVO_SAIDA="
set /p "ARQUIVO_SAIDA=Digite o nome desejado para o arquivo de saida (ex: video_instagram.mp4): "
if "%ARQUIVO_SAIDA%"=="" (
    echo === ERRO: Nome do arquivo de saida nao pode ser vazio! Tente novamente. ===
    goto loop_output
)
:: Garante extensao .mp4
if /I not "%ARQUIVO_SAIDA:~-4%"==".mp4" (
    set "ARQUIVO_SAIDA=%ARQUIVO_SAIDA%.mp4"
)
:: Se ja existir no disco, confirmar sobrescrita
if exist "%ARQUIVO_SAIDA%" (
    set "RESPOSTA="
    where choice >nul 2>&1
    if errorlevel 1 (
        set /p "RESPOSTA=Arquivo '%ARQUIVO_SAIDA%' ja existe. Deseja sobrescrever? (S/N): "
        set "RESPOSTA=%RESPOSTA:~0,1%"
    ) else (
        choice /C SN /M "Arquivo '%ARQUIVO_SAIDA%' ja existe. Deseja sobrescrever? [S/N]"
        if errorlevel 2 set "RESPOSTA=N"
        if errorlevel 1 set "RESPOSTA=S"
    )
    if /I not "%RESPOSTA%"=="S" (
        echo Informe outro nome de saida.
        goto loop_output
    )
)
:: Extrair nome-base (sem extensao) para prefixo de logs de 2PASS
for %%A in ("%ARQUIVO_SAIDA%") do set "NOME_BASE_SAIDA=%%~nA"
set "ARQUIVO_LOG_PASSAGEM=%NOME_BASE_SAIDA%_ffmpeg_passlog"
exit /b 0

::-----------------------------------------------------------------------------
:: :GetResolution
::   Pergunta se o usuario quer vertical (1080x1920) ou horizontal (1920x1080).
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
    echo === ERRO: Opcao invalida. Digite 1 ou 2. ===
    goto loop_resolution
)
exit /b 0

::-----------------------------------------------------------------------------
:: :GetEncodingMode
::   Pergunta se o usuario quer codificar em Two-Pass (2PASS) ou CRF (CRF).
::-----------------------------------------------------------------------------
:GetEncodingMode
echo DEBUG: Entrou em :GetEncodingMode
pause
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
    echo === ERRO: Opcao invalida. Digite 'D' ou 'C'. ===
    goto loop_enc_mode
)
echo DEBUG: :GetEncodingMode vai sair. ENCODE_MODE = [%ENCODE_MODE%]
pause
exit /b 0

::-----------------------------------------------------------------------------
:GetAdvancedParams
echo DEBUG: Entrou no INICIO de :GetAdvancedParams. ENCODE_MODE = [%ENCODE_MODE%]
pause

::   Coleta todos os parametros avancados, aceitando ENTER para padrao,
::   sem jamais encerrar o .bat antes do esperado.
::   1) Preset x264
::   2) Bitrate de Audio
::   3) Se modo=2PASS:
::        - Bitrate de Video Alvo
::        - Bitrate de Video Maximo
::        - Bufsize VBV
::   4) Se modo=CRF:
::        - Valor de CRF (0-30)
::   Ao final, exibe resumo e faz pause.
::-----------------------------------------------------------------------------

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

::--- 2) Bitrate de Audio
set "BITRATE_AUDIO_PADRAO=192k"
set "BITRATE_AUDIO_ESCOLHIDO="
set /p "BITRATE_AUDIO_ESCOLHIDO=Bitrate de Audio (ex: 128k, 192k, 256k) [%BITRATE_AUDIO_PADRAO%]: "
if "%BITRATE_AUDIO_ESCOLHIDO%"=="" set "BITRATE_AUDIO_ESCOLHIDO=%BITRATE_AUDIO_PADRAO%"

echo DEBUG: Verificando ENCODE_MODE ANTES do IF principal em GetAdvancedParams. Valor: [%ENCODE_MODE%]
pause

REM ### ESTRUTURA IF SIMPLIFICAD COM GOTO ###
if /I "%ENCODE_MODE%"=="2PASS" goto :Process2PASS_Params
if /I "%ENCODE_MODE%"=="CRF" goto :ProcessCRF_Params

REM Se nao for nem 2PASS NEM CRF (improvavel, mas como fallback)
echo ERRO FATAL: MODO DE ENCODING DESCONHECIDO: [%ENCODE_MODE%]
pause
goto :ShowSummary_GetAdvancedParams :: Ou talvez um goto :EOF para sair com erro

:Process2PASS_Params
    echo DEBUG: Entrou em :Process2PASS_Params.
    pause

    ::--- 3) inicio do Bloco 2PASS ---
    echo DEBUG: Adicionando Prompt para Bitrate de Video Alvo...
    pause
    :: 3.1) Bitrate de Video Alvo
    set "BITRATE_VIDEO_ALVO_PADRAO=15M"
    set "BITRATE_VIDEO_ALVO_ESCOLHIDO="
    set /p "BITRATE_VIDEO_ALVO_ESCOLHIDO=Bitrate de Video Alvo (ex: 10M, 15M) [%BITRATE_VIDEO_ALVO_PADRAO%]: "
    if "%BITRATE_VIDEO_ALVO_ESCOLHIDO%"=="" set "BITRATE_VIDEO_ALVO_ESCOLHIDO=!BITRATE_VIDEO_ALVO_PADRAO!"
    echo DEBUG: BITRATE_VIDEO_ALVO_ESCOLHIDO = [!BITRATE_VIDEO_ALVO_ESCOLHIDO!]
    pause

   :: 3.2) Bitrate de Video Maximo
    set "BITRATE_VIDEO_MAX_PADRAO=25M"
    set "BITRATE_VIDEO_MAX_ESCOLHIDO="
    set /p "BITRATE_VIDEO_MAX_ESCOLHIDO=Bitrate de Video Maximo (ex: 20M, 25M) [%BITRATE_VIDEO_MAX_PADRAO%]: "
    if "%BITRATE_VIDEO_MAX_ESCOLHIDO%"=="" set "BITRATE_VIDEO_MAX_ESCOLHIDO=!BITRATE_VIDEO_MAX_PADRAO!"
    echo DEBUG: BITRATE_VIDEO_MAX_ESCOLHIDO = [!BITRATE_VIDEO_MAX_ESCOLHIDO!]
    pause

   :: 3.3) Bufsize VBV
    set "BUFSIZE_VIDEO_PADRAO=30M"
    set "BUFSIZE_VIDEO_ESCOLHIDO="
    set /p "BUFSIZE_VIDEO_ESCOLHIDO=Bufsize de Video (ex: 20M, 30M, 40M) [%BUFSIZE_VIDEO_PADRAO%]: "
    if "%BUFSIZE_VIDEO_ESCOLHIDO%"=="" set "BUFSIZE_VIDEO_ESCOLHIDO=!BUFSIZE_VIDEO_PADRAO!"
    echo DEBUG: BUFSIZE_VIDEO_ESCOLHIDO = [!BUFSIZE_VIDEO_ESCOLHIDO!]

    echo DEBUG: Fim das perguntas do 2PASS. Saltando para o resumo.
    pause
    goto :ShowSummary_GetAdvancedParams
    ::--- fim do Bloco 2PASS ---

:ProcessCRF_Params
    echo DEBUG: Entrou em :ProcessCRF_Params.
    pause
    ::
    ::--- 4) Modo CRF: solicitar CRF entre 0 e 30
    ::
    set "CRF_PADRAO=18"
    set "CRF_ESCOLHIDO="
:loop_crf
    set /p "CRF_ESCOLHIDO=Qual CRF usar (0-30) [%CRF_PADRAO%]: "
    if "%CRF_ESCOLHIDO%"=="" set "CRF_ESCOLHIDO=%CRF_PADRAO%"

    :: remove espacos em branco
    set "CRF_ESCOLHIDO=%CRF_ESCOLHIDO: =%"

    :: garante que ha apenas digitos
    echo %CRF_ESCOLHIDO% | findstr /R "^[0-9][0-9]*$" >nul
    if errorlevel 1 (
        echo === ERRO: Valor de CRF invalido. Digite apenas numeros. ===
        goto loop_crf
    )

    :: verifica se e numero inteiro
    set /a CRF_TEST=%CRF_ESCOLHIDO% >nul 2>&1
    if errorlevel 1 (
        echo === ERRO: Valor de CRF invalido. Digite um numero inteiro de 0 a 30. ===
        goto loop_crf
    )

    if %CRF_ESCOLHIDO% LSS 0 (
        echo === ERRO: CRF nao pode ser menor que 0. Tente novamente. ===
        goto loop_crf
    )
    if %CRF_ESCOLHIDO% GTR 30 (
        echo === ERRO: CRF nao pode ser maior que 30. Tente novamente. ===
        goto loop_crf
    )

    echo CRF valido escolhido: %CRF_ESCOLHIDO%
    goto :ShowSummary_GetAdvancedParams

    ::--- fim do Bloco CRF ---

:ShowSummary_GetAdvancedParams
::--- 5) Mostrar resumo dos parametros e aguardar ENTER
echo.
echo DEBUG: Chegou ao ponto de mostrar o resumo.
pause
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
echo Pressione qualquer tecla para continuar com a codificacao...
pause >nul
exit /b 0

::-----------------------------------------------------------------------------
:: :EncodeTwoPass
::   Realiza a codificacao em duas passagens (2PASS), gerando logs em
::   !ARQUIVO_LOG_PASSAGEM!-0.log e -0.log.mbtree.
::-----------------------------------------------------------------------------
:EncodeTwoPass
echo.
echo ===================   INICIANDO PASSAGEM 1 (ANALISE)   ===================
echo (Gerando arquivos de log para a segunda passagem)
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

call :LogEntry "[OK] Codificaco 2-pass concluida."
exit /b 0

::-----------------------------------------------------------------------------
:: :EncodeCRF
::   Realiza codificacao em modo CRF (single-pass), gerando o arquivo final.
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

call :LogEntry "[OK] Codificacao CRF concluida."
exit /b 0

::-----------------------------------------------------------------------------
:: :CleanupLogs
::   Pergunta se o usuario deseja excluir os arquivos de log gerados no 2PASS.
::-----------------------------------------------------------------------------
:CleanupLogs
echo.
echo =========================================================================
echo Deseja deletar os arquivos de log da codificacao 2-pass?
echo   (%ARQUIVO_LOG_PASSAGEM%-0.log, %ARQUIVO_LOG_PASSAGEM%-0.log.mbtree)
echo =========================================================================
set "DELETAR_LOGS=N" :: Define um padrao seguro inicial

where choice >nul 2>&1
if errorlevel 1 (
    echo DEBUG: choice.exe nao encontrado, usando set /p.
    set /p "RESPOSTA_USUARIO=Digite S para sim ou N para nao (padrao N):"
    if /I "%RESPOSTA_USUARIO:~0,1%"=="S" (
        set "DELETAR_LOGS=S"
    ) else (
        set "DELETAR_LOGS=N" :: Garante N se nao for S, ou se for vazio (ja que o padrao e N)
    )
) else (
    echo DEBUG: Usando choice.exe
    choice /C SN /N /M "Deseja deletar os arquivos de log? [S/N]"
    REM /N oculta as opcoes [S,N]? no final do prompt choice
    REM E crucial vereficar os errorlevels do MAIOR para o MENOR,
    REM ou usar IF DEFINED ERRORLEVEL_X ELSE IF DEFINED ERRORLEVEL_Y que e mais robusto,
    REM mas para este caso simples, vamos apenas ajustar a ordem e a lógica.

    if errorlevel 2 (
        REM Errorlevel 2 significa que a SEGUNDA opcao (/C SN -> N) foi escolhida.
        echo DEBUG: Choice - Opcao N detectada.
        set "DELETAR_LOGS=N"
    ) else (
        REM Se nao for errorlevel 2 (ou maior), so pode ser errorlevel 1
        REM (PRIMEIRA opcao /C SN -> S) ou 0 (Ctrl+C, que manteria o padrao N)
        echo DEBUG: Choice - Opcao S detectada.
        set "DELETAR_LOGS=S"
    )
)

echo DEBUG: DELETAR_LOGS defenido como: [!DELETAR_LOGS!]
pause :: Pause para depuracao

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