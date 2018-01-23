!define APP_VERSION "0.0"
!define APP_NAME "LuaWiMix"
!define WIMIX_FOLDER "wimix"

Name "${APP_NAME} ${APP_VERSION}"
RequestExecutionLevel admin

	!include "UMUI.nsh"
	
	!define UMUI_SKIN "blue"
	; !define UMUI_BGSKIN "blue"
	; !define UMUI_USE_INSTALLOPTIONSEX
	; !define MUI_COMPONENTSPAGE_NODESC
	; !define MUI_COMPONENTSPAGE_SMALLDESC
	; !define UMUI_NOLEFTIMAGE

OutFile "${APP_NAME}.exe"
InstallDir $PROGRAMFILES\Lua
; InstallDirRegKey HKLM "SOFTWARE\${APP_NAME}" ""
; InstallDir $APPDATA\Dummy\test

	!insertmacro MUI_PAGE_LICENSE "LICENSE"
	!insertmacro MUI_PAGE_COMPONENTS
	!insertmacro MUI_PAGE_DIRECTORY
	!insertmacro MUI_PAGE_INSTFILES
	!insertmacro MUI_PAGE_FINISH

	!insertmacro MUI_UNPAGE_CONFIRM
	; !insertmacro MUI_UNPAGE_COMPONENTS
	!insertmacro MUI_UNPAGE_INSTFILES
	!insertmacro MUI_UNPAGE_FINISH
	
	; !insertmacro MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
	; !insertmacro MUI_STARTMENUPAGE_REGISTRY_KEY "SOFTWARE\${APP_NAME}"
	; !insertmacro MUI_STARTMENUPAGE_REGISTRY_VALUENAME "StartMenuFolder"
	
	; !insertmacro MUI_FINISHPAGE_NOAUTOCLOSE
	; !insertmacro MUI_UNFINISHPAGE_NOAUTOCLOSE
	; !insertmacro MUI_ABORTWARNING
	; !insertmacro MUI_UNABORTWARNING
	
	; !insertmacro MUI_CUSTOMFUNCTION_ABORT CustomOnUserAbort
	

	!insertmacro MUI_LANGUAGE "English"
	!insertmacro MUI_LANGUAGE "German"

; -----------------------------------------------------------------------------
; - Macros
; -----------------------------------------------------------------------------

