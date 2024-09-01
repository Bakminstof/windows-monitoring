@ECHO off

:: Windows 10

@SET "ENCODING=65001"
@SET "CURRENT_DIR=%~dp0"
@SET "SCRIPT_NAME=Start monitoring"

:: ===Colors===
:: ==Normal foreground colors==
@SET "NF_BLACK=[30m"
@SET "NF_RED=[31m"
@SET "NF_GREEN=[32m"
@SET "NF_YELLOW=[33m"
@SET "NF_MAGENTA=[35m"
@SET "NF_CAYN=[36m"
@SET "NF_WHITE=[37m"

:: ==Strong foreground colors==
@SET "SF_RED=[91m"
@SET "SF_GREEN=[92m"
@SET "SF_YELLOW=[93m"
@SET "SF_CAYN=[96m"

:: ==Normal background colors==
@SET "NB_CAYN=[46m"
@SET "NB_WHITE=[47m"

:: ==Styles==
@SET "RESET=[0m"
@SET "BOLD=[1m"

:: ===Utils===
@SET "LINE_LENGTH=80"
@SET "LINE_SYMBOL=-"
@SET "BORDER=%NF_YELLOW%%NB_WHITE%#!%RESET%"

:: Pre start
CHCP %ENCODING% > nul

TITLE %SCRIPT_NAME%
:: Start
::==============================================================================================================
PUSHD %CURRENT_DIR%

@SET "ENV_FILE=%CURRENT_DIR%config.env"
@SET "COMPOSE_FILE=docker-compose.yaml"

CALL create-service.cmd -d
CALL create-containers.cmd -d

CALL :print %NF_CAYN% "Start Grafana and Prometheus containers" Print_border
CALL :run_command docker-compose --env-file "%ENV_FILE%" -f "%COMPOSE_FILE%" up -d

@ECHO %SF_CAYN%Windows exporter%RESET% %NF_GREEN%=^>%RESET% %NF_CAYN%http://localhost:9182/metrics%RESET%
@ECHO %SF_CAYN%Prometheus%RESET% %NF_GREEN%=^>%RESET% %NF_CAYN%http://localhost:9090/%RESET%
@ECHO %SF_CAYN%Grafana%RESET% %NF_GREEN%=^>%RESET% %NF_CAYN%http://localhost:3000/%RESET%

CALL :print %NF_BLACK%%NB_CAYN% " DONE "

IF [%~1] == [-d] (
  @EXIT /B 0
)  ELSE (
  PAUSE > nul
)

POPD
::==============================================================================================================
:: Stop

@EXIT /B 0

:: Functions
:print [color] [text] [if_border]
SETLOCAL
@SET "COLON=%SF_YELLOW%:%RESET%"

IF [%~3] == [] (
  @ECHO %~1%~2%RESET%
) ELSE (
  @ECHO %BORDER% %~1%~2%RESET%%COLON%
)

ENDLOCAL
goto :eof

:check_error_level
IF %ERRORLEVEL% == 0 (
  CALL :print %SF_GREEN% OK
) ELSE (
  CALL :print %SF_RED% Fail
)

goto :eof

:run_command [command]
%*

CALL :check_error_level

goto :eof

:run_command_with_echo [command]
@ECHO %NF_BLACK%%NB_WHITE%Run command:%RESET% %*

CALL :run_command %*

goto :eof

:run_command_with_line [command]
CALL :run_command %*
CALL :print_line

goto :eof

:print_line [length]
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

@SET "LINE=%LINE_SYMBOL%"

IF [%~1] == [] (
  @SET "LENGTH=%LINE_LENGTH%"
) ELSE (
  @SET "LENGTH=%~1"
)

FOR /L %%i in (1,1,%LENGTH%) DO (
  @SET LINE=!LINE!%LINE_SYMBOL%
)

CALL :print %SF_YELLOW% %LINE%

ENDLOCAL
goto :eof

:check_exists [file]

IF NOT EXIST %~1 (
  CALL :print %SF_RED% "Error. Не могу найти `%~1`"
  TIMEOUT /T 6 > nul
  @EXIT 1
)

goto :eof
