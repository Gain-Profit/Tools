unit Utama;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  IniFiles, SHFolder, ExtCtrls, TlHelp32;

type
  TGainUpdater = class(TService)
    Timer1: TTimer;
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure Log(msg: string);
    procedure Timer1Timer(Sender: TObject);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
  private
    { Private declarations }
  public
    ThisPath, AppPath, RootPath: string;
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  GainUpdater: TGainUpdater;

implementation

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  GainUpdater.Controller(CtrlCode);
end;

function TGainUpdater.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

function GetAppData(Folder: Integer): string;
var
  path: array[0..MAX_PATH] of Char;
begin
  if Succeeded(SHGetFolderPath(0, Folder, 0, 0, @Path[0])) then
    Result := path + '\Gain Profit\'
  else
    Result := '';
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

procedure TGainUpdater.ServiceStart(Sender: TService;
  var Started: Boolean);
  var
    AppINI: TIniFile;
begin
  ThisPath:= ExtractFilePath(ParamStr(0));
  AppPath := GetAppData(CSIDL_COMMON_APPDATA);

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
begin
  if processExists('gudang.exe') then
  Log('Gudang Berjalan...')
  //
end;

procedure TGainUpdater.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  Log('Service Stop.');
  Timer1.Enabled:= False;
end;

end.