!macro InstallSectLua major minor old
		Section /o "${major}.${minor}" "SectLua${major}${minor}"
			SetOutPath $INSTDIR\${major}${minor}
			
			CreateDirectory $INSTDIR\${major}${minor}\clibs
			CreateDirectory $INSTDIR\${major}${minor}\lua
			CreateDirectory $INSTDIR\${major}${minor}\include
			CreateDirectory $INSTDIR\${major}${minor}\lib
			CreateDirectory $INSTDIR\${major}${minor}\docs
			CreateDirectory $INSTDIR\${major}${minor}\example
			
			File /oname=lua${major}${minor}.exe   src\${major}${minor}\lua${major}${minor}.exe
			File /oname=luac${major}${minor}.exe  src\${major}${minor}\luac${major}${minor}.exe
			File /oname=wlua${major}${minor}.exe  src\${major}${minor}\wlua${major}${minor}.exe
			File /oname=lua${major}${minor}.dll   src\${major}${minor}\lua${major}${minor}.dll
			
			File /oname=lua\ilua.lua       src\${major}${minor}\lua\ilua.lua
			File /oname=include\lauxlib.h  src\${major}${minor}\include\lauxlib.h
			File /oname=include\lua.h      src\${major}${minor}\include\lua.h
			File /oname=include\lua.hpp    src\${major}${minor}\include\lua.hpp
			File /oname=include\luaconf.h  src\${major}${minor}\include\luaconf.h
			File /oname=include\lualib.h   src\${major}${minor}\include\lualib.h
			File /oname=lib\liblua${major}${minor}.a     src\${major}${minor}\lib\liblua${major}${minor}.a
			File /oname=lib\liblua${major}${minor}.dll   src\${major}${minor}\lib\lua${major}${minor}.dll
			
			# if old
			StrCmp "${old}" "true" 0 LuaNotOld${major}${minor}
			# then
				File /oname=lua${major}.${minor}.dll          src\${major}${minor}\lua${major}.${minor}.dll
				File /oname=lib\liblua${major}.${minor}.a     src\${major}${minor}\lib\liblua${major}.${minor}.a
				File /oname=lib\liblua${major}.${minor}.dll   src\${major}${minor}\lib\lua${major}.${minor}.dll
			# end
			LuaNotOld${major}${minor}:
			
			
				WriteRegStr HKCR ".lua${major}${minor}"  "" "Lua${major}${minor}.Script"
				WriteRegStr HKCR ".wlua${major}${minor}" "" "wLua${major}${minor}.Script"
				WriteRegStr HKCR ".luac${major}${minor}" "" "Lua${major}${minor}.Compiled"
				WriteRegStr HKCR  ".lua${major}${minor}\ContentType"   "" "text/plain"
				WriteRegStr HKCR  ".lua${major}${minor}\PerceivedType" "" "text"
				WriteRegStr HKCR ".wlua${major}${minor}\ContentType"   "" "text/plain"
				WriteRegStr HKCR ".wlua${major}${minor}\PerceivedType" "" "text"
				
				WriteRegStr HKCR "Lua${major}${minor}.Compiled" "" "Lua ${major}.${minor} compiled Script"
				WriteRegStr HKCR  "wLua${major}${minor}.Script" "" "Lua ${major}.${minor} promptless Script File"
				WriteRegStr HKCR   "Lua${major}${minor}.Script" "" "Lua ${major}.${minor} Script File"
				WriteRegExpandStr HKCR   "Lua${major}${minor}.Script\Shell\Open\Command" "" "$\"$INSTDIR\${major}${minor}\lua${major}${minor}.exe$\" $\"%1$\" %*"
				WriteRegExpandStr HKCR  "wLua${major}${minor}.Script\Shell\Open\Command" "" "$\"$INSTDIR\${major}${minor}\wlua${major}${minor}.exe$\" $\"%1$\" %*"
				WriteRegExpandStr HKCR "Lua${major}${minor}.Compiled\Shell\Open\Command" "" "$\"$INSTDIR\${major}${minor}\luac${major}${minor}.exe$\" $\"%1$\" %*"
				WriteRegStr HKCR "Lua${major}${minor}.Compiled\DefaultIcon" "" "$INSTDIR\${WIMIX_FOLDER}\icon\luac-file.ico"
				WriteRegStr HKCR  "wLua${major}${minor}.Script\DefaultIcon" "" "$INSTDIR\${WIMIX_FOLDER}\icon\lua-file.ico"
				WriteRegStr HKCR   "Lua${major}${minor}.Script\DefaultIcon" "" "$INSTDIR\${WIMIX_FOLDER}\icon\lua-file.ico"
				WriteRegExpandStr HKCR  "Lua${major}${minor}.Script\Shell\Edit\Command"  "" "$\"$INSTDIR\${WIMIX_FOLDER}\SciTE\SciTE.exe$\" $\"%1$\""
				WriteRegExpandStr HKCR "wLua${major}${minor}.Script\Shell\Edit\Command" "" "$\"$INSTDIR\${WIMIX_FOLDER}\SciTE\SciTE.exe$\" $\"%1$\""
				
				WriteRegStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "LUA_DEV_${major}_${minor}" "$INSTDIR\${major}${minor}"
			# if old
			StrCmp "${old}" "true" 0 +4
			# then
				WriteRegStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "LUA_CPATH" ".\?.dll;.\?${major}${minor}.dll;$INSTDIR\${major}${minor}\?.dll;$INSTDIR\${major}${minor}\?${major}${minor}.dll;$INSTDIR\${major}${minor}\clibs\?.dll;$INSTDIR\${major}${minor}\clibs\?${major}${minor}.dll;$INSTDIR\${major}${minor}\loadall.dll;$INSTDIR\${major}${minor}\clibs\loadall.dll"
				WriteRegStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "LUA_PATH" ".\?.lua;.\?.lua${major}${minor};$INSTDIR\${major}${minor}\lua\?.lua;$INSTDIR\${major}${minor}\lua\?.lua${major}${minor};$INSTDIR\${major}${minor}\lua\?\init.lua;$INSTDIR\${major}${minor}\lua\?\init.lua${major}${minor};$INSTDIR\${major}${minor}\?.lua;$INSTDIR\${major}${minor}\?.lua${major}${minor};$INSTDIR\${major}${minor}\?\init.lua;$INSTDIR\${major}${minor}\?\init.lua${major}${minor};$INSTDIR\${major}${minor}\lua\?.luac$INSTDIR\${major}${minor}\lua\?.luac${major}${minor}"
				Goto IfEndOldEnv
			# else
				WriteRegStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "LUA_CPATH_${major}_${minor}" ".\?.dll;.\?${major}${minor}.dll;$INSTDIR\${major}${minor}\?.dll;$INSTDIR\${major}${minor}\?${major}${minor}.dll;$INSTDIR\${major}${minor}\clibs\?.dll;$INSTDIR\${major}${minor}\clibs\?${major}${minor}.dll;$INSTDIR\${major}${minor}\loadall.dll;$INSTDIR\${major}${minor}\clibs\loadall.dll"
				WriteRegStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "LUA_PATH_${major}_${minor}" ".\?.lua;.\?.lua${major}${minor};$INSTDIR\${major}${minor}\lua\?.lua;$INSTDIR\${major}${minor}\lua\?.lua${major}${minor};$INSTDIR\${major}${minor}\lua\?\init.lua;$INSTDIR\${major}${minor}\lua\?\init.lua${major}${minor};$INSTDIR\${major}${minor}\?.lua;$INSTDIR\${major}${minor}\?.lua${major}${minor};$INSTDIR\${major}${minor}\?\init.lua;$INSTDIR\${major}${minor}\?\init.lua${major}${minor};$INSTDIR\${major}${minor}\lua\?.luac$INSTDIR\${major}${minor}\lua\?.luac${major}${minor}"
			# end
			IfEndOldEnv:
		SectionEnd
