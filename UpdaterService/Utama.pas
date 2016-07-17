unit Utama;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  IniFiles, SHFolder, ExtCtrls, TlHelp32, ShellAPI, AbUnzper, ExtActns;

type
  TGainUpdater = class(TService)
    Timer1: TTimer;
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure UpdateApplication;
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

type
  TApplication = class(TComponent)
  private
    FRootPath : string;
    FPath     : string;
    FName     : string;
    FVersion  : string;
    FMd5      : string;
    function URLDownLoad: string;
    function FileVersion: string;
    function ZipFile: string;
    function FullFileName: string;
    procedure ExtractZipFile;
    procedure DownloadZipFile;
  public
    constructor Create(RootPath, Path, Name, Version, Md5: string);
    procedure UpdateApplication;
  end;

var
  GainUpdater: TGainUpdater;

implementation

uses UDM;

{$R *.DFM}

function GetAppData(Folder: Integer): string;
var
  path: array[0..MAX_PATH] of Char;
begin
  if Succeeded(SHGetFolderPath(0, Folder, 0, 0, @Path[0])) then
    Result := path + '\Gain Profit\'
  else
    Result := '';
end;

function program_versi(exeName: string): string;
var
  V1, V2, V3, V4: Word;
  VerInfoSize, VerValueSize, Dummy: DWORD;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(exeName), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(exeName), 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
  with VerValue^ do
  begin
    V1 := dwFileVersionMS shr 16;
    V2 := dwFileVersionMS and $FFFF;
    V3 := dwFileVersionLS shr 16;
    V4 := dwFileVersionLS and $FFFF;
  end;
  FreeMem(VerInfo, VerInfoSize);

  Result := IntToStr(V1) + '.' + IntToStr(V2) + '.' + IntToStr(V3) + '.' + IntToStr(V4);
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
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName))
      or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName))) then
    begin
      Result := True;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

procedure Log(msg: string);
var
  X: TextFile;
  sekarang, FileName: string;
begin
  sekarang := FormatDateTime('dd/MM/yyyy hh:nn:ss', Now);
  FileName := AppPath + 'LogServiceUpdater.txt';

  assignfile(X, FileName);
  if not FileExists(FileName) then
    Rewrite(X) else
    Append(X);
  Writeln(X, sekarang + ' : '+ msg);
  closefile(X);
end;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  GainUpdater.Controller(CtrlCode);
end;

function TGainUpdater.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TGainUpdater.UpdateApplication;
var
  xxx: Integer;
  nama, versiOnline, path, MD5Online: string;
  app : TApplication;
begin
  dm.SQLExec(dm.QShow, 'SELECT * FROM app_versi WHERE RIGHT(kode,4)=".exe" ' +
    'ORDER BY path', True);

  dm.QShow.First;
  for xxx := 0 to dm.QShow.RecordCount - 1 do
  begin
    nama := dm.QShow.FieldByName('kode').AsString;
    versiOnline := dm.QShow.FieldByName('versi_terbaru').AsString;
    path := dm.QShow.FieldByName('path').AsString;
    MD5Online := dm.QShow.FieldByName('md5_file').AsString;

    if not processExists(nama) then
    begin
      try
        app := TApplication.Create(FRootPath,path,nama,versiOnline,MD5Online);
        app.UpdateApplication;
        app.Free;
      except
        on e: Exception do Log(e.Message);
      end;
    end;
    
    dm.QShow.Next;
  end;
end;

procedure TGainUpdater.ServiceStart(Sender: TService;
  var Started: Boolean);
  var
    AppINI: TIniFile;
begin
  AppPath := GetAppData(CSIDL_COMMON_APPDATA);
  Log('Service Start.');

  if not (DirectoryExists(AppPath)) then
    CreateDir(AppPath);

  appINI := TIniFile.Create(AppPath + 'gain.ini');
  try
    FRootPath := appINI.ReadString('updater', 'root_path', 'C:\Program Files\GAIN PROFIT');
  finally
    appINI.Free;
  end;

  Log('Root Path: ' + FRootPath);
  
  Application.CreateForm(Tdm, dm);

  if not (DirectoryExists(FRootPath + '\Downloaded')) then
    CreateDir(FRootPath + '\Downloaded');

  Timer1.Enabled:= True;
end;

procedure TGainUpdater.Timer1Timer(Sender: TObject);
begin
  if dm.terkoneksi then
  begin
    UpdateApplication;
  end;
end;

procedure TGainUpdater.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  Log('Service Stop.');
  Timer1.Enabled:= False;
  dm.Free;
end;

{ TApplication }

constructor TApplication.Create(RootPath, Path, Name, Version, Md5: string);
begin
  FRootPath := RootPath;
  FPath     := Path;
  FName     := Name;
  FVersion  := Version;
  FMd5      := Md5;
end;

procedure TApplication.DownloadZipFile;
begin
  Log('Download File: ' + URLDownLoad);

  with TDownloadURL.Create(self) do
  try
    URL := URLDownLoad;
    FileName := ZipFile;
    ExecuteTarget(nil);
  finally
    Free;
  end;
  ExtractZipFile;
end;

procedure TApplication.ExtractZipFile;
var
  UnZip : TAbUnZipper;
begin
  Log('extract Zip File: ' + ZipFile);
  
  UnZip := TAbUnZipper.Create(self);
  UnZip.FileName := ZipFile;
  UnZip.ExtractAt(0, FullFileName);
  UnZip.CloseArchive;
  UnZip.Free;
end;

function TApplication.FileVersion: string;
begin
  if FileExists(FullFileName) then
    Result := program_versi(FullFileName) else
    Result := 'HILANG';
end;

function TApplication.FullFileName: string;
begin
  Result := FRootPath + FPath + FName;
end;

procedure TApplication.UpdateApplication;
begin
  if FVersion <> FileVersion then
  begin
    Log(FName + ' v:' + FileVersion + ' new v:' + FVersion);

    if FileExists(ZipFile) then
      ExtractZipFile else
      DownloadZipFile;
  end;  
end;

function TApplication.URLDownLoad: string;
begin
    Result := 'http://' + dm.xConn.Host + '/GainProfit' + FPath + ExtractFileName(ZipFile);
end;

function TApplication.ZipFile: string;
var
  FileNameWithoutExt: string;
begin
  FileNameWithoutExt := Copy(FName, 1 , Length(FName)- 4);
  Result := FRootPath + '\Downloaded\' + FileNameWithoutExt + '-' +
    FVersion + '.zip';
end;

end.
