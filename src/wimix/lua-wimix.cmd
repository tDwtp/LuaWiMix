@ECHO OFF
SETLOCAL
NET SESSION >NUL 2>&1
IF ERRORLEVEL 1 GOTO REQUEST_ADMIN

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
GOTO CHECK_DO
:DO_52
SET "LV=52"
GOTO CHECK_DO
:DO_53
SET "LV=53"
GOTO CHECK_DO


:CHECK_DO
FOR %%C IN (ADD REMOVE DEFAULT) DO IF /I "%1" == "%%C" CALL :DO_%*
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
CALL :CHECK_ADMIN
IF ERRORLEVEL 1 GOTO :ERROR_NO_ADMIN
CALL :CHECK_LUA
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
CALL :CHECK_LUA
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
CALL :CHECK_ADMIN
IF ERRORLEVEL 1 GOTO :ERROR_NO_ADMIN

PUSHD .
CD /D "%~dp0\..\%LV%"
%~dps0\iser\addPaths.vbs "%CD%"
POPD

%~dp0\iser\remReg.vbs %LV:~0,1% %LV:~-1%
IF ERRORLEVEL 1 CALL :REMOVE_LUA_FAILED_REGISTRY

%~dp0\iser\remEnv.vbs %LV:~0,1% %LV:~-1%
IF ERRORLEVEL 1 CALL :ADD_LUA_FAILED_ENVIRONMENT


CALL :CHECK_LUA
IF NOT ERRORLEVEL 1 GOTO :REMOVE_LUA_STEP
IF NOT ERRORLEVEL 2 GOTO :REMOVE_LUA_NOLUA
:REMOVE_LUA_STEP
%~dp0\iser\remLua.vbs %LV:~0,1% %LV:~-1%
IF ERRORLEVEL 1 GOTO :ADD_LUA_FAILED_REMOVING

IF EXIST %~dp0\..\%LV% RMDIR /S /Q %~dp0\..\%LV%

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


REM CHECK ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:CHECK_LUA
PUSHD .
CD /C %~dp0\..\
IF NOT EXIST %LV% POPD & EXIT /B 1
CD %LV%
SET "INST_PATH=%CD%"
IF NOT "%INST_PATH:~-1%" == "\" SET "INST_PATH=%CD%\"
POPD

IF NOT EXIST %INST_PATH%\lua%LV%.exe EXIT /B 2
IF NOT EXIST %INST_PATH%\wlua%LV%.exe EXIT /B 3
IF NOT EXIST %INST_PATH%\luac%LV%.exe EXIT /B 4
IF NOT EXIST %INST_PATH%\lib EXIT /B 5
IF NOT EXIST %INST_PATH%\lib\lib%LV%.dll EXIT /B 6
IF NOT EXIST %INST_PATH%\lib\lib%LV%.a EXIT /B 7
IF NOT EXIST %INST_PATH%\lua EXIT /B 8
IF NOT EXIST %INST_PATH%\clibs EXIT /B EXIT /B 9
IF NOT EXIST %INST_PATH%\include EXIT /B 10
IF NOT EXIST %INST_PATH%\include\lauxlib.h EXIT /B 11
IF NOT EXIST %INST_PATH%\include\lua.h EXIT /B 12
IF NOT EXIST %INST_PATH%\include\lua.hpp EXIT /B 13
IF NOT EXIST %INST_PATH%\include\lualib.h EXIT /B 14
IF NOT EXIST %INST_PATH%\include\luaconf.h EXIT /B 15
EXIT /B 0


:CHECK_ADMIN
fsutil file findbysid %USERNAME% %~dp0\arc
EXIT /B %ERRORLEVEL%


:ERROR_NO_ADMIN
ECHO.You do not have administrator permissions.
ECHO.Elevate? (currently not available)
GOTO END

:DO_REMOVE
IF /I "%1" == "ROCKS" CALL REMOVE_%*
IF /I "%1" == "ROCKS" GOTO END

CALL :REMOVE_LUA
GOTO END

:REMOVE_ROCKS
ECHO.Not implemented yet.
GOTO END

:REMOVE_LUA




REM HELP :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:DO_HELP
IF "%~1" == "" GOTO :USAGE
FOR %%C IN (ADD REMOVE DEFAULT HELP) DO IF "%~1" == "%%C" GOTO :USAGE_%%C
ECHO.^! unknown help-command "%~1".

:USAGE
IF DEFINED USAGE GOTO USAGE_%USAGE%
ECHO.Usage: %~n0 ^<Lua-version^> [ADD^|REMOVE^|DEFAULT^|HELP] [ROCKS]
ECHO.
ECHO.  Lua-version   The Lua-version to apply commands to.
ECHO.
ECHO.  ADD       Add the Lua-version or its LuaRocks.
ECHO.            If LuaRocks should be installed, but Lua is not,
ECHO.            Lua will be installed silently before its LuaRocks.
ECHO.  REMOVE    Remove the Lua-version or just its LuaRocks.
ECHO.            Removing the Lua-version will remove its LuaRocks as well.
ECHO.  DEFAULT   Set the Lua-version as default.
ECHO.  HELP      Show this command-description or the one for a specific command.
ECHO.
ECHO.NOTE: All commands (ADD, REMOVE, DEFAULT, CHECK, HELP) are case-insensitive.
ECHO.      The switch ROCKS is also case-insensitive.
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
ECHO.  Check the Lua-versions folder for the default/minimal structure
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
ECHO.  HELP      show this command-description.
ECHO.
ECHO.NOTE: All commands (ADD, REMOVE, DEFAULT, CHECK, HELP) are case-insensitive.
ECHO.
ENDLOCAL
GOTO END

:END