!macroend
!macro InstallSectLuaRocks major minor
		Section /o "${major}.${minor}" SectRocks${major}${minor}
			; SetOutPath $INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}
			
			Push $0
			Push $1
			FileOpen $0 "$PLUGINSDIR\instrocks${major}${minor}.cmd" w
			FileSeek $0 0 SET
			FileWrite $0 "@ECHO OFF$\r$\n"
			; FileWrite $0 "ECHO.Start Installation$\r$\n"
			FileWrite $0 "PUSHD $\"$INSTDIR\${WIMIX_FOLDER}\rocks\${WIMIX_FOLDER}$\"$\r$\n"
			FileWrite $0 "$\"$INSTDIR\${WIMIX_FOLDER}\rocks\${WIMIX_FOLDER}\win32\lua5.1\bin\lua5.1.exe$\" "
			FileWrite $0 "$\"$INSTDIR\${WIMIX_FOLDER}\rocks\${WIMIX_FOLDER}\install.bat$\" "
			FileWrite $0 "/P $\"$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}$\" "
			FileWrite $0 "/TREE $\"$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}\tree$\" "
			FileWrite $0 "/CMOD $\"$INSTDIR\${major}${minor}\clibs$\" "
			FileWrite $0 "/LUAMOD $\"$INSTDIR\${major}${minor}\lua$\" "
			FileWrite $0 "/LV ${major}.${minor} /LUA $\"$INSTDIR\${major}${minor}\$\" /MW /NOREG /Q"
			FileWrite $0 "$\r$\n"
			FileWrite $0 "POPD$\r$\n"
			; FileWrite $0 "PAUSE$\r$\n"
			FileClose $0
			ExecWait "$PLUGINSDIR\instrocks${major}${minor}.cmd"
			; ExecWait "$\"$INSTDIR\${WIMIX_FOLDER}\install\win32\lua5.1\bin\lua5.1.exe$\" $\"$INSTDIR\${WIMIX_FOLDER}\install\install.bat$\" /P $\"$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}$\" /TREE $\"$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}\tree$\" /CMOD $\"$INSTDIR\${major}${minor}\clibs$\" /LUAMOD $\"$INSTDIR\${major}${minor}\lua$\" /LV ${major}.${minor} /LUA $\"$INSTDIR\${major}${minor}\$\" /MW /NOREG /Q"
			Delete "$PLUGINSDIR\instrocks${major}${minor}.cmd"
			Pop $1
			Pop $0
			
			CopyFiles "$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}\luarocks.bat" "$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}\luarocks${major}${minor}.bat"
			CopyFiles "$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}\luarocks-admin.bat" "$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}\luarocks-admin${major}${minor}.bat"
			CopyFiles "$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}\luarocksw.bat" "$INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}\luarocksw${major}${minor}.bat"
			
			; File /oname=LuaRocks${major}${minor}.txt dummy.txt
		SectionEnd
!macroend
!macro InstallSectDefault major minor
		Section /o "${major}.${minor}" SectDef${major}${minor}
			Push $0
			FileOpen $0 "$INSTDIR\${WIMIX_FOLDER}\default-version.txt" w
			IfErrors 0 +2
				Abort
			
			FileSeek $0 0 SET
			FileWrite $0 "${major}${minor}$\r$\n"
			FileClose $0
			Pop $0
			
			WriteRegStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "LUA_DEV" "$INSTDIR\${major}${minor}"
		SectionEnd
!macroend

!macro UninstallSectLua major minor old
		Section "un.${major}.${minor}" UnSectLua${major}${minor}
			RMDir /r $INSTDIR\${major}${minor}
			
				DeleteRegKey HKCR ".lua${major}${minor}"
				DeleteRegKey HKCR ".wlua${major}${minor}"
				DeleteRegKey HKCR ".luac${major}${minor}"
				DeleteRegKey HKCR "Lua${major}${minor}.Script"
				DeleteRegKey HKCR "wLua${major}${minor}.Script"
				DeleteRegKey HKCR "Lua${major}${minor}.Compiled"
				
				DeleteRegValue HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "LUA_DEV_${major}_${minor}"
			# if old
			StrCmp "${old}" "true" 0 +4
			# then
				DeleteRegValue HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "LUA_CPATH"
				DeleteRegValue HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "LUA_PATH"
				Goto IfEndOldEnv
			# else
				DeleteRegValue HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "LUA_CPATH_${major}_${minor}"
				DeleteRegValue HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "LUA_PATH_${major}_${minor}"
			# end
			IfEndOldEnv:
		SectionEnd
