unit u_utama;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,shellapi, DB,
  ExtCtrls, ComCtrls, Menus, Grids, Buttons,registry, Mask,
  sMaskEdit, sCustomComboEdit, sTooledit,inifiles, sButton, DBAccess,
  MyAccess;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    db: TMyConnection;
    lb_time: TLabel;
    sb: TStatusBar;
    PopupMenu1: TPopupMenu;
    open1: TMenuItem;
    exit1: TMenuItem;
    sg: TStringGrid;
    Button1: TButton;
    gb_pilihan: TRadioGroup;
    ed_nama: TEdit;
    procedure salin;
    procedure WndProc(var Msg : TMessage); override;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure open1Click(Sender: TObject);
    procedure exit1Click(Sender: TObject);
    procedure deAfterDialog(Sender: TObject; var Name: String;
      var Action: Boolean);
    procedure sgSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure Button1Click(Sender: TObject);
    procedure ed_namaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    pusat,jalur,nama,kata,data,wpath: string;
    { Private declarations }
  public
    { Public declarations }
    IconData : TNotifyIconData;
    IconCount : integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

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

procedure TForm1.WndProc(var Msg : TMessage);
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
        if Form1.Showing then
          Form1.Hide else
          Form1.Show;
      end;
    end;
  end;
  inherited;
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

function tempdir: String;
var
  TempDir: array[0..255] of Char;
begin
  GetTempPath(255, @TempDir);
  Result := StrPas(TempDir);
end;

procedure TForm1.salin;
var
param,sekarang: String;
begin
sekarang := formatdatetime('_yyyyMMdd_HHmmss',now());

param:='/C mysqldump -u'+db.Username+' -p'+db.Password+' --host='+db.Server
+' --complete-insert --routines '+db.Database+' | gzip -9 > BackUp\'+sekarang+'.sql.gz';

Form1.Caption:= 'Proses Backup Berjalan';
ShellExecute_andwait('open', 'cmd.exe', param , wpath, SW_HIDE, True);
Form1.Caption:= 'Auto Backup';
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var i,aktif:integer;
    X: TextFile;
    aini: Tinifile;
begin
aini:=Tinifile.Create(wpath+'\gain.ini');
try
sg.Cells[0,0]:=aini.ReadString('backup','jam1','09:00:00');
sg.Cells[0,1]:=aini.ReadString('backup','jam2','15:00:00');
sg.Cells[0,2]:=aini.ReadString('backup','jam3','20:00:00');
aktif:= aini.ReadInteger('backup','aktif',1);
finally
aini.Free;
end;

if aktif=0 then
begin
application.Terminate;
exit;
end;

assignfile(X,wpath+'\koneksi.cbCon');
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

lb_time.Caption:=formatdatetime('HH:mm:ss',time());
try
db.Server:=krupuk(pusat,6);
db.Database:= krupuk(data,6);
db.Port:= strtoint(krupuk(jalur,6));
db.Username:= krupuk(nama,6);
db.Password:= krupuk(kata,6);
db.Connected:=true;
sb.Panels[0].Text:='CONNECTED' ;
sb.Panels[1].Text:='   '+db.Database+'@'+ db.Server ;
except
on E:exception do
begin
sb.Panels[0].Text:='UNCONNECTED';
sb.Panels[1].text:=e.Message;
end;
end;

for i:=0 to sg.RowCount do
  begin
    if (pos(sg.Cells[0,i],lb_time.Caption)>0) and (sb.Panels[0].Text='CONNECTED') then salin;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

wpath:=extractfilepath(application.ExeName);

if not (DirectoryExists(wpath+'\BackUp')) then
MkDir(wpath+'\BackUp');

ShowWindow(Application.Handle, SW_HIDE);

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

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caNone;
  Form1.Hide;
end;

procedure TForm1.open1Click(Sender: TObject);
begin
  Form1.Show;
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TForm1.exit1Click(Sender: TObject);
begin
  Shell_NotifyIcon(NIM_DELETE, @IconData);
  Application.ProcessMessages;
  Application.Terminate;
end;

procedure TForm1.deAfterDialog(Sender: TObject;
  var Name: String; var Action: Boolean);
var aini: Tinifile;
begin
aini:=Tinifile.Create(wpath+'\gain.ini');
try
aini.WriteString('setting','jam1',sg.Cells[0,0]);
aini.WriteString('setting','jam2',sg.Cells[0,1]);
aini.WriteString('setting','jam3',sg.Cells[0,2]);
aini.WriteString('setting','tempat',name);
finally
aini.Free;
end;
end;

procedure TForm1.sgSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: String);
begin
ShellExecute(Handle, 'open', PChar(wpath+'\gain.ini'), nil,nil, SW_SHOWNORMAL);
end;


procedure TForm1.Button1Click(Sender: TObject);
var
param: String;
begin
if ed_nama.Text='' then
begin
showmessage('masukkan nama file terlebih dahulu..., nama tidak boleh ada spasi...');
ed_nama.SetFocus;
exit;
end;

case gb_pilihan.ItemIndex of
//hanya strukturnya saja
0: param:='/C mysqldump -u'+db.UserName+' -p'+db.Password+' --host='+db.Server
+' --no-data --routines '+db.Database+' | gzip > BackUp\'+ed_nama.Text+'.sql.gz';


// hanya datanya saja
1: param:='/C mysqldump -u'+db.UserName+' -p'+db.Password+' --host='+db.Server
+' --no-create-info --complete-insert '+db.Database+' | gzip > BackUp\'+ed_nama.Text+'.sql.gz';

// data komplit (struktur plus data)
2: param:='/C mysqldump -u'+db.UserName+' -p'+db.Password+' --host='+db.Server
+' --complete-insert --routines '+db.Database+' | gzip > BackUp\'+ed_nama.Text+'.sql.gz';

end;
//ShellExecute(Handle, 'open', 'cmd.exe', Pchar(param) ,pchar(wpath), SW_HIDE);
Form1.Caption:= 'Proses Backup Berjalan';
ShellExecute_andwait('open', 'cmd.exe', param , wpath, SW_HIDE, True);
Form1.Caption:= 'Auto Backup';
end;

procedure TForm1.ed_namaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if Key= vk_return then
 Button1Click(Self);
end;

end.
