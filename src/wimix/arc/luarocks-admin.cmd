@setlocal
@set /p LUA_PROFILE=<%~pds0\default-version.txt >nul 2>nul
@if not defined LUA_PROFILE set LUA_PROFILE=53
@if not exist "%~pds0\..\%LUA_PROFILE%" set LUA_PROFILE=53
@if "%LUA_PROFILE%" == "wimix" set LUA_PROFILE=53
@if not exist %~dps0\..\wimix\rocks\%1\%~n0%1.bat @%~dps0\..\wimix\rocks\%LUA_PROFILE%\%~n0%LUA_PROFILE% %*
@endlocal
@if     exist %~dps0\..\wimix\rocks\%1\%~n0%1.bat @%~dps0\..\wimix\rocks\%1\%~n0%*
