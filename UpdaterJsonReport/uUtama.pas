unit uUtama;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Xmldoc, StdCtrls, XMLIntf, ComCtrls, ExtCtrls, filectrl, ulkjson,
  IdHashMessageDigest;

type
  TVersion = class
    Mayor: Integer;
    Minor: Integer;
    Release: Integer;
    Build: Integer;
    public
      constructor Create(AMayor, AMinor, ARelease, ABuild: Integer);
      function AsString: string;
  end;

  TReportVersion = class(TVersion)
    public
      constructor Create(AFile: TFileName);
  end;

  TForm1 = class(TForm)
    Lv: TListView;
    Panel1: TPanel;
    BtnVersi: TButton;
    EdDir: TEdit;
    OpenDialog1: TOpenDialog;
    BtnSimpan: TButton;
    procedure BtnVersiClick(Sender: TObject);
    procedure EdDirDblClick(Sender: TObject);
    procedure BtnSimpanClick(Sender: TObject);
  private
    function ReportVersion(AFile: TFileName): TVersion;
    { Private declarations }
  public
    { Public declarations }
  end;


var
  Form1: TForm1;

implementation

{$R *.dfm}

//returns MD5 has for a file
function MD5(const fileName: string): string;
var
  idmd5: TIdHashMessageDigest5;
  fs: TFileStream;
begin
  idmd5 := TIdHashMessageDigest5.Create;
  fs := TFileStream.Create(fileName, fmOpenRead or fmShareDenyWrite);
  try
    result := idmd5.AsHex(idmd5.HashValue(fs));
  finally
    fs.Free;
    idmd5.Free;
  end;
end;

procedure GetFiles(const StartDir: String; const List: TListItems);
var
  SRec: TSearchRec;
  Res: Integer;
  item: TListItem;
begin
  if not Assigned(List) then
  begin
    Exit;
  end;

  list.Clear;
  Res := FindFirst(StartDir + '*.fr3', faAnyfile, SRec );
  if Res = 0 then
  try
    while res = 0 do
    begin
      item := List.Add;
      item.Caption := SRec.Name;
      item.SubItems.Add(TReportVersion.Create(StartDir + SRec.Name).AsString);
      item.SubItems.Add(MD5(StartDir + SRec.Name));
      Res := FindNext(SRec);
    end;
  finally
    FindClose(SRec)
  end;
end;

{ TVersion }

constructor TVersion.Create(AMayor, AMinor, ARelease, ABuild: Integer);
begin
  self.Mayor := AMayor;
  Self.Minor := AMinor;
  Self.Release := ARelease;
  Self.Build := ABuild;
end;

function TVersion.AsString: string;
begin
  Result := Format('%d.%d.%d.%d', [Self.Mayor, Self.Minor, Self.Release, Self.Build]);
end;

{ TReportVersion }

constructor TReportVersion.Create(AFile: TFileName);
var
  lap: IXMLNode;
  xml : IXMLDocument;
begin
  try
    xml := TXMLDocument.Create(nil);
    xml.FileName :=AFile;
    xml.Active := True;
    lap := xml.ChildNodes.FindNode('TfrxReport');
    inherited Create(
        StrToIntDef(VarToStr(lap.Attributes['ReportOptions.VersionMajor']), 0),
        StrToIntDef(VarToStr(lap.Attributes['ReportOptions.VersionMinor']), 0),
        StrToIntDef(VarToStr(lap.Attributes['ReportOptions.VersionRelease']), 0),
        StrToIntDef(VarToStr(lap.Attributes['ReportOptions.VersionBuild']), 0)
      );
  finally
    xml.Active := False;
  end;
end;

function TForm1.ReportVersion(AFile: TFileName): TVersion;
var
  lap: IXMLNode;
  xml : IXMLDocument;
begin
  try
    xml := TXMLDocument.Create(nil);
    xml.FileName :=AFile;
    xml.Active := True;
    lap := xml.ChildNodes.FindNode('TfrxReport');
    Result := TVersion.Create(
        StrToIntDef(VarToStr(lap.Attributes['ReportOptions.VersionMajor']), 0),
        StrToIntDef(VarToStr(lap.Attributes['ReportOptions.VersionMinor']), 0),
        StrToIntDef(VarToStr(lap.Attributes['ReportOptions.VersionRelease']), 0),
        StrToIntDef(VarToStr(lap.Attributes['ReportOptions.VersionBuild']), 0)
      );
  finally
    xml.Active := False;
  end;
end;

procedure TForm1.BtnVersiClick(Sender: TObject);
begin
  GetFiles(EdDir.Text, lv.Items);
end;

procedure TForm1.EdDirDblClick(Sender: TObject);
var
  chosenDirectory: string;
begin
  if selectdirectory('Select a directory', '', chosenDirectory) then
    EdDir.Text := chosenDirectory + '\';
end;

procedure TForm1.BtnSimpanClick(Sender: TObject);
var
  X: TextFile;
  js, jsonDetail: TlkJSONobject;
  jsonList: TlkJSONlist;
  no, i: Integer;
  json: string;
begin
  try
    js := TlkJSONobject.Create(False);
    jsonList := TlkJSONlist.Create;

    for no := 0 to 10 do
    begin
      jsonDetail := TlkJSONobject.Create(False);
      jsondetail.Add('nama', lv.Items[no].Caption);
      jsondetail.Add('path', '/Laporan/');
      jsondetail.Add('md5_file', lv.Items[no].SubItems.Strings[1]);
      jsondetail.Add('versi', lv.Items[no].SubItems.Strings[0]);
      jsondetail.Add('download',
        'https://raw.githubusercontent.com/Gain-Profit/laporan/master/' + lv.Items[no].Caption);
      jsonList.Add(jsonDetail);
    end;
    js.Add('profit_report', jsonList);

    i := 0;
    json := GenerateReadableText(js, i);

    assignfile(X, 'updater_report.json');
    rewrite(X);
    write(X, json);
    closefile(X);

    showmessage('penyimpanan data Berhasil');
  except
    on E: Exception do
    begin
      showmessage('SIMPAN DATA GAGAL...'#10#13'' + E.message);
    end;
  end;
end;

end.