!macroend
!macro UninstallSectLuaRocks major minor
		Section "un.${major}.${minor}" UnSectRocks${major}${minor}
			; SetOutPath $INSTDIR\lua\rocks\${major}${minor}
			
			RMDir /r $INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}
			
			; File /oname=LuaRocks${major}${minor}.txt dummy.txt
		SectionEnd
!macroend
!macro UninstallSectDefault major minor
		Section "un.${major}.${minor}" UnSectDef${major}${minor}
			; Delete "$INSTDIR\${WIMIX_FOLDER}\default-version.txt"
		SectionEnd
!macroend

!macro PrepareLuaInstall major minor
	SectionGetFlags ${SectLua${major}${minor}} $R0
	IntOp $R0 $R0 & ${SF_SELECTED}
	StrCpy $DepLua${major}${minor} $R0
	
	SectionGetFlags ${SectRocks${major}${minor}} $R0
	IntOp $R0 $R0 & ${SF_SELECTED}
	StrCpy $DepRocks${major}${minor} $R0
	
	SectionGetFlags ${SectDef${major}${minor}} $R0
	IntOp $R0 $R0 & ${SF_SELECTED}
	StrCpy $DepDef${major}${minor} $R0
!macroend
!macro LuaDepency major minor
	; CheckLua${major}${minor}:
		SectionGetFlags ${SectLua${major}${minor}} $R0 ; Lua ${major}.${minor} flags (SectLua${major}${minor})
		IntOp $R0 $R0 & ${SF_SELECTED}                 ; mask selected flag
		# if (current != previous and not isSelected(current))
		StrCmp $R0 $DepLua${major}${minor} +4          ; if current != previous
		StrCmp $R0 ${SF_SELECTED} +3                   ;    and current is unselected
		# then ; deselected -> deselect Rocks ${major}.${minor}
			StrCpy $DepLua${major}${minor} $R0
			Goto DeselectRocks${major}${minor}
		# else
			StrCpy $DepLua${major}${minor} $R0
			Goto CheckRocks${major}${minor}
		# end
	
	DeselectRocks${major}${minor}:
		SectionGetFlags ${SectRocks${major}${minor}} $R0 ; Rocks ${major}.${minor} flags (SectRocks${major}${minor})
		IntOp $R0 $R0 & ${SF_SELECTED}                   ; mask selected flag
		# if (isSelected(current))
		StrCmp $R0 ${SF_SELECTED} 0 +5                   ; if current is selected
		# then ; deselect
			SectionGetFlags ${SectRocks${major}${minor}} $R0 ; Rocks ${major}.${minor} flags (SectRocks${major}${minor})
			IntOp $R0 $R0 | ${SF_SELECTED}                   ; select
			IntOp $R0 $R0 ^ ${SF_SELECTED}                   ; invert select
			SectionSetFlags ${SectRocks${major}${minor}} $R0 ; apply
		# end
		IntOp $R0 $R0 & ${SF_SELECTED}       ; mask selected flag
		StrCpy $DepRocks${major}${minor} $R0 ; save selection
	
	CheckRocks${major}${minor}:
		SectionGetFlags ${SectRocks${major}${minor}} $R0 ; Rocks ${major}.${minor} flags (SectRocks${major}${minor})
		IntOp $R0 $R0 & ${SF_SELECTED}                   ; mask seleted flag
		# if (current != previous and isSelected(current))
		StrCmp $R0 $DepRocks${major}${minor} +5          ; if current != previous
		StrCmp $R0 ${SF_SELECTED} 0 +4                   ;    and current is selected
		# then
			StrCpy $RequireMiWiRocks "true"      ; require MiWiRocks
			StrCpy $DepRocks${major}${minor} $R0 ; save selection
			Goto SelectLua${major}${minor}
		# else
			StrCpy $DepRocks${major}${minor} $R0 ; save selection
			Goto DoneCheckLua${major}${minor}
		# end
	
	SelectLua${major}${minor}:
		SectionGetFlags ${SectLua${major}${minor}} $R0 ; Lua ${major}.${minor} flags (SectLua${major}${minor})
		IntOp $R0 $R0 & ${SF_SELECTED}                 ; mask selected flag
		# if (not isSelected(current))
		StrCmp $R0 ${SF_SELECTED} +4                   ; if current is unselected
		# then ; deselect
			SectionGetFlags ${SectLua${major}${minor}} $R0 ; Lua ${major}.${minor} flags (SectLua${major}${minor})
			IntOp $R0 $R0 | ${SF_SELECTED}                 ; select
			SectionSetFlags ${SectLua${major}${minor}} $R0 ; apply
		# end
		IntOp $R0 $R0 & ${SF_SELECTED}     ; mask selected flag
		StrCpy $DepLua${major}${minor} $R0 ; save selection
	
	DoneCheckLua${major}${minor}:
