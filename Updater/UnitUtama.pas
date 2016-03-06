unit UnitUtama;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGrid, ExtCtrls,IdHTTP,uLkJSON,ExtActns, ComCtrls,
  frxBarcode, frxClass, AbBase, AbBrowse, AbZBrows, AbUnzper,TlHelp32,
  AbComCtrls,AbArcTyp;

type
  TFormUtama = class(TForm)
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
    Laporan: TfrxReport;
    frxBarCodeObject1: TfrxBarCodeObject;
    TableViewColumn5: TcxGridDBColumn;
    status: TStatusBar;
    UnZipApp: TAbUnZipper;
    procedure btnCekClick(Sender: TObject);
    procedure _set(baris,kolom:Integer; _isi:variant);
    function fileExistandVersion(filename:string):string;
    procedure btnJalankanClick(Sender: TObject);
    procedure UnZipAppArchiveItemProgress(Sender: TObject;
      Item: TAbArchiveItem; Progress: Byte; var Abort: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    function GetURLDownloadLocal(UrlOnline: string):string;
    procedure LoadDataFromJson;
    procedure LoadDataFromDatabase;
    procedure URL_OnDownloadProgress
        (Sender: TDownLoadURL;
         Progress, ProgressMax: Cardinal;
         StatusCode: TURLDownloadStatus;
         StatusText: String; var Cancel: Boolean) ;
    function loadJsonOnline(online:Boolean):Boolean;
    function laporan_versi(filename: string): string;
    function cekAksi(baris:Integer;path,URLfile: string):string;
  public
    { Public declarations }
  end;

var
  FormUtama: TFormUtama;
  Json: string;
  js: TlkJsonObject;

implementation

uses UDM;

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

function TFormUtama.laporan_versi(filename: string): string;
var
  versi: string;
begin
  Laporan.LoadFromFile(filename);

  with Laporan.ReportOptions do
  begin
    versi := VersionMajor+'.'+VersionMinor+'.'+VersionRelease+'.'+VersionBuild;
  end;

  Result := versi;
end;

function TFormUtama.loadJsonOnline(online: Boolean): Boolean;
var
  IdHTTP: TIdHTTP;
begin
  Result := True;
  if online then
  begin
    IdHTTP := TIdHTTP.Create(nil);
    try
      Json := IdHTTP.Get('http://gain-profit.github.io/updater.json');
      js := TlkJSON.ParseText(Json) as TlkJSONobject;
    except
      ShowMessage('TIDAK DAPAT MENYAMBUNGKAN KE INTERNET');
      Result := False;
    end;
    IdHTTP.Free;
  end else
      js := TlkJSONstreamed.loadfromfile('updater.json') as TlkJsonObject;
end;

function TFormUtama.cekAksi(baris:Integer;path,URLfile: string):string;
var
  namaFile: string;
begin
  namaFile  := Copy(URLfile,LastDelimiter('/',URLfile) + 1,Length(URLfile));

  if TableView.DataController.GetValue(baris, 1) <>
     TableView.DataController.GetValue(baris, 2) then
    begin
      btnJalankan.Enabled := True;

      if FileExists(path + namaFile) then
        Result := 'EXTRACT ' + namaFile else
        Result := 'DOWNLOAD ' + namaFile;
    end else
    begin
      Result := 'LEWATI';
    end;
end;

function GetParentFolder(path:string):string;
begin
  Result := ExpandFileName(path+'\..');
end;

function TFormUtama.GetURLDownloadLocal(UrlOnline: string): string;
var
  fileName: string;
begin
  fileName  := Copy(UrlOnline,LastDelimiter('/',UrlOnline) + 1,Length(UrlOnline));
  Result    := 'http://'+dm.xConn.Host + '/GainProfit/' + fileName;
end;

procedure TFormUtama.LoadDataFromDatabase;
var
  NoItem: Integer;
  nama,namaFile,versiOnline,path,download,versiOffline,aksi:string;
  updated: Boolean;
begin
  if dm.terkoneksi then
  begin
    updated:= True;
    // Hanya Menampilkan Aplikasi...
    dm.SQLExec(dm.QShow, 'SELECT * FROM app_versi WHERE RIGHT(kode,4)=".exe"', True);

    dm.QShow.First;
    TableView.DataController.RecordCount := dm.QShow.RecordCount;
    for NoItem := 0 to dm.QShow.RecordCount - 1 do
    begin
      nama        := dm.QShow.FieldByName('kode').AsString;
      versiOnline := dm.QShow.FieldByName('versi_terbaru').AsString;
      path        := dm.QShow.FieldByName('path').AsString;
      download    := GetURLDownloadLocal(dm.QShow.FieldByName('URLdownload').AsString);
      namaFile    := ThisPath + path + nama;
      versiOffline:= fileExistandVersion(namaFile);

      _set(NoItem,0,namaFile);
      _set(NoItem,1,versiOnline);
      _set(NoItem,2,versiOffline);
      aksi        := cekAksi(NoItem,ThisPath + path,download);
      _set(NoItem,3,aksi);
      if aksi <> 'LEWATI' then
        updated:= False;
      _set(NoItem,4,download);
      dm.QShow.Next;
    end;
    if updated then
    begin
      btnJalankan.Enabled := False;
      ShowMessage('Semua Aplikasi Sudah TerUpdate...');
    end;
  end else
  begin
    ShowMessage('Tidak Dapat Terhubung ke Database...');
  end;
end;

procedure TFormUtama.LoadDataFromJson;
var
  jsonDetail:TlkJSONobject;
  NoItem: Integer;
  nama,namaFile,versiOnline,path,download,versiOffline,aksi:string;
  updated: Boolean;
begin
  pbDownload.Position:= 0;
  btnJalankan.Enabled := False;

  if not loadJsonOnline(False) then Exit;

  TableView.DataController.RecordCount := js.Field['profit'].Count;

  for NoItem := 0 to js.Field['profit'].Count -1 do
  begin
    jsonDetail  := (js.Field['profit'].Child[NoItem] as TlkJSONobject);
    nama        := jsondetail.getString('nama');
    versiOnline := jsondetail.getString('versi');
    path        := jsondetail.getString('path');
    download    := jsondetail.getString('download');
    namaFile    := ThisPath + path + nama;
    versiOffline:= fileExistandVersion(namaFile);

    _set(NoItem,0,namaFile);
    _set(NoItem,1,versiOnline);
    _set(NoItem,2,versiOffline);
    aksi        := cekAksi(NoItem,ThisPath + path,download);
    _set(NoItem,3,aksi);
    if aksi <> 'LEWATI' then
      updated:= False;
    _set(NoItem,4,download);
  end;
  if updated then
  begin
    btnJalankan.Enabled := False;
    ShowMessage('Semua Aplikasi Sudah TerUpdate...');
  end;

  status.Panels[0].Text := 'Pengecekan File Gain Profit Selesai...';
end;

procedure TFormUtama.btnCekClick(Sender: TObject);
begin
  //LoadDataFromJson;
  LoadDataFromDatabase;
end;

function TFormUtama.fileExistandVersion(filename: string) : string;
begin
  if FileExists(filename) then
  begin
    if ExtractFileExt(filename) = '.exe' then
    Result := program_versi(filename) else
    if ExtractFileExt(filename) = '.fr3' then
    Result := laporan_versi(filename);
  end else
  begin
    Result := 'HILANG';
  end;
end;

procedure TFormUtama._set(baris,kolom:Integer; _isi:variant);
begin
TableView.DataController.SetValue(baris,kolom,_isi);
end;

procedure TFormUtama.URL_OnDownloadProgress;
begin
   pbDownload.Max:= ProgressMax;
   pbDownload.Position:= Progress;
end;

function processExists(exeFileName: string): Boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
    begin
      Result := True;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

procedure TFormUtama.btnJalankanClick(Sender: TObject);
var
  data: Integer;
  URLfile,kolomAksi,kolomNama,namaFile: string;
begin
  for data:= 0 to tableview.DataController.RecordCount-1 do
  begin
    kolomAksi := TableView.DataController.GetValue(data, 3);
    kolomNama := TableView.DataController.GetValue(data, 0);
    namaFile  := Copy(kolomNama,LastDelimiter('/',kolomNama) + 1,Length(kolomNama));

    if processExists(namaFile) then
    begin
      ShowMessage('Tidak dapat melakukan Aksi untuk Aplikasi '+ namaFile + #13#10
      +'Aplikasi Masih Berjalan, Tutup Aplikasi !!!');
      Exit;
    end;

    if Copy(kolomAksi,1,8) = 'DOWNLOAD' then
      begin
        status.Panels[0].Text := 'Download File ' + namaFile;
        URLfile := TableView.DataController.GetValue(data, 4);
        with TDownloadURL.Create(self) do
        try
         URL := URLfile;
         FileName := Copy(kolomAksi,10,Length(kolomAksi)-1);
         OnDownloadProgress := URL_OnDownloadProgress;

         ExecuteTarget(nil);
        finally
         Free;
        end;

        if ExtractFileExt(Copy(kolomAksi,10,Length(kolomAksi)-1)) = '.zip' then
        begin
        UnZipApp.FileName := Copy(kolomAksi,10,Length(kolomAksi)-1);
        UnZipApp.ExtractAt(0,TableView.DataController.GetValue(data, 0));
        end;

      end;

    if Copy(kolomAksi,1,7) = 'EXTRACT' then
      begin
        UnZipApp.FileName := Copy(kolomAksi,9,Length(kolomAksi)-1);
        UnZipApp.ExtractAt(0,TableView.DataController.GetValue(data, 0));
      end;
  end;

  btnCekClick(Self);
end;


procedure TFormUtama.UnZipAppArchiveItemProgress(Sender: TObject;
  Item: TAbArchiveItem; Progress: Byte; var Abort: Boolean);
begin
  status.Panels[0].Text := 'Extract file : ' + Item.FileName;
  pbDownload.Position := Progress;
end;

procedure TFormUtama.FormCreate(Sender: TObject);
var
  tempat: String;
begin
  tempat:= GetParentFolder(ExtractFilePath(Application.ExeName));
  ThisPath := StringReplace(tempat,'\','/',[rfReplaceAll]);
end;

end.
