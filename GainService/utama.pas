unit utama;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  DB, mySQLDbTables, ExtCtrls;

type
  TServiceMutasi = class(TService)
    db: TmySQLDatabase;
    T_mutasi: TTimer;
    Q_service: TmySQLQuery;
    Q_show: TmySQLQuery;
    Q_rinci: TmySQLQuery;
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure T_mutasiTimer(Sender: TObject);
    procedure SQLExec(aQuery:TmySQLQuery; _SQL:string; isSearch: boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  ServiceMutasi: TServiceMutasi;
  Wpath: string;
  konek:Boolean;

implementation

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  ServiceMutasi.Controller(CtrlCode);
end;

function TServiceMutasi.GetServiceController: TServiceController;
begin
  Result := ServiceController;
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

procedure TServiceMutasi.ServiceStart(Sender: TService; var Started: Boolean);
var 
    X: TextFile;
    pusat,jalur,nama,kata,data: string;
begin
  Wpath:= ExtractFilePath(ParamStr(0));

assignfile(X,Wpath+'koneksi.cbCon');
try
   reset(X);
   readln(X,pusat);
   readln(X,data);
   readln(X,jalur);
   readln(X,nama);
   readln(X,kata);
finally
   closefile(X);
end;

db.Host:=krupuk(pusat,6);
db.DatabaseName:= krupuk(data,6);
db.Port:= strtoint(krupuk(jalur,6));
db.UserName:= krupuk(nama,6);
db.UserPassword:= krupuk(kata,6);

T_mutasi.Enabled:= True;
end;

procedure TServiceMutasi.SQLExec(aQuery:TmySQLQuery; _SQL:string; isSearch: boolean);
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

procedure TServiceMutasi.T_mutasiTimer(Sender: TObject);
var x,y: Integer;
begin
try
  db.Connected:= True;
  konek:= True;
except
  konek:= False;
end;

if konek then
begin
  SQLExec(Q_show,'select kd_perusahaan,aktif_terahir from tb_company',True);
  Q_show.First;
  for X:= 0 to Q_show.RecordCount-1 do
  begin
    SQLExec(Q_rinci,'SELECT tgl FROM tb_mutasi_bulan WHERE tgl >= "'+
    FormatDateTime('yyyy-MM-dd',Q_show.fieldbyname('aktif_terahir').AsDateTime)+'" and kd_perusahaan = "'+
    Q_show.fieldbyname('kd_perusahaan').AsString+'" ORDER BY tgl ASC',True);

    Q_rinci.First;
    for y := 0 to Q_rinci.RecordCount - 1 do
      begin
        SQLExec(Q_service,'call sp_mutasi_service("'+Q_show.fieldbyname('kd_perusahaan').AsString+'","'+
        FormatDateTime('yyyy-MM-dd',Q_rinci.fieldbyname('tgl').AsDateTime)+'")',False);
        Q_rinci.Next;
      end;
      	SQLExec(Q_service,'update tb_company set update_mutasi="NO" where kd_perusahaan="'+
        Q_show.fieldbyname('kd_perusahaan').AsString+'"',False);
//        SQLExec(Q_service,'call sp_mutasi_service("'+Q_show.fieldbyname('kd_perusahaan').AsString+'",date(now()))',False);
    Q_show.Next;
  end;
end;
end;

procedure TServiceMutasi.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
T_mutasi.Enabled:= False;
end;

end.
