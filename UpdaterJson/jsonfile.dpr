program jsonfile;

uses
  Forms,
  UnitUtama in 'UnitUtama.pas' {FormUtama},
  uLkJSON in '..\pascal\uLkJSON.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormUtama, FormUtama);
  Application.Run;
end.
