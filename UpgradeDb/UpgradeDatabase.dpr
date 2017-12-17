program UpgradeDatabase;

uses
  Vcl.Forms,
  uUtama in 'uUtama.pas' {FrmUpgrade};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmUpgrade, FrmUpgrade);
  Application.Run;
end.