!macroend
!macro CheckDef major minor
	SectionGetFlags ${SectDef${major}${minor}} $R0 ; Lua ${major}.${minor} As Deault flags (SectDef${major}${minor})
	IntOp $R0 $R0 & ${SF_SELECTED}                 ; mask selected flag
	# if (current != previous)
	StrCmp $R0 $DepDef${major}${minor} CheckDef${major}${minor} ; if current != previous
	# then
		# if (isSelected(current))
		StrCmp $R0 ${SF_SELECTED} 0 CheckDefSel${major}${minor} ;    and current is selected
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
		CheckDefSel${major}${minor}:
		; activate it again; cannot be unset
		StrCpy $DepDef "${major}${minor}" ;set current default
		IntOp $TempSectLua${major}${minor} $TempSectLua${major}${minor} | ${SF_SELECTED}
		IntOp $TempSectLua${major}${minor} $TempSectLua${major}${minor} | ${SF_RO}
		IntOp $TempSectDef${major}${minor} $TempSectDef${major}${minor} | ${SF_SELECTED}
	# end
	CheckDef${major}${minor}:
!macroend


; -----------------------------------------------------------------------------
; - Settings
; -----------------------------------------------------------------------------

!include Sections.nsh

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

; -----------------------------------------------------------------------------
; - Installing
; -----------------------------------------------------------------------------

Section ""
	SectionIn RO
	SetOutPath $INSTDIR
	
	
	SetOutPath $INSTDIR\${WIMIX_FOLDER}
	File /oname=7z.exe src\${WIMIX_FOLDER}\7z.exe
	File /oname=7z.dll src\${WIMIX_FOLDER}\7z.dll
	
	File /oname=lua.cmd   src\${WIMIX_FOLDER}\lua.cmd
	File /oname=wlua.cmd  src\${WIMIX_FOLDER}\wlua.cmd
	File /oname=luac.cmd  src\${WIMIX_FOLDER}\luac.cmd
	File /oname=ilua.cmd  src\${WIMIX_FOLDER}\ilua.cmd
	
	;; lua
	SetOutPath $INSTDIR\${WIMIX_FOLDER}\icon
	File /oname=lua-file.ico       src\${WIMIX_FOLDER}\icon\lua-file.ico
	File /oname=luac-file.ico      src\${WIMIX_FOLDER}\icon\luac-file.ico
	File /oname=luarocks-file.ico  src\${WIMIX_FOLDER}\icon\luarocks-file.ico
	
	;; lua\arc
	; CreateDirectory $INSTDIR\lua\arc
	SetOutPath $INSTDIR\${WIMIX_FOLDER}\arc
	StrCmp $Bits "32" 0 +7
	# then ; 32
		File /oname=lua-5.1.5_Win32_bin.zip        src\${WIMIX_FOLDER}\arc\lua-5.1.5_Win32_bin.zip
		File /oname=lua-5.2.4_Win32_bin.zip        src\${WIMIX_FOLDER}\arc\lua-5.2.4_Win32_bin.zip
		File /oname=lua-5.3.4_Win32_bin.zip        src\${WIMIX_FOLDER}\arc\lua-5.3.4_Win32_bin.zip
		File /oname=lua-5.1.5_Win32_dllw4_lib.zip  src\${WIMIX_FOLDER}\arc\lua-5.1.5_Win32_dllw4_lib.zip
		File /oname=lua-5.2.4_Win32_dllw4_lib.zip  src\${WIMIX_FOLDER}\arc\lua-5.2.4_Win32_dllw4_lib.zip
		File /oname=lua-5.3.4_Win32_dllw4_lib.zip  src\${WIMIX_FOLDER}\arc\lua-5.3.4_Win32_dllw4_lib.zip
	# end
	StrCmp $Bits "64" 0 +7
	# then ; 64
		File /oname=lua-5.1.5_Win64_bin.zip        src\${WIMIX_FOLDER}\arc\lua-5.1.5_Win64_bin.zip
		File /oname=lua-5.2.4_Win64_bin.zip        src\${WIMIX_FOLDER}\arc\lua-5.2.4_Win64_bin.zip
		File /oname=lua-5.3.4_Win64_bin.zip        src\${WIMIX_FOLDER}\arc\lua-5.3.4_Win64_bin.zip
		File /oname=lua-5.1.5_Win64_dllw4_lib.zip  src\${WIMIX_FOLDER}\arc\lua-5.1.5_Win64_dllw4_lib.zip
		File /oname=lua-5.2.4_Win64_dllw4_lib.zip  src\${WIMIX_FOLDER}\arc\lua-5.2.4_Win64_dllw4_lib.zip
		File /oname=lua-5.3.4_Win64_dllw4_lib.zip  src\${WIMIX_FOLDER}\arc\lua-5.3.4_Win64_dllw4_lib.zip
	# end
	File /oname=luarocks.cmd        src\${WIMIX_FOLDER}\arc\luarocks.cmd
	File /oname=luarocks-admin.cmd  src\${WIMIX_FOLDER}\arc\luarocks-admin.cmd
	File /oname=luarocksw.cmd       src\${WIMIX_FOLDER}\arc\luarocksw.cmd
	
	
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
		
		WriteRegStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "LUA_MIWI" "$INSTDIR"
	
		WriteRegStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "LUA_MIWI" "$INSTDIR"
	
	WriteUninstaller $INSTDIR\uninstall.exe
	
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayName" "${APP_NAME} ${APP_VERSION}"
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
	
