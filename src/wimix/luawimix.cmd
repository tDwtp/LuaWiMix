@ECHO OFF
SETLOCAL
IF "%~1" == "" GOTO END
IF "%~2" == "" GOTO END

REM luamiwi
REM   add
REM     rocks 5 ?
REM     lua 5 ?
REM   remove
REM     rocks 5 ?
REM     lua 5 ?
REM   get

SET "MAJOR=%~1"
SET "MINOR=%~2"

SET /A PROXYMAJOR=%MAJOR%
IF ERRORLEVEL 1 GOTO NAN
SET /A PROXYMINOR=%MINOR%
IF ERRORLEVEL 1 GOTO NAN
IF NOT "%MAJOR%" == "%PROXYMAJOR%" GOTO NAN
IF NOT "%MINOR%" == "%PROXYMINOR%" GOTO NAN


:REMOVE
IF NOT EXIST "%LUA_MIWI%\%MAJOR%%MINOR%" GOTO NOT_INSTALLED

REM require admin rights
NET SESSION 1>NUL 2>&1
IF NOT ERRORLEVEL 1 GOTO ADMIN
	REM try to elevate
	VER>NUL
	PowerShell /? 1>NUL 2>&1
	IF ERRORLEVEL 1 GOTO NO_ADMIN
	ECHO.You get eleveated
	ENDLOCAL
	PowerShell -Command (New-Object -com 'Shell.Application').ShellExecute('cmd.exe', '/c %~fs0 %*', '', 'runas')
	GOTO END
:ADMIN

FOR %%# IN (luarocks.cmd) DO SET "MIWI_DIR=%%~dp$PATH:#"
"%MIWI_DIR%\install\install.bat /P "%MIWI_DIR%\rocks\%MAJOR%%MINOR%\" /TREE "%MIWI_DIR%\rocks\%MAJOR%%MINOR%\tree" /LUA "%LUA_MIWI%\%MAJOR%%MINOR%" /MW /CMOD "%LUA_MIWI%\%major%%minor%\clibs" /LUAMOD $\"%LUA_MIWI%\%MAJOR%%MINOR%\lua"

GOTO ENDLOC

:NO_ADMIN
ECHO.You need administrator right to run this installation
GOTO ENDLOC

:NAN
ECHO.Only numerical parameters are allowed
GOTO ENDLOC

:NOT_INSTALLED
ECHO.This Lua version (%MAJOR%.%MINOR%) is not installed

:ENDLOC
ENDLOCAL
:END