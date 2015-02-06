program koneksi;

uses
  fastMM4,
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  U_Utama in 'U_Utama.pas' {F_atur};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Gain Setting 2.0';
  Application.CreateForm(TF_atur, F_atur);
  Application.Run;
end.
