!ifndef __INSTALL_SECTIONS_H__
!define __INSTALL_SECTIONS_H__

; -----------------------------------------------------------------------------
; - Macros
; -----------------------------------------------------------------------------

!macro AddToEnvironment var_name var_value
	Exec "$\"$SYSDIR\WScript.exe$\" $\"$INSTDIR\${WIMIX_FOLDER}\arc\addEnv.vbs$\" //E:VBScript //B //NOLOGO $\"${var_name}$\" $\"${var_value}$\""
!macroend
!macro RemoveFromEnvironment var_name
	Exec "$\"$SYSDIR\WScript.exe$\" $\"$INSTDIR\${WIMIX_FOLDER}\arc\remEnv.vbs$\" //E:VBScript //B //NOLOGO $\"${var_name}$\""
!macroend


!define OldVersion51
!macro InstallSectLua major minor old
	Section /o "${major}.${minor}" "SectLua${major}${minor}"
		SetOutPath "$INSTDIR\${major}${minor}"
		
		CreateDirectory "$INSTDIR\${major}${minor}\clibs"
		CreateDirectory "$INSTDIR\${major}${minor}\lua"
		CreateDirectory "$INSTDIR\${major}${minor}\include"
		CreateDirectory "$INSTDIR\${major}${minor}\lib"
		CreateDirectory "$INSTDIR\${major}${minor}\docs"
		CreateDirectory "$INSTDIR\${major}${minor}\example"
		
		File /oname=lua${major}${minor}.exe   "..\src\${major}${minor}\lua${major}${minor}.exe"
		File /oname=luac${major}${minor}.exe  "..\src\${major}${minor}\luac${major}${minor}.exe"
		File /oname=wlua${major}${minor}.exe  "..\src\${major}${minor}\wlua${major}${minor}.exe"
		File /oname=lua${major}${minor}.dll   "..\src\${major}${minor}\lua${major}${minor}.dll"
		File /oname=ilua${major}${minor}.bat  "..\src\wimix\arc\ilua.bat"
		
		File /oname=lua\ilua.lua       "..\src\${major}${minor}\lua\ilua.lua"
		File /oname=include\lauxlib.h  "..\src\${major}${minor}\include\lauxlib.h"
		File /oname=include\lua.h      "..\src\${major}${minor}\include\lua.h"
		File /oname=include\lua.hpp    "..\src\${major}${minor}\include\lua.hpp"
		File /oname=include\luaconf.h  "..\src\${major}${minor}\include\luaconf.h"
		File /oname=include\lualib.h   "..\src\${major}${minor}\include\lualib.h"
		File /oname=lib\liblua${major}${minor}.a     "..\src\${major}${minor}\lib\liblua${major}${minor}.a"
		File /oname=lib\liblua${major}${minor}.dll   "..\src\${major}${minor}\lib\lua${major}${minor}.dll"
		
		!ifdef OldVersion${major}${minor}
			File /oname=lua${major}.${minor}.dll          "src\${major}${minor}\lua${major}.${minor}.dll"
			File /oname=lib\liblua${major}.${minor}.a     "src\${major}${minor}\lib\liblua${major}.${minor}.a"
			File /oname=lib\liblua${major}.${minor}.dll   "src\${major}${minor}\lib\lua${major}.${minor}.dll"
		!endif
		
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
			
			!insertmacro AddToEnvironment "LUA_DEV_${major}_${minor}" "$INSTDIR\${major}${minor}"
		
		!ifdef OldVersion${major}${minor}
			!insertmacro AddToEnvironment "LUA_CPATH" ".\?.dll;.\?${major}${minor}.dll;$INSTDIR\${major}${minor}\?.dll;$INSTDIR\${major}${minor}\?${major}${minor}.dll;$INSTDIR\${major}${minor}\clibs\?.dll;$INSTDIR\${major}${minor}\clibs\?${major}${minor}.dll;$INSTDIR\${major}${minor}\loadall.dll;$INSTDIR\${major}${minor}\clibs\loadall.dll"
			!insertmacro AddToEnvironment "LUA_PATH"  ".\?.lua;.\?.lua${major}${minor};$INSTDIR\${major}${minor}\lua\?.lua;$INSTDIR\${major}${minor}\lua\?.lua${major}${minor};$INSTDIR\${major}${minor}\lua\?\init.lua;$INSTDIR\${major}${minor}\lua\?\init.lua${major}${minor};$INSTDIR\${major}${minor}\?.lua;$INSTDIR\${major}${minor}\?.lua${major}${minor};$INSTDIR\${major}${minor}\?\init.lua;$INSTDIR\${major}${minor}\?\init.lua${major}${minor};$INSTDIR\${major}${minor}\lua\?.luac$INSTDIR\${major}${minor}\lua\?.luac${major}${minor}"
		!else
			!insertmacro AddToEnvironment "LUA_CPATH_${major}_${minor}" ".\?.dll;.\?${major}${minor}.dll;$INSTDIR\${major}${minor}\?.dll;$INSTDIR\${major}${minor}\?${major}${minor}.dll;$INSTDIR\${major}${minor}\clibs\?.dll;$INSTDIR\${major}${minor}\clibs\?${major}${minor}.dll;$INSTDIR\${major}${minor}\loadall.dll;$INSTDIR\${major}${minor}\clibs\loadall.dll"
			!insertmacro AddToEnvironment "LUA_PATH_${major}_${minor}"  ".\?.lua;.\?.lua${major}${minor};$INSTDIR\${major}${minor}\lua\?.lua;$INSTDIR\${major}${minor}\lua\?.lua${major}${minor};$INSTDIR\${major}${minor}\lua\?\init.lua;$INSTDIR\${major}${minor}\lua\?\init.lua${major}${minor};$INSTDIR\${major}${minor}\?.lua;$INSTDIR\${major}${minor}\?.lua${major}${minor};$INSTDIR\${major}${minor}\?\init.lua;$INSTDIR\${major}${minor}\?\init.lua${major}${minor};$INSTDIR\${major}${minor}\lua\?.luac$INSTDIR\${major}${minor}\lua\?.luac${major}${minor}"
		!endif
		
		StrCmp ${minor} "3" 0 NotMinimal
			SectionIn 1 2
		NotMinimal:
			SectionIn 3
	SectionEnd
