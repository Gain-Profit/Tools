program FRshow;

uses
  Dialogs,
  frxExportPDf,
  frxClass;
  
{$R *.res}

var
    rpt1: TfrxReport;
    opd1: TOpenDialog;
    pdf1: TfrxPDFExport;

begin
rpt1:= TfrxReport.Create(nil);
opd1:= TOpenDialog.Create(nil);
pdf1:= TfrxPDFExport.create(nil);

opd1.DefaultExt:= '.fp3';
opd1.Filter:= 'Fast Show (*.fp3)|*.fp3';

if ParamCount > 0 then
begin
    rpt1.PreviewPages.LoadFromFile(ParamStr(1));
    rpt1.ShowPreparedReport;
end else
begin
  if opd1.Execute then
  begin
    rpt1.PreviewPages.LoadFromFile(opd1.FileName);
    rpt1.ShowPreparedReport;
  end;
end;
rpt1.Free;
opd1.Free;
pdf1.Free;

end.


