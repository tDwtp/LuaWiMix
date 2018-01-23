!define APP_VERSION_MAJOR 0
!define APP_VERSION_MINOR 0
!define APP_VERSION_BUILD 2
!define APP_VERSION "${APP_VERSION_MAJOR}.${APP_VERSION_MINOR}"
!define APP_VERSION_FULL "${APP_VERSION_MAJOR}.${APP_VERSION_MINOR}-${APP_VERSION_BUILD}"

!define DUMMY "Dummy"
!define INSTDIRBASE "$APPDATA\Dummy"
!ifndef INSTDIRBASE
	!define INSTDIRBASE "$PROGRAMFILES"
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
	; !define UMUI_SKIN "wimix"

	!define UMUI_SKIN "wimix"

	; registry settings
	!define UMUI_PARAMS_REGISTRY_ROOT HKLM
	!define UMUI_PARAMS_REGISTRY_KEY "Software\${APP_NAME}\Installer"
	
	!define UMUI_INSTALLDIR_REGISTRY_VALUENAME "InstallDirectory"
	!define UMUI_UNINSTALLPATH_REGISTRY_VALUENAME "UninstallPath"
	!define UMUI_INSTALLERFULLPATH_REGISTRY_VALUENAME "InstallPath"
	
	!define UMUI_UNINSTALL_FULLPATH "$INSTDIR\Uninstall.exe"
	; !define UMUI_PREUNINSTALL_FUNCTION preuninstall_function

	; pages
	!insertmacro UMUI_PAGE_MULTILANGUAGE
	!insertmacro MUI_PAGE_WELCOME
	!insertmacro MUI_PAGE_LICENSE "..\LICENSE"
	!insertmacro MUI_PAGE_COMPONENTS


!include ".\Languages.nsh"
!include ".\InstallSections.nsh"
!include ".\UninstallSections.nsh"
