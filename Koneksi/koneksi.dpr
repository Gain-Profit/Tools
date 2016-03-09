program koneksi;

uses
  Forms,
  U_Utama in 'U_Utama.pas' {F_atur};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Gain Setting 2.0';
  Application.CreateForm(TF_atur, F_atur);
  Application.Run;
end.
