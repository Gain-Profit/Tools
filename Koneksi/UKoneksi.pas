unit UKoneksi;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, mySQLDbTables, StdCtrls, Mask, sMaskEdit, sCustomComboEdit,
  sCurrEdit, sCurrencyEdit, sLabel, sEdit;

type
  TFKoneksi = class(TForm)
    edHost: TsEdit;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    edDatabase: TsEdit;
    sLabel3: TsLabel;
    edPort: TsCurrencyEdit;
    sLabel4: TsLabel;
    edUserName: TsEdit;
    sLabel5: TsLabel;
    edPassword: TsEdit;
    btnTes: TButton;
    btnSimpan: TButton;
    db: TmySQLDatabase;
    procedure FormCreate(Sender: TObject);
    procedure btnTesClick(Sender: TObject);
    procedure btnSimpanClick(Sender: TObject);
    procedure edChange(Sender: TObject);
  private
    function tesKoneksi: Boolean;
  public
    { Public declarations }
  end;

var
  FKoneksi: TFKoneksi;

implementation

{$R *.dfm}

function kripik(const s: string; CryptInt: Integer): string;
var
  i: integer;
  s2: string;
begin
  if not (Length(s) = 0) then
    for i := 1 to Length(s) do
      s2 := s2 + Chr(Ord(s[i]) + CrypTint);
  Result := s2;
end;

function krupuk(const s: string; CryptInt: Integer): string;
var
  i: integer;
  s2: string;
begin
  if not (Length(s) = 0) then
    for i := 1 to Length(s) do
      s2 := s2 + Chr(Ord(s[i]) - cryptint);
  Result := s2;
end;

function TFKoneksi.tesKoneksi: Boolean;
begin
  Result := False;

  if (edHost.Text = '') or (edPort.Value = 0) or (edUserName.Text = '') or (edDatabase.Text
    = '') or (edPassword.Text = '') then
  begin
    ShowMessage('semua data untuk koneksi harus di isi...');
    Exit;
  end;

  try
    db.Connected := False;
    db.Host := edHost.Text;
    db.Port := strtoint(edPort.text);
    db.UserName := edUserName.Text;
    db.UserPassword := edPassword.Text;
    db.DatabaseName := edDatabase.Text;
    db.Connected := true;
    Result := True;
  except
    on E: Exception do
    begin
      db.Connected := False;
      showmessage('KONEKSI KE SERVER GAGAL'#10#13'' + E.message);
    end;
  end;
end;

procedure TFKoneksi.FormCreate(Sender: TObject);
var
  x: TextFile;
  pusat, jalur, nama, kata, data: string;
begin
  assignfile(x, 'koneksi.cbCon');
  try
    reset(x);
    readln(x, pusat);
    readln(x, data);
    readln(x, jalur);
    readln(x, nama);
    readln(x, kata);
    closefile(x);

    edHost.Text := krupuk(pusat, 6);
    edDatabase.Text := krupuk(data, 6);
    edPort.Text := krupuk(jalur, 6);
    edUserName.Text := krupuk(nama, 6);
    edPassword.Text := krupuk(kata, 6);
  except
  end;
end;

procedure TFKoneksi.btnTesClick(Sender: TObject);
begin
  if tesKoneksi then
  begin
    ShowMessage('Tes Koneksi Berhasil Tersambung...');
    btnSimpan.Enabled := True;
  end;
end;

procedure TFKoneksi.btnSimpanClick(Sender: TObject);
var
  x: TextFile;
  pusat, jalur, nama, kata, data: string;
begin
  pusat := kripik(edHost.Text, 6);
  data := kripik(edDatabase.Text, 6);
  jalur := kripik(edPort.Text, 6);
  nama := kripik(edUserName.Text, 6);
  kata := kripik(edPassword.Text, 6);
  try
    assignfile(X, 'koneksi.cbCon');
    rewrite(X);
    writeln(X, pusat);
    writeln(X, data);
    writeln(X, jalur);
    writeln(X, nama);
    writeln(X, kata);
    closefile(X);
    showmessage('SIMPAN DATA BERHASIL...');
  except
    on E: Exception do
    begin
      showmessage('SIMPAN DATA GAGAL...'#10#13'' + E.message);
    end;
  end;
end;

procedure TFKoneksi.edChange(Sender: TObject);
begin
  btnSimpan.Enabled := False;
end;

end.

