Program ServiceSMS;

Uses
{$IFDEF UNIX}{$IFDEF UseCThreads}
  CThreads,
{$ENDIF}{$ENDIF}
  DaemonApp, lazdaemonapp, daemonmapperunitSMS, daemonunitSMS
  { add your units here };

{$R *.res}

begin
  Application.Title:='Daemon Gain Profit SMS';
  Application.Initialize;
  Application.Run;
end.
