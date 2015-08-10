unit UUpdater;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGrid, ExtCtrls,IdHTTP,uLkJSON,ExtActns, ComCtrls;

type
  TForm1 = class(TForm)
    TableView: TcxGridDBTableView;
    Level: TcxGridLevel;
    cxGrid1: TcxGrid;
    TableViewColumn1: TcxGridDBColumn;
    TableViewColumn2: TcxGridDBColumn;
    TableViewColumn3: TcxGridDBColumn;
    pnl1: TPanel;
    btnCek: TButton;
    TableViewColumn4: TcxGridDBColumn;
    btnJalankan: TButton;
    pbDownload: TProgressBar;
    procedure btnCekClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure _set(baris,kolom:Integer; _isi:variant);
    procedure fileExistandVersion(baris,kolom:Integer; filename:string);
    procedure btnJalankanClick(Sender: TObject);
  private
    procedure URL_OnDownloadProgress
        (Sender: TDownLoadURL;
         Progress, ProgressMax: Cardinal;
         StatusCode: TURLDownloadStatus;
         StatusText: String; var Cancel: Boolean) ;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Json: string;
  js: TlkJsonObject;

implementation

{$R *.dfm}

function program_versi(exeName : string): string;
var V1, V2, V3, V4: Word;
   VerInfoSize, VerValueSize, Dummy : DWORD;
   VerInfo : Pointer;
   VerValue : PVSFixedFileInfo;
begin
VerInfoSize := GetFileVersionInfoSize(PChar(exeName), Dummy);
GetMem(VerInfo, VerInfoSize);
GetFileVersionInfo(PChar(exeName), 0, VerInfoSize, VerInfo);
VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
With VerValue^ do
begin
  V1 := dwFileVersionMS shr 16;
  V2 := dwFileVersionMS and $FFFF;
  V3 := dwFileVersionLS shr 16;
  V4 := dwFileVersionLS and $FFFF;
end;
FreeMem(VerInfo, VerInfoSize);

Result := IntToStr(V1) + '.'
            + IntToStr(V2) + '.'
            + IntToStr(V3) + '.'
            + IntToStr(V4);
end;

procedure TForm1.btnCekClick(Sender: TObject);
var
  IdHTTP: TIdHTTP;
  data: Integer;
begin
  fileExistandVersion(0,1,'..\gudang.exe');
  fileExistandVersion(1,1,'..\accounting.exe');
  fileExistandVersion(2,1,'..\pos_server.exe');
  fileExistandVersion(3,1,'..\kasir.exe');

  IdHTTP := TIdHTTP.Create(nil);
  try
    Json := IdHTTP.Get('http://gain-profit.github.io/profit.json');
  finally
    IdHTTP.Free;
  end;

  try
    js := TlkJSON.ParseText(Json) as TlkJSONobject;
    _set(0,2,VarToStr(js.Field['app'].Field['gudang'].Field['versi'].Value));
    _set(1,2,VarToStr(js.Field['app'].Field['accounting'].Field['versi'].Value));
    _set(2,2,VarToStr(js.Field['app'].Field['POS_server'].Field['versi'].Value));
    _set(3,2,VarToStr(js.Field['app'].Field['kasir'].Field['versi'].Value));
  except
    exit;
  end;

  for data:= 0 to tableview.DataController.RecordCount-1 do
  begin
    if TableView.DataController.GetValue(data, 1) <>
       TableView.DataController.GetValue(data, 2) then
      begin
        _set(data,3,'DOWNLOAD');
        btnJalankan.Enabled := True;
      end else
      begin
        _set(data,3,'LEWATI');
      end;
  end;
end;

procedure TForm1.fileExistandVersion(baris, kolom: Integer;
  filename: string);
begin
if FileExists(filename) then
  _set(baris,kolom,program_versi(filename))
else
  _set(baris,kolom,'HILANG');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
TableView.DataController.RecordCount := 4;
_set(0,0,'gudang');
_set(1,0,'accounting');
_set(2,0,'POS_server');
_set(3,0,'kasir');
end;

procedure TForm1._set(baris,kolom:Integer; _isi:variant);
begin
TableView.DataController.SetValue(baris,kolom,_isi);
end;

procedure TForm1.URL_OnDownloadProgress;
begin
   pbDownload.Max:= ProgressMax;
   pbDownload.Position:= Progress;
end;

procedure TForm1.btnJalankanClick(Sender: TObject);
var
  data: Integer;
  namafile, URLfile: string;
begin
  for data:= 0 to tableview.DataController.RecordCount-1 do
  begin
    if TableView.DataController.GetValue(data, 3) = 'DOWNLOAD' then
      begin
        URLfile := VarToStr(js.Field['app'].Field[TableView.DataController.GetValue(data, 0)].Field['download'].Value);
        namafile := Copy(URLfile,LastDelimiter('/',URLfile)+1,Length(URLfile)-LastDelimiter('/',URLfile));
        with TDownloadURL.Create(self) do
        try
         URL := URLfile;
         FileName := '..\'+namafile;
         OnDownloadProgress := URL_OnDownloadProgress;

         ExecuteTarget(nil);
        finally
         Free;
        end;
      end;
  end;
btnJalankan.Enabled := False;
end;

end.
