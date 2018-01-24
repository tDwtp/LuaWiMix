@SETLOCAL
@FOR /F "TOKENS=1 USEBACKQ" %%# IN (`CSCRIPT //NOLOGO %~dps0\wimix\iser\findVer.vbs %*`) DO @SET "LUA_PROFILE=%%#"
@IF NOT "%1" == "wimix" @IF EXIST "%~dp0\..\%1" (
	@ENDLOCAL & @%~dps0\rocks\%1\%~n0%*
) ELSE (
	@ENDLOCAL & @%~dps0\rocks\%LUA_PROFILE%\%~n0%LUA_PROFILE% %*
)