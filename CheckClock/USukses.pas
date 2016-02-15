unit USukses;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sLabel, ExtCtrls, Buttons, sBitBtn;

type
  TFSukses = class(TForm)
    imgSIdikJari: TImage;
    lblStatus: TsLabel;
    lblKode: TsLabel;
    lblNama: TsLabel;
    btnKeluar: TsBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btnKeluarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSukses: TFSukses;

implementation

{$R *.dfm}

procedure TFSukses.FormShow(Sender: TObject);
begin
  lblStatus.Caption := Caption;
end;

procedure TFSukses.btnKeluarClick(Sender: TObject);
begin
  Close;
end;

procedure TFSukses.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_escape then
  Close;
end;

end.