!macroend
!macro InstallSectLuaRocks major minor
		Section /o "${major}.${minor}" SectRocks${major}${minor}
			; SetOutPath $INSTDIR\${WIMIX_FOLDER}\rocks\${major}${minor}
			
			Push $0
			; Push $1
			FileOpen $0 "$PLUGINSDIR\instrocks${major}${minor}.cmd" w
			FileSeek $0 0 SET
			FileWrite $0 "@ECHO OFF$\r$\n"
			; FileWrite $0 "ECHO.Start Installation$\r$\n"
			FileWrite $0 "PUSHD $\"$INSTDIR\${WIMIX_FOLDER}\iser\rocks$\"$\r$\n"
			FileWrite $0 "$\"$INSTDIR\${WIMIX_FOLDER}\iser\rocks\win32\lua5.1\bin\lua5.1.exe$\" "
			FileWrite $0 "$\"$INSTDIR\${WIMIX_FOLDER}\iser\rocks\install.bat$\" "
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
			; Pop $1
			Pop $0
			
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
		File /oname=lua51x86.zip    ..\src\${WIMIX_FOLDER}\arc\lua51x86.zip
		File /oname=lua52x86.zip    ..\src\${WIMIX_FOLDER}\arc\lua52x86.zip
		File /oname=lua53x86.zip    ..\src\${WIMIX_FOLDER}\arc\lua53x86.zip
	# end
	StrCmp $Bits "64" 0 +7
	# then ; 64
		File /oname=lua51amd64.zip  ..\src\${WIMIX_FOLDER}\arc\lua51amd64.zip
		File /oname=lua52amd64.zip  ..\src\${WIMIX_FOLDER}\arc\lua52amd64.zip
		File /oname=lua53amd64.zip  ..\src\${WIMIX_FOLDER}\arc\lua53amd64.zip
	# end
	File /oname=luarocks.cmd        ..\src\${WIMIX_FOLDER}\arc\luarocks.cmd
	File /oname=luarocks-admin.cmd  ..\src\${WIMIX_FOLDER}\arc\luarocks-admin.cmd
	File /oname=luarocksw.cmd       ..\src\${WIMIX_FOLDER}\arc\luarocksw.cmd
	
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
		
		!insertmacro AddToEnvironment "LUA_MIWI" "$INSTDIR"
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
	
	
	
SectionEnd

Section "DummyA"
SectionEnd
Section "DummyB"
SectionEnd
Section "DummyC"
SectionEnd
Section "DummyD"
SectionEnd
Section "DummyE"
SectionEnd
Section "DummyF"
SectionEnd
Section "DummyG"
SectionEnd
Section "DummyH"
SectionEnd
Section "DummyI"
SectionEnd
Section "DummyJ"
SectionEnd
Section "DummyK"
SectionEnd
Section "DummyL"
SectionEnd
Section "DummyM"
SectionEnd
Section "DummyN"
SectionEnd
Section "DummyO"
SectionEnd
Section "DummyP"
SectionEnd
Section "DummyQ"
SectionEnd
Section "DummyS"
SectionEnd
Section "DummyT"
SectionEnd
Section "DummyU"
SectionEnd
Section "DummyV"
SectionEnd
Section "DummyW"
SectionEnd
Section "DummyX"
SectionEnd
Section "DummyY"
SectionEnd
Section "DummyZ"
SectionEnd

Function ".onInit"
	; default language english:
	; StrCpy $Language ${LANG_ENGLISH}
	!insertmacro UMUI_MULTILANG_GET
FunctionEnd

!endif