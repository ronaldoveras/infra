#define MyAppName "Demoiselle 2 Infra - Extras"
#define MyAppVersion "1.0"
#define MyAppPublisher "Comunidade Demoiselle"
#define MyAppURL "http://www.frameworkdemoiselle.gov.br"
#define MyAppFrameworkDemoiselle "Framework Demoiselle"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{C3785A8B-EE3C-4E69-B566-1DED29DEDCA0}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName=C:\Demoiselle
DisableDirPage=yes
DefaultGroupName={#MyAppName}
OutputDir=.
OutputBaseFilename=demoiselle-2-infra-extra-{#MyAppVersion}
Compression=lzma
SolidCompression=yes
WizardImageFile=fundo1.bmp
WizardSmallImageFile=fundo2.bmp
ArchitecturesAllowed=x86 x64
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: english; MessagesFile: compiler:Default.isl
Name: brazilianportuguese; MessagesFile: compiler:Languages\BrazilianPortuguese.isl

[Tasks]
;Name: desktopicon; Description: {cm:CreateDesktopIcon}; GroupDescription: {cm:AdditionalIcons}; Flags: unchecked
;Name: quicklaunchicon; Description: {cm:CreateQuickLaunchIcon}; GroupDescription: {cm:AdditionalIcons}; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: C:\Demoiselle\tool\ireport-4.0\*; DestDir: {app}\tool\ireport-4.0\; Flags: ignoreversion recursesubdirs createallsubdirs
Source: C:\Demoiselle\tool\soapui-4.5\*; DestDir: {app}\tool\soapui-4.5\; Flags: ignoreversion recursesubdirs createallsubdirs
Source: C:\Demoiselle\tool\squirrel-3.4\*; DestDir: {app}\tool\squirrel-3.4\; Flags: ignoreversion recursesubdirs createallsubdirs
Source: C:\Demoiselle\tool\nimble\*; DestDir: {app}\tool\nimble\; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: {group}\iReport 4.0; Filename: {app}\tool\ireport-4.0\bin\ireport.exe
Name: {group}\SoapUI 4.5; Filename: {app}\tool\soapui-4.5\bin\soapui.bat; IconFilename: {app}\tool\soapui-4.5\bin\soapui32.ico
Name: {group}\SQuirreL 3.4; Filename: {app}\tool\squirrel-3.4\squirrel-sql.bat; IconFilename: {app}\tool\squirrel-3.4\icons\acorn.ico
Name: {group}\Nimble 1.1; Filename: {app}\tool\nimble\bin\demoiselle.bat
Name: {group}\{cm:ProgramOnTheWeb,{#MyAppFrameworkDemoiselle}}; Filename: {#MyAppURL}
Name: {group}\{cm:UninstallProgram,{#MyAppName}}; Filename: {uninstallexe}
;Name: {commondesktop}\{#MyAppName}; Filename: {app}\{#MyAppExeName}; Tasks: desktopicon
;Name: {userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}; Filename: {app}\{#MyAppExeName}; Tasks: quicklaunchicon

[Run]
;Filename: {app}\{#MyAppExeName}; Description: {cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}; Flags: nowait postinstall skipifsilent

[Registry]
Root: HKLM; Subkey: System\CurrentControlSet\Control\Session Manager\Environment; ValueType: string; ValueName: JAVA_HOME; ValueData: {code:GetJAVAHome|Default}; Flags: uninsdeletekeyifempty createvalueifdoesntexist

[Code]
var
javaPath: String;

function InitializeSetup(): Boolean;
var
 ErrorCode: Integer;
 JavaInstalled : Boolean;
 Result1 : Boolean;
 Versions: TArrayOfString;
 I: Integer;
begin
 if RegGetSubkeyNames(HKLM, 'SOFTWARE\JavaSoft\Java Development Kit', Versions) then
 begin
  for I := 0 to GetArrayLength(Versions)-1 do
   if JavaInstalled = true then
   begin
    //do nothing
   end else
   begin
    if ( Versions[I][2]='.' ) and ( ( StrToInt(Versions[I][1]) > 1 ) or ( ( StrToInt(Versions[I][1]) = 1 ) and ( StrToInt(Versions[I][3]) >= 6 ) ) ) then
    begin
     JavaInstalled := true;

     RegQueryStringValue(HKLM, 'SOFTWARE\JavaSoft\Java Development Kit\' + Versions[I], 'JavaHome', javaPath);
    end else
    begin
     JavaInstalled := false;
    end;
   end;
 end else
 begin
  JavaInstalled := false;
 end;

 if JavaInstalled then
 begin
  Result := true;
 end else
    begin
  Result1 := MsgBox('This tool requires Java Development Kit more than 1.6 to run. Please download and install the JDK and run this setup again. Do you want to download it now?',
   mbConfirmation, MB_YESNO) = idYes;
  if Result1 = false then
  begin
   Result:=false;
  end else
  begin
   Result:=false;
   ShellExec('open',
    'http://www.oracle.com/technetwork/java/javase/downloads/jdk6-downloads-1637591.html',
    '','',SW_SHOWNORMAL,ewNoWait,ErrorCode);
  end;
    end;
end;

function GetJAVAHome(S: String) : String;
begin
  Result := javaPath;
end;

end.
