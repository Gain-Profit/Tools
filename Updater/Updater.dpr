program Updater;

uses
  Forms,
  UUpdater in 'UUpdater.pas' {FUpdater};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Updater Gain Profit';
  Application.CreateForm(TFUpdater, FUpdater);
  Application.Run;
end.
