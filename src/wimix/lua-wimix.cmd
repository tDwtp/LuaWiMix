@ECHO OFF
SETLOCAL
CALL :TEST_ADMIN
IF ERRORLEVEL 1 IF NOT "%~2" == "CHECK" GOTO REQUEST_ADMIN

SET "NO_USAGE="
REM IF "%~1" == "HELP" SET "USAGE=%~1"

FOR %%V IN (51 52 53 HELP) DO IF /I "%1" == "%%V" CALL :DO_%*

IF /I "%1" == "?" GOTO USAGE
IF /I "%1" == "-?" GOTO USAGE
IF /I "%1" == "/?" GOTO USAGE
IF /I "%1" == "/h" GOTO USAGE
IF /I "%1" == "-h" GOTO USAGE
IF /I "%1" == "-help" GOTO USAGE
IF /I "%1" == "/help" GOTO USAGE
IF /I "%1" == "--help" GOTO USAGE

ENDLOCAL
GOTO END




REM DO :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:DO_51
SET "LV=51"
GOTO DO_
:DO_52
SET "LV=52"
GOTO DO_
:DO_53
SET "LV=53"
GOTO DO_


:DO_
FOR %%C IN (ADD REMOVE DEFAULT CHECK) DO IF /I "%1" == "%%C" CALL :DO_%*
GOTO END


:DO_DEFUALT
ECHO.Not implemented yet.
GOTO END


:DO_ADD
IF /I "%1" == "ROCKS" CALL :ADD_ROCKS
IF /I "%1" == "ROCKS" GOTO END

CALL :ADD_LUA
GOTO END


:DO_REMOVE
IF /I "%1" == "ROCKS" CALL :REMOVE_ROCKS
IF /I "%1" == "ROCKS" GOTO END

CALL :REMOVE_LUA
GOTO END




REM ADD ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:ADD_LUA
CALL :TEST_ADMIN
IF ERRORLEVEL 1 GOTO :ERROR_NO_ADMIN
CALL :TEST_LUA
IF NOT ERRORLEVEL 1 GOTO :ADD_LUA_VALID

CALL :REMOVE_LUA

MKDIR %~dp0\..\%LV%

%~dp0\iser\addLua.vbs %LV:~0,1% %LV:~-1%
IF ERRORLEVEL 1 GOTO :ADD_LUA_FAILED_UNZIPPING
%~dp0\iser\addEnv.vbs %LV:~0,1% %LV:~-1%
IF ERRORLEVEL 1 GOTO :ADD_LUA_FAILED_ENVIRONMENT
%~dp0\iser\addReg.vbs %LV:~0,1% %LV:~-1%
IF ERRORLEVEL 1 GOTO :ADD_LUA_FAILED_REGISTRY

PUSHD .
CD /D "%~dp0\..\%LV%"
%~dps0\iser\addPaths.vbs "%CD%"
POPD

GOTO END

:ADD_LUA_FAILED_UNZIPPING
ECHO.Error while unzipping Lua.
EXIT /B 1
:ADD_LUA_FAILED_ENVIRONMENT
ECHO.Error while adding Lua environment-variables.
EXIT /B 1
:ADD_LUA_FAILED_REGISTRY
ECHO.Error while adding Lua registry-entries.
EXIT /B 1

:ADD_LUA_VALID
ECHO.Lua %LV:~0,1%.%LV:~-1% is already installed.
GOTO END




:ADD_ROCKS
CALL :TEST_LUA
IF NOT ERRORLEVEL 1 GOTO ADD_ROCKS_HAVELUA
IF ERRORLEVEL 2 GOTO ADD_ROCKS_FAILED_INVALIDLUA
CALL :ADD_LUA

:ADD_ROCKS_HAVELUA
PUSHD .
CD /D "%~dp0\..\%LV%"
SET "LP=%CD%"
IF "%LP:~-1%" == "\" SET SET "LP=%LP:~0,-1%"
CD /D "%~dp0\iser\rocks"
"%~dp0\iser\rocks\win32\lua5.1\bin\lua5.1.exe" "%~dp0\iser\rocks\install.bat" "%~dp0\rocks\%LV%" ^
	/TREE "%~dp0\rocks\%LV%\tree" /CMOD "%LP%\clibs" /LUAMOD "%LP%\lua" /LV %LV:~0,1%.%LV:~-1% /LUA "%LP%" /MW /NOREG /Q
POPD
GOTO END

:ADD_ROCKS_FAILED_INVALIDLUA
IF NOT ERRORLEVEL 2 ECHO.Lua %LV:~0,1%.%LV:~-1% is an invalid installation.
GOTO END




