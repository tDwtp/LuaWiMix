@FOR /F "TOKENS=1 USEBACKQ" %%# IN (`CSCRIPT //NOLOGO %~dps0\wimix\iser\findVer.vbs %*`) DO @SET "LUA_PROFILE=%%#"
@IF "%LUA_PROFILE%" == "%~1" (
	@ENDLOCAL & @%~dp0%~1\%~n0%*
) ELSE (
	@ENDLOCAL & @%~dp0%LUA_PROFILE%\%~n0%LUA_PROFILE% %*
)