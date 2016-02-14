unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, sStatusBar, StdCtrls, Buttons, sBitBtn;

type
  TFMain = class(TForm)
    sb: TsStatusBar;
    sBitBtn1: TsBitBtn;
    sBitBtn2: TsBitBtn;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

uses UDM;

{$R *.dfm}

procedure TFMain.FormCreate(Sender: TObject);
begin
sb.Panels[0].Text := dm.xConn.DatabaseName + '@' +dm.xConn.Host;
end;

end.
