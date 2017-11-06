unit uUtama;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBAccess, MyAccess, StdCtrls, System.UITypes;

type
  TFUtama = class(TForm)
    Con: TMyConnection;
    BtnHapus: TButton;
    Label1: TLabel;
    EdKeamanan: TEdit;
    Label2: TLabel;
    procedure BtnHapusClick(Sender: TObject);
  private
    function Koneksikan: boolean;
    procedure HapusTransaksi;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FUtama: TFUtama;

implementation

{$R *.dfm}

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

function TFUtama.Koneksikan: boolean;
var
  data, pusat, jalur1, jalur2, nama, kata: string;
  X: TextFile;
begin
  con.Connected := False;
  assignfile(X, 'koneksi.cbCon');
  try
    reset(X);
    readln(X, pusat);
    readln(X, data);
    readln(X, jalur2);
    readln(X, nama);
    readln(X, kata);
    closefile(X);
    con.Server := krupuk(pusat, 6);
    con.Database := krupuk(data, 6);
    jalur1 := krupuk(jalur2, 6);
    con.Port := strtoint(jalur1);
    con.Username := krupuk(nama, 6);
    con.Password := krupuk(kata, 6);
    con.Connected := true;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TFUtama.BtnHapusClick(Sender: TObject);
begin
  if EdKeamanan.Text <> 'HKY73E-87HAI6JY-23HHBUA6-8YHA839J' then
  begin
    ShowMessage('Kode Keamanan Tidak Sesuai...');
    EdKeamanan.SetFocus;
    Exit;
  end;

  if MessageDlg('Yakin, Akan Menghapus Seluruh Transaksi dan jurnal?', mtWarning, [mbYes, mbNo], 0) = mrYes then
  begin
    HapusTransaksi;
  end;
end;

procedure TFUtama.HapusTransaksi;
var
  LSql : String;
begin
  if not Koneksikan then
  begin
    ShowMessage('Tidak Dapat Terhubung ke Database...');
    Exit;
  end;
  Con.StartTransaction;
  Try
    LSql := 'UPDATE tb_barang set stok_OH = 0';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_gross_margin';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_mutasi';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_mutasi_bulan';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_hutang';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_piutang';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_purchase_global';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_purchase_rinci';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_receipt_global';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_receipt_rinci';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_return_global';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_return_rinci';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_kirim_global';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_kirim_rinci';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_return_kirim_global';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_return_kirim_rinci';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_jual_global';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_jual_rinci';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_return_jual_global';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_return_jual_rinci';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_koreksi_global';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_koreksi_rinci';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_koreksi_temp';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_jual_batal';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_jurnal_global';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_jurnal_rinci';
    Con.ExecSQL(LSql);

    LSql := 'DELETE FROM tb_jurnal_history';
    Con.ExecSQL(LSql);

    Con.Commit;
    ShowMessage('proses hapus seluruh transaksi sukses...');
  except
    on e: Exception do
      begin
        con.Rollback;
        ShowMessage('gagal menghapus data...' + e.Message);
      end;
  end;
end;


end.
