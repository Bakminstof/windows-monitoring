@ECHO off

:: Windows 10

@SET "ENCODING=65001"
@SET "CURRENT_DIR=%~dp0"
@SET "SCRIPT_NAME=Start Grafana and Prometheus containers"

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
@SET "DOCKER_NAME=docker-compose"

CALL :check_exsist %DOCKER_NAME%

PUSHD %CURRENT_DIR%

CALL :print %NF_CAYN% "Start Grafana and Prometheus containers" Print_border
CALL :run_command %DOCKER_NAME% --env-file %CURRENT_DIR%config.env -f docker-compose.yaml up -d

POPD
::==============================================================================================================
:: Stop
CALL :print %NF_BLACK%%NB_CAYN% " DONE "

TIMEOUT /T 10 > nul

@EXIT

:: Functions
:: Check util exists
:check_exsist [util_name]
WHERE %~1

IF NOT %ERRORLEVEL% == 0 (
  CALL :print %SF_RED% "Util: %~1 not found"

  TIMEOUT /T 12 > nul

  @EXIT 1
)

goto :eof

:: Displaying colored text
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

:: Running the received command
:run_command [command]
%*

IF %ERRORLEVEL% == 0 (
  CALL :print %SF_GREEN% OK
) ELSE (
  CALL :print %SF_RED% Fail
)

CALL :print_line
goto :eof

:: Displaying a line of the specified length
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
