program perbarui;

uses
  Forms,
  UnitUtama in 'UnitUtama.pas' {FormUtama},
  UDM in 'UDM.pas' {dm: TDataModule};

{$R *.res}
{$R 'RequestAdmin.res'}

begin
  Application.Initialize;
  Application.Title := 'Gain Profit Updater';
  Application.CreateForm(TFormUtama, FormUtama);
  Application.CreateForm(Tdm, dm);
  // Jangan Tampilkan Form Utama ketika di create
  Application.ShowMainForm:=False;
  Application.Run;
end.
