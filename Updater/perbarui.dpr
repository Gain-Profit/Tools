program perbarui;

uses
  Forms,
  // Unit yang digunakan untuk cek instance sebelumnya.
  CheckPrevious In 'CheckPrevious.pas',
  UnitUtama in 'UnitUtama.pas' {FormUtama},
  UDM in 'UDM.pas' {dm: TDataModule};

{$R *.res}
// agar aplikasi berjalan sebagai administrator
//{$R 'RequestAdmin.res'}

begin
  // Hanya boleh ada satu instance
  if not CheckPrevious.RestoreIfRunning(Application.Handle, 1) then
  begin
    Application.Initialize;
    Application.Title := 'Gain Profit Updater';
    Application.CreateForm(TFormUtama, FormUtama);
    Application.CreateForm(Tdm, dm);
    // Jangan Tampilkan Form Utama ketika di create
    Application.ShowMainForm:=False;
    Application.Run;
  end;
end.
