program CheckClock;

uses
  Forms,
  UCheckIO in 'UCheckIO.pas' {FChekIO},
  UDM in 'UDM.pas' {dm: TDataModule},
  UMain in 'UMain.pas' {FMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
