unit u_utama;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,shellapi, DB, ExtCtrls, ComCtrls, Menus, Grids,
  Buttons,registry, Mask, inifiles, DBAccess, MyAccess, SHFolder;

type
  TFrmBackup = class(TForm)
    TmrBackup: TTimer;
    db: TMyConnection;
    lb_time: TLabel;
    sb: TStatusBar;
    PopupMenu1: TPopupMenu;
    open1: TMenuItem;
    exit1: TMenuItem;
    BtnBackup: TButton;
    gb_pilihan: TRadioGroup;
    ed_nama: TEdit;
    procedure TmrBackupTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure open1Click(Sender: TObject);
    procedure exit1Click(Sender: TObject);
    procedure BtnBackupClick(Sender: TObject);
    procedure ed_namaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    procedure WndProc(var Msg : TMessage); override;
  private
    FBackUpPath : string;
    pusat,jalur,nama,kata,data,wpath: string;
    Connected: Boolean;
    procedure BackUpToFile(AType : Integer = 2; AName : string = '');
    procedure CekConnection;
    procedure RequiredFile(AFileName: TFileName);
  public
    IconData : TNotifyIconData;
    IconCount : integer;
  end;

var
  FrmBackup: TFrmBackup;

implementation

uses Math;

{$R *.dfm}

function GetAppData(Folder: Integer): string;
var
  path: array[0..MAX_PATH] of Char;
begin
  if Succeeded(SHGetFolderPath(0, Folder, 0, 0, @Path[0])) then
    Result := path + '\Gain Profit\'
  else
    Result := '';
end;

function ShellExecute_AndWait(Operation, FileName, Parameter, Directory: string;
  Show: Word; bWait: Boolean): Longint;
var
  bOK: Boolean;
  Info: TShellExecuteInfo;
begin
  FillChar(Info, SizeOf(Info), Chr(0));
  Info.cbSize := SizeOf(Info);
  Info.fMask := SEE_MASK_NOCLOSEPROCESS;
  Info.lpVerb := PChar(Operation);
  Info.lpFile := PChar(FileName);
  Info.lpParameters := PChar(Parameter);
  Info.lpDirectory := PChar(Directory);
  Info.nShow := Show;
  bOK := Boolean(ShellExecuteEx(@Info));
  if bOK then
  begin
    if bWait then
    begin
      while
        WaitForSingleObject(Info.hProcess, 100) = WAIT_TIMEOUT
        do Application.ProcessMessages;
      bOK := GetExitCodeProcess(Info.hProcess, DWORD(Result));
    end
    else
      Result := 0;
  end;
  if not bOK then Result := -1;
end;

function krupuk(const s: String; CryptInt: Integer): String;
var
  i: integer;
  s2: string;
begin
  if not (Length(s) = 0) then
    for i := 1 to Length(s) do
      s2 := s2 + Chr(Ord(s[i]) - cryptint);
  Result := s2;
end;

procedure TFrmBackup.WndProc(var Msg : TMessage);
var
  aPoint : TPoint;
begin
  case Msg.Msg of
    WM_USER + 1:
    case Msg.lParam of
      WM_RBUTTONDOWN:
      begin
         SetForegroundWindow(Handle);
         GetCursorPos(aPoint);
         PopupMenu1.Popup(aPoint.x, aPoint.y);
         PostMessage(Handle, WM_NULL, 0, 0);
      end;
      WM_LBUTTONDOWN:
      begin
        if Self.Showing then
          Self.Hide else
          Self.Show;
      end;
    end;
  end;
  inherited;
end;

procedure TFrmBackup.CekConnection;
var
  X: TextFile;
begin
  assignfile(X,wpath+'\koneksi_root.cbCon');
  try
    reset(X);
    readln(X,pusat);
    readln(X,data);
    readln(X,jalur);
    readln(X,nama);
    readln(X,kata);
    closefile(X);
  except
  end;

  try
    db.Server:=krupuk(pusat,6);
    db.Database:= krupuk(data,6);
    db.Port:= strtoint(krupuk(jalur,6));
    db.Username:= krupuk(nama,6);
    db.Password:= krupuk(kata,6);
    db.Connected:=true;
    sb.Panels[0].Text:='CONNECTED';
    sb.Panels[1].Text:=db.Username + ':' + db.Database + '@' + db.Server ;
    Connected := True;
  except
    on E:exception do
    begin
      Connected := False;
      sb.Panels[0].Text:='UNCONNECTED';
      sb.Panels[1].text:=e.Message;
    end;
  end;
