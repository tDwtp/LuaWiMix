@if     exist %~dps0\..\%1\lua%1.exe @%~dps0\..\%1\lua%* -e "require('ilua')"
@set /p LUA_PROFILE=<%~pds0\default-version.txt >nul 2>nul
@if not defined LUA_PROFILE set LUA_PROFILE=53
@if not exist "%~pds0\..\%LUA_PROFILE%" set LUA_PROFILE=53
@if "%LUA_PROFILE%" == "wimix" set LUA_PROFILE=53
@if not exist %~dps0\..\%1\lua%1.exe @%~dps0\..\%LUA_PROFILE%\lua%LUA_PROFILE% -e "require('ilua')" %*
