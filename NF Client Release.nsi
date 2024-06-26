; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "NF Client"
!define PRODUCT_VERSION "1.9.9" ;download PRODUCT_VERSION.7z
!define PRODUCT_PUBLISHER "NF Client"
!define PRODUCT_WEB_SITE "https://www.nfclient.kro.kr"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; MUI 1.67 compatible ------
!include "MUI.nsh"
!ifndef IPersistFile
!define IPersistFile {0000010b-0000-0000-c000-000000000046}
!endif
!ifndef CLSID_ShellLink
!define CLSID_ShellLink {00021401-0000-0000-C000-000000000046}
!define IID_IShellLinkA {000214EE-0000-0000-C000-000000000046}
!define IID_IShellLinkW {000214F9-0000-0000-C000-000000000046}
!define IShellLinkDataList {45e2b4ae-b1c3-11d0-b92f-00a0c90312e1}
	!ifdef NSIS_UNICODE
	!define IID_IShellLink ${IID_IShellLinkW}
	!else
	!define IID_IShellLink ${IID_IShellLinkA}
	!endif
!endif

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "nfclient.ico"
!define MUI_UNICON "nfclient.ico"
BrandingText "NF Client"

!define MUI_WELCOMEFINISHPAGE_BITMAP "나죠안 스킨.bmp"
; Welcome page
!insertmacro MUI_PAGE_WELCOME
Page custom Form1
!define MUI_PAGE_HEADER_TEXT "주의"
!define MUI_PAGE_HEADER_SUBTEXT "아래 내용은 꼭 읽어주세요."
; License page
!insertmacro MUI_PAGE_LICENSE "통합.txt"
LicenseForceSelection checkbox
; Directory page

; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH

; Language files
!insertmacro MUI_LANGUAGE "Korean"

; MUI end ------

;커스텀 페이지------------

ReserveFile "Form1.ini"

!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
;함수
Var 'CheckA'

;커스텀 페이지 압축풀기
Function .onInit
!insertmacro MUI_INSTALLOPTIONS_EXTRACT "Form1.ini"
FunctionEnd
;첫번째 설치 페이지 로드, 상단 굵은글씨와 얇은 글씨--
Function Form1
!insertmacro MUI_HEADER_TEXT '추가 구성 요소 선택' '원하는 추가 구성 요소를 설치하세요.'
!insertmacro MUI_INSTALLOPTIONS_DISPLAY_RETURN "Form1.ini"
FunctionEnd

Name "${PRODUCT_NAME} v${PRODUCT_VERSION}"
OutFile "NF Client Setup.exe"
RequestExecutionLevel admin
InstallDir "$APPDATA\.nfclient"
ShowInstDetails hide

Function ShellLinkSetRunAs
System::Store S
pop $9
System::Call "ole32::CoCreateInstance(g'${CLSID_ShellLink}',i0,i1,g'${IID_IShellLink}',*i.r1)i.r0"
${If} $0 = 0
	System::Call "$1->0(g'${IPersistFile}',*i.r2)i.r0" ;QI
	${If} $0 = 0
		System::Call "$2->5(w '$9',i 0)i.r0" ;Load
		${If} $0 = 0
			System::Call "$1->0(g'${IShellLinkDataList}',*i.r3)i.r0" ;QI
			${If} $0 = 0
				System::Call "$3->6(*i.r4)i.r0" ;GetFlags
				${If} $0 = 0
					System::Call "$3->7(i $4|0x2000)i.r0" ;SetFlags ;SLDF_RUNAS_USER
					${If} $0 = 0
						System::Call "$2->6(w '$9',i1)i.r0" ;Save
					${EndIf}
				${EndIf}
				System::Call "$3->2()" ;Release
			${EndIf}
		System::Call "$2->2()" ;Release
		${EndIf}
	${EndIf}
	System::Call "$1->2()" ;Release
${EndIf}
push $0
System::Store L
FunctionEnd

Section "MainSection" SEC01
  SetOverwrite on
  AddSize 1000000
  Messagebox MB_OKCANCEL "경고: NF Client에 따로 설치한 모드는 삭제됩니다.$\n$\n설치를 취소하시려면 취소를 누르세요" IDCANCEL END
  SetOutPath "$INSTDIR"
  File "start.bat"
  ExecWait '"start.bat"'
  delete "start.bat"
  Sleep 5000
  CreateDirectory "$APPDATA\.nfclient"
  ;delete "$INSTDIR\mods\*.*"
  iffileexists "$INSTDIR\essential\config.toml" eso esx
