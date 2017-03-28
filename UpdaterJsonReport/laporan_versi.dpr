program laporan_versi;

uses
  Forms,
  uUtama in 'uUtama.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
