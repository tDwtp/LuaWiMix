!ifndef __LANGUAGES_H__
!define __LANGUAGES_H__

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "German"

/*
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
LangString DESC_SectPath     ${LANG_GERMAN} "Fügt LuaWiMix der Umgebungsvariable Path an. Auf diese Weise kann lua (und luarocks) in der Kommandozeile (cmd.exe) genutzt werden."

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
; */

!endif