end;

procedure TFrmBackup.RequiredFile(AFileName: TFileName);
begin
  if not(FileExists(AFileName)) then
  begin
    ShowMessage( Format('File %s tidak dapat ditemukan, aplikasi tidak dapat dijalankan.',
      [AFileName]));
    Application.Terminate;
  end;
end;

procedure TFrmBackup.FormCreate(Sender: TObject);
begin
  wpath:=extractfilepath(application.ExeName);

  FBackUpPath := GetAppData(CSIDL_COMMON_APPDATA) + '\BackUp\';
  if not (DirectoryExists(FBackUpPath)) then
    CreateDir(FBackUpPath);

  RequiredFile(wpath + 'gzip.exe');

  RequiredFile(wpath + 'mysqldump.exe');

  RequiredFile(wpath + 'koneksi_root.cbCon');

  ShowWindow(Application.Handle, SW_HIDE);

  TmrBackup.Enabled := True;

  BorderIcons := [biSystemMenu];
  IconCount := 0;
  IconData.cbSize := sizeof(IconData);
  IconData.Wnd := Handle;
  IconData.uID := 100;
  IconData.uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
  IconData.uCallbackMessage := WM_USER + 1;
  IconData.hIcon := Application.Icon.Handle;
  StrPCopy(IconData.szTip, Application.Title);
  Shell_NotifyIcon(NIM_ADD, @IconData);
end;

procedure TFrmBackup.BackUpToFile(AType : Integer; AName : string);
var
  LParam, LName: String;
begin
  LName := AName;
  if LName='' then
  begin
    LName := formatdatetime('_yyyyMMdd_HHmmss', Now());
  end;

  case AType of
    //hanya strukturnya saja
    0: LParam:='/C mysqldump -u' + db.UserName + ' -p' + db.Password +
      ' --host=' + db.Server + ' -P' + IntToStr(db.Port) + ' --no-data --routines '+
       db.Database+' | gzip > "' + FBackUpPath + LName + '.sql.gz"';

    // hanya datanya saja
    1: LParam:='/C mysqldump -u' + db.UserName + ' -p' + db.Password +
      ' --host=' + db.Server + ' -P' + IntToStr(db.Port) + ' --no-create-info --complete-insert '+
       db.Database + ' | gzip > "' + FBackUpPath + LName + '.sql.gz"';

    // data komplit (struktur plus data)
    2: LParam:='/C mysqldump -u' + db.UserName + ' -p' + db.Password +
      ' --host=' + db.Server + ' -P' + IntToStr(db.Port) + ' --complete-insert --routines '+
       db.Database + ' | gzip > "' + FBackUpPath + LName + '.sql.gz"';
  end;
  
  Caption:= 'Proses Backup Berjalan';
  ShellExecute_andwait('open', 'cmd.exe', LParam , wpath, SW_HIDE, True);
  Caption:= 'Auto Backup';
end;

procedure TFrmBackup.TmrBackupTimer(Sender: TObject);
var
  I:integer;
  LBackupTime : array[0..1] of String;
begin
  LBackupTime[0] := '10.00.00';
  LBackupTime[1] := '22.00.00';

  lb_time.Caption:=formatdatetime('HH.mm.ss',time());

  CekConnection;

  for i:=0 to Length(LBackupTime) - 1 do
  begin
    If ( not( Connected )) then Exit;
    if ( pos( LBackUpTime[i], lb_time.Caption ) > 0 ) then
      BackUpToFile;
  end;
end;

procedure TFrmBackup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caNone;
  Self.Hide;
end;

procedure TFrmBackup.open1Click(Sender: TObject);
begin
  Self.Show;
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TFrmBackup.exit1Click(Sender: TObject);
begin
  Shell_NotifyIcon(NIM_DELETE, @IconData);
  Application.ProcessMessages;
  Application.Terminate;
end;

procedure TFrmBackup.BtnBackupClick(Sender: TObject);
begin
  BackUpToFile(gb_pilihan.ItemIndex, ed_nama.Text);
end;

procedure TFrmBackup.ed_namaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key= vk_return then
    BackUpToFile(gb_pilihan.ItemIndex, ed_nama.Text);
end;

end.
