unit UCheckIO;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleServer, FlexCodeSDK, ExtCtrls, StdCtrls, sLabel,jpeg;

type
  TFChekIO = class(TForm)
    FPVer: TFinFPVer;
    lblPerintah: TsLabel;
    lblStatus: TsLabel;
    imgSIdikJari: TImage;
    procedure LoadData;
    procedure FPVerFPVerificationID(ASender: TObject; const ID: WideString;
      FingerNr: Integer);
    procedure FPVerFPVerificationStatus(ASender: TObject; Status: Integer);
    procedure LolosVerifikasi;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  FChekIO: TFChekIO;
  SN: WideString;
  Verification: WideString;
  Activation: WideString;
  parentPath, jenis,idUser,namaUser:string;

implementation

uses UDM, USukses;

{$R *.dfm}

procedure TFChekIO.FormShow(Sender: TObject);
begin
  Caption := 'CHECK '+ jenis;
  lblStatus.Caption := Caption;
  SN:= 'C800V004068';
  Verification:= 'EC5-C58-C93-CAD-DEA';
  Activation:= '1YJ3-FBDA-C633-2124-7321-5XJN';

  FPVer.AddDeviceInfo(SN,Verification,Activation);
  LoadData;
  FPVer.FPVerificationStart('');
  parentPath := ExtractFilePath(ExcludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)));
end;

procedure TFChekIO.LoadData;
var
  _sql : string;
begin
  _sql := 'SELECT * FROM tb_user_template';

  DM.SQLExec(DM.QShow,_sql,True);
  DM.QShow.First;
  while not DM.QShow.Eof do
  begin
  FPVer.FPLoad(DM.QShow.FieldByName('id_template').AsString,
               DM.QShow.FieldByName('finger_index').AsInteger,
               DM.QShow.FieldByName('template').AsString,
               'MySecretKey'+DM.QShow.FieldByName('user_id').AsString);
  DM.QShow.Next;
  end;
end;

procedure TFChekIO.FPVerFPVerificationID(ASender: TObject;
  const ID: WideString; FingerNr: Integer);
var
  _sql : string;
begin
  _sql := 'SELECT user_id FROM tb_user_template WHERE id_template ="'+ID+'"';
  DM.SQLExec(DM.QShow,_sql,True);

  _sql := 'SELECT * FROM tb_user WHERE kd_user ="'+DM.QShow.FieldByName('user_id').AsString+'"';
  DM.SQLExec(DM.QShow,_sql,True);

  idUser    := DM.QShow.FieldByName('kd_user').AsString;
  namaUser  := DM.QShow.FieldByName('n_user').AsString;
  LolosVerifikasi;
end;

procedure TFChekIO.LolosVerifikasi;
begin
  Application.CreateForm(TFSukses, FSukses);
  FSukses.Caption := 'CHECK '+ jenis + ' SUKSES';
  FSukses.lblKode.Caption := idUser;
  FSukses.lblNama.Caption := namaUser;
  if FileExists(parentPath+'image/'+idUser+'.jpg') then
  FSukses.imgSIdikJari.Picture.LoadFromFile(parentPath+'image/'+idUser+'.jpg');
  FSukses.ShowModal;
end;

procedure TFChekIO.FPVerFPVerificationStatus(ASender: TObject;
  Status: Integer);
begin
  case Status of
    0  :  begin
            ShowMessage('Data Sidik Jari Tidak Terdaftar... '#10#13''+
                        'Tidak Dapat melakukan ' + Caption);
          end;
    1  :  begin
            //ShowMessage('Match!');
          end;
    2   : begin
            ShowMessage('Multiple match!');
          end;
    3  :  begin
            ShowMessage('Verification fail!');
          end;
    7   : begin
            ShowMessage('Mesin Sidik Jari Tidak Terpasang '#10#13''+
                        'Tidak Dapat melakukan ' + Caption);
            Close;
          end;
    8  :  begin
            ShowMessage('Kualitas Gambar Jelek, '#10#13''+
                        'Ulangi Lagi Proses ' + Caption);
          end;
    9   : begin
            ShowMessage('Aktivasi dan verifikasi Mesin Salah'#10#13''+
                        'Tidak Dapat melakukan ' + Caption);
            Close;
          end;
    11  : begin
            ShowMessage('&Stop Verify!');
          end;
    15  : begin
            //ShowMessage('Jari Menempel...');
          end;
    16  : begin
            ShowMessage('Max 2000 templates!'#10#13''+
                        'Tidak Dapat melakukan ' + Caption);
            Close;
          end;
    17  : begin
            ShowMessage('Max 10 Devices!'#10#13''+
                        'Tidak Dapat melakukan ' + Caption);
            Close;
          end;
    18  : begin
            ShowMessage('TIdak Ada Template yang terdaftar'#10#13''+
                        'Tidak Dapat melakukan ' + Caption);
            Close;
          end;          
  end;
end;

procedure TFChekIO.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FPVer.FPVerificationStop;
end;

end.
