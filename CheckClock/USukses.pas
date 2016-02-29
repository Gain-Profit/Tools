unit USukses;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sLabel, ExtCtrls, Buttons, sBitBtn, sMemo, sEdit;

type
  TFSukses = class(TForm)
    lblStatus: TsLabel;
    lblKode: TsLabel;
    lblNama: TsLabel;
    btnKeluar: TsBitBtn;
    lblCheck: TsLabel;
    lblKeterangan: TsLabel;
    imgSidikJari: TImage;
    edKeterangan: TsEdit;
    procedure FormShow(Sender: TObject);
    procedure btnKeluarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edKeteranganKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    jenis: string;
    { Public declarations }
  end;

var
  FSukses: TFSukses;

implementation

uses UDM;

{$R *.dfm}

procedure TFSukses.FormShow(Sender: TObject);
begin
  FSukses.Caption := 'CHECK '+ jenis + ' SUKSES';
  lblStatus.Caption := Caption;
  if jenis = 'OUT' then
  begin
    edKeterangan.Visible := False;
    lblKeterangan.Visible:= False;
    btnKeluar.Caption := 'Keluar';
  end;  
end;

procedure TFSukses.btnKeluarClick(Sender: TObject);
var
  sql: string;
begin
  if (jenis = 'IN') and (edKeterangan.Text <> '') then
  begin
    sql := Format('UPDATE tb_checkinout SET keterangan = "%s" ' +
    'WHERE user_id = "%s" AND checkin_time = "%s"',
    [edKeterangan.Text,lblKode.Caption,lblCheck.Caption]);

    dm.SQLExec(dm.Qexe,sql,False);
  end;

  Close;
end;

procedure TFSukses.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_escape then
  Close;
end;

procedure TFSukses.edKeteranganKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=vk_return then
  begin
    btnKeluarClick(Sender);
  end;
end;

end.
