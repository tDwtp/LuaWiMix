!ifndef __INSTALL_SECTIONS_H__
!define __INSTALL_SECTIONS_H__

; -----------------------------------------------------------------------------
; - Settings
; -----------------------------------------------------------------------------

; Var DepMiWiRocks
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

; !include "UMUI.nsh"
InstType "$(UMUI_TEXT_SETUPTYPE_MINIMAL_TITLE)"
InstType "$(UMUI_TEXT_SETUPTYPE_STANDARD_TITLE)"
InstType "$(UMUI_TEXT_SETUPTYPE_COMPLETE_TITLE)"


; !include "UMUI.nsh"
!include "Sections.nsh"
!include "FileFunc.nsh"


; -----------------------------------------------------------------------------
; - Macros
; -----------------------------------------------------------------------------


!macro AddToEnvironment var_name var_value
	Exec "$\"$SYSDIR\WScript.exe$\" $\"$INSTDIR\${WIMIX_FOLDER}\arc\addAnyEnv.vbs$\" //E:VBScript //B //NOLOGO $\"${var_name}$\" $\"${var_value}$\""
!macroend
!macro AddToPath path
	Exec "$\"$SYSDIR\WScript.exe$\" $\"$INSTDIR\${WIMIX_FOLDER}\arc\addPaths.vbs$\" //E:VBScript //B //NOLOGO $\"${path}$\""
!macroend


; - ------------- -
; - Helper Macros -
; - ------------- -
!macro VBS_addLua major minor
	ExecWait "$\"$SYSDIR\WScript.exe$\" $\"$INSTDIR\${WIMIX_FOLDER}\iser\addLua.vbs$\" //E:VBScript //B //NOLOGO ${major} ${minor}"
!macroend
!macro VBS_addEnv major minor
	ExecWait "$\"$SYSDIR\WScript.exe$\" $\"$INSTDIR\${WIMIX_FOLDER}\iser\addEnv.vbs$\" //E:VBScript //NOLOGO ${major} ${minor}"
!macroend
!macro VBS_addReg major minor
	ExecWait "$\"$SYSDIR\WScript.exe$\" $\"$INSTDIR\${WIMIX_FOLDER}\iser\addReg.vbs$\" //E:VBScript //NOLOGO ${major} ${minor}"
!macroend

!macro VBS_addAll major minor
	!insertmacro VBS_addLua  "${major}" "${minor}"
	!insertmacro VBS_addEnv  "${major}" "${minor}"
	!insertmacro VBS_addReg  "${major}" "${minor}"
!macroend

!macro VBS_setDefault major minor
	Exec "$\"$SYSDIR\WScript.exe$\" $\"$INSTDIR\${WIMIX_FOLDER}\arc\setDefault.vbs$\" //E:VBScript //B //NOLOGO $\"${major}$\" $\"${minor}$\""
!macroend

; - ---------------- -
; - Install Sections -
; - ---------------- -
; !define OldVersion51
!macro InstallSectLua major minor
	Section /o "${major}.${minor}" "SectLua${major}${minor}"
		; SetOutPath "$INSTDIR\${major}${minor}"
		
		!insertmacro VBS_AddAll ${major} ${minor}
		
		StrCmp ${minor} "3" 0 NotMinimal
			SectionIn 1 2 3
			Goto Done
		NotMinimal:
			SectionIn 3
		Done:
	SectionEnd
!macroend
!macro InstallSectLuaRocks major minor
		Section /o "${major}.${minor}" SectRocks${major}${minor}
			; SetOutPath $INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}
			
			ExecWait "$INSTDIR\${WIMIX_FOLDER}\lua-wimix.bat ${major}${minor} ADD ROCKS"
			
			; CopyFiles "$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}\luarocks.bat" "$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}\luarocks${major}${minor}.bat"
			; CopyFiles "$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}\luarocks-admin.bat" "$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}\luarocks-admin${major}${minor}.bat"
			; CopyFiles "$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}\luarocksw.bat" "$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}\luarocksw${major}${minor}.bat"
			
			; File /oname=LuaRocks${major}${minor}.txt dummy.txt
			
			StrCmp "${minor}" "3" 0 NotMinimal
				SectionIn 2 3
				Goto Done
			NotMinimal:
				SectionIn 3
			Done:
		SectionEnd
!macroend
!macro InstallSectDefault major minor
		Section /o "${major}.${minor}" SectDef${major}${minor}
			
			!insertmacro AddToEnvironment "LUA_DEV" "$INSTDIR\${major}${minor}"
			!insertmacro VBS_setDefault "${major}" "${minor}"
			
			StrCmp "${minor}" "3" 0 NotMinimal
				SectionIn 1 2 3
			NotMinimal:
		SectionEnd