eso:
  iffileexists "$INSTDIR\essential\patched1" ifaddon esx
esx:
  SetOutPath "$INSTDIR\essential"
  File "나죠안\minecraft\essential\config.toml"
  File "나죠안\minecraft\essential\onboarding.json"
  File "나죠안\minecraft\essential\patched1"
  goto ifaddon
ifaddon:
  iffileexists "$INSTDIR\mods\1.12.2\slf4j-api-1.7.25.jar" addon nonaddon
addon:
  RMDir /r "$INSTDIR\mods\1.8.9"
  SetOutPath "$INSTDIR"
  File "나죠안\minecraft\1.12.2\launcher_profiles.json"
  goto main
nonaddon:
  RMDir /r "$INSTDIR\mods"
  SetOutPath "$INSTDIR"
  File "나죠안\minecraft\1.8.9\launcher_profiles.json"
  goto main
main:
  ;hack
  ;SetOutPath "$INSTDIR\versions"
  ;Nsisdl::download "https://blog.kakaocdn.net/dn/k74Yy/btqFIOze0RG/ckQOY9gpF5J4iMfcKJotH1/7z.exe?attach=1&knm=tfile.exe" "7z.exe"
  ;Nsisdl::download "https://blog.kakaocdn.net/dn/1KDXh/btqGUe4a5z1/h3AVVvvi6rJ6EbRKC7HpOK/Flux%201.8.8.7z.001?attach=1&knm=tfile.001" "Flux 1.8.8.7z.001"
  ;Nsisdl::download "https://blog.kakaocdn.net/dn/k07Wz/btqGU2oKNOc/Dd5rJlhdmwbkK32jSUApQk/Flux%201.8.8.7z.002?attach=1&knm=tfile.002" "Flux 1.8.8.7z.002"
  ;nsexec::exec '$INSTDIR\versions\7z.exe x "$instdir\versions\Flux 1.8.8.7z.001" "-aoa"'
  ;delete "Flux 1.8.8.7z.001"
  ;delete "Flux 1.8.8.7z.002"
  ;delete "7z.exe"
  ;modcore
  SetOutPath "$INSTDIR\modcore"
  File "나죠안\minecraft\modcore\config.toml"
  File "나죠안\minecraft\modcore\metadata.json"
  ;patcher
  SetOutPath "$INSTDIR\config"
  File "나죠안\minecraft\config\patcher.toml"
  File "나죠안\minecraft\config\splash.properties"
  ;launcher profiles
  SetOutPath "$INSTDIR"
  ;File "나죠안\minecraft\launcher_profiles.json"
  File "나죠안\minecraft\launcher_ui_state.json"
  ;config
  File "나죠안\minecraft\betterfps.txt"
  SetOutPath "$INSTDIR\config\CustomMainMenu"
  File "나죠안\minecraft\config\CustomMainMenu\mainmenu.json"
  ;smoothfont
  SetOutPath "$INSTDIR\config\smoothfont"
  File "나죠안\minecraft\config\smoothfont\smoothfont.cfg"
  ;forge
  SetOutPath "$INSTDIR"
  iffileexists "$INSTDIR\uninst.exe" YES NO
YES:
  Messagebox MB_YESNO "NF Client 2020.7 이상의 버전이 설치되어있습니다. $\n 설정파일을 유지하시겠습니까?" IDYES keep IDNO X
NO:
  iffileexists "$APPDATA\.minecraft\mods\customdiscordrpc-2.21-[1.8,1.8.9].jar" O X
