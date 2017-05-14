program dump;

uses
  Forms,
  u_utama in 'u_utama.pas' {FrmBackup};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Auto BackUp';
  Application.ShowMainForm:=False;
  Application.CreateForm(TFrmBackup, FrmBackup);
  Application.Run;
end.
