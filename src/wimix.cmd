@ECHO OFF
SETLOCAL

CALL :DO_%* 2>NUL
IF ERRORLEVEL 1 CALL :ERROR
GOTO EXIT


:DO_
:DO_-?
:DO_HELP
	CALL :USAGE %*
GOTO USAGE


:DO_ADD
IF "%~1" == "ROCKS" CALL :DO_ADD_%*
IF "%~1" == "ROCKS" GOTO RETURN
	
GOTO RETURN

:DO_ADD_ROCKS
	
GOTO RETURN


:DO_REMOVE
IF NOT "%~1" == "ROCKS" CALL :DO_REMOVE_ROCKS %*
IF "%~1" == "ROCKS" CALL :DO_REMOVE_%*
IF "%~1" == "ROCKS" GOTO RETURN
	
GOTO RETURN

:DO_REMOVE_ROCKS
	
GOTO RETURN

:DO_DEFAULT
	CSCRIPT //NOLOGO "%~p0\iser\setDefault.vbs" %*
GOTO RETURN


:ERROR
ECHO.Invalid command-line
:USAGE
IF NOT "%~1" == "" GOTO USAGE_%~1
IF DEFINED USAGE GOTO USAGE_%USAGE%
	ECHO.Usage: %~n0 [ADD^|REMOVE^|DEFAULT^|HELP] [options...]
	ECHO.
	ECHO.  ADD       add a Lua-version or a LuaRocks to a version.
	ECHO.  REMOVE    remove a Lua-version or a LuaRocks to a version.
	ECHO.  DEFAULT   set the default Lua-version.
	ECHO.  HELP      show a specific command-description or this information.
	ECHO.
	ECHO.NOTE: The command names (ADD, REMOVE, DEFAULT, HELP) are case-insensitive.
	ECHO.      The switch ROCKS for ADD and REMOVE is also case-insensitive.
	ECHO.
GOTO RETURN

:USAGE_ADD
	ECHO.Usage: %~n0 ADD {ROCKS} [51^|52^|53] {[x86^|amd64]}
	ECHO.
	ECHO.  ROCKS     if specified LuaRocks will be added to the specified version.
	ECHO.            this does not remove the installed libraries.
	ECHO.            if omitted, Lua will be removed and if present LuaRocks
	ECHO.            will also be removed.
	ECHO.
	ECHO.  51        add Lua 5.1 or add LuaRocks to installed Lua 5.1
	ECHO.  52        add Lua 5.2 or add LuaRocks to installed Lua 5.2
	ECHO.  53        add Lua 5.3 or add LuaRocks to installed Lua 5.3
	ECHO.
	ECHO.  x86       use the x86 32-bit architecture (default if omitted)
	ECHO.  amd64     use the amd64 64-bit architecture
	ECHO.
	ECHO.NOTE: The command names (ADD, REMOVE, DEFAULT, HELP) are case-insensitive.
	ECHO.      The switch ROCKS is also case-insensitive.
	ECHO.
GOTO RETURN

:USAGE_REMOVE
	ECHO.Usage: %~n0 REMOVE
	ECHO.
	ECHO.  ROCKS     if specified LuaRocks will be removed from given version.
	ECHO.            if omitted Lua wll be removed and if present its corresponding
	ECHO.            LuaRocks.
	ECHO.
	ECHO.  51        add Lua 5.1 or add LuaRocks to installed Lua 5.1
	ECHO.  52        add Lua 5.2 or add LuaRocks to installed Lua 5.2
	ECHO.  53        add Lua 5.3 or add LuaRocks to installed Lua 5.3
	ECHO.
	ECHO.  x86       use the x86 32-bit architecture (default if omitted)
	ECHO.  amd64     use the amd64 64-bit architecture
	ECHO.
	ECHO.NOTE: The command names (ADD, REMOVE, DEFAULT, HELP) are case-insensitive.
	ECHO.      The switch ROCKS is also case-insensitive.
GOTO RETURN

:USAGE_DEFAULT
	ECHO.Usage: %~n0 DEFAULT {^<architecture^>} ^<version^> {^<architecture^>}
	ECHO.architecture: [x86^|amd64]
	ECHO.version: [51^|52^|53]
	ECHO.the version can only be either preceded or followed by the architecture
	ECHO.
	ECHO.  version
	ECHO.            if preceded by an architecture:
	ECHO.             -^> set the default architecture of the specified version
	ECHO.            if followed by an architecture:
	ECHO.             -^> set the default architecture of the specified version
	ECHO.            
	FOR %%V IN (51 52 53) DO (
		ECHO.  %%V
		ECHO.         if preceded by 'x86' or 'amd64'
		ECHO.          set the architecture for version %%V.
		ECHO.        if not preceded by any architecture, set the default version to %%V.
		ECHO.
	)
	ECHO.
	ECHO.NOTE: The command names (ADD, REMOVE, DEFAULT, HELP) are case-insensitive.
	ECHO.
GOTO RETURN

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
GOTO RETURN


:EXIT
ENDLOCAL
:RETURN
