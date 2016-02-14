unit unitUtama;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFKoneksi }

  TFKoneksi = class(TForm)
    Button1: TButton;
    Button2: TButton;
    edHostProfit: TEdit;
    edPasswordSMS: TEdit;
    edDBProfit: TEdit;
    edPortProfit: TEdit;
    edUserProfit: TEdit;
    edPasswordProfit: TEdit;
    edHostSMS: TEdit;
    edDBSMS: TEdit;
    edPortSMS: TEdit;
    edUserSMS: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FKoneksi: TFKoneksi;

implementation

{$R *.lfm}

{ TFKoneksi }
function kripik(const s: String; CryptInt: Integer): String;
var
  i: integer;
  s2: string;
begin
  if not (Length(s) = 0) then
    for i := 1 to Length(s) do
      s2 := s2 + Chr(Ord(s[i]) + CrypTint);
  Result := s2;
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

procedure TFKoneksi.Button1Click(Sender: TObject);
var
  pusat,data,jalur,nama,kata : String;
  X: TextFile;
begin
  pusat:=kripik(edHostProfit.Text,6);
  data:=kripik(edDBProfit.Text,6);
  jalur:=kripik(edPortProfit.Text,6);
  nama:=kripik(edUserProfit.Text,6);
  kata:=kripik(edPasswordProfit.Text,6);

  assignfile(X,'koneksi.cbCon');
  try
    rewrite(X);
    writeln(X,pusat);
    writeln(X,data);
    writeln(X,jalur);
    writeln(X,nama);
    writeln(X,kata);
  finally
    closefile(X);
  end;
end;

procedure TFKoneksi.Button2Click(Sender: TObject);
var
  pusat,data,jalur,nama,kata : String;
  X: TextFile;
begin
  pusat:=kripik(edHostSMS.Text,7);
  data:=kripik(edDBSMS.Text,7);
  jalur:=kripik(edPortSMS.Text,7);
  nama:=kripik(edUserSMS.Text,7);
  kata:=kripik(edPasswordSMS.Text,7);

  assignfile(X,'koneksiSMS.cbCon');
  try
    rewrite(X);
    writeln(X,pusat);
    writeln(X,data);
    writeln(X,jalur);
    writeln(X,nama);
    writeln(X,kata);
  finally
    closefile(X);
  end;
end;

procedure TFKoneksi.FormShow(Sender: TObject);
var
  pusat,data,jalur,nama,kata : String;
  X: TextFile;
begin
  assignfile(X,'koneksi.cbCon');
  try
    reset(X);
    readln(X,pusat);
    readln(X,data);
    readln(X,jalur);
    readln(X,nama);
    readln(X,kata);

    edHostProfit.Text :=krupuk(pusat,6);
    edDBProfit.Text :=krupuk(data,6);
    edPortProfit.Text :=krupuk(jalur,6);
    edUserProfit.Text :=krupuk(nama,6);
    edPasswordProfit.Text :=krupuk(kata,6);
  finally
    closefile(X);
  end;

  assignfile(X,'koneksiSMS.cbCon');
  try
    reset(X);
    readln(X,pusat);
    readln(X,data);
    readln(X,jalur);
    readln(X,nama);
    readln(X,kata);

    edHostSMS.Text :=krupuk(pusat,7);
    edDBSMS.Text :=krupuk(data,7);
    edPortSMS.Text :=krupuk(jalur,7);
    edUserSMS.Text :=krupuk(nama,7);
    edPasswordSMS.Text :=krupuk(kata,7);
  finally
    closefile(X);
  end;

end;


end.

