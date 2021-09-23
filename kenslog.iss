; This is an Inno Setup Script for dBASE
; Test app

; Constants:
#Define MyAppVersion "1.00"

[Setup]
; ----------------------------------------------------------
; Name of program to run
OutputBaseFilename=kenslog_install

; ----------------------------------------------------------
; Output directory -- where the install program gets created
; C:\kenslog\Installer
OutputDir=Installer

; ----------------------------------------------------------
; Source folder for application files
SourceDir=C:\kenslog\idssys

; ----------------------------------------------------------
; Application folder, C:\Program Files (x86)\kenslog\idssys
DefaultDirName={pf}\kenslog
; Don't allow user to select paths
DisableDirPage=yes

; ---------------------------------------------------------
; Name of group that is created
DefaultGroupName=kenslog

; ---------------------------------------------------------
; Items involved in install program display:
AppCopyright=Copyright 2021 - Wendy Munyasi
AppId=Kenslog Application
; Application Name -- as it will appear in Setup program (upper left corner)
AppName=Kenslog Test Application
; Version -- required
AppVerName=Kenslog, ver. 1.0
AppVersion=MyAppVersion

; ---------------------------------------------------------
; Uninstallable?
Uninstallable=yes

[Dirs]
; This is where the data is supposed to be placed, this is editable:
;    C:\Users\username\AppData\Local\kenslog\idssys
Name: "{localappdata}\kenslog\idssys"; Permissions: everyone-modify;

; -----------------------------------------------------
; images folder -- using DEO, we can store the images used here:
; C:\Program Files (x86)\kenslog\idssys
Name: "{app}\kenslog\idssys"; Permissions: everyone-modify;


; -----------------------------------------------------
; Where the dBASE Plus Runtime Engine will go: "C:\Program Files (x86)" if on 
; 64-bit versions of Windows, or on 32-bit versions, "C:\Program Files"):
Name: "{pf}\dBASE\dBASE2019\Runtime"; Permissions: everyone-readexec; Flags: uninsneveruninstall;
            
; -----------------------------------------------------
; Where the BDE will go:
Name: "{cf}\Borland\BDE"; Permissions: everyone-full; Flags: uninsneveruninstall;

[Files]
; -----------------------------------------------------
; The application itself, to the application folder:
Source: "deploy\kenslog.exe"; DestDir: "{app}"; Flags: ignoreversion;

; -----------------------------------------------------
; Don't forget your .INI file -- this should go in the {app} folder,
; note that it will be copied when the exe is first run, see above:
Source: "deploy\kenslog.ini"; DestDir: "{app}"; Flags: ignoreversion;

; -----------------------------------------------------
; object files in main folder

; data modules
Source: "deploy\*.dmo"; DestDir: "{app}"; Flags: ignoreversion;
; forms:
Source: "deploy\*.wfo"; DestDir: "{app}"; Flags: ignoreversion;
; custom class:
Source: "deploy\*.co"; DestDir: "{app}"; Flags: ignoreversion;
; program:
Source: "deploy\*.pro"; DestDir: "{app}"; Flags: ignoreversion;
; menu:
Source: "deploy\*.mno"; DestDir: "{app}"; Flags: ignoreversion;

; -----------------------------------------------------
; images folder
Source: "deploy\*.*"; DestDir: "{localappdata}\kenslog\idssys"; Flags: ignoreversion;

; -----------------------------------------------------
; tables folder
Source: "deploy\*.*"; DestDir: "{localappdata}\kenslog\idssys"; Flags: ignoreversion;

; -----------------------------------------------------
; dBASE Runtime Installer
Source: "C:\Program Files (x86)\dBASE\dBASE2019\Runtime\dBASE201900Runtime-b2618_ALL.exe"; DestDir: "{tmp}"; Flags: ignoreversion deleteafterinstall;

; -----------------------------------------------------
; Manifest file for runtime:
Source: "C:\Program Files (x86)\dBASE\dBASE2019\Runtime\plusrun.exe.manifest"; DestDir: "{pf}\dBASE\dBASE2019\Runtime"

; Manifest file for our application:
Source: "deploy\kenslog.exe.manifest"; DestDir: "{app}"; Flags: ignoreversion;

[INI]
; -----------------------------------------------------

; DEO Paths:
Filename: {app}\kenslog.ini; Section: "ObjectPath";
Filename: {app}\kenslog.ini; Section: "ObjectPath"; Key: "objPath0"; String: "{app}";
Filename: {app}\kenslog.ini; Section: "ObjectPath"; Key: "objPath1"; String: "{app}";
Filename: {app}\kenslog.ini; Section: "ObjectPath"; Key: "objPath2"; String: "{app}";

; Application Theme:
Filename: {app}\kenslog.ini; Section: "AppTheme";
Filename: {app}\kenslog.ini; Section: "AppTheme"; Key: "Type"; String: "6";

[Run]
; dBASE Plus 11 -- parameter of /S seems to be the "silent" install
Filename: {tmp}\dBASE201900Runtime-b2618_ALL.exe; Parameters: "/S"; Flags: runascurrentuser waituntilterminated runhidden; Description: "dBASE Runtime and BDE"; StatusMsg: "Installing dBASE Runtime and BDE..."; WorkingDir: {tmp};

[Icons]
; -----------------------------------------------------
; Application icon:

Name: "{group}\kenslog"; Filename: "{app}\kenslog.exe"; WorkingDir: "{app}"
            
; Desktop icons:
; Name: "{userdesktop}\kenslog"; Filename: "{app}\kenslog.exe"; IconFilename: "{app}\kenslog.exe"; WorkingDir: "{app}"; Comment: "dBASE Tutorial Application";


; -----------------------------------------------------
; End of tutorial.iss Inno Setup script
; -----------------------------------------------------


