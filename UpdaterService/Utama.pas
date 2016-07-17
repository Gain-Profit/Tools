unit Utama;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  IniFiles, SHFolder, ExtCtrls, TlHelp32, ShellAPI;

type
  TGainUpdater = class(TService)
    Timer1: TTimer;
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure Log(msg: string);
    procedure Timer1Timer(Sender: TObject);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure UpdateApplication;
  private
    { Private declarations }
  public
    AppPath, RootPath: string;
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

type
  TApplication = class(TObject)
    FRootPath : string;
    FPath     : string;
    FName     : string;
    FVersion  : string;
    FMd5      : string;
  private
    function URLDownLoad: string;
    function FileVersion: string;
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

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  GainUpdater.Controller(CtrlCode);
end;

function TGainUpdater.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TGainUpdater.Log(msg: string);
var
  X: TextFile;
  sekarang, FileName: string;
begin
  sekarang := FormatDateTime('dd/MM/yyyy hh:nn:ss', Now);
  FileName := ThisPath + 'log.txt';

  assignfile(X, FileName);
  if not FileExists(FileName) then
    Rewrite(X) else
    Append(X);
  Writeln(X, sekarang + ' : '+ msg);
  closefile(X);
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

    app := TApplication.Create(RootPath,path,nama,versiOnline,MD5Online);
    app.UpdateApplication;
    app.Free;

    dm.QShow.Next;
  end;
end;

procedure TGainUpdater.ServiceStart(Sender: TService;
  var Started: Boolean);
  var
    AppINI: TIniFile;
begin
  ThisPath:= ExtractFilePath(ParamStr(0));
  AppPath := GetAppData(CSIDL_COMMON_APPDATA);

  Application.CreateForm(Tdm, dm);

  if not (DirectoryExists(AppPath)) then
    CreateDir(AppPath);

  appINI := TIniFile.Create(AppPath + 'gain.ini');
  try
    RootPath := appINI.ReadString('updater', 'root_path', 'C:\Program Files\GAIN PROFIT');
  finally
    appINI.Free;
  end;
  
  Log('Service Start.');
  Timer1.Enabled:= True;
end;

procedure TGainUpdater.Timer1Timer(Sender: TObject);
var
  FileName: string;
begin
  if dm.terkoneksi then
  begin
    Log('terkoneksi ke database...');
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

function TApplication.FileVersion: string;
var
  FileName : string;
begin
  FileName := FRootPath + FPath + FName;
  if FileExists(FileName) then
    Result := program_versi(filename) else
    Result := 'HILANG';
end;

procedure TApplication.UpdateApplication;
begin
  //
end;

function TApplication.URLDownLoad: string;
begin
    Result := 'http://' + dm.xConn.Host + '/GainProfit' + FPath + FName;
end;

end.
