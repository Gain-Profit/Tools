program GainUpdaterService;

uses
  SvcMgr,
  Utama in 'Utama.pas' {GainUpdater: TService};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TGainUpdater, GainUpdater);
  Application.Run;
end.
