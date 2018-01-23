@ECHO OFF
SETLOCAL
NET SESSION >NUL 2>&1
IF ERRORLEVEL 1 GOTO REQUEST_ADMIN

SET "NO_USAGE="
REM IF "%~1" == "HELP" SET "USAGE=%~1"
FOR %%C IN (ADD REMOVE DEFAULT HELP) DO IF /I "%1" == "%%C" CALL :DO_%*
IF ERRORLEVEL 1 IF NOT DEFINED NO_USAGE GOTO USAGE

ENDLOCAL
GOTO END

:DO_DEFUALT
ECHO.Not implemented yet.
GOTO END

:DO_ADD
IF /I "%1" == "ROCKS" CALL :DO_ADD_%*
IF /I "%1" == "ROCKS" GOTO END

IF "%1" == "x86" CALL :ADD_%*
IF "%1" == "x86" GOTO END

IF "%1" == "amd64" CALL :ADD_%*
IF "%1" == "amd64" GOTO END

CALL :ADD_x86 %*
GOTO END

:ADD_x86
IF EXIST "%~dps0\..\%2" GOTO DO_APPLY
IF NOT EXIST "%~dps0\arc\bin%2x86.zip" GOTO ERROR_VERSION_UNAVAILABLE
IF NOT EXIST "%~dps0\arc\lib%2x86.zip" GOTO ERROR_VERSION_CORRUPT
PUSHD .
CD /D "%~dp0\..\"
MKDIR %2

POPD
:ADD_APPLY
PUSHD .
CD /D "%~dp0\..\"
%~dps0\iser\addPaths.vbs "%CD%"
POPD
GOTO END

:DO_ADD_ROCKS
IF EXIST "%~dps0\..\%3" GOTO DO_APPLY
IF NOT EXIST "%~dps0\arc\bin%3x86.zip" GOTO VERSION_UNAVAILABLE
GOTO END

:DO_REMOVE
IF /I "%1" == "ROCKS" CALL DO_REMOVE_%*
IF /I "%1" == "ROCKS" GOTO END

ECHO.Not implemented yet.
GOTO END

:DO_REMOVE_ROCKS
ECHO.Not implemented yet.
GOTO END



:ERROR_VERSION_CORRUPT
ECHO.%2 is not corrupted. (could not find "lib%2x86.zip")
GOTO END


:ERROR_VERSION_UNAVAILABLE
ECHO.%2 is not available. (could not find "bin%2x86.zip")
GOTO END

:ERROR_REQUEST_ADMIN
ECHO.You do not have administrator permissions.
ECHO.Elevate?
GOTO END



:DO_HELP
IF "%~1" == "" GOTO :USAGE
FOR %%C IN (ADD REMOVE DEFAULT HELP) DO IF "%~1" == "%%C" GOTO :USAGE_%%C
ECHO.^! unknown help-command "%~1".

:USAGE
IF DEFINED USAGE GOTO USAGE_%USAGE%
ECHO.Usage: %~n0 [ADD^|REMOVE^|DEFAULT^|HELP] [options...]
ECHO.
ECHO.  ADD       add a Lua-version or a LuaRocks to a version.
ECHO.  REMOVE    remove a Lua-version or a LuaRocks to a version.
ECHO.  DEFAULT   set the default Lua-version.
ECHO.  HELP      show this command-description or the one for a specific command
ECHO.
ECHO.NOTE: All commands (ADD, REMOVE, DEFAULT, HELP) are case-insensitive.
ECHO.      The switch ROCKS is also case-insensitive.
ECHO.
ENDLOCAL
GOTO END

:USAGE_ADD
ECHO.Usage: %~n0 ADD {ROCKS} [51^|52^|53] {[x86^|amd64]}
ECHO.
ECHO.
ECHO.
ECHO.NOTE: All commands (ADD, REMOVE, DEFAULT, HELP) are case-insensitive.
ECHO.
ENDLOCAL
GOTO END

:USAGE_REMOVE
ECHO.Usage: %~n0 REMOVE
ENDLOCAL
GOTO END

:USAGE_DEFAULT
ECHO.Usage: %~n0 DEFAULT {^<architecture^>} ^<version^> {^<architecture^>}
ECHO.architecture: [x86^|amd64]
ECHO.version: [51^|52^|53]
ECHO.the version can only be either preceded or followed by the architecture
ECHO.
ECHO.  version   if preceded by an architecture:
ECHO.             -^> set the default architecture of the specified version
ECHO.            if followed by an architecture:
ECHO.             -^> set the default architecture of the specified version
ECHO.            
FOR %%V IN (51 52 53) DO (
ECHO.  %%V    if preceded by 'x86' or 'amd64'
ECHO.          set the architecture for version %%V.
	ECHO.        if not preceded by any architecture, set the default version to %%V.
)
ECHO.
ECHO.NOTE: All commands (ADD, REMOVE, DEFAULT, HELP) are case-insensitive.
ECHO.
ENDLOCAL
GOTO END

:USAGE_HELP
ECHO.Usage: %~n0 HELP {[ADD^|REMOVE^|DEFUALT^|HELP]}
ECHO.
ECHO.  ADD       show the command-description for adding a version.
ECHO.  REMOVE    show the command-description for removing a version.
ECHO.  DEFAULT   show the command-description for setting the default version.
ECHO.  HELP      show this command-description.
ECHO.
ECHO.NOTE: All commands (ADD, REMOVE, DEFAULT, HELP) are case-insensitive.
ECHO.
ENDLOCAL
GOTO END

:END