unit uDm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, sqldblib, mysql55conn, FileUtil;

type

  { Tdm }

  Tdm = class(TDataModule)
    LibLoad: TSQLDBLibraryLoader;
    Qexe: TSQLQuery;
    Trans: TSQLTransaction;
    Xcon: TSQLConnector;
    procedure DataModuleCreate(Sender: TObject);
    procedure query(queryComponent:TSQLQuery;_SQL:String;isSearch:boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  dm: Tdm;
  Wpath:string;

implementation

{$R *.lfm}

{ Tdm }

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

procedure Tdm.DataModuleCreate(Sender: TObject);
var
    X: TextFile;
    pusat,jalur,nama,kata,data: string;
begin
  Wpath:= ExtractFilePath(ParamStr(0));

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

Xcon.HostName:=krupuk(pusat,7);
Xcon.DatabaseName:= krupuk(data,7);
Xcon.UserName:= krupuk(nama,7);
Xcon.Password:= krupuk(kata,7);

Xcon.Connected:=true;
end;

procedure Tdm.query(queryComponent: TSQLQuery; _SQL: String; isSearch: boolean);
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

end.

