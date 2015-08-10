program Updater;

uses
  Forms,
  UUpdater in 'UUpdater.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