REM REMOVE :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:REMOVE_LUA
CALL :TEST_ADMIN
IF ERRORLEVEL 1 GOTO :ERROR_NO_ADMIN

FOR /F %%# IN ('%~dp0\iser\findVer.vbs') IF "%%#" == "%LV%" GOTO REMOVE_LUA_FAILED_VERSIONISDEFAULT

%~dp0\iser\remReg.vbs %LV:~0,1% %LV:~-1%
IF ERRORLEVEL 1 CALL :REMOVE_LUA_FAILED_REGISTRY

%~dp0\iser\remEnv.vbs %LV:~0,1% %LV:~-1%
IF ERRORLEVEL 1 CALL :ADD_LUA_FAILED_ENVIRONMENT


CALL :TEST_LUA
IF NOT ERRORLEVEL 1 GOTO REMOVE_LUA_STEP
IF NOT ERRORLEVEL 2 GOTO REMOVE_LUA_FAILED_NOLUA
:REMOVE_LUA_STEP
PUSHD .
	CD /D "%~dp0\..\%LV%"
	%~dps0\iser\remPaths.vbs "%CD%"
POPD

%~dp0\iser\remLua.vbs %LV:~0,1% %LV:~-1%
IF ERRORLEVEL 1 GOTO ADD_LUA_FAILED_REMOVING

IF EXIST %~dp0\..\%LV% RMDIR /S /Q %~dp0\..\%LV%

GOTO END

:REMOVE_LUA_FAILED_VERSIONISDEFAULT
ECHO.Version %LV:~0,1%.%LV:~-1% cant be removed. It is set as default.
ECHO.Set another version as default to be able to remove this version.
EXIT /B 1
:REMOVE_LUA_FAILED_NOLUA
ECHO.Lua %LV:~0,1%.%LV:~-1% already removed.
GOTO END
:REMOVE_LUA_FAILED_REMOVING
ECHO.Error while removing Lua files and directories.
EXIT /B 1
:REMOVE_LUA_FAILED_ENVIRONMENT
ECHO.Environment variables could not be removed. This might be due to
ECHO.previous removal.
ECHO.To check whether the Environment variables are still set run
ECHO."%~n0 %LV% CHECK".
EXIT /B 1
:REMOVE_LUA_FAILED_REGISTRY
ECHO.Registry entries could not be removed. This might be due to
ECHO.previous removal.
ECHO.To check whether the registry entries still exist run
ECHO."%~n0 %LV% CHECK".
GOTO END



:REMOVE_ROCKS
CALL :TEST_ADMIN
IF ERRORLEVEL 1 GOTO :ERROR_NO_ADMIN


GOTO END


REM CHECK ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:DO_CHECK
ECHO.Errors (for Lua %LV:~0,1%.%LV:~-1%):
PUSHD .
CD /D %~dp0\..\
IF NOT EXIST %LV% (
	ECHO.No directory found for Lua version %LV~0,1%.%LV:~-1%
	POPD
	GOTO DO_CHECK_ENTRIES
)
CD %LV%
SET "INST_PATH=%CD%"
IF "%INST_PATH:~-1%" == "\" SET "INST_PATH=%CD%\"
POPD

FOR %%N IN (lib include lua clibs) DO IF NOT EXIST %INST_PATH%\%%N ECHO.missing folder "%%N"
FOR %%N IN (lua%LV%.exe wlua%LV%.exe luac%LV%.exe lib\lua%LV%.dll lib\liblua%LV%.a include\lauxlib.h include\lua.h include\lua.hpp include\lualib.h include\luaconf.h) DO IF NOT EXIST %INST_PATH%\%%N ECHO.missing file "%%N"

:DO_CHECK_ENTRIES
FOR %%# IN (".lua%LV% Lua%LV%.Script" ".luac%LV% Lua%LV%.Compiled" ".wlua%LV% wLua%LV%.Script") DO CALL :DO_CHECK_ASSOC %%~# "%%B" "%%C"
CALL :DO_CHECK_REG Lua%LV%.Script lua
CALL :DO_CHECK_REG Lua%LV%.Compiled luac
CALL :DO_CHECK_REG wLua%LV%.Script wlua

SET SUFFIX=_%LV:~0,1%_%LV:~-1%
IF %LV:~-1% == 1 SET SUFFIX=
IF NOT DEFINED LUA_CPATH%SUFFIX% ECHO.LUA_CPATH%SUFFIX% is not set
IF NOT DEFINED LUA_PATH%SUFFIX%  ECHO.LUA_PATH%SUFFIX% is not set
IF NOT DEFINED LUA_DEV_%LV:~0,1%_%LV:~-1% ECHO.LUA_DEV_%LV:~0,1%_%LV:~-1% is not set
GOTO END

