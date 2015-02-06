program FRdesign;

uses
  Dialogs,
  frxDesgn,
  frxClass;


{$R *.res}
var
    rpt1: TfrxReport;
    dsg1: TfrxDesigner;
    opd1: TOpenDialog;

begin
rpt1:= TfrxReport.Create(nil);
dsg1:= TfrxDesigner.Create(nil);
opd1:= TOpenDialog.Create(nil);
opd1.DefaultExt:= '.fr3';
opd1.Filter:= 'Fast Design(*.fr3)|*.fr3';

if ParamCount > 0 then
begin
    rpt1.LoadFromFile(ParamStr(1));
    rpt1.DesignReport;
end else
begin
  if opd1.Execute then
  begin
    rpt1.LoadFromFile(opd1.FileName);
    rpt1.DesignReport;
  end;
end;
rpt1.Free;
dsg1.Free;
opd1.Free;
end.
