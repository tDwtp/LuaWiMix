@SETLOCAL
@FOR /F "TOKENS=1 USEBACKQ" %%# IN (`CSCRIPT //NOLOGO %~dps0\iser\findVer.vbs %*`) DO @SET "LUA_PROFILE=%%#"
@IF "%LUA_PROFILE%" == "%1" (
	@ENDLOCAL & @%~dps0\%~1\%~n0%*
) ELSE (
	@ENDLOCAL & @%~dps0\%LUA_PROFILE%\%~n0%LUA_PROFILE% %*
)