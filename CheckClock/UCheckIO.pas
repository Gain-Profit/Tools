unit UCheckIO;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleServer, FlexCodeSDK, ExtCtrls, StdCtrls;

type
  TFChekIO = class(TForm)
    FPVer: TFinFPVer;
    imgJari: TImage;
    mmoInfo: TMemo;
    lbl1: TLabel;
    lbl2: TLabel;
    edID: TEdit;
    edNama: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LoadData;
    procedure FPVerFPVerificationID(ASender: TObject; const ID: WideString;
      FingerNr: Integer);
    procedure FPVerFPVerificationImage(Sender: TObject);
    procedure FPVerFPVerificationStatus(ASender: TObject; Status: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FChekIO: TFChekIO;
  SN: WideString;
  Verification: WideString;
  Activation: WideString;

implementation

uses UDM;

{$R *.dfm}

procedure TFChekIO.FormCreate(Sender: TObject);
begin
  imgJari.Canvas.Create();
  FPVer.PictureSamplePath := ExtractFilePath(Application.ExeName) + '\FPTemp.BMP';
  FPVer.PictureSampleHeight := 1635;
  FPVer.PictureSampleWidth := 1335;
end;

procedure TFChekIO.FormShow(Sender: TObject);
begin
  SN:= 'C800V004068';
  Verification:= 'EC5-C58-C93-CAD-DEA';
  Activation:= '1YJ3-FBDA-C633-2124-7321-5XJN';

  FPVer.AddDeviceInfo(SN,Verification,Activation);
  LoadData;
  FPVer.FPVerificationStart('');
  mmoInfo.Lines.Add('Tempelkan jari ke Alat Perekam!!!...')
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

  edID.Text   := DM.QShow.FieldByName('kd_user').AsString;
  edNama.Text := DM.QShow.FieldByName('n_user').AsString;

//  mmoInfo.lines.add('ID = ' + ID + ', FingerNr = ' + inttostr(FingerNr));
end;

procedure TFChekIO.FPVerFPVerificationImage(Sender: TObject);
begin
  imgJari.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + '\FPTemp.BMP');
end;

procedure TFChekIO.FPVerFPVerificationStatus(ASender: TObject;
  Status: Integer);
begin
  case Status of
    0  :  begin
            mmoInfo.lines.add('Not match!');
            ShowMessage('Data Sidik Jari Tidak Terdaftar...');
            edID.Clear;
            edNama.Clear;
          end;
    1  :  begin
            mmoInfo.lines.add('Match!');
          end;
    2   : begin
            mmoInfo.lines.add('Multiple match!');
          end;
    3  :  begin
            mmoInfo.lines.add('Verification fail!');
          end;
    7   : begin
            mmoInfo.lines.add('Please connect the device to USB port!');
          end;
    8  :  begin
            mmoInfo.lines.add('Poor image quality!');
          end;
    9   : begin
            mmoInfo.lines.add('Activation/verification code is incorrect!');
          end;
    11  : begin
            mmoInfo.lines.add('&Stop Verify!');
          end;
    15  : begin
            mmoInfo.Clear;
            mmoInfo.lines.add('Jari Menempel...');
          end;
    16  : begin
            mmoInfo.lines.add('Max 2000 templates!');
          end;
    17  : begin
            mmoInfo.lines.add('Max 10 Devices!');
          end;
    18  : begin
            mmoInfo.lines.add('Please add some template!');
          end;          
  end;
end;

procedure TFChekIO.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FPVer.FPVerificationStop;
end;

end.
