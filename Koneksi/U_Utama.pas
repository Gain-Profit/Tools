unit U_Utama;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,StdCtrls, shellapi, DB, mySQLDbTables, sEdit, Mask, sMaskEdit,
  sCustomComboEdit, sCurrEdit, sCurrencyEdit, sLabel, sGroupBox,inifiles,
  ExtCtrls, sPanel, sBevel, sSkinManager, sButton, sSpinEdit, ComCtrls,
  sTrackBar,acselectskin, ImgList, acAlphaImageList, Buttons, sSpeedButton,
  sComboBox, sCheckBox;

type
  TF_atur = class(TForm)
    P_perusahaan: TsPanel;
    B_tes: TButton;
    db: TmySQLDatabase;
    ed_host: TsEdit;
    ed_database: TsEdit;
    Ed_User: TsEdit;
    Ed_Pass: TsEdit;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    sLabel3: TsLabel;
    sLabel4: TsLabel;
    sLabel5: TsLabel;
    ed_port: TsCurrencyEdit;
    gb_perusahaan: TsGroupBox;
    sLabel6: TsLabel;
    sLabel7: TsLabel;
    sLabel8: TsLabel;
    sLabel9: TsLabel;
    sLabel10: TsLabel;
    ed_kdComp: TsEdit;
    ed_nComp: TsEdit;
    ed_alComp: TsEdit;
    ed_telpComp: TsEdit;
    p_gudang: TsPanel;
    sBevel1: TsBevel;
    b_gudang: TsButton;
    b_akun: TsButton;
    b_kasir: TsButton;
    b_server: TsButton;
    sm: TsSkinManager;
    p_backup: TsPanel;
    b_apply: TsButton;
    ed_sgudang: TsEdit;
    sLabel12: TsLabel;
    sLabel13: TsLabel;
    sLabel14: TsLabel;
    tb_hgudang: TsTrackBar;
    tb_sgudang: TsTrackBar;
    p_akun: TsPanel;
    sLabel15: TsLabel;
    sLabel16: TsLabel;
    sLabel17: TsLabel;
    ed_sakun: TsEdit;
    tb_hakun: TsTrackBar;
    tb_sakun: TsTrackBar;
    p_server: TsPanel;
    sLabel18: TsLabel;
    sLabel19: TsLabel;
    sLabel20: TsLabel;
    ed_sserver: TsEdit;
    tb_hserver: TsTrackBar;
    tb_sserver: TsTrackBar;
    p_kasir: TsPanel;
    sLabel21: TsLabel;
    sLabel22: TsLabel;
    sLabel23: TsLabel;
    ed_skasir: TsEdit;
    tb_hkasir: TsTrackBar;
    tb_skasir: TsTrackBar;
    sb_akun: TsSpeedButton;
    gambar: TsAlphaImageList;
    sb_gudang: TsSpeedButton;
    sb_kasir: TsSpeedButton;
    sb_server: TsSpeedButton;
    ed_footer: TsEdit;
    rg_retail: TsRadioGroup;
    rg_tunai: TsRadioGroup;
    rg_struk: TsRadioGroup;
    ce_lebar: TsCurrencyEdit;
    sLabel26: TsLabel;
    ce_PPN: TsCurrencyEdit;
    sLabel27: TsLabel;
    p_auto: TsPanel;
    t1: TsTimePicker;
    t2: TsTimePicker;
    t3: TsTimePicker;
    cb_aktif: TsCheckBox;
    sLabel11: TsLabel;
    Q_exe: TmySQLQuery;
    l_1: TsLabel;
    ed_pusat: TsEdit;
    l_2: TsLabel;
    cb_1: TsCheckBox;
    b_new: TButton;
    b_lihat: TButton;
    procedure panel_aktif(panel: TsPanel;kulit:string;ini_hue:integer;ini_sat:integer);
    procedure B_tesClick(Sender: TObject);
    procedure B_applyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ini_tampil;
    procedure b_gudangClick(Sender: TObject);
    procedure b_akunClick(Sender: TObject);
    procedure b_serverClick(Sender: TObject);
    procedure b_kasirClick(Sender: TObject);
    procedure sb_akunClick(Sender: TObject);
    procedure sb_gudangClick(Sender: TObject);
    procedure sb_kasirClick(Sender: TObject);
    procedure sb_serverClick(Sender: TObject);
    procedure tb_hakunChange(Sender: TObject);
    procedure tb_sakunChange(Sender: TObject);
    procedure cb_1Click(Sender: TObject);
    function tes_koneksi: Boolean;
    procedure b_lihatClick(Sender: TObject);
    procedure b_newClick(Sender: TObject);
    procedure amankan(pathin, pathout: string; Chave: Word);
    procedure ed_kdCompChange(Sender: TObject);
    procedure ed_hostChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_atur: TF_atur;
  pusat,jalur,nama,kata,data,a_path: string;
  X,Y: TextFile;

