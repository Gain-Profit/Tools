program GainService;

uses
  SvcMgr,
  utama in 'utama.pas' {ServiceMutasi: TService};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TServiceMutasi, ServiceMutasi);
  Application.Run;
end.