!macroend


; - ---------------- -
; - Install Sections -
; - ---------------- -
!macro PrepareLuaInstall m s
	SectionGetFlags ${SectLua${m}${s}} $R0
	IntOp $R0 $R0 & ${SF_SELECTED}
	StrCpy $DepLua${m}${s} $R0
	
	SectionGetFlags ${SectRocks${m}${s}} $R0
	IntOp $R0 $R0 & ${SF_SELECTED}
	StrCpy $DepRocks${m}${s} $R0
	
	SectionGetFlags ${SectDef${m}${s}} $R0
	IntOp $R0 $R0 & ${SF_SELECTED}
	StrCpy $DepDef${m}${s} $R0
!macroend
!macro LuaDepency m s
	; CheckLua${m}${s}:
		SectionGetFlags ${SectLua${m}${s}} $R0           ; Lua ${m}.${s} flags (SectLua${m}${s})
		IntOp $R0 $R0 & ${SF_SELECTED}                   ; mask selected flag
		# if (current != previous and not isSelected(current))
		StrCmp $R0 $DepLua${m}${s} CheckLua${m}${s}_done ; if current != previous
		StrCmp $R0 ${SF_SELECTED} CheckLua${m}${s}_done  ;    and current is unselected
		# then ; deselected -> deselect Rocks ${m}.${s}
			StrCpy $DepLua${m}${s} $R0
			Goto DeselectRocks${m}${s}
		CheckLua${m}${s}_done:
		# else
			StrCpy $DepLua${m}${s} $R0
			Goto CheckRocks${m}${s}
		# end
	
	DeselectRocks${m}${s}:
		SectionGetFlags ${SectRocks${m}${s}} $R0     ; Rocks ${m}.${s} flags (SectRocks${m}${s})
		IntOp $R0 $R0 & ${SF_SELECTED}               ; mask selected flag
		# if (isSelected(current))
		StrCmp $R0 ${SF_SELECTED} 0 DeselectRocks${m}${s}_done ; if current is selected
		# then ; deselect
			SectionGetFlags ${SectRocks${m}${s}} $R0 ; Rocks ${m}.${s} flags (SectRocks${m}${s})
			IntOp $R0 $R0 | ${SF_SELECTED}                   ; select
			IntOp $R0 $R0 ^ ${SF_SELECTED}                   ; invert select
			SectionSetFlags ${SectRocks${m}${s}} $R0 ; apply
		DeselectRocks${m}${s}_done:
		# end
		IntOp $R0 $R0 & ${SF_SELECTED}       ; mask selected flag
		StrCpy $DepRocks${m}${s} $R0 ; save selection
	
	CheckRocks${m}${s}:
		SectionGetFlags ${SectRocks${m}${s}} $R0 ; Rocks ${m}.${s} flags (SectRocks${m}${s})
		IntOp $R0 $R0 & ${SF_SELECTED}           ; mask seleted flag
		# if (current != previous and isSelected(current))
		StrCmp $R0 $DepRocks${m}${s} CheckRocks${m}${s}_else ; if current != previous
		StrCmp $R0 ${SF_SELECTED} 0 CheckRocks${m}${s}_else  ;    and current is selected
		# then
			StrCpy $RequireMiWiRocks "true"      ; require MiWiRocks
			StrCpy $DepRocks${m}${s} $R0         ; save selection
			Goto SelectLua${m}${s}
		CheckRocks${m}${s}_else:
		# else
			StrCpy $DepRocks${m}${s} $R0         ; save selection
			Goto DoneCheckLua${m}${s}
		# end
	
	SelectLua${m}${s}:
		SectionGetFlags ${SectLua${m}${s}} $R0     ; Lua ${m}.${s} flags (SectLua${m}${s})
		IntOp $R0 $R0 & ${SF_SELECTED}             ; mask selected flag
		# if (not isSelected(current))
		StrCmp $R0 ${SF_SELECTED} SectLua${m}${s}_done ; if current is unselected
		# then ; deselect
			SectionGetFlags ${SectLua${m}${s}} $R0 ; Lua ${m}.${s} flags (SectLua${m}${s})
			IntOp $R0 $R0 | ${SF_SELECTED}                 ; select
			SectionSetFlags ${SectLua${m}${s}} $R0 ; apply
		SectLua${m}${s}_done:
		# end
		IntOp $R0 $R0 & ${SF_SELECTED}     ; mask selected flag
		StrCpy $DepLua${m}${s} $R0         ; save selection
	
	DoneCheckLua${m}${s}:
