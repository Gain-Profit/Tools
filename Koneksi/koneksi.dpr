program koneksi;

uses
  Forms,
  UKoneksi in 'UKoneksi.pas' {FKoneksi};

{$R *.res}
{$R 'RequestAdmin.res'}

begin
  Application.Initialize;
  Application.Title := 'Koneksi Database';
  Application.CreateForm(TFKoneksi, FKoneksi);
  Application.Run;
end.