X:
  SetOverwrite on
  Nsisdl::download "https://blog.kakaocdn.net/dn/k74Yy/btqFIOze0RG/ckQOY9gpF5J4iMfcKJotH1/7z.exe?attach=1&knm=tfile.exe" "7z.exe"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (1/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/bWXNDQ/btqGpxJvcQ0/YlGqjEvkRK9AiKIxus5Qr0/1.8.9%ED%8F%AC%EC%A7%80.7z.001?attach=1&knm=tfile.001" "1.8.9포지.7z.001"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (2/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/bB2nMS/btqGg52hF0m/FgiK6PJ4VFPYq8iKrE7WXK/1.8.9%ED%8F%AC%EC%A7%80.7z.002?attach=1&knm=tfile.002" "1.8.9포지.7z.002"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (3/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/EI2C6/btqGnZsH7Ou/0FOZ3MoK8wgKbNy7229XQk/1.8.9%ED%8F%AC%EC%A7%80.7z.003?attach=1&knm=tfile.003" "1.8.9포지.7z.003"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (4/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/8vKmS/btqGmOLKauu/nlBzKCU3tdxFkWVkwNdsR1/1.8.9%ED%8F%AC%EC%A7%80.7z.004?attach=1&knm=tfile.004" "1.8.9포지.7z.004"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (5/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/ln0Ca/btqGktPiMc4/r87TahFwcSbr4iFNqUMxcK/1.8.9%ED%8F%AC%EC%A7%80.7z.005?attach=1&knm=tfile.005" "1.8.9포지.7z.005"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (6/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/0w4ED/btqGmUZJF7R/lwWYy7SoMuh95ZG4BNs3Fk/1.8.9%ED%8F%AC%EC%A7%80.7z.006?attach=1&knm=tfile.006" "1.8.9포지.7z.006"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (7/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/XrV5j/btqGiSBlC6X/lnNcEoUlK2CmZKHrp5Rsj0/1.8.9%ED%8F%AC%EC%A7%80.7z.007?attach=1&knm=tfile.007" "1.8.9포지.7z.007"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (8/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/bNsi77/btqGg5nEUUz/KiGnHIWAINH7TXRAuD0RG1/1.8.9%ED%8F%AC%EC%A7%80.7z.008?attach=1&knm=tfile.008" "1.8.9포지.7z.008"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (9/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/rpHWN/btqGnHlivJ2/xv38YbR3cMZfofkMcbGpg1/1.8.9%ED%8F%AC%EC%A7%80.7z.009?attach=1&knm=tfile.009" "1.8.9포지.7z.009"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (10/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/dA3xk4/btqGnrC2GnI/IDPbpdGweiOVUkkChdQHZK/1.8.9%ED%8F%AC%EC%A7%80.7z.010?attach=1&knm=tfile.010" "1.8.9포지.7z.010"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (11/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/bKIB11/btqGkhhgR9I/lhmvSxJubiveYOacoBA510/1.8.9%ED%8F%AC%EC%A7%80.7z.011?attach=1&knm=tfile.011" "1.8.9포지.7z.011"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (12/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/du0Ajy/btqGfNHONtt/aUwtWrLoD8Krzwn4VbTjrk/1.8.9%ED%8F%AC%EC%A7%80.7z.012?attach=1&knm=tfile.012" "1.8.9포지.7z.012"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (13/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/brEknt/btqGfNHOKOi/IAO4WNkOQosImr9IRwYLZK/1.8.9%ED%8F%AC%EC%A7%80.7z.013?attach=1&knm=tfile.013" "1.8.9포지.7z.013"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (14/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/deJaLX/btqGip0sxBT/LUbGC1OogwOx1tXR6TUOIK/1.8.9%ED%8F%AC%EC%A7%80.7z.014?attach=1&knm=tfile.014" "1.8.9포지.7z.014"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (15/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/bCndXo/btqGiK5jiuu/xmFISA4sNBxsUZmreRUgU1/1.8.9%ED%8F%AC%EC%A7%80.7z.015?attach=1&knm=tfile.015" "1.8.9포지.7z.015"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (16/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/diRaLD/btqGnY1DKKS/zDUhbpOtbJ50iFekEtpGbk/1.8.9%ED%8F%AC%EC%A7%80.7z.016?attach=1&knm=tfile.016" "1.8.9포지.7z.016"
  nsexec::exec '$INSTDIR\7z.exe x "$instdir\1.8.9포지.7z.001" "-aoa"'
  delete "7z.exe"
  delete "1.8.9포지.7z.001"
  delete "1.8.9포지.7z.002"
  delete "1.8.9포지.7z.003"
  delete "1.8.9포지.7z.004"
  delete "1.8.9포지.7z.005"
  delete "1.8.9포지.7z.006"
  delete "1.8.9포지.7z.007"
  delete "1.8.9포지.7z.008"
  delete "1.8.9포지.7z.009"
  delete "1.8.9포지.7z.010"
  delete "1.8.9포지.7z.011"
  delete "1.8.9포지.7z.012"
  delete "1.8.9포지.7z.013"
  delete "1.8.9포지.7z.014"
  delete "1.8.9포지.7z.015"
  delete "1.8.9포지.7z.016"
  goto notkeep
notkeep:
  ;config1
  SetOverwrite on
  SetOutPath "$INSTDIR"
  ;File "나죠안\minecraft\launcher_profiles.json"
  File "나죠안\minecraft\options.txt"
  File "나죠안\minecraft\optionsof.txt"
  File "나죠안\minecraft\crosshair_config.ccmcfg"
  DetailPrint "설정파일 설치중"
  SetOutPath "$INSTDIR\config"
  File "나죠안\minecraft\config\animations.cfg"
  File "나죠안\minecraft\config\autogg_delay.cfg"
  File "나죠안\minecraft\config\ChromaHUD.cfg"
  File "나죠안\minecraft\config\forge.cfg"
  File "나죠안\minecraft\config\forgeChunkLoading.cfg"
  File "나죠안\minecraft\config\keystrokes.json"
  File "나죠안\minecraft\config\LEVEL_HEAD.cfg"
  File "나죠안\minecraft\config\orangesimplemod.cfg"
  File "나죠안\minecraft\config\Sk1er-ChromaCPS.cfg"
  File "나죠안\minecraft\config\splash.properties"
  File "나죠안\minecraft\config\autogg.toml"
  File "나죠안\minecraft\config\blockOverlay.cfg"
  File "나죠안\minecraft\config\replaymod.cfg"
  File "나죠안\minecraft\config\fncompassmod.cfg"
  ;File "나죠안\minecraft\config\blur.cfg"
  SetOutPath "$INSTDIR\modcore"
  File "나죠안\minecraft\modcore\config.toml"
  SetOutPath "$INSTDIR\quickplay"
  SetOutPath "$INSTDIR\quickplay\configs"
  File "나죠안\minecraft\quickplay\configs\keybinds.json"
  File "나죠안\minecraft\quickplay\configs\privacy.json"
  File "나죠안\minecraft\quickplay\configs\settings.json"
  SetOutPath "$INSTDIR\sk1ermod"
  File "나죠안\minecraft\sk1ermod\2017lock"
  SetOutPath "$INSTDIR\ReachDisplayMod"
  File "나죠안\minecraft\ReachDisplayMod\values.cfg"
  goto keep3
notkeep2:
  ;config2
  SetOverwrite on
  SetOutPath "$INSTDIR"
  ;File "나죠안\minecraft\launcher_profiles.json"
  File "나죠안\minecraft\options.txt"
  File "나죠안\minecraft\optionsof.txt"
  File "나죠안\minecraft\crosshair_config.ccmcfg"
  DetailPrint "설정파일 설치중"
  SetOutPath "$INSTDIR\config"
  File "나죠안\minecraft\config\animations.cfg"
  File "나죠안\minecraft\config\autogg_delay.cfg"
  File "나죠안\minecraft\config\ChromaHUD.cfg"
  File "나죠안\minecraft\config\forge.cfg"
  File "나죠안\minecraft\config\forgeChunkLoading.cfg"
  File "나죠안\minecraft\config\keystrokes.json"
  File "나죠안\minecraft\config\LEVEL_HEAD.cfg"
  File "나죠안\minecraft\config\orangesimplemod.cfg"
  File "나죠안\minecraft\config\Sk1er-ChromaCPS.cfg"
  File "나죠안\minecraft\config\splash.properties"
  File "나죠안\minecraft\config\autogg.toml"
  File "나죠안\minecraft\config\blockOverlay.cfg"
  File "나죠안\minecraft\config\replaymod.cfg"
  File "나죠안\minecraft\config\fncompassmod.cfg"
  ;File "나죠안\minecraft\config\blur.cfg"
  SetOutPath "$INSTDIR\modcore"
  File "나죠안\minecraft\modcore\config.toml"
  SetOutPath "$INSTDIR\quickplay"
  SetOutPath "$INSTDIR\quickplay\configs"
  File "나죠안\minecraft\quickplay\configs\keybinds.json"
  File "나죠안\minecraft\quickplay\configs\privacy.json"
  File "나죠안\minecraft\quickplay\configs\settings.json"
  SetOutPath "$INSTDIR\sk1ermod"
  File "나죠안\minecraft\sk1ermod\2017lock"
  SetOutPath "$INSTDIR\ReachDisplayMod"
  File "나죠안\minecraft\ReachDisplayMod\values.cfg"
  goto keep2
O:
  SetOutPath "$INSTDIR"
  Messagebox MB_YESNO "NF Client 2020.7 미만의 버전이 설치되어있습니다. $\n 설정파일을 유지하시겠습니까?" IDNO notkeep2
  ;File "나죠안\minecraft\launcher_profiles.json"
  CopyFiles "$APPDATA\.minecraft\options.txt" "$INSTDIR\options.txt"
  CopyFiles "$APPDATA\.minecraft\optionsof.txt" "$INSTDIR\optionsof.txt"
  CopyFiles "$APPDATA\.minecraft\config\animations.cfg" "$INSTDIR\config\animations.cfg"
  CopyFiles "$APPDATA\.minecraft\config\autogg.toml" "$INSTDIR\config\autogg.toml"
  CopyFiles "$APPDATA\.minecraft\config\autogg_delay.cfg" "$INSTDIR\config\autogg_delay.cfg"
  CopyFiles "$APPDATA\.minecraft\config\AutoText.cfg" "$INSTDIR\config\AutoText.cfg"
  CopyFiles "$APPDATA\.minecraft\config\blockOverlay.cfg" "$INSTDIR\config\blockOverlay.cfg"
  CopyFiles "$APPDATA\.minecraft\config\ChromaHUD.cfg" "$INSTDIR\config\ChromaHUD.cfg"
  CopyFiles "$APPDATA\.minecraft\config\IngameAccountSwitcher.cfg" "$INSTDIR\config\IngameAccountSwitcher.cfg"
  CopyFiles "$APPDATA\.minecraft\config\keystrokes.json" "$INSTDIR\config\keystrokes.json"
  CopyFiles "$APPDATA\.minecraft\config\LEVEL_HEAD.cfg" "$INSTDIR\config\LEVEL_HEAD.cfg"
  CopyFiles "$APPDATA\.minecraft\config\orangesimplemod.cfg" "$INSTDIR\config\orangesimplemod.cfg"
  CopyFiles "$APPDATA\.minecraft\config\Sk1er-ChromaCPS.cfg" "$INSTDIR\config\Sk1er-ChromaCPS.cfg"
  goto keep
of:
  SetOverwrite on
  SetOutPath "$INSTDIR"
  File "나죠안\minecraft\optionsof.txt"
  goto keep2
keep:
  ;config3
  SetOverwrite off
  SetOutPath "$INSTDIR"
  ;File "나죠안\minecraft\launcher_profiles.json"
  File "나죠안\minecraft\options.txt"
  File "나죠안\minecraft\optionsof.txt"
  File "나죠안\minecraft\crosshair_config.ccmcfg"
  DetailPrint "설정파일 설치중"
  SetOutPath "$INSTDIR\config"
  File "나죠안\minecraft\config\animations.cfg"
  File "나죠안\minecraft\config\autogg_delay.cfg"
  File "나죠안\minecraft\config\ChromaHUD.cfg"
  File "나죠안\minecraft\config\forge.cfg"
  File "나죠안\minecraft\config\forgeChunkLoading.cfg"
  File "나죠안\minecraft\config\keystrokes.json"
  File "나죠안\minecraft\config\LEVEL_HEAD.cfg"
  File "나죠안\minecraft\config\orangesimplemod.cfg"
  File "나죠안\minecraft\config\Sk1er-ChromaCPS.cfg"
  File "나죠안\minecraft\config\splash.properties"
  File "나죠안\minecraft\config\autogg.toml"
  File "나죠안\minecraft\config\blockOverlay.cfg"
  File "나죠안\minecraft\config\replaymod.cfg"
  File "나죠안\minecraft\config\fncompassmod.cfg"
  ;File "나죠안\minecraft\config\blur.cfg"
  SetOutPath "$INSTDIR\modcore"
  File "나죠안\minecraft\modcore\config.toml"
  SetOutPath "$INSTDIR\quickplay"
  SetOutPath "$INSTDIR\quickplay\configs"
  File "나죠안\minecraft\quickplay\configs\keybinds.json"
  File "나죠안\minecraft\quickplay\configs\privacy.json"
  File "나죠안\minecraft\quickplay\configs\settings.json"
  SetOutPath "$INSTDIR\sk1ermod"
  File "나죠안\minecraft\sk1ermod\2017lock"
  SetOutPath "$INSTDIR\ReachDisplayMod"
  File "나죠안\minecraft\ReachDisplayMod\values.cfg"
  Messagebox MB_YESNO "옵티파인(optifine)권장 설정을 적용하시겠습니까??$\n옵티파인 권장설정을 적용하면 더 원할한 게임이 가능합니다." IDYES of IDNO keep2
keep2:
  iffileexists "$INSTDIR\libraries\net\minecraftforge\forge\1.8.9-11.15.1.2318-1.8.9\forge-1.8.9-11.15.1.2318-1.8.9.jar" keep3 forgeinstall
forgeinstall:
  SetOverwrite on
  SetOutPath "$INSTDIR"
  ;forge
  Nsisdl::download "https://blog.kakaocdn.net/dn/k74Yy/btqFIOze0RG/ckQOY9gpF5J4iMfcKJotH1/7z.exe?attach=1&knm=tfile.exe" "7z.exe"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (1/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/bWXNDQ/btqGpxJvcQ0/YlGqjEvkRK9AiKIxus5Qr0/1.8.9%ED%8F%AC%EC%A7%80.7z.001?attach=1&knm=tfile.001" "1.8.9포지.7z.001"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (2/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/bB2nMS/btqGg52hF0m/FgiK6PJ4VFPYq8iKrE7WXK/1.8.9%ED%8F%AC%EC%A7%80.7z.002?attach=1&knm=tfile.002" "1.8.9포지.7z.002"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (3/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/EI2C6/btqGnZsH7Ou/0FOZ3MoK8wgKbNy7229XQk/1.8.9%ED%8F%AC%EC%A7%80.7z.003?attach=1&knm=tfile.003" "1.8.9포지.7z.003"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (4/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/8vKmS/btqGmOLKauu/nlBzKCU3tdxFkWVkwNdsR1/1.8.9%ED%8F%AC%EC%A7%80.7z.004?attach=1&knm=tfile.004" "1.8.9포지.7z.004"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (5/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/ln0Ca/btqGktPiMc4/r87TahFwcSbr4iFNqUMxcK/1.8.9%ED%8F%AC%EC%A7%80.7z.005?attach=1&knm=tfile.005" "1.8.9포지.7z.005"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (6/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/0w4ED/btqGmUZJF7R/lwWYy7SoMuh95ZG4BNs3Fk/1.8.9%ED%8F%AC%EC%A7%80.7z.006?attach=1&knm=tfile.006" "1.8.9포지.7z.006"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (7/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/XrV5j/btqGiSBlC6X/lnNcEoUlK2CmZKHrp5Rsj0/1.8.9%ED%8F%AC%EC%A7%80.7z.007?attach=1&knm=tfile.007" "1.8.9포지.7z.007"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (8/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/bNsi77/btqGg5nEUUz/KiGnHIWAINH7TXRAuD0RG1/1.8.9%ED%8F%AC%EC%A7%80.7z.008?attach=1&knm=tfile.008" "1.8.9포지.7z.008"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (9/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/rpHWN/btqGnHlivJ2/xv38YbR3cMZfofkMcbGpg1/1.8.9%ED%8F%AC%EC%A7%80.7z.009?attach=1&knm=tfile.009" "1.8.9포지.7z.009"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (10/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/dA3xk4/btqGnrC2GnI/IDPbpdGweiOVUkkChdQHZK/1.8.9%ED%8F%AC%EC%A7%80.7z.010?attach=1&knm=tfile.010" "1.8.9포지.7z.010"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (11/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/bKIB11/btqGkhhgR9I/lhmvSxJubiveYOacoBA510/1.8.9%ED%8F%AC%EC%A7%80.7z.011?attach=1&knm=tfile.011" "1.8.9포지.7z.011"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (12/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/du0Ajy/btqGfNHONtt/aUwtWrLoD8Krzwn4VbTjrk/1.8.9%ED%8F%AC%EC%A7%80.7z.012?attach=1&knm=tfile.012" "1.8.9포지.7z.012"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (13/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/brEknt/btqGfNHOKOi/IAO4WNkOQosImr9IRwYLZK/1.8.9%ED%8F%AC%EC%A7%80.7z.013?attach=1&knm=tfile.013" "1.8.9포지.7z.013"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (14/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/deJaLX/btqGip0sxBT/LUbGC1OogwOx1tXR6TUOIK/1.8.9%ED%8F%AC%EC%A7%80.7z.014?attach=1&knm=tfile.014" "1.8.9포지.7z.014"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (15/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/bCndXo/btqGiK5jiuu/xmFISA4sNBxsUZmreRUgU1/1.8.9%ED%8F%AC%EC%A7%80.7z.015?attach=1&knm=tfile.015" "1.8.9포지.7z.015"
  Nsisdl::download /TRANSLATE2 "포지 설치중 (16/16)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/diRaLD/btqGnY1DKKS/zDUhbpOtbJ50iFekEtpGbk/1.8.9%ED%8F%AC%EC%A7%80.7z.016?attach=1&knm=tfile.016" "1.8.9포지.7z.016"
  nsexec::exec '$INSTDIR\7z.exe x "$instdir\1.8.9포지.7z.001" "-aoa"'
  delete "7z.exe"
  delete "1.8.9포지.7z.001"
  delete "1.8.9포지.7z.002"
  delete "1.8.9포지.7z.003"
  delete "1.8.9포지.7z.004"
  delete "1.8.9포지.7z.005"
  delete "1.8.9포지.7z.006"
  delete "1.8.9포지.7z.007"
  delete "1.8.9포지.7z.008"
  delete "1.8.9포지.7z.009"
  delete "1.8.9포지.7z.010"
  delete "1.8.9포지.7z.011"
  delete "1.8.9포지.7z.012"
  delete "1.8.9포지.7z.013"
  delete "1.8.9포지.7z.014"
  delete "1.8.9포지.7z.015"
  delete "1.8.9포지.7z.016"
  goto keep3
keep3:
  SetOverwrite on
  ;resource pack
  SetOutPath "$INSTDIR\resourcepacks"
  RMDir /r "$INSTDIR\resourcepacks\§c나죠안의 커스텀 팩 2020.02"
  RMDir /r "$INSTDIR\resourcepacks\§c나죠안의 커스텀 팩 2021"
  Nsisdl::download "https://blog.kakaocdn.net/dn/k74Yy/btqFIOze0RG/ckQOY9gpF5J4iMfcKJotH1/7z.exe?attach=1&knm=tfile.exe" "7z.exe"
  Nsisdl::download /TRANSLATE2 "커스텀 팩 설치중 (1/1)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "http://132.226.170.151/file/%C2%A7c%EB%82%98%EC%A3%A0%EC%95%88%EC%9D%98%20%EC%BB%A4%EC%8A%A4%ED%85%80%20%ED%8C%A9%202021.7z" "§c나죠안의 커스텀 팩 2020.02.7z"
  nsexec::exec '$INSTDIR\resourcepacks\7z.exe x "$instdir\resourcepacks\§c나죠안의 커스텀 팩 2020.02.7z" "-aoa"'
  delete "§c나죠안의 커스텀 팩 2020.02.7z"
  delete "7z.exe"
  ;mod
  SetOutPath "$INSTDIR\mods\1.8.9"
  File "mod.bat"
  Nsisdl::download "https://blog.kakaocdn.net/dn/k74Yy/btqFIOze0RG/ckQOY9gpF5J4iMfcKJotH1/7z.exe?attach=1&knm=tfile.exe" "7z.exe"
  Nsisdl::download /TRANSLATE2 "모드 설치중 (1/1)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "http://132.226.170.151/file/${PRODUCT_VERSION}.7z" "mods.7z"
  nsexec::exec '$INSTDIR\mods\1.8.9\7z.exe x "$instdir\mods\1.8.9\mods.7z" "-aoa"'
  ExecWait '"mod.bat"'
  delete "7z.exe"
  delete "mods.7z"
  delete "mod.bat"
  SetOutPath "$INSTDIR\modcore"
  Nsisdl::download "https://blog.kakaocdn.net/dn/k74Yy/btqFIOze0RG/ckQOY9gpF5J4iMfcKJotH1/7z.exe?attach=1&knm=tfile.exe" "7z.exe"
  Nsisdl::download /TRANSLATE2 "모드 핵심 파일 설치 중 (1/2)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/brkMRI/btqV19Hfr80/7g1e1g6qNgzJ6RWrsbJQp0/beta.7z.001?attach=1&knm=tfile.001" "beta.7z.001"
  Nsisdl::download /TRANSLATE2 "모드 핵심 파일 설치 중 (2/2)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/1dy9W/btqV0Fmo00f/3IYwHz3GXNFIk8htyyp0cK/beta.7z.002?attach=1&knm=tfile.002" "beta.7z.002"
  nsexec::exec '$INSTDIR\modcore\7z.exe x "$instdir\modcore\beta.7z.001" "-aoa"'
  delete "7z.exe"
  delete "beta.7z.001"
  delete "beta.7z.002"
  SetOutPath "$PROGRAMFILES\Minecraft Launcher\"
  File "nfclient.ico"
  SetOverwrite off
  iffileexists "$PROGRAMFILES\Minecraft Launcher\MinecraftLauncher.exe" launcher nonlauncher
nonlauncher:
  Nsisdl::download /TRANSLATE2 "마인크래프트 런처 설치 중 (1/1)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/buRRdi/btq09jZtZc4/sRT9b5pjQ7Is2RN6H4SOMK/MinecraftLauncher.exe?attach=1&knm=tfile.exe" "MinecraftLauncher.exe"
launcher:
  SetOverwrite on
  CreateShortCut "$DESKTOP\NF Client.lnk" "$PROGRAMFILES\Minecraft Launcher\MinecraftLauncher.exe" '--workDir "$INSTDIR"' "$PROGRAMFILES\Minecraft Launcher\nfclient.ico"
  CreateShortCut "$STARTMENU\Programs\NF Client.lnk" "$PROGRAMFILES\Minecraft Launcher\MinecraftLauncher.exe" '--workDir "$INSTDIR"' "$PROGRAMFILES\Minecraft Launcher\nfclient.ico"
  push "$DESKTOP\NF Client.lnk"
  call ShellLinkSetRunAs
  pop $0
  push "$STARTMENU\Programs\NF Client.lnk"
  call ShellLinkSetRunAs
  pop $0
  Messagebox MB_OK "설치가 완료되었습니다! 바탕화면에 있는 NF Client를 실행해주세요!$\n제거하실 때는 제어판 -> 프로그램 제거 -> NF Client ${PRODUCT_VERSION}"
  goto END
  
END:

SectionEnd

Section "legacy" SECO2
!insertmacro MUI_HEADER_TEXT '추가 구성 요소 설치' '추가 구성 요소가 설치중입니다.'
!insertmacro MUI_INSTALLOPTIONS_READ "$CheckA" "Form1.ini" "Field 2" "State"
StrCmp $CheckA "1" CheckA1 CheckA2
CheckA1:
  SetOutPath "$INSTDIR\resourcepacks"
  SetOverwrite on
  Nsisdl::download "https://blog.kakaocdn.net/dn/k74Yy/btqFIOze0RG/ckQOY9gpF5J4iMfcKJotH1/7z.exe?attach=1&knm=tfile.exe" "7z.exe"
  Nsisdl::download /TRANSLATE2 "하이픽셀 레거시 리소스팩 설치 중 (1/1)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://132.226.170.151/file/%EA%B3%B5%EC%9C%A0/resourcepacks.7z" "resourcepacks.7z"
  nsexec::exec '$INSTDIR\resourcepacks\7z.exe x "$instdir\resourcepacks\resourcepacks.7z" "-aoa"'
  delete "7z.exe"
  delete "resourcepacks.7z"
CheckA2:
SectionEnd

;uninstall
Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$PROGRAMFILES\Minecraft Launcher\nfclient.ico"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name)는(은) 완전히 제거되었습니다."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "$(^Name)을(를) 제거하시겠습니까?" IDYES +2
  Abort
FunctionEnd

Section "un.언인스톨"
  delete "$DESKTOP\NF Client.lnk"
  delete "$STARTMENU\Programs\NF Client.lnk"
  delete "$PROGRAMFILES\Minecraft Launcher\nfclient.ico"
  RMDir /r "$INSTDIR"
  
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  SetAutoClose true
SectionEnd