SectionEnd

Section "Add MiWi to Path" SectPath
	GetTempFileName $0
	File /oname=$0 "append_if_missing.vbs"
	Exec "$\"$SYSDIR\WScript.exe$\" $0 //E:VBScript //B //NOLOGO $\"$INSTDIR\${WIMIX_FOLDER}$\""
SectionEnd

Section /o "-MiWiRocks" SectWiMixRocks
	; SectionIn RO
	
	CreateDirectory $INSTDIR\${WIMIX_FOLDER}\rocks\${WIMIX_FOLDER}
	
	SetOutPath $INSTDIR\${WIMIX_FOLDER}\rocks\${WIMIX_FOLDER}
	File /r src\${WIMIX_FOLDER}\rocks\${WIMIX_FOLDER}\*
	
	SetOutPath $INSTDIR\${WIMIX_FOLDER}
	File /oname=luarocks.cmd       src\${WIMIX_FOLDER}\arc\luarocks.cmd
	File /oname=luarocks-admin.cmd src\${WIMIX_FOLDER}\arc\luarocks-admin.cmd
	File /oname=luarocksw.cmd      src\${WIMIX_FOLDER}\arc\luarocksw.cmd
	
		WriteRegStr HKCR ".rockspec" "" "Lua.Rockspec"
		WriteRegStr HKCR ".rockspec\ContentType"   "" "text/plain"
		WriteRegStr HKCR ".rockspec\PerceivedType" "" "text"
		
		WriteRegStr HKCR "Lua.Rockspec" "" "Lua Rockspec File"
		WriteRegExpandStr HKCR "Lua.Rockspec\Shell\Open\Command" "" "$\"$INSTDIR\${WIMIX_FOLDER}\luarocksw.bat$\" make $\"%1$\""
		
		WriteRegStr HKCR "Lua.Rockspec\DefaultIcon" "" "$INSTDIR\${WIMIX_FOLDER}\icon\luarocks-file.ico"
		WriteRegStr HKCR "Lua.Rockspec\Shell" "" "Edit"
		WriteRegStr HKCR "Lua.Rockspec\Shell\Fetch" "" "Fetch"
		WriteRegStr HKCR "Lua.Rockspec\Shell\Install" "" "Install Lua-module"
		WriteRegStr HKCR "Lua.Rockspec\Shell\Uninstall" "" "Uninstall Lua-module (this version)"
		WriteRegStr HKCR "Lua.Rockspec\Shell\UninstallAll" "" "Uninstall Lua-module (all versions)"
		
		WriteRegExpandStr HKCR "Lua.Rockspec\Shell\Edit\Command" "" "$\"$INSTDIR\${WIMIX_FOLDER}\SciTE\SciTE.exe$\" $\"%1$\""
		WriteRegExpandStr HKCR "Lua.Rockspec\Shell\Fetch\Command" "" "$\"$INSTDIR\${WIMIX_FOLDER}\rocks\luarocksw.bat$\" install $\"%1$\""
		WriteRegExpandStr HKCR "Lua.Rockspec\Shell\Install\Command" "" "$\"$INSTDIR\${WIMIX_FOLDER}\luarocksw.bat$\" make $\"%1$\""
		WriteRegExpandStr HKCR "Lua.Rockspec\Shell\Uninstall\Command" "" "$\"$INSTDIR\${WIMIX_FOLDER}\luarocksw.bat$\" remove $\"%1$\""
		WriteRegExpandStr HKCR "Lua.Rockspec\Shell\UninstallAll\Command" "" "$\"$INSTDIR\${WIMIX_FOLDER}\luarocksw.bat$\" removeall $\"%1$\""
	
	; File /oname=MiWiRocks.txt dummy.txt
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

Section	"-RunLast" SectRunLast
	SectionIn RO
SectionEnd

; -----------------------------------------------------------------------------
; - Uninstalling
; -----------------------------------------------------------------------------

Section "un.Add MiWi to Path" UnSectPath
	GetTempFileName $0
	File /oname=$0 "remove_if_present.vbs"
	Exec "$\"$SYSDIR\WScript.exe$\" $0 //E:VBScript //B //NOLOGO $\"$INSTDIR\${WIMIX_FOLDER}$\""
SectionEnd

	SectionGroup "un.Lua" UnSectLua
		!insertmacro UninstallSectLua 5 1 "true"
		!insertmacro UninstallSectLua 5 2 "false"
		!insertmacro UninstallSectLua 5 3 "false"
	SectionGroupEnd
	
	SectionGroup "un.LuaRocks" UnSectLuaRocks
		!insertmacro UninstallSectLuaRocks 5 1
		!insertmacro UninstallSectLuaRocks 5 2
		!insertmacro UninstallSectLuaRocks 5 3
	SectionGroupEnd
	
	SectionGroup "un.Default" UnSectDef
		!insertmacro UninstallSectDefault 5 1
		!insertmacro UninstallSectDefault 5 2
		!insertmacro UninstallSectDefault 5 3
	SectionGroupEnd

