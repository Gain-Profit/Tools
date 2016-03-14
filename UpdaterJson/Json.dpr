program Json;

uses
  Forms,
  UnitUtama in 'UnitUtama.pas' {FormUtama};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormUtama, FormUtama);
  Application.Run;
end.
