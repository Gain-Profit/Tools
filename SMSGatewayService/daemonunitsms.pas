unit daemonunitSMS;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ExtCtrls, DaemonApp, sqldb, sqldblib,
  mysql55conn,Interfaces;

type

  { TGainSMS }

  TGainSMS = class(TDaemon)
    LibLoad: TSQLDBLibraryLoader;
    ProfitConn: TSQLConnector;
    ProfitTrans: TSQLTransaction;
    QProfitShow: TSQLQuery;
    QSMSShow: TSQLQuery;
    SMSConn: TSQLConnector;
    SMSTrans: TSQLTransaction;
    QSMSEXE: TSQLQuery;
    Timer1: TTimer;
    procedure logfile(data:String);
    procedure query(queryComponent: TSQLQuery; _SQL: String; isSearch: boolean);
    procedure koneksiProfit;
    procedure koneksiSMS;
    function tersambung:boolean;
    procedure DataModuleStart(Sender: TCustomDaemon; var OK: Boolean);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  GainSMS: TGainSMS;
  Wpath  : String;

implementation

procedure RegisterDaemon;
begin
  RegisterDaemonClass(TGainSMS)
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

{$R *.lfm}

{ TGainSMS }

procedure TGainSMS.logfile(data: String);
var
    X: TextFile;
begin

assignfile(X,Wpath+'logSMS.txt');
try
   if FileExists(Wpath+'logSMS.txt') then
   Append(X) else
   Rewrite(X);
   WriteLn(X,data);
finally
   closefile(X);
end;
end;

procedure TGainSMS.query(queryComponent: TSQLQuery; _SQL: String; isSearch: boolean);
begin
  with queryComponent do
  begin
    close;
    sql.Clear;
    sql.Text:=_SQL;
    if isSearch then
    Open else
    ExecSQL;
  end;
end;

procedure TGainSMS.koneksiProfit;
var
    X: TextFile;
    pusat,jalur,nama,kata,data: string;
begin
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

ProfitConn.ConnectorType:=LibLoad.ConnectionType;
ProfitConn.HostName:=krupuk(pusat,6);
ProfitConn.DatabaseName:= krupuk(data,6);
ProfitConn.UserName:= krupuk(nama,6);
ProfitConn.Password:= krupuk(kata,6);
end;

procedure TGainSMS.koneksiSMS;
var
    X: TextFile;
    pusat,jalur,nama,kata,data: string;
begin
assignfile(X,Wpath+'koneksiSMS.cbCon');
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

SMSConn.ConnectorType:=LibLoad.ConnectionType;
SMSConn.HostName:=krupuk(pusat,7);
SMSConn.DatabaseName:= krupuk(data,7);
SMSConn.UserName:= krupuk(nama,7);
SMSConn.Password:= krupuk(kata,7);
end;

function TGainSMS.tersambung: boolean;
begin
try
  ProfitConn.Open;
  SMSConn.open;
  Result := true;
except on e:Exception do
  begin
    Result := false;
//    logfile(DateTimeToStr(Now)+' '+e.Message);
  end;
end;
end;

procedure TGainSMS.DataModuleStart(Sender: TCustomDaemon; var OK: Boolean);
begin
Wpath:= ExtractFilePath(ParamStr(0));
LibLoad.ConnectionType:= 'MySQL 5.5';

koneksiProfit;
koneksiSMS;

Timer1.Enabled:=True;
end;

procedure TGainSMS.Timer1Timer(Sender: TObject);
var pesan : string;
begin
  if tersambung then
  begin
    try
    query(QSMSShow,'SELECT ID,SenderNumber,MID(TextDecoded,7)as kode '+
    'FROM inbox WHERE TextDecoded LIKE "harga %" AND '+
    'Processed = "FALSE" ORDER BY ReceivingDateTime',True);
    while not QSMSShow.EOF do
    begin
      query(QProfitShow,'SELECT CONCAT(tb_barang.barcode3," - ", '+
      'tb_barang.n_barang,", Harga: Rp. ", '+
      'CONVERT(FORMAT(tb_barang_harga.harga_jual3,0) USING utf8)) as pesan '+
      'FROM tb_barang INNER JOIN tb_barang_harga ON '+
      'tb_barang.kd_barang=tb_barang_harga.kd_barang  AND '+
      'tb_barang_harga.kd_perusahaan = tb_barang.kd_perusahaan '+
      'WHERE tb_barang.barcode3 = "'+QSMSShow.FieldByName('kode').AsString+'" AND '+
      'tb_barang_harga.kd_macam_harga = "HETK" AND '+
      'tb_barang.aktif="Y" AND tb_barang.kd_perusahaan= "BR001"',true);

      IF QProfitShow.RecordCount=0 then
        pesan := 'Barang dan Harga Tidak ada dalam database'
      else
        pesan := QProfitShow.FieldByName('pesan').AsString;

      query(QSMSEXE,Format('insert into outbox(DestinationNumber,TextDecoded,creatorID) '+
      'values ("%s","%s","Auto SMS")',[QSMSShow.FieldByName('SenderNumber').AsString,pesan]),False);

      query(QSMSEXE,'update inbox set Processed = "TRUE" '+
      'where ID ="'+QSMSShow.FieldByName('ID').AsString+'"',False);

      QSMSShow.Next;
    end;

    SMSTrans.Commit;
    except on e:Exception do
      begin
        SMSTrans.Rollback;
        logfile(DateTimeToStr(Now)+' '+e.Message);
        ProfitConn.Close(true);
        SMSConn.Close(true);
      end;
    end;
  end;
end;


initialization
  RegisterDaemon;
end.