:DO_CHECK_REG
REG QUERY HKCR\%1 1>NUL 2>&1
IF ERRORLEVEL 1 ECHO.no file-type entry for %1
REG QUERY HKCR\%1\DefaultIcon 1>NUL 2>&1
IF ERRORLEVEL 1 ECHO.no icon entry for %1
IF NOT ERRORLEVEL 1 FOR /F "SKIP=2 TOKENS=1,2,*" %%A IN ('REG QUERY HKCR\%1\DefaultIcon /ve') DO IF /I NOT "%%C" == "%~dp0icon\%2-file.ico" ECHO.invalid icon-location for %1
REG QUERY HKCR\%1\Shell\Open\Command 1>NUL 2>&1
IF ERRORLEVEL 1 ECHO.no open entry for %1
IF NOT ERRORLEVEL 1 FOR /F "SKIP=2 TOKENS=1,2,*" %%A IN ('REG QUERY HKCR\%1\Shell\Open\Command /ve') DO IF /I NOT "%%C" == ""%INST_PATH%\%2%LV%.exe" "%%1" %%*" ECHO.invalid open-command for %1
IF "%2" == "luac" GOTO END
REG QUERY HKCR\%1\Shell\Edit\Command 1>NUL 2>&1
IF NOT ERRORLEVEL 1 FOR /F "SKIP=2 TOKENS=1,2,*" %%A IN ('REG QUERY HKCR\%1\Shell\Edit\Command /ve') DO IF /I NOT "%%C" == ""%~dp0SciTE\SciTE.exe" "%%1"" ECHO.invalid edit-command for %1
IF ERRORLEVEL 1 ECHO.no edit entry for %1
GOTO END

:DO_CHECK_ASSOC
FOR /F "SKIP=2 TOKENS=1,2,*" %%A IN ('REG QUERY HKCR\%1 /ve') DO CALL :DO_CHECK_ASSOC_VALUES %1 %2 "%%B" "%%C"
GOTO END
:DO_CHECK_ASSOC_VALUES
IF NOT "%~3" == "REG_SZ" ECHO.invalid type for association "%~1"
IF NOT "%~4" == "%~2" ECHO.invalid association "%~1" ("%~2" excpected, got "%~4")
GOTO END




REM TEST :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:TEST_LUA
PUSHD .
CD /D %~dp0\..\
IF NOT EXIST %LV% POPD & EXIT /B 1
CD %LV%
SET "INST_PATH=%CD%"
IF NOT "%INST_PATH:~-1%" == "\" SET "INST_PATH=%CD%\"
POPD

IF NOT EXIST %INST_PATH%\lua%LV%.exe EXIT /B 2
IF NOT EXIST %INST_PATH%\wlua%LV%.exe EXIT /B 3
IF NOT EXIST %INST_PATH%\luac%LV%.exe EXIT /B 4
IF NOT EXIST %INST_PATH%\lib EXIT /B 5
IF NOT EXIST %INST_PATH%\lib\lua%LV%.dll EXIT /B 6
IF NOT EXIST %INST_PATH%\lib\liblua%LV%.a EXIT /B 7
IF NOT EXIST %INST_PATH%\lua EXIT /B 8
IF NOT EXIST %INST_PATH%\clibs EXIT /B 9
IF NOT EXIST %INST_PATH%\include EXIT /B 10
IF NOT EXIST %INST_PATH%\include\lauxlib.h EXIT /B 11
IF NOT EXIST %INST_PATH%\include\lua.h EXIT /B 12
IF NOT EXIST %INST_PATH%\include\lua.hpp EXIT /B 13
IF NOT EXIST %INST_PATH%\include\lualib.h EXIT /B 14
IF NOT EXIST %INST_PATH%\include\luaconf.h EXIT /B 15
EXIT /B 0


:TEST_ADMIN
fsutil file findbysid %USERNAME% %~dp0\arc 1>NUL 2>&1
EXIT /B %ERRORLEVEL%


:ERROR_NO_ADMIN
ECHO.You do not have administrator permissions.
GOTO END

:REQUEST_ADMIN
SET "ELEVATE="
ECHO.Call with administrator rights?
SET /P "ELEVATE=Any text will cancle the elevation: "
IF DEFINED ELEVATE EXIT /B 1

:REQUEST_ADMIN_TMP
SET TF=%TEMP%\lwm-%RANDOM%.bat
IF EXIST "%TF%" GOTO :REQUEST_ADMIN_TMP

