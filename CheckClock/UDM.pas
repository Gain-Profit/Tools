unit UDM;

interface

uses
  SysUtils, Classes, DB, sSkinManager, Dialogs, Forms,
  ImgList, Controls, acAlphaImageList, MemDS, DBAccess, MyAccess;

type
  Tdm = class(TDataModule)
    xConn: TMyConnection;
    Qexe: TMyQuery;
    QShow: TMyQuery;
    sm: TsSkinManager;
    dsStatus: TDataSource;
    QStatus: TMyQuery;
    procedure koneksikan;
    procedure SQLExec(aQuery:TMyQuery; _SQL:string; isSearch: boolean);
    procedure DataModuleCreate(Sender: TObject);
    procedure refreshTable;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;
  _host,_db,_user,_password:string;
  _port:Integer;

implementation

{$R *.dfm}

procedure Tdm.SQLExec(aQuery:TMyQuery; _SQL:string; isSearch: boolean);
begin
  with aQuery  do
  begin
    Close;
    sql.Clear;
    SQL.Text := _SQL;
    if isSearch then
      Open
    else
      ExecSQL;
  end;
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

procedure Tdm.koneksikan;
var
  data,pusat,jalur1,jalur2,nama,kata: string;
  X: TextFile;
begin
  assignfile(X,'koneksi.cbCon');
  try
    reset(X);
    readln(X,pusat);
    readln(X,data);
    readln(X,jalur2);
    readln(X,nama);
    readln(X,kata);
    closefile(X);

    jalur1 :=krupuk(jalur2,6);
  
    _host := krupuk(pusat,6);
    _db:= krupuk(data,6);
    _user:= krupuk(nama,6);
    _password:= krupuk(kata,6);
    _port:= strtoint(jalur1);

    with xConn do
    begin
      Connected := False;
      Server := _host;
      Database:= _db;
      UserName:= _user;
      Password:= _password;
      port:= _port;
      Connected:= True;
    end;
  except
    showmessage('Tidak Terkoneksi ke database...');
    application.Terminate;
  end;
end;

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  sm.Active := True;
  koneksikan;
end;

procedure Tdm.refreshTable;
begin
  SQLExec(QStatus,'SELECT kd_user, n_user, fx_checkclock(kd_user) ' +
  'AS kondisi FROM tb_user',True);
end;

end.
