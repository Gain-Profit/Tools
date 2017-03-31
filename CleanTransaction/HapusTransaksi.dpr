program HapusTransaksi;

uses
  Forms,
  uUtama in 'uUtama.pas' {FUtama};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFUtama, FUtama);
  Application.Run;
end.