ECHO @ECHO OFF> "%TF%"
ECHO CHDIR /D "%CD%">> "%TF%"
ECHO ECHO.%0 %*>> "%TF%"
ECHO CALL %0 %*>> "%TF%"
ECHO PAUSE>> "%TF%"
ECHO DEL "%TF%">> "%TF%"

PowerShell -Command (New-Object -com 'Shell.Application').ShellExecute('%TMPFILE%', '', '', 'runas', 5)
GOTO END




REM HELP :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:DO_HELP
IF "%~1" == "" GOTO :USAGE
FOR %%C IN (ADD REMOVE DEFAULT HELP) DO IF "%~1" == "%%C" GOTO :USAGE_%%C
ECHO.^! unknown help-command "%~1".

:USAGE
IF DEFINED USAGE GOTO USAGE_%USAGE%
ECHO.Usage: %~n0 ^<Lua-version^> [ADD^|REMOVE^|DEFAULT^|CHECK^|HELP] [ROCKS]
ECHO.
ECHO.  Lua-version   The Lua-version to apply commands to.
ECHO.
ECHO.  ADD       Add the Lua-version or its LuaRocks.
ECHO.            If LuaRocks should be installed, but Lua is not,
ECHO.            Lua will be installed silently before its LuaRocks.
ECHO.  REMOVE    Remove the Lua-version or just its LuaRocks.
ECHO.            Removing the Lua-version will remove its LuaRocks as well.
ECHO.  DEFAULT   Set the Lua-version as default.
ECHO.  CHECK     Print all errors with the installation of the Lua-version.
ECHO.  HELP      Show this command-description or the one for a specific command.
ECHO.
ECHO.
ECHO.NOTE: All commands (ADD, REMOVE, DEFAULT, CHECK, HELP) are case-insensitive.
ECHO.      The switch ROCKS is also case-insensitive.
ECHO.      DEFAULT and CHECK do not care about the ROCKS switch
ECHO.
ENDLOCAL
GOTO END

:USAGE_ADD
ECHO.Usage: %~n0 [51^|52^|53] ADD {ROCKS}
ECHO.
ECHO.  Add the Lua-version or its LuaRocks.
ECHO.
ECHO.  ROCKS     Will install LuaRocks to the Lua-version.
ECHO.            If LuaRocks should be installed, but Lua is not,
ECHO.            Lua will be installed silently before its LuaRocks.
ECHO.
ECHO.NOTE: All commands (ADD, REMOVE, DEFAULT, CHECK, HELP) are case-insensitive.
ECHO.      The switch ROCKS is also case-insensitive.
ECHO.
ENDLOCAL
GOTO END

:USAGE_REMOVE
ECHO.Usage: %~n0 [51^|52^|53] REMOVE {ROCKS}
ECHO.
ECHO.  Remove the Lua-version.
ECHO.  Removing the Lua-version will remove its LuaRocks as well.
ECHO.
ECHO.  ROCKS     Will just remove the Lua-version's LuaRocks.
ECHO.
ECHO.NOTE: All commands (ADD, REMOVE, DEFAULT, CHECK, HELP) are case-insensitive.
ECHO.      The switch ROCKS is also case-insensitive.
ECHO.
ENDLOCAL
GOTO END

:USAGE_DEFAULT
ECHO.Usage: %~n0 [51^|52^|53] DEFAULT
ECHO.
ECHO.  Set the Lua-version as default. This will modify findVer.vbs
ECHO.
ECHO.NOTE: All commands (ADD, REMOVE, DEFAULT, CHECK, HELP) are case-insensitive.
ECHO.
ENDLOCAL
GOTO END

:USAGE_CHECK
ECHO.Usage: %~n0 [51^|52^|53] CHECK
ECHO.
ECHO.  This command will only display errors!
ECHO.  It will check the Lua-versions folder for the default/minimal structure
ECHO.  as well as the registry entries and environment variables.
ECHO.
ECHO.NOTE: All commands (ADD, REMOVE, DEFAULT, CHECK, HELP) are case-insensitive.
ECHO.
ENDLOCAL
GOTO END

:USAGE_HELP
ECHO.Usage: %~n0 HELP {[ADD^|REMOVE^|DEFUALT^|HELP]}
ECHO.
ECHO.  ADD       show the command-description for adding a version.
ECHO.  REMOVE    show the command-description for removing a version.
ECHO.  DEFAULT   show the command-description for setting the default version.
ECHO.  CHECK     show the command-description for checking a version.
ECHO.  HELP      show this command-description.
ECHO.
ECHO.NOTE: All commands (ADD, REMOVE, DEFAULT, CHECK, HELP) are case-insensitive.
ECHO.
ENDLOCAL
GOTO END

:ABORT
ENDLOCAL
EXIT /B %1

:END