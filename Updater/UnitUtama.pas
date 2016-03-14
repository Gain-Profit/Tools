unit UnitUtama;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGrid, ExtCtrls,IdHTTP,uLkJSON,ExtActns, ComCtrls,
  frxBarcode, frxClass, AbBase, AbBrowse, AbZBrows, AbUnzper,TlHelp32,
  AbComCtrls,AbArcTyp,ShellAPI;

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
    tmrBaru: TTimer;
    procedure btnCekClick(Sender: TObject);
    procedure _set(baris,kolom:Integer; _isi:variant);
    function fileExistandVersion(filename:string):string;
    procedure btnJalankanClick(Sender: TObject);
    procedure UnZipAppArchiveItemProgress(Sender: TObject;
      Item: TAbArchiveItem; Progress: Byte; var Abort: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure WndProc(var Msg : TMessage); override;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tmrBaruTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    function GetURLDownloadLocal(UrlOnline: string):string;
    procedure LoadDataFromJson;
    function LoadDataFromDatabase: Boolean;
    procedure URL_OnDownloadProgress
        (Sender: TDownLoadURL;
         Progress, ProgressMax: Cardinal;
         StatusCode: TURLDownloadStatus;
         StatusText: String; var Cancel: Boolean) ;
    function loadJsonOnline(online:Boolean):Boolean;
    function laporan_versi(filename: string): string;
    function cekAksi(baris:Integer; URLfile: string):string;
  public
    IconData : TNotifyIconData;
    IconCount : integer;
  end;

var
  FormUtama: TFormUtama;
  Json: string;
  js: TlkJsonObject;

implementation

uses UDM, Math;

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

function TFormUtama.cekAksi(baris:Integer; URLfile: string):string;
var
  namaFile: string;
begin
  namaFile  := Copy(URLfile,LastDelimiter('/',URLfile) + 1,Length(URLfile));

  if TableView.DataController.GetValue(baris, 1) <>
     TableView.DataController.GetValue(baris, 2) then
    begin
      btnJalankan.Enabled := True;
      status.Panels[0].Text := 'Jalankan Aksi...';

      if FileExists(ThisPath + '/Downloaded/' + namaFile) then
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

function TFormUtama.LoadDataFromDatabase: Boolean;
var
  NoItem: Integer;
  nama,namaFile,versiOnline,path,download,versiOffline,aksi:string;
  updated: Boolean;
begin
  pbDownload.Position:= 0;
  updated:= True;

  if dm.terkoneksi then
  begin
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
      aksi        := cekAksi(NoItem, download);
      _set(NoItem,3,aksi);
      if aksi <> 'LEWATI' then
        updated:= False;
      _set(NoItem,4,download);
      dm.QShow.Next;
    end;
  end else
  begin
    status.Panels[0].Text := 'Tidak Dapat Terhubung ke Database...';
  end;
  
  Result:= updated;
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
    aksi        := cekAksi(NoItem, download);
    _set(NoItem,3,aksi);
    if aksi <> 'LEWATI' then
      updated:= False;
    _set(NoItem,4,download);
  end;
  if updated then
  begin
    btnJalankan.Enabled := False;
    ShowMessage('Semua Aplikasi Sudah TerUpdate...');
    status.Panels[0].Text := 'Semua Aplikasi Sudah TerUpdate...';
  end;
end;

procedure TFormUtama.btnCekClick(Sender: TObject);
begin
  //LoadDataFromJson;
  if LoadDataFromDatabase then
    begin
      btnJalankan.Enabled := False;
      ShowMessage('Semua Aplikasi Sudah TerUpdate...');
      status.Panels[0].Text := 'Semua Aplikasi Sudah TerUpdate...';
    end;
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
  URLfile,kolomAksi,kolomNama,namaFile,zipFile: string;
begin
  if not(DirectoryExists(ThisPath + '/Downloaded')) then
    CreateDir(ThisPath + '/Downloaded');

  for data:= 0 to tableview.DataController.RecordCount-1 do
  begin
    kolomAksi := TableView.DataController.GetValue(data, 3);
    kolomNama := TableView.DataController.GetValue(data, 0);
    namaFile  := Copy(kolomNama,LastDelimiter('/',kolomNama) + 1,Length(kolomNama));
    zipFile   := ThisPath + '/Downloaded/' +
    Copy(kolomAksi,LastDelimiter(' ',kolomAksi) + 1,Length(kolomAksi));
    
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
         FileName := zipFile;
         OnDownloadProgress := URL_OnDownloadProgress;

         ExecuteTarget(nil);
        finally
         Free;
        end;

        UnZipApp.FileName := zipFile;
        UnZipApp.ExtractAt(0,TableView.DataController.GetValue(data, 0));
        UnZipApp.CloseArchive;
      end;

    if Copy(kolomAksi,1,7) = 'EXTRACT' then
      begin
        UnZipApp.FileName := zipFile;
        UnZipApp.ExtractAt(0,TableView.DataController.GetValue(data, 0));
        UnZipApp.CloseArchive;
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

  ShowWindow(Application.Handle, SW_HIDE);

  BorderIcons := [biSystemMenu];
  IconCount := 0;
  IconData.cbSize := sizeof(IconData);
  IconData.Wnd := Handle;
  IconData.uID := 100;
  IconData.uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
  IconData.uCallbackMessage := WM_USER + 1;
  IconData.hIcon := Application.Icon.Handle;
  StrPCopy(IconData.szTip, Application.Title);
  Shell_NotifyIcon(NIM_ADD, @IconData);
end;

procedure TFormUtama.FormResize(Sender: TObject);
begin
  pbDownload.Width := btnJalankan.Left - pbDownload.Left - 8;
end;

procedure TFormUtama.WndProc(var Msg: TMessage);
begin
  case Msg.Msg of
    WM_USER + 1:
    case Msg.lParam of
      WM_LBUTTONDOWN:
      begin
        if FormUtama.Showing then
          FormUtama.Hide else
          FormUtama.Show;
      end;
    end;
  end;
  inherited;
end;

procedure TFormUtama.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caNone;
  FormUtama.Hide;
end;

procedure TFormUtama.tmrBaruTimer(Sender: TObject);
begin
  // jalankan aksi setiap satu menit....
  if not LoadDataFromDatabase then
  begin
    FormUtama.Show;
  end; 
end;

procedure TFormUtama.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Ctrl + F4 untuk menutup applikasi
  if ((Shift = [ssCtrl]) and (Key = VK_F4)) then
    Application.Terminate;
end;

end.
