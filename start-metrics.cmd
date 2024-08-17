@ECHO off

:: Windows 10

@SET "ENCODING=65001"
@SET "CURRENT_DIR=%~dp0"
@SET "SCRIPT_NAME=Windows metrics"

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
@SET "BLACKBOX_EXPORTER_NAME=Blackbox exporter"
@SET "BLACKBOX_EXPORTER_DIR=%CURRENT_DIR%blackbox-exporter"

@SET "WINDOWS_EXPORTER_NAME=Windows exporter"
@SET "WINDOWS_EXPORTER_DIR=%CURRENT_DIR%windows-exporter"

PUSHD %CURRENT_DIR%

PUSHD %BLACKBOX_EXPORTER_DIR%
CALL :print %NF_CAYN% "Start %BLACKBOX_EXPORTER_NAME%" Print_border
CALL :run_command START "%BLACKBOX_EXPORTER_NAME%" "%BLACKBOX_EXPORTER_DIR%\blackbox_exporter.exe"
POPD

PUSHD %WINDOWS_EXPORTER_DIR%
CALL :print %NF_CAYN% "Start %WINDOWS_EXPORTER_NAME%" Print_border
CALL :run_command START "%WINDOWS_EXPORTER_NAME%" "%WINDOWS_EXPORTER_DIR%\windows_exporter-0.26.2-amd64.exe"
POPD

POPD
::==============================================================================================================
:: Stop

CALL :print %NF_BLACK%%NB_CAYN% " DONE "

TIMEOUT /T 10 > nul

@EXIT

:: Functions
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
