program perbarui;

uses
  Forms,
  UnitUtama in 'UnitUtama.pas' {FormUtama},
  UDM in 'UDM.pas' {dm: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormUtama, FormUtama);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.