implementation

{$R *.dfm}

procedure TF_atur.amankan(pathin, pathout: string; Chave: Word);
var
  InMS, OutMS: TMemoryStream;
  cnt: Integer;
  C: byte;
begin
  InMS  := TMemoryStream.Create;
  OutMS := TMemoryStream.Create;
  try
    InMS.LoadFromFile(pathin);
    InMS.Position := 0;
    for cnt := 0 to InMS.Size - 1 DO
      begin
        InMS.Read(C, 1);
        C := (C xor not (ord(chave shr cnt)));
        OutMS.Write(C, 1);
      end;
    OutMS.SaveToFile(pathout);
  finally
    InMS.Free;
    OutMS.Free;
  end;
end;

function SQLExec(aQuery:TmySQLQuery; _SQL:string; isSearch: boolean):Boolean;
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
Result:=True;
end;

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

function TF_atur.tes_koneksi: Boolean;
begin
Result:= False;

if (ed_host.Text='') or (ed_port.Value=0) or (Ed_User.Text='') or (ed_database.Text='') or (Ed_Pass.Text ='') then
begin
ShowMessage('semua data untuk koneksi harus di isi...');
Exit;
end;

try
db.Connected:= False;
db.Host:=ed_host.Text;
db.Port:= strtoint(ed_port.text);
db.UserName:= ed_user.Text;
db.UserPassword:= ed_pass.Text;
db.Connected:=true;
except
  on E: Exception do
  begin
  db.Connected:= False;
  showmessage('KONEKSI KE SERVER GAGAL'#10#13''+E.message);
  Exit;
  end;
end;

try
db.Connected:= False;
db.DatabaseName:=ed_database.Text;
db.Connected:=true;
Result:= True;
except
  on E: Exception do
  begin
  showmessage('DATA BASE TIDAK ADA'#10#13''+E.message);
  b_new.Enabled:= True;
  b_new.SetFocus;
  end;
end;
end;


procedure TF_atur.B_tesClick(Sender: TObject);
begin
if tes_koneksi then
begin
 pusat:=kripik(ed_host.Text,6);
 data:=kripik(ed_database.Text,6);
 jalur:=kripik(ed_port.Text,6);
 nama:=kripik(ed_user.Text,6);
 kata:=kripik(ed_pass.Text,6);

 assignfile(X,'koneksi.cbCon');
 rewrite(X);
 writeln(X,pusat);
 writeln(X,data);
 writeln(X,jalur);
 writeln(X,nama);
 writeln(X,kata);
 closefile(X);

showmessage('koneksi berhasil');
b_tes.Caption:= 'TERKONEKSI';
b_lihat.Enabled:= True;


end else
begin
b_tes.Caption:= '&TES KONEKSI';
b_lihat.Caption:= '&CHECK';
b_lihat.Enabled:= False;
Exit;
end;
end;

procedure TF_atur.B_applyClick(Sender: TObject);
var appINI : TIniFile;
  ini_retail,ini_tunai,jenis_struk,ini_aktif:integer;
begin
if b_tes.Caption<> 'TERKONEKSI' then
begin
   B_tes.SetFocus;
   ShowMessage('tidak dapat menyimpan data, koneksi belum tersambung...');
   Exit;
end;

if b_lihat.Caption<> 'CHECKED' then
begin
   b_lihat.SetFocus;
   ShowMessage('tidak dapat menyimpan data, Data Perusahaan Belum diCHECK...');
   Exit;
end;


db.StartTransaction;
try
if sLabel10.Caption='TIDAK ADA DATA PERUSAHAAN' then
    SQLExec(Q_Exe,'insert into tb_company (kd_perusahaan, n_perusahaan,alamat,telp,ket)values ("'+ED_KDcomp.Text
    +'","'+ed_ncomp.Text+'","'+ed_alcomp.Text+'","'+ed_telpcomp.Text+'","'+ed_pusat.Text+'")',false);

if l_1.Caption='DEFAULT USER:ADMIN PASSWORD:123' then
    SQLExec(Q_Exe,'insert into tb_user (kd_perusahaan,kd_user,n_user,password,gudang,akun,toko,kasir)values ("'+
    ed_kdComp.Text+'",''ADMIN'',''ADMINISTRATOR'',md5(''123''),''Y'',''Y'',''Y'',''Y'')',false);

    SQLExec(Q_Exe,'REPLACE INTO tb_supp (kode,n_supp,aktif,kd_perusahaan) VALUES (''SU-0001'',''UMUM'',''Y'',"'+ed_kdComp.Text+'")',false);

    SQLExec(Q_Exe,'REPLACE INTO tb_pelanggan(kd_perusahaan,kd_pelanggan,n_pelanggan) VALUES ("'+ed_kdComp.Text+'",''CU-0001'',''UMUM'')',false);

  db.Commit;
except
  db.Rollback;
end;

  appINI := TIniFile.Create(a_path+'\gain.ini') ;
try
  appINI.WriteString('perusahaan','kode',ed_kdcomp.Text);
  appINI.WriteString('perusahaan','nama',ed_ncomp.Text);
  appINI.WriteString('perusahaan','alamat',ed_alcomp.Text);
  appINI.WriteString('perusahaan','telp',ed_telpcomp.Text);

  if b_gudang.Visible = True then
  begin
  appINI.WriteString('gudang','kd_perusahaan',ed_kdcomp.Text);
  appINI.WriteString('gudang','nama_skin',ed_sgudang.Text);
  appINI.WriteInteger('gudang','hue_skin',tb_hgudang.Position);
  appINI.WriteInteger('gudang','sat_skin',tb_sgudang.Position);
  appINI.WriteString('gudang','PPN',ce_PPN.Text);
  end;

  if b_akun.Visible = True then
  begin
  appINI.WriteString('akun','kd_perusahaan',ed_kdcomp.Text);
  appINI.WriteString('akun','kd_perusahaan',ed_kdcomp.Text);
  appINI.WriteString('akun','nama_skin',ed_sakun.Text);
  appINI.WriteInteger('akun','hue_skin',tb_hakun.Position);
  appINI.WriteInteger('akun','sat_skin',tb_sakun.Position);
  end;

  if b_server.Visible = True then
  begin
  appINI.WriteString('toko','kd_perusahaan',ed_kdcomp.Text);
  appINI.WriteString('toko','kd_perusahaan',ed_kdcomp.Text);
  appINI.WriteString('toko','nama_skin',ed_sserver.Text);
  appINI.WriteInteger('toko','hue_skin',tb_hserver.Position);
  appINI.WriteInteger('toko','sat_skin',tb_sserver.Position);
  end;

  if b_kasir.Visible = True then
  begin
  appINI.WriteString('kasir','kd_perusahaan',ed_kdcomp.Text);
  appINI.WriteString('kasir','kd_perusahaan',ed_kdcomp.Text);
  appINI.WriteString('kasir','nama_skin',ed_skasir.Text);
  appINI.WriteInteger('kasir','hue_skin',tb_hkasir.Position);
  appINI.WriteInteger('kasir','sat_skin',tb_skasir.Position);

  if rg_retail.ItemIndex=1 then ini_retail := 1 else ini_retail := 0;
  if rg_tunai.ItemIndex=1 then ini_tunai := 1 else ini_tunai := 0;
  if rg_struk.ItemIndex=1 then jenis_struk := 1 else jenis_struk := 0;

  appINI.WriteInteger('kasir','retail',ini_retail);
  appINI.WriteInteger('kasir','tunai',ini_tunai);
  appINI.WriteInteger('kasir','jenis_struk',jenis_struk);
  appINI.WriteString('kasir','lebar_struk',ce_lebar.Text);
  appINI.WriteString('kasir','footer_struk',ed_footer.Text);
  end;

  if p_auto.Visible = True then
  begin
  appINI.WriteString('backup','jam1',t1.Text);
  appINI.WriteString('backup','jam2',t2.Text);
  appINI.WriteString('backup','jam3',t3.Text);

  if cb_aktif.Checked=true then ini_aktif := 1 else ini_aktif := 0;
  appINI.WriteInteger('backup','aktif',ini_aktif);
  end;
  
finally
 appINI.Free;
end;

  if (MessageDlg('Data Berhasil disimpan,'+#13+#10+'Apakah anda akan keluar dari Program????', mtWarning, [mbYes, mbNo], 0) in [mrYes, mrNone]) then
  close;
end;

procedure TF_atur.panel_aktif(panel: TsPanel;kulit:string;ini_hue:integer;ini_sat:integer);
begin
p_gudang.Visible:=false;
p_akun.Visible:= false;
p_server.Visible:=false;
p_kasir.Visible:= false;

panel.Visible:= true;

  sm.SkinName:=kulit;
  sm.HueOffset:=ini_hue;
  sm.Saturation:=ini_sat;
end;

procedure TF_atur.FormCreate(Sender: TObject);
var i: Integer;
    appINI : TIniFile;
begin
a_path:= extractfilepath(application.ExeName);
sm.SkinDirectory := a_path + 'Skins';
ini_tampil;
sm.Active:=true;

  for i := 1 to ParamCount do
  begin
    if LowerCase(ParamStr(i)) = '-dump' then
    begin
      appINI := TIniFile.Create(a_path+'\gain.ini') ;
      try
        appINI.WriteInteger ('backup', 'aktif', 0);
      finally
      appINI.Free;
      end;
    Application.Terminate;
    end;
  end;


 assignfile(X,'koneksi.cbCon');
 try
   reset(X);
   readln(X,pusat);
   readln(X,data);
   readln(X,jalur);
   readln(X,nama);
   readln(X,kata);
   closefile(X);
 ed_host.Text :=krupuk(pusat,6);
 ed_database.Text :=krupuk(data,6);
 ed_port.Text :=krupuk(jalur,6);
 ed_user.Text :=krupuk(nama,6);
 ed_pass.Text :=krupuk(kata,6);
 except
 end;
end;

procedure TF_atur.ini_tampil;
var  appINI : TIniFile;
  ini_retail,ini_tunai,jenis_struk,aktif,gudang,akun,server,ksr,cadang:integer;
begin
  appINI := TIniFile.Create(a_path+'\gain.ini') ;
 try
  ed_kdcomp.Text := appINI.ReadString ('perusahaan', 'kode', '123');
  ed_ncomp.Text := appINI.ReadString ('perusahaan', 'nama_skin', 'PERUSAHAAN CONTOH');
  ed_alcomp.Text:= appINI.ReadString ('perusahaan', 'alamat', 'JL. CONTOH NO 16 CONTOH');
  ed_telpComp.Text:= appINI.ReadString ('perusahaan', 'telp', '0343-345625');

  ed_sgudang.Text:=appINI.ReadString('gudang','nama_skin','Deep');
  tb_hgudang.Position:=appini.ReadInteger('gudang','hue_skin',0);
  tb_sgudang.Position:=appini.ReadInteger('gudang','sat_skin',0);
  gudang:= appINI.ReadInteger('gudang','install',0);

  ed_sakun.Text:=appINI.ReadString('akun','nama_skin','Office2010 Blue');
  tb_hakun.Position:=appini.ReadInteger('akun','hue_skin',0);
  tb_sakun.Position:=appini.ReadInteger('akun','sat_skin',0);
  akun:= appINI.ReadInteger('akun','install',0);

  ed_sserver.Text:=appINI.ReadString('toko','nama_skin','Air');
  tb_hserver.Position:=appini.ReadInteger('toko','hue_skin',0);
  tb_sserver.Position:=appini.ReadInteger('toko','sat_skin',0);
  server:= appINI.ReadInteger('toko','install',0);

  ed_skasir.Text:=appINI.ReadString('kasir','nama_skin','Aluminium');
  tb_hkasir.Position:=appini.ReadInteger('kasir','hue_skin',0);
  tb_skasir.Position:=appini.ReadInteger('kasir','sat_skin',0);
  ksr:= appINI.ReadInteger('kasir','install',0);

  ini_retail:= appini.ReadInteger('kasir','retail',1);
  ini_tunai:= appini.ReadInteger('kasir','tunai',1);
  jenis_struk:= appINI.ReadInteger ('kasir', 'jenis_struk', 0);
  ce_lebar.Value:= appini.ReadInteger('kasir','lebar_struk',32);
  ed_footer.Text:= appINI.ReadString ('kasir', 'footer_struk', '');

  if ini_retail = 1 then rg_retail.ItemIndex:=0 else rg_retail.ItemIndex:=1;
  if ini_tunai = 1 then rg_tunai.ItemIndex:=0 else rg_tunai.ItemIndex:=1;
  if jenis_struk = 1 then rg_struk.ItemIndex:=1 else rg_struk.ItemIndex:=0;

  cadang:= appINI.ReadInteger ('backup', 'install', 0);
  t1.Text:= appINI.ReadString ('backup', 'jam1', '09:00:00');
  t2.Text:= appINI.ReadString ('backup', 'jam2', '14:00:00');
  t3.Text:= appINI.ReadString ('backup', 'jam3', '22:00:00');
  aktif:= appINI.ReadInteger ('backup', 'aktif', 1);
  ce_PPN.Text:= appINI.ReadString ('setting', 'PPN', '10');

  if aktif= 1 then cb_aktif.Checked:=true else cb_aktif.Checked:=false;

finally
 appINI.Free;
end;
panel_aktif(p_gudang,ed_sgudang.Text,tb_hgudang.Position,tb_sgudang.Position);

  if cadang = 0 then
  p_auto.Visible:= False else
  p_auto.Visible:=True;
  
  if gudang = 0 then
  begin
    panel_aktif(p_akun,ed_sakun.Text,tb_hakun.Position,tb_sakun.Position);
    b_kasir.Left:=b_server.Left;
    b_server.Left:=b_akun.Left;
    b_akun.Left:=b_gudang.Left;
    b_gudang.Visible:=False;
  end;

  if akun = 0 then
  begin
    panel_aktif(p_server,ed_sserver.Text,tb_hserver.Position,tb_sserver.Position);
    b_kasir.Left:=b_server.Left;
    b_server.Left:=b_akun.Left;
    b_akun.Visible:=False;
  end;

  if server = 0 then
  begin
    panel_aktif(p_kasir,ed_skasir.Text,tb_hkasir.Position,tb_skasir.Position);
    b_kasir.Left:=b_server.Left;
    b_server.Visible:=False;
  end;

  if ksr = 0 then
  begin
    b_kasir.Visible:=false;
  end;

  if (b_gudang.Visible = False) and (b_akun.Visible = False) and
     (b_server.Visible = False) and (b_kasir.Visible = False) then
  begin
  p_gudang.Visible:=b_gudang.Visible;
  p_akun.Visible:= b_akun.Visible;
  p_server.Visible:=b_server.Visible;
  p_kasir.Visible:= b_kasir.Visible;
  p_backup.Visible:=False;
  P_perusahaan.Visible:= False;
  ShowMessage('tidak ada aplikasi yang terinstall...');
  Application.Terminate;
  end;

end;

procedure TF_atur.b_gudangClick(Sender: TObject);
begin
panel_aktif(p_gudang,ed_sgudang.Text,tb_hgudang.Position,tb_sgudang.Position);
end;

procedure TF_atur.b_akunClick(Sender: TObject);
begin
panel_aktif(p_akun,ed_sakun.Text,tb_hakun.Position,tb_sakun.Position);
end;

procedure TF_atur.b_serverClick(Sender: TObject);
begin
panel_aktif(p_server,ed_sserver.Text,tb_hserver.Position,tb_sserver.Position);
end;

procedure TF_atur.b_kasirClick(Sender: TObject);
begin
panel_aktif(p_kasir,ed_skasir.Text,tb_hkasir.Position,tb_skasir.Position);
end;

procedure TF_atur.sb_akunClick(Sender: TObject);
begin
if selectskin(sm) then
ed_sakun.Text:=sm.SkinName;
end;

procedure TF_atur.sb_gudangClick(Sender: TObject);
begin
if selectskin(sm) then
ed_sgudang.Text:=sm.SkinName;
end;

procedure TF_atur.sb_kasirClick(Sender: TObject);
begin
if selectskin(sm) then
ed_skasir.Text:=sm.SkinName;
end;

procedure TF_atur.sb_serverClick(Sender: TObject);
begin
if selectskin(sm) then
ed_sserver.Text:=sm.SkinName;
end;

procedure TF_atur.tb_hakunChange(Sender: TObject);
begin
sm.HueOffset:= TsTrackBar(sender).Position;
end;

procedure TF_atur.tb_sakunChange(Sender: TObject);
begin
sm.Saturation:=TsTrackBar(sender).Position;
end;

procedure TF_atur.cb_1Click(Sender: TObject);
begin
if cb_1.Checked then
begin
  ed_pusat.Text:='PUSAT';
  ed_pusat.Enabled:= False;
end else
begin
  ed_pusat.Text:='PUSAT';
  ed_pusat.Enabled:= True;
end;

end;

procedure TF_atur.b_lihatClick(Sender: TObject);
begin
  SQLExec(Q_exe,'select * from tb_company where kd_perusahaan="'+ed_kdcomp.Text+'"',True);
  if Q_exe.Eof then
    sLabel10.Caption:='TIDAK ADA DATA PERUSAHAAN' else
    begin
    sLabel10.Caption:='DATA PERUSAHAAN AKTIF...';
    ed_pusat.Text:= Q_exe.fieldbyname('ket').AsString;
    ed_nComp.Text:=  Q_exe.fieldbyname('n_perusahaan').AsString;
    ed_alComp.Text:=  Q_exe.fieldbyname('alamat').AsString;
    ed_telpComp.Text:=  Q_exe.fieldbyname('telp').AsString;
    if ed_pusat.Text='PUSAT' then cb_1.Checked:=True else cb_1.Checked:=False;
    end;

SQLExec(Q_exe,'select * from tb_user where kd_perusahaan="'+ed_kdcomp.Text+'" AND kd_user=''ADMIN''',True);
  if Q_exe.Eof then
    l_1.Caption:='DEFAULT USER:ADMIN PASSWORD:123'
    else
    l_1.Caption:='';

b_lihat.Caption:= 'CHECKED';
end;

procedure TF_atur.b_newClick(Sender: TObject);
var database: string;
begin
db.DatabaseName:='';
db.Execute('CREATE DATABASE IF NOT EXISTS '+ed_database.Text);
{amankan(a_path+'database.sql.gz',a_path+'database.sql.gz',9966);

amankan(a_path+'database.sql.gz',a_path+'database.sql.gz',9966);
}end;

procedure TF_atur.ed_kdCompChange(Sender: TObject);
begin
b_lihat.Caption:='&CHECK';
end;

procedure TF_atur.ed_hostChange(Sender: TObject);
begin
B_tes.Caption:='&TES KONEKSI';
b_lihat.Caption:= '&CHECK';
b_lihat.Enabled:= False;
end;

end.