Section "un.MiWiRocks" UnSectWiMicRocks
	SectionIn RO
	SetOutPath $INSTDIR
	
	RMDir /r $INSTDIR\${WIMIX_FOLDER}\rocks
	
	Delete $INSTDIR\${WIMIX_FOLDER}\luarocks.cmd
	Delete $INSTDIR\${WIMIX_FOLDER}\luarocks-admin.cmd
	Delete $INSTDIR\${WIMIX_FOLDER}\luarocksw.cmd
	
		DeleteRegKey HKCR ".rockspec"
		DeleteRegKey HKCR "Lua.Rockspec"
	
	DeleteRegKey HKLM "SOFTWARE\${APP_NAME}"
SectionEnd

Section "Uninstall"
	SectionIn RO
	/*
	RMDir /r $INSTDIR\${WIMIX_FOLDER}
	
		DeleteRegKey HKCR ".lua"
		DeleteRegKey HKCR ".wlua"
		DeleteRegKey HKCR ".luac"
		DeleteRegKey HKCR "Lua.Script"
		DeleteRegKey HKCR "wLua.Script"
		DeleteRegKey HKCR "Lua.Compiled"
		
		DeleteRegValue HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "LUA_DEV"
		DeleteRegValue HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "LUA_MIWI"
	
	; */
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
		
		DeleteRegValue HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "LUA_DEV"
		DeleteRegValue HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "LUA_MIWI"
	
	
	MessageBox MB_YESNO "remove uninstaller?" /SD IDYES IDNO DontRemoveUninstaller
		DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
		Delete $INSTDIR\uninstall.exe
	DontRemoveUninstaller:
	
	MessageBox MB_YESNO "remove install dir (only works if empty)?" /SD IDYES IDNO DontRemoveDir
		RMDir $INSTDIR
	DontRemoveDir:
SectionEnd

; -----------------------------------------------------------------------------
; - Language
; -----------------------------------------------------------------------------

LangString DESC_SectLua      ${LANG_ENGLISH} "Choose which Lua versions to install (default version is mndatory)"
LangString DESC_SectLua51    ${LANG_ENGLISH} "Lua version 5.1"
LangString DESC_SectLua52    ${LANG_ENGLISH} "Lua version 5.2"
LangString DESC_SectLua53    ${LANG_ENGLISH} "Lua version 5.3"
LangString DESC_SectRocks    ${LANG_ENGLISH} "Choose which Lua version should get a LuaRocks installation (optional)"
LangString DESC_SectRocks51  ${LANG_ENGLISH} "LuaRocks for Lua version 5.1"
LangString DESC_SectRocks52  ${LANG_ENGLISH} "LuaRocks for Lua version 5.2"
LangString DESC_SectRocks53  ${LANG_ENGLISH} "LuaRocks for Lua version 5.3"
LangString DESC_SectDef      ${LANG_ENGLISH} "Choose which Lua version should be set as default (mandatory)"
LangString DESC_SectDef51    ${LANG_ENGLISH} "Set Lua 5.1 as default Lua version"
LangString DESC_SectDef52    ${LANG_ENGLISH} "Set Lua 5.2 as default Lua version"
LangString DESC_SectDef53    ${LANG_ENGLISH} "Set Lua 5.3 as default Lua version"
LangString DESC_SectPath     ${LANG_ENGLISH} "Adds LuaWiMix to the environment-variable Path. This way you will be able to call it in the commandline (cmd.exe)"

