Unicode true
RequestExecutionLevel user

!include "MUI2.nsh"

!ifndef PAYLOAD_DIR
  !error "PAYLOAD_DIR must point to the tested standalone payload"
!endif
!ifndef OUTPUT_FILE
  !define OUTPUT_FILE "OneBoardLocalFileSort-Setup-1.0.0-win-x64.exe"
!endif
!ifndef PRODUCT_ICON
  !define PRODUCT_ICON "..\..\branding\OneBoardLocalFileSort.ico"
!endif

!define PRODUCT_NAME "OneBoard Local File Sort"
!define PRODUCT_VERSION "1.0.0"
!define PRODUCT_PUBLISHER "OneBoard"
!define PRODUCT_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\OneBoardLocalFileSort"

Name "${PRODUCT_NAME}"
OutFile "${OUTPUT_FILE}"
InstallDir "$LOCALAPPDATA\Programs\OneBoardLocalFileSort"
InstallDirRegKey HKCU "${PRODUCT_KEY}" "InstallLocation"
Icon "${PRODUCT_ICON}"
UninstallIcon "${PRODUCT_ICON}"
BrandingText "OneBoard"

!define MUI_ABORTWARNING
!define MUI_ICON "${PRODUCT_ICON}"
!define MUI_UNICON "${PRODUCT_ICON}"
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Vietnamese"

Section "OneBoard Local File Sort" SEC_MAIN
  SectionIn RO
  SetOutPath "$INSTDIR"
  File /r "${PAYLOAD_DIR}\*.*"
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  CreateDirectory "$SMPROGRAMS\OneBoard Local File Sort"
  CreateShortcut "$SMPROGRAMS\OneBoard Local File Sort\OneBoard Local File Sort.lnk" "$INSTDIR\OneBoardLocalFileSort.exe" "" "$INSTDIR\OneBoardLocalFileSort.exe"
  CreateShortcut "$SMPROGRAMS\OneBoard Local File Sort\Uninstall.lnk" "$INSTDIR\Uninstall.exe"

  WriteRegStr HKCU "${PRODUCT_KEY}" "DisplayName" "${PRODUCT_NAME}"
  WriteRegStr HKCU "${PRODUCT_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr HKCU "${PRODUCT_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  WriteRegStr HKCU "${PRODUCT_KEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKCU "${PRODUCT_KEY}" "DisplayIcon" "$INSTDIR\OneBoardLocalFileSort.exe"
  WriteRegStr HKCU "${PRODUCT_KEY}" "UninstallString" '"$INSTDIR\Uninstall.exe"'
  WriteRegDWORD HKCU "${PRODUCT_KEY}" "NoModify" 1
  WriteRegDWORD HKCU "${PRODUCT_KEY}" "NoRepair" 1
SectionEnd

Section /o "Desktop shortcut" SEC_DESKTOP
  CreateShortcut "$DESKTOP\OneBoard Local File Sort.lnk" "$INSTDIR\OneBoardLocalFileSort.exe" "" "$INSTDIR\OneBoardLocalFileSort.exe"
SectionEnd

LangString DESC_SEC_MAIN ${LANG_ENGLISH} "Install the tested OneBoard application payload."
LangString DESC_SEC_MAIN ${LANG_VIETNAMESE} "Cài đặt bộ ứng dụng OneBoard đã được kiểm thử."
LangString DESC_SEC_DESKTOP ${LANG_ENGLISH} "Create a desktop shortcut."
LangString DESC_SEC_DESKTOP ${LANG_VIETNAMESE} "Tạo lối tắt trên màn hình nền."
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_MAIN} $(DESC_SEC_MAIN)
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_DESKTOP} $(DESC_SEC_DESKTOP)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Section "Uninstall"
  Delete "$DESKTOP\OneBoard Local File Sort.lnk"
  Delete "$SMPROGRAMS\OneBoard Local File Sort\OneBoard Local File Sort.lnk"
  Delete "$SMPROGRAMS\OneBoard Local File Sort\Uninstall.lnk"
  RMDir "$SMPROGRAMS\OneBoard Local File Sort"
  RMDir /r "$INSTDIR"
  DeleteRegKey HKCU "${PRODUCT_KEY}"
SectionEnd
