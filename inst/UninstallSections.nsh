!ifndef __UNINSTALL_SECTIONS_H__
!define __UNINSTALL_SECTIONS_H__


; -----------------------------------------------------------------------------
; - Macros
; -----------------------------------------------------------------------------


!macro RemoveFromEnvironment var_name
	Exec "$\"$SYSDIR\WScript.exe$\" $\"$INSTDIR\${WIMIX_FOLDER}\arc\remAnyEnv.vbs$\" //E:VBScript //B //NOLOGO $\"${var_name}$\""
!macroend


; - ------------- -
; - Helper Macros -
; - ------------- -
!macro VBS_remLua major minor
	Exec "$\"$SYSDIR\WScript.exe$\" $\"$INSTDIR\${WIMIX_FOLDER}\arc\addLua.vbs$\" //E:VBScript //B //NOLOGO $\"${major}$\" $\"${minor}$\""
!macroend
!macro VBS_remEnv major minor
	Exec "$\"$SYSDIR\WScript.exe$\" $\"$INSTDIR\${WIMIX_FOLDER}\arc\addEnv.vbs$\" //E:VBScript //B //NOLOGO $\"${major}$\" $\"${minor}$\""
!macroend
!macro VBS_remReg major minor
	Exec "$\"$SYSDIR\WScript.exe$\" $\"$INSTDIR\${WIMIX_FOLDER}\arc\addReg.vbs$\" //E:VBScript //B //NOLOGO $\"${major}$\" $\"${minor}$\""
!macroend

!macro VBS_remAll major minor
	!insertmacro VBS_remLua  "${major}" "${minor}"
	!insertmacro VBS_remEnv  "${major}" "${minor}"
	!insertmacro VBS_remReg  "${major}" "${minor}"
!macroend



; -----------------------------------------------------------------------------
; - Uninstalling
; -----------------------------------------------------------------------------


Section "un.-RunFirst"
	SectionIn RO
	
SectionEnd


Section "Uninstall"
SectionEnd


Section	"un.-RunLast" UnSectRunLast
	SectionIn RO
	
	RMDir /r $INSTDIR\${WIMIX_FOLDER}
	
		DeleteRegKey HKCR ".lua"
		DeleteRegKey HKCR ".wlua"
		DeleteRegKey HKCR ".luac"
		DeleteRegKey HKCR "Lua.Script"
		DeleteRegKey HKCR "wLua.Script"
		DeleteRegKey HKCR "Lua.Compiled"
		
		!insertmacro RemoveFromEnvironment "LUA_WIMIX"
		!insertmacro RemoveFromEnvironment "LUA_DEV"
	
	
	; MessageBox MB_YESNO "remove uninstaller?" /SD IDYES IDNO DontRemoveUninstaller
		DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
		Delete "$INSTDIR\uninstall.exe"
	; DontRemoveUninstaller:
	
	; MessageBox MB_YESNO "remove install dir (only works if empty)?" /SD IDYES IDNO DontRemoveDir
		RMDir "$INSTDIR"
	; DontRemoveDir:
SectionEnd

; -----------------------------------------------------------------------------
; - Events
; -----------------------------------------------------------------------------
Function un.onInit
	; !insertmacro UMUI_MULTILANG_GET
    ; !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

!endif