program GainUpdaterService;

uses
  SvcMgr,
  Utama in 'Utama.pas' {GainUpdater: TService},
  UDM in 'UDM.pas' {dm: TDataModule};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TGainUpdater, GainUpdater);
  Application.Run;
end.
