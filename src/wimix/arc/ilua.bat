@SETLOCAL
@SET "ILUA_PROFILE=%~n0"
@ENDLOCAL & @lua%ILUA_PROFILE:~4%.exe -e "require('ilua')" %*
