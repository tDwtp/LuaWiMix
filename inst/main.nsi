!define APP_VERSION_MAJOR 0
!define APP_VERSION_MINOR 1
!define APP_VERSION_BUILD 2
!define APP_VERSION "${APP_VERSION_MAJOR}.${APP_VERSION_MINOR}"
!define APP_VERSION_FULL "${APP_VERSION_MAJOR}.${APP_VERSION_MINOR}-${APP_VERSION_BUILD}"

!define DUMMY "Dummy"
!if DUMMY == ""
	!define INSTDIRBASE "$PROGRAMFILES"
!else
	!define INSTDIRBASE "$APPDATA\Dummy"
!endif

!define APP_NAME "${DUMMY}LuaWiMix"
!define WIMIX_FOLDER "wimix"

; -----------------------------------------------------------------------------
; - 
; -----------------------------------------------------------------------------

Unicode True
RequestExecutionLevel admin
BrandingText "${APP_NAME} ${APP_VERSION_FULL}"
Name "${APP_NAME} ${APP_VERSION}"
OutFile "${APP_NAME}-${APP_VERSION_FULL}.exe"
InstallDir "${INSTDIRBASE}\${APP_NAME}"
; InstallDirRegKey HKLM "SOFTWARE\${APP_NAME}" "InstallDirectory"

!include UMUI.nsh

	;        skins: blue brown darkgreen gray green purple red 
	;   soft skins: SoftBlue SoftBrown SoftGray SoftGreen SoftPurple SoftRed
	; custom skins: wimix unwimix
	; !define UMUI_SKIN "name"

	!define UMUI_SKIN "wimix"

	; registry settings
	!define UMUI_PARAMS_REGISTRY_ROOT HKLM
	!define UMUI_PARAMS_REGISTRY_KEY "Software\${APP_NAME}\Installer"
	
	!define UMUI_INSTALLDIR_REGISTRY_VALUENAME "InstallDirectory"
	!define UMUI_UNINSTALLPATH_REGISTRY_VALUENAME "UninstallPath"
	!define UMUI_INSTALLERFULLPATH_REGISTRY_VALUENAME "InstallPath"
	
	!define UMUI_UNINSTALL_FULLPATH "$INSTDIR\Uninstall.exe"
	; !define UMUI_PREUNINSTALL_FUNCTION preuninstall_function

	!define UMUI_SETUPTYPEPAGE_MINIMAL "$(UMUI_TEXT_SETUPTYPE_MINIMAL_TITLE)"
	!define UMUI_SETUPTYPEPAGE_STANDARD "$(UMUI_TEXT_SETUPTYPE_STANDARD_TITLE)"
	!define UMUI_SETUPTYPEPAGE_COMPLETE "$(UMUI_TEXT_SETUPTYPE_COMPLETE_TITLE)"
	!define UMUI_SETUPTYPEPAGE_DEFAULTCHOICE ${UMUI_STANDARD}
	
	; pages
	!insertmacro UMUI_PAGE_MULTILANGUAGE
	!insertmacro MUI_PAGE_WELCOME
	; !insertmacro UMUI_PAGE_MAINTENANCE
	!insertmacro MUI_PAGE_LICENSE "..\LICENSE"
	!insertmacro UMUI_PAGE_SETUPTYPE
	!insertmacro MUI_PAGE_COMPONENTS
	!insertmacro MUI_PAGE_DIRECTORY
	; !insertmacro MUI_PAGE_INSTFILES
	!insertmacro MUI_PAGE_FINISH

	!insertmacro MUI_UNPAGE_CONFIRM
	; !insertmacro UMUI_UNPAGE_MAINTENANCE
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

	
	; !insertmacro UMUI_PAGE_MULTILANGUAGE
	; !insertmacro MUI_PAGE_WELCOME
	; !insertmacro MUI_PAGE_LICENSE "..\LICENSE"
	; !insertmacro MUI_PAGE_COMPONENTS

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "German"


!include ".\InstallSections.nsh"
!include ".\UninstallSections.nsh"
!include ".\Languages.nsh"
