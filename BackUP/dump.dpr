program dump;

uses
  Forms,
  u_utama in 'u_utama.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Auto BackUp';
  Application.ShowMainForm:=False;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
