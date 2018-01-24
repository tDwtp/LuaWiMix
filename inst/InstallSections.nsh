!ifndef __INSTALL_SECTIONS_H__
!define __INSTALL_SECTIONS_H__

; -----------------------------------------------------------------------------
; - Macros
; -----------------------------------------------------------------------------

!macro AddToEnvironment var_name var_value
	Exec "$\"$SYSDIR\WScript.exe$\" $\"$INSTDIR\${WIMIX_FOLDER}\arc\addAnyEnv.vbs$\" //E:VBScript //B //NOLOGO $\"${var_name}$\" $\"${var_value}$\""
!macroend
!macro RemoveFromEnvironment var_name
	Exec "$\"$SYSDIR\WScript.exe$\" $\"$INSTDIR\${WIMIX_FOLDER}\arc\remEnv.vbs$\" //E:VBScript //B //NOLOGO $\"${var_name}$\""
!macroend

!macro VBS_AddLua major minor
	Exec "$\"$SYSDIR\WScript.exe$\" $\"$INSTDIR\${WIMIX_FOLDER}\arc\addLua.vbs$\" //E:VBScript //B //NOLOGO $\"${major}$\" $\"${minor}$\""
!macroend
!macro VBS_AddEnv major minor
	Exec "$\"$SYSDIR\WScript.exe$\" $\"$INSTDIR\${WIMIX_FOLDER}\arc\addEnv.vbs$\" //E:VBScript //B //NOLOGO $\"${major}$\" $\"${minor}$\""
!macroend
!macro VBS_AddReg major minor
	Exec "$\"$SYSDIR\WScript.exe$\" $\"$INSTDIR\${WIMIX_FOLDER}\arc\addReg.vbs$\" //E:VBScript //B //NOLOGO $\"${major}$\" $\"${minor}$\""
!macroend

!macro VBS_AddAll major minor
	!insertmacro VBS_AddLua  "${major}" "${minor}"
	!insertmacro VBS_AddEnv  "${major}" "${minor}"
	!insertmacro VBS_AddReg  "${major}" "${minor}"
!macroend

; !define OldVersion51
!macro InstallSectLua major minor old
	Section /o "${major}.${minor}" "SectLua${major}${minor}"
		SetOutPath "$INSTDIR\${major}${minor}"
		
		!insertmacro VBS_AddAll ${major} ${minor}
		
		StrCmp ${minor} "3" 0 NotMinimal
			SectionIn 1 2
		NotMinimal:
			SectionIn 3
	SectionEnd
!macroend
!macro InstallSectLuaRocks major minor
		Section /o "${major}.${minor}" SectRocks${major}${minor}
			; SetOutPath $INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}
			
			Exec "$INSTDIR\${WIMIX_FOLDER}\lua-wimix.bat ${major}${minor} ROCKS"
			
			CopyFiles "$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}\luarocks.bat" "$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}\luarocks${major}${minor}.bat"
			CopyFiles "$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}\luarocks-admin.bat" "$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}\luarocks-admin${major}${minor}.bat"
			CopyFiles "$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}\luarocksw.bat" "$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}\luarocksw${major}${minor}.bat"
			
			; File /oname=LuaRocks${major}${minor}.txt dummy.txt
			
			StrCmp ${minor} "3" 0 NotMinimal
				SectionIn 2
			NotMinimal:
				SectionIn 3
		SectionEnd
!macroend
!macro InstallSectDefault major minor
		Section /o "${major}.${minor}" SectDef${major}${minor}
			
			
			
			WriteRegStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "LUA_DEV" "$INSTDIR\${major}${minor}"
			
			StrCmp ${minor} "3" 0 NotMinimal
				SectionIn 1 2 3
			NotMinimal:
		SectionEnd
!macroend



; -----------------------------------------------------------------------------
; - Settings
; -----------------------------------------------------------------------------

Var DepMiWiRocks
Var DepLua51
Var DepLua52
Var DepLua53
Var DepRocks51
Var DepRocks52
Var DepRocks53
Var DepDef
Var DepDef51
Var DepDef52
Var DepDef53

Var Bits

InstType "$(UMUI_TEXT_SETUPTYPE_MINIMAL_TITLE)"
InstType "$(UMUI_TEXT_SETUPTYPE_STANDARD_TITLE)"
InstType "$(UMUI_TEXT_SETUPTYPE_COMPLETE_TITLE)"

; -----------------------------------------------------------------------------
; - Installing
; -----------------------------------------------------------------------------

Section "-RunFirst"
	SectionIn RO
	SectionIn 1 2 3
SectionEnd