LangString DESC_SectLua      ${LANG_GERMAN} "Wähle die zu installierenden Lua-Versionen aus (Die standard-Version muss installiert werden)"
LangString DESC_SectLua51    ${LANG_GERMAN} "Lua Version 5.1"
LangString DESC_SectLua52    ${LANG_GERMAN} "Lua Version 5.2"
LangString DESC_SectLua53    ${LANG_GERMAN} "Lua Version 5.3"
LangString DESC_SectRocks    ${LANG_GERMAN} "Wähle aus, welche Lua Version(en) eine LuaRocks installation erhalten sollen (optional)"
LangString DESC_SectRocks51  ${LANG_GERMAN} "LuaRocks für Lua version 5.1"
LangString DESC_SectRocks52  ${LANG_GERMAN} "LuaRocks für Lua version 5.2"
LangString DESC_SectRocks53  ${LANG_GERMAN} "LuaRocks für Lua version 5.3"
LangString DESC_SectDef      ${LANG_GERMAN} "Wähle die Standard Lua-Version aus (pflicht)"
LangString DESC_SectDef51    ${LANG_GERMAN} "Setzt Lua 5.1 als Standardversion fest"
LangString DESC_SectDef52    ${LANG_GERMAN} "Setzt Lua 5.2 als Standardversion fest"
LangString DESC_SectDef53    ${LANG_GERMAN} "Setzt Lua 5.3 als Standardversion fest"
LangString DESC_SectPath     ${LANG_GERMAN} "Fügt LuaWiMix der Umgebungsvariable Path hinzu. Auf diese Weise kann lua (und luarocks) in der Kommandozeile (cmd.exe) genutzt werden."

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${SectLua51}   $(DESC_SectLua51)
	!insertmacro MUI_DESCRIPTION_TEXT ${SectLua52}   $(DESC_SectLua52)
	!insertmacro MUI_DESCRIPTION_TEXT ${SectLua53}   $(DESC_SectLua53)
	!insertmacro MUI_DESCRIPTION_TEXT ${SectRocks51} $(DESC_SectRocks51)
	!insertmacro MUI_DESCRIPTION_TEXT ${SectRocks52} $(DESC_SectRocks52)
	!insertmacro MUI_DESCRIPTION_TEXT ${SectRocks53} $(DESC_SectRocks53)
	!insertmacro MUI_DESCRIPTION_TEXT ${SectDef51}   $(DESC_SectDef51)
	!insertmacro MUI_DESCRIPTION_TEXT ${SectDef52}   $(DESC_SectDef52)
	!insertmacro MUI_DESCRIPTION_TEXT ${SectDef53}   $(DESC_SectDef53)
	!insertmacro MUI_DESCRIPTION_TEXT ${SectPath}    $(DESC_SectPath)
!insertmacro MUI_FUNCTION_DESCRIPTION_END
; }

; -----------------------------------------------------------------------------
; - Initialize
; -----------------------------------------------------------------------------
Function .onInit
    InitPluginsDir
	StrCpy $Language ${LANG_ENGLISH}
    !insertmacro MUI_LANGDLL_DISPLAY
	StrCpy $Bits "32" ; we currently only support 32 bits :P
	
	; check if installing is ok...
	; check for mingw32?
	; Abort if not
	
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
	
	SectionGetFlags ${SectWiMixRocks} $R0
	IntOp $R0 $R0 & ${SF_SELECTED}
	StrCpy $DepMiWiRocks $R0
	
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
	
	; --------------------------------------
	; - Lua 5.1
	; --------------------------------------
	
	!insertmacro LuaDepency 5 1
	!insertmacro LuaDepency 5 2
	!insertmacro LuaDepency 5 3
	
	; CheckMiWiRocks:
			; MessageBox MB_OK $RequireMiWiRocks
		StrCmp $RequireMiWiRocks "true" 0 +5
		# then
			SectionGetFlags ${SectWiMixRocks} $R0 ; MiWiRocks flags (SectMiWiRocks)
			IntOp $R0 $R0 | ${SF_SELECTED}        ; select
			SectionSetFlags ${SectWiMixRocks} $R0 ; apply
			Goto CheckDef
		# else
			; SectionGetFlags ${SectWiMixRocks} $R0 ; MiWiRocks flags (SectWiMixRocks)
			; IntOp $R0 $R0 | ${SF_SELECTED}        ; select
			; IntOp $R0 $R0 ^ ${SF_SELECTED}        ; invert select
			; SectionSetFlags ${SectWiMixRocks} $R0 ; apply
		# end
	
	CheckDef:
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

/*
Function CustomOnUserAbort
;FIXME: translation
	MessageBox MB_YESNO "Cancel Installation?" IDYES DontCancel
		; save an uninstaller
		WriteUninstaller $INSTDIR\uninstall.exe
		; run uninstaller
		Exec $INSTDIR\uninstall.exe
	DontCancel:
FunctionEnd
; */
Function .onInstSuccess
	WriteUninstaller $INSTDIR\uninstall.exe
	
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayName" "${APP_NAME} ${APP_VERSION}"
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
	
FunctionEnd
Function .onInstFailed
	; save an uninstaller
	WriteUninstaller $INSTDIR\uninstall.exe
	; run uninstaller
	Exec $INSTDIR\uninstall.exe
FunctionEnd

/*
Section /o "LuaRocks 5.1"
	; Only if Section "Lua 5.1"
	ExecWait "install\install.bat /P $\"$INSTDIR\lua\rocks\51$\" /TREE $\"$INSTDIR\lua\rocks\51\tree$\" /LUA $\"$INSTDIR\51\$\" /MW /CMOD $\"$INSTDIR\51\clibs$\" /LUAMOD $\"$INSTDIR\51\lua$\""
	; SetOutPath $INSTDIR\lua\rocks
SectionEnd
; -----------------------------------------------------------------------------
; - Uninstalling
; -----------------------------------------------------------------------------
	Var SMFOLDER
	!insertmacro MUI_STARTMENU_GETFOLDER page_id $SMFOLDER
		Delete "$SMPROGRAMS\$SMFOLDER"
	
; uninstall startmenu...
; */

; -----------------------------------------------------------------------------
; - Notes
; -----------------------------------------------------------------------------

; DeleteRegKey HKLM "SOFTWARE\${NAME}"