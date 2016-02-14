unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, sStatusBar, StdCtrls, Buttons, sBitBtn, sLabel;

type
  TFMain = class(TForm)
    sb: TsStatusBar;
    btnCheckIn: TsBitBtn;
    btnCheck: TsBitBtn;
    lbl1: TsLabel;
    lbl2: TsLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnCheckInClick(Sender: TObject);
    procedure btnCheckClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

uses UDM, UCheckIO;

{$R *.dfm}

procedure TFMain.FormCreate(Sender: TObject);
begin
sb.Panels[0].Text := dm.xConn.DatabaseName + '@' +dm.xConn.Host;
end;

procedure TFMain.btnCheckInClick(Sender: TObject);
begin
Application.CreateForm(TFChekIO,FChekIO);
FChekIO.ShowModal;
end;

procedure TFMain.btnCheckClick(Sender: TObject);
begin
Application.CreateForm(TFChekIO,FChekIO);
FChekIO.ShowModal;
end;

end.