Section ""
	SectionIn RO
	SetOutPath $INSTDIR
	
	SetOutPath $INSTDIR\${WIMIX_FOLDER}
	
	;; wimix
	File /oname=lua.cmd             ..\src\${WIMIX_FOLDER}\lua.cmd
	File /oname=wlua.cmd            ..\src\${WIMIX_FOLDER}\wlua.cmd
	File /oname=luac.cmd            ..\src\${WIMIX_FOLDER}\luac.cmd
	File /oname=ilua.cmd            ..\src\${WIMIX_FOLDER}\ilua.cmd
	File /oname=lua-wimix.cmd       ..\src\${WIMIX_FOLDER}\lua-wimix.cmd
	
	;; wimix\icon
	SetOutPath $INSTDIR\${WIMIX_FOLDER}\icon
	File /oname=lua-logo.ico        ..\src\${WIMIX_FOLDER}\icon\lua-logo.ico
	File /oname=lua-file.ico        ..\src\${WIMIX_FOLDER}\icon\lua-file.ico
	File /oname=luac-file.ico       ..\src\${WIMIX_FOLDER}\icon\luac-file.ico
	File /oname=luarocks-file.ico   ..\src\${WIMIX_FOLDER}\icon\luarocks-file.ico
	
	;; wimix\arc
	SetOutPath $INSTDIR\${WIMIX_FOLDER}\arc
	StrCmp $Bits "32" 0 +7
	# then ; 32
		File /oname=lua51.zip       ..\src\${WIMIX_FOLDER}\arc\lua51x86.zip
		File /oname=lua52.zip       ..\src\${WIMIX_FOLDER}\arc\lua52x86.zip
		File /oname=lua53.zip       ..\src\${WIMIX_FOLDER}\arc\lua53x86.zip
	# end
	StrCmp $Bits "64" 0 +7
	# then ; 64
		File /oname=lua51.zip       ..\src\${WIMIX_FOLDER}\arc\lua51amd64.zip
		File /oname=lua52.zip       ..\src\${WIMIX_FOLDER}\arc\lua52amd64.zip
		File /oname=lua53.zip       ..\src\${WIMIX_FOLDER}\arc\lua53amd64.zip
	# end
	File /oname=luarocks.cmd        ..\src\${WIMIX_FOLDER}\arc\luarocks.cmd
	File /oname=luarocks-admin.cmd  ..\src\${WIMIX_FOLDER}\arc\luarocks-admin.cmd
	File /oname=luarocksw.cmd       ..\src\${WIMIX_FOLDER}\arc\luarocksw.cmd
	File /oname=lua.cmd             ..\src\${WIMIX_FOLDER}\arc\lua.cmd
	File /oname=wlua.cmd            ..\src\${WIMIX_FOLDER}\arc\wlua.cmd
	File /oname=luac.cmd            ..\src\${WIMIX_FOLDER}\arc\luac.cmd
	File /oname=ilua.cmd            ..\src\${WIMIX_FOLDER}\arc\ilua.cmd
	File /oname=iluaXX.cmd          ..\src\${WIMIX_FOLDER}\arc\iluaXX.cmd
	
	;; wimix\iser
	SetOutPath $INSTDIR\${WIMIX_FOLDER}\iser
	File /oname=addEnv.vbs          ..\src\${WIMIX_FOLDER}\iser\addEnv.vbs
	File /oname=addLua.vbs          ..\src\${WIMIX_FOLDER}\iser\addLua.vbs
	File /oname=addLuaEnv.vbs       ..\src\${WIMIX_FOLDER}\iser\addLuaEnv.vbs
	File /oname=addPaths.vbs        ..\src\${WIMIX_FOLDER}\iser\addPaths.vbs
	File /oname=addReg.vbs          ..\src\${WIMIX_FOLDER}\iser\addReg.vbs
	
	File /oname=remEnv.vbs          ..\src\${WIMIX_FOLDER}\iser\remEnv.vbs
	File /oname=remLua.vbs          ..\src\${WIMIX_FOLDER}\iser\remLua.vbs
	File /oname=remLuaEnv.vbs       ..\src\${WIMIX_FOLDER}\iser\remLuaEnv.vbs
	File /oname=remPaths.vbs        ..\src\${WIMIX_FOLDER}\iser\remPaths.vbs
	File /oname=remReg.vbs          ..\src\${WIMIX_FOLDER}\iser\remReg.vbs
	
	File /oname=dummyVer.vbs        ..\src\${WIMIX_FOLDER}\iser\dummyVer.vbs
	File /oname=findVer.vbs         ..\src\${WIMIX_FOLDER}\iser\findVer.vbs
	File /oname=setDefault.vbs      ..\src\${WIMIX_FOLDER}\iser\setDefault.vbs
	
	CreateDirectory $INSTDIR\${WIMIX_FOLDER}\rocks
	
	; CreateDirectory $INSTDIR\{MIWI_FOLDER}\SciTE
	SetOutPath $INSTDIR\${WIMIX_FOLDER}\SciTE
	File /r src\${WIMIX_FOLDER}\SciTE\*
	
	; SetOutPath $INSTDIR
	
		WriteRegStr HKCR ".lua"  "" "Lua.Script"
		WriteRegStr HKCR ".wlua" "" "wLua.Script"
		WriteRegStr HKCR ".luac" "" "Lua.Compiled"
		WriteRegStr HKCR  ".lua\ContentType"   "" "text/plain"
		WriteRegStr HKCR  ".lua\PerceivedType" "" "text"
		WriteRegStr HKCR ".wlua\ContentType"   "" "text/plain"
		WriteRegStr HKCR ".wlua\PerceivedType" "" "text"
		
		WriteRegStr HKCR "Lua.Compiled" "" "Lua compiled Script"
		WriteRegStr HKCR  "wLua.Script" "" "Lua promptless Script File"
		WriteRegStr HKCR   "Lua.Script" "" "Lua Script File"
		WriteRegExpandStr HKCR   "Lua.Script\Shell\Open\Command" "" "$\"$INSTDIR\${WIMIX_FOLDER}\lua.cmd$\" $\"%1$\" %*"
		WriteRegExpandStr HKCR  "wLua.Script\Shell\Open\Command" "" "$\"$INSTDIR\${WIMIX_FOLDER}\wlua.cmd$\" $\"%1$\" %*"
		WriteRegExpandStr HKCR "Lua.Compiled\Shell\Open\Command" "" "$\"$INSTDIR\${WIMIX_FOLDER}\luac.cmd$\" $\"%1$\" %*"
		WriteRegStr HKCR "Lua.Compiled\DefaultIcon" "" "$INSTDIR\${WIMIX_FOLDER}\icon\luac-file.ico"
		WriteRegStr HKCR  "wLua.Script\DefaultIcon" "" "$INSTDIR\${WIMIX_FOLDER}\icon\lua-file.ico"
		WriteRegStr HKCR   "Lua.Script\DefaultIcon" "" "$INSTDIR\${WIMIX_FOLDER}\icon\lua-file.ico"
		WriteRegExpandStr HKCR  "Lua.Script\Shell\Edit\Command" "" "$\"$INSTDIR\${WIMIX_FOLDER}\SciTE\SciTE.exe$\" $\"%1$\""
		WriteRegExpandStr HKCR "wLua.Script\Shell\Edit\Command" "" "$\"$INSTDIR\${WIMIX_FOLDER}\SciTE\SciTE.exe$\" $\"%1$\""
		
		!insertmacro AddToEnvironment "LUA_WIMIX" "$INSTDIR"
		; !insertmacro AddToEnvironment "LUA_DEV" "$INSTDIR\$DepDef"
	
	WriteUninstaller $INSTDIR\uninstall.exe
	
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayName" "${APP_NAME} ${APP_VERSION}"
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "QuietUninstallString" "$\"$\"$INSTDIR\uninstall.exe$\" /S"
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayVersion" "${APP_VERSION}"
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayIcon" "$INSTDIR\${WIMIX_FOLDER}\icon\lua-logo.ico"
	WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "VersionMajor" ${APP_VERSION_MAJOR}
	WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "VersionMinor" ${APP_VERSION_MINOR}
	WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "NoModify" 1
	WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "NoRepair" 1
	; WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "Readme" "$INSTDIR\${WIMIX_FOLDER}\arc\readme.txt"
	; WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "HelpLink" "https://github.com/tDwtp/LuaWiMix/issues"
	; WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "HelpLink" "https://github.com/tDwtp/LuaWiMix/blob/master/wiki/index.md"
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "URLUpdateInfo" "https://github.com/tDwtp/LuaWiMix/releases/latest"
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "URLInfoAbout" "https://github.com/tDwtp/LuaWiMix/blob/master/README.md"
	
SectionEnd

SectionGroup /e "Lua" SectLua
	!insertmacro InstallSectLua 5 1 "true"
	!insertmacro InstallSectLua 5 2 "false"
	!insertmacro InstallSectLua 5 3 "false"
SectionGroupEnd

SectionGroup /e "LuaRocks" SectLuaRocks
	!insertmacro InstallSectLuaRocks 5 1
	!insertmacro InstallSectLuaRocks 5 2
	!insertmacro InstallSectLuaRocks 5 3
SectionGroupEnd

SectionGroup /e "Default" SectDef
	!insertmacro InstallSectDefault 5 1
	!insertmacro InstallSectDefault 5 2
	!insertmacro InstallSectDefault 5 3
SectionGroupEnd


Function ".onInit"
	; default language english:
	; StrCpy $Language ${LANG_ENGLISH}
	!insertmacro UMUI_MULTILANG_GET
FunctionEnd

!endif