!macroend
!macro CheckDef m s
	SectionGetFlags ${SectDef${m}${s}} $R0 ; Lua ${m}.${s} As Deault flags (SectDef${m}${s})
	IntOp $R0 $R0 & ${SF_SELECTED}                 ; mask selected flag
	# if (current != previous)
	StrCmp $R0 $DepDef${m}${s} CheckDef${m}${s} ; if current != previous
	# then
		# if (isSelected(current))
		StrCmp $R0 ${SF_SELECTED} 0 CheckDefSel${m}${s} ;    and current is selected
		# then
			IntOp $TempSectDef51 $TempSectDef51 | ${SF_SELECTED}
			IntOp $TempSectDef51 $TempSectDef51 ^ ${SF_SELECTED}
			IntOp $TempSectLua51 $TempSectLua51 | ${SF_RO}
			IntOp $TempSectLua51 $TempSectLua51 ^ ${SF_RO}
			
			IntOp $TempSectDef52 $TempSectDef52 | ${SF_SELECTED}
			IntOp $TempSectDef52 $TempSectDef52 ^ ${SF_SELECTED}
			IntOp $TempSectLua52 $TempSectLua52 | ${SF_RO}
			IntOp $TempSectLua52 $TempSectLua52 ^ ${SF_RO}
			
			IntOp $TempSectDef53 $TempSectDef53 | ${SF_SELECTED}
			IntOp $TempSectDef53 $TempSectDef53 ^ ${SF_SELECTED}
			IntOp $TempSectLua53 $TempSectLua53 | ${SF_RO}
			IntOp $TempSectLua53 $TempSectLua53 ^ ${SF_RO}
		# end
		CheckDefSel${m}${s}:
		; activate it again; cannot be unset
		StrCpy $DepDef "${m}${s}" ;set current default
		IntOp $TempSectLua${m}${s} $TempSectLua${m}${s} | ${SF_SELECTED}
		IntOp $TempSectLua${m}${s} $TempSectLua${m}${s} | ${SF_RO}
		IntOp $TempSectDef${m}${s} $TempSectDef${m}${s} | ${SF_SELECTED}
	# end
	CheckDef${m}${s}:
!macroend


; -----------------------------------------------------------------------------
; - Installing
; -----------------------------------------------------------------------------

Section "-RunFirst"
	SectionIn RO
	SectionIn 1 2 3
	; pre installation stuff
SectionEnd

Section ""
	SectionIn RO
	SectionIn 1 2 3
	SetOutPath "$INSTDIR"
	
	SetOutPath "$INSTDIR\${WIMIX_FOLDER}"
	
	;; wimix
	File /oname=lua.cmd             ..\src\${WIMIX_FOLDER}\lua.cmd
	File /oname=wlua.cmd            ..\src\${WIMIX_FOLDER}\wlua.cmd
	File /oname=luac.cmd            ..\src\${WIMIX_FOLDER}\luac.cmd
	File /oname=ilua.cmd            ..\src\${WIMIX_FOLDER}\ilua.cmd
	File /oname=lua-wimix.cmd       ..\src\${WIMIX_FOLDER}\lua-wimix.cmd
	
	;; wimix\icon
	SetOutPath "$INSTDIR\${WIMIX_FOLDER}\icon"
	File /oname=lua-logo.ico        ..\src\${WIMIX_FOLDER}\icon\lua-logo.ico
	File /oname=lua-file.ico        ..\src\${WIMIX_FOLDER}\icon\lua-file.ico
	File /oname=wlua-file.ico       ..\src\${WIMIX_FOLDER}\icon\lua-file.ico
	File /oname=luac-file.ico       ..\src\${WIMIX_FOLDER}\icon\luac-file.ico
	File /oname=luarocks-file.ico   ..\src\${WIMIX_FOLDER}\icon\luarocks-file.ico
	
	;; wimix\arc
	SetOutPath "$INSTDIR\${WIMIX_FOLDER}\arc"
	StrCmp $Bits "32" 0 Not32
	# then ; 32
		File /oname=lua51.zip       ..\src\${WIMIX_FOLDER}\arc\lua51x86.zip
		File /oname=lua52.zip       ..\src\${WIMIX_FOLDER}\arc\lua52x86.zip
		File /oname=lua53.zip       ..\src\${WIMIX_FOLDER}\arc\lua53x86.zip
	Not32:
	# end
	StrCmp $Bits "64" 0 Not64
	# then ; 64
		File /oname=lua51.zip       ..\src\${WIMIX_FOLDER}\arc\lua51amd64.zip
		File /oname=lua52.zip       ..\src\${WIMIX_FOLDER}\arc\lua52amd64.zip
		File /oname=lua53.zip       ..\src\${WIMIX_FOLDER}\arc\lua53amd64.zip
	Not64:
	# end
	File /oname=luarocks.cmd        ..\src\${WIMIX_FOLDER}\arc\luarocks.cmd
	File /oname=luarocks-admin.cmd  ..\src\${WIMIX_FOLDER}\arc\luarocks-admin.cmd
	File /oname=luarocksw.cmd       ..\src\${WIMIX_FOLDER}\arc\luarocksw.cmd
	File /oname=lua.cmd             ..\src\${WIMIX_FOLDER}\arc\lua.cmd
	File /oname=wlua.cmd            ..\src\${WIMIX_FOLDER}\arc\wlua.cmd
	File /oname=luac.cmd            ..\src\${WIMIX_FOLDER}\arc\luac.cmd
	File /oname=ilua.cmd            ..\src\${WIMIX_FOLDER}\arc\ilua.cmd
	File /oname=iluaXX.bat          ..\src\${WIMIX_FOLDER}\arc\iluaXX.bat
	
	;; wimix\iser
	SetOutPath "$INSTDIR\${WIMIX_FOLDER}\iser"
	File /oname=addAnyEnv.vbs       ..\src\${WIMIX_FOLDER}\iser\addAnyEnv.vbs
	File /oname=addEnv.vbs          ..\src\${WIMIX_FOLDER}\iser\addEnv.vbs
	File /oname=addLua.vbs          ..\src\${WIMIX_FOLDER}\iser\addLua.vbs
	File /oname=addReg.vbs          ..\src\${WIMIX_FOLDER}\iser\addReg.vbs
	File /oname=addPaths.vbs        ..\src\${WIMIX_FOLDER}\iser\addPaths.vbs
	
	File /oname=remAnyEnv.vbs       ..\src\${WIMIX_FOLDER}\iser\remAnyEnv.vbs
	File /oname=remEnv.vbs          ..\src\${WIMIX_FOLDER}\iser\remEnv.vbs
	File /oname=remLua.vbs          ..\src\${WIMIX_FOLDER}\iser\remLua.vbs
	File /oname=remReg.vbs          ..\src\${WIMIX_FOLDER}\iser\remReg.vbs
	File /oname=remPaths.vbs        ..\src\${WIMIX_FOLDER}\iser\remPaths.vbs
	
	File /oname=dummyVer.vbs        ..\src\${WIMIX_FOLDER}\iser\dummyVer.vbs
	File /oname=findVer.vbs         ..\src\${WIMIX_FOLDER}\iser\findVer.vbs
	File /oname=setDefault.vbs      ..\src\${WIMIX_FOLDER}\iser\setDefault.vbs
	File /oname=setDirectDefault.vbs ..\src\${WIMIX_FOLDER}\iser\setDirectDefault.vbs
	
	SetOutPath "$INSTDIR\${WIMIX_FOLDER}\iser\rocks"
	File /r ..\src\${WIMIX_FOLDER}\iser\rocks\*
	
	CreateDirectory "$INSTDIR\${WIMIX_FOLDER}\rocks"
	
	; CreateDirectory $INSTDIR\{MIWI_FOLDER}\SciTE
	SetOutPath $INSTDIR\${WIMIX_FOLDER}\SciTE
	File /r ..\src\${WIMIX_FOLDER}\SciTE\*
	
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
		!insertmacro AddToEnvironment "LUA_DEV" "$INSTDIR\$DepDef"
	
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
	
	SetOutPath "$INSTDIR\${WIMIX_FOLDER}"
SectionEnd


Section "Add WiMix to Path" SectPath
	; !insertmacro AddToPath "$INSTDIR\${WIMIX_FOLDER}"
SectionEnd

SectionGroup /e "Lua" SectLua
	!insertmacro InstallSectLua 5 1
	!insertmacro InstallSectLua 5 2
	!insertmacro InstallSectLua 5 3
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

Section "-RunLast"
	SectionIn RO
	SectionIn 1 2 3
	; post installation stuff
	
	; Calculate Estimated Size
	Push $0
	Push $1
	Push $2
	${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
	Pop $2
	Pop $1
	WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "EstimatedSize" $0
	Pop $0
SectionEnd

; -----------------------------------------------------------------------------
; - Events
; -----------------------------------------------------------------------------
Function .onInit
    InitPluginsDir
	; StrCpy $Language ${LANG_ENGLISH}
	!insertmacro UMUI_MULTILANG_GET
    ; !insertmacro MUI_LANGDLL_DISPLAY
	StrCpy $Bits "32" ; we currently only support 32 bits :P
	
	; check if installing is ok...
	; check for mingw32?
	; Abort if not
	
	; Prepare Default (Lua 5.3)
	
	SectionGetFlags ${SectLua53} $R0
	IntOp $R0 $R0 | ${SF_RO}
	IntOp $R0 $R0 | ${SF_SELECTED}
	SectionSetFlags ${SectLua53} $R0
	SectionGetFlags ${SectDef53} $R0
	IntOp $R0 $R0 | ${SF_SELECTED}
	SectionSetFlags ${SectDef53} $R0
	StrCpy $DepDef "53"
	
	; Prepare Depencies
	
	!insertmacro PrepareLuaInstall 5 1
	!insertmacro PrepareLuaInstall 5 2
	!insertmacro PrepareLuaInstall 5 3
	
	; SectionGetFlags ${SectWiMixRocks} $R0
	; IntOp $R0 $R0 & ${SF_SELECTED}
	; StrCpy $DepMiWiRocks $R0
	
FunctionEnd


; -----------------------------------------------------------------------------
; - Depencies
; -----------------------------------------------------------------------------
Var RequireMiWiRocks
Var TempSectDef51
Var TempSectDef52
Var TempSectDef53
Var TempSectLua51
Var TempSectLua52
Var TempSectLua53
Function .onSelChange
	Push $R0
	
	StrCpy $RequireMiWiRocks "false"
	; Goto CheckLua51
	
	!insertmacro LuaDepency 5 1
	!insertmacro LuaDepency 5 2
	!insertmacro LuaDepency 5 3
	
!ifdef MiWiRocks
	; CheckMiWiRocks:
			; MessageBox MB_OK $RequireMiWiRocks
		StrCmp $RequireMiWiRocks "true" 0 NoMiWiRocks
		# then
			SectionGetFlags ${SectWiMixRocks} $R0 ; MiWiRocks flags (SectMiWiRocks)
			IntOp $R0 $R0 | ${SF_SELECTED}        ; select
			SectionSetFlags ${SectWiMixRocks} $R0 ; apply
			Goto CheckDef
		NoMiWiRocks:
		# else
			; SectionGetFlags ${SectWiMixRocks} $R0 ; MiWiRocks flags (SectWiMixRocks)
			; IntOp $R0 $R0 | ${SF_SELECTED}        ; select
			; IntOp $R0 $R0 ^ ${SF_SELECTED}        ; invert select
			; SectionSetFlags ${SectWiMixRocks} $R0 ; apply
		CheckDef:
		# end
!endif
	
		; prepare
		SectionGetFlags ${SectDef51} $TempSectDef51
		SectionGetFlags ${SectDef52} $TempSectDef52
		SectionGetFlags ${SectDef53} $TempSectDef53
		SectionGetFlags ${SectLua51} $TempSectLua51
		SectionGetFlags ${SectLua52} $TempSectLua52
		SectionGetFlags ${SectLua53} $TempSectLua53
		
		; check
		!insertmacro CheckDef 5 1
		!insertmacro CheckDef 5 2
		!insertmacro CheckDef 5 3
		
		; apply
		SectionSetFlags ${SectDef51} $TempSectDef51
		SectionSetFlags ${SectDef52} $TempSectDef52
		SectionSetFlags ${SectDef53} $TempSectDef53
		SectionSetFlags ${SectLua51} $TempSectLua51
		SectionSetFlags ${SectLua52} $TempSectLua52
		SectionSetFlags ${SectLua53} $TempSectLua53
		
		; mask
		IntOp $TempSectDef51 $TempSectDef51 & ${SF_SELECTED}
		IntOp $TempSectDef52 $TempSectDef52 & ${SF_SELECTED}
		IntOp $TempSectDef53 $TempSectDef53 & ${SF_SELECTED}
		
		; save
		StrCpy $DepDef51 $TempSectDef51
		StrCpy $DepDef52 $TempSectDef52
		StrCpy $DepDef53 $TempSectDef53
	
	Pop $R0
FunctionEnd

Function .onInstSuccess
	WriteUninstaller $INSTDIR\uninstall.exe
	
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayName" "${APP_NAME} ${APP_VERSION}"
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
	
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
	
FunctionEnd
Function .onInstFailed
	; save an uninstaller
	WriteUninstaller $INSTDIR\uninstall.exe
	; run uninstaller
	Exec $INSTDIR\uninstall.exe
FunctionEnd




!endif