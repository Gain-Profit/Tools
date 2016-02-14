program SMSgateway;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Uutama, uDm, uKotakMasuk, uKirimPesan
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFUtama, FUtama);
  Application.Run;
end.

