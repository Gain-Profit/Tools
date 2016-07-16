unit CreateProcessIntr;

interface

uses
  Windows, SysUtils, Registry, TlHelp32;

procedure ExecuteProcessAsLoggedOnUser(FileName: string);

implementation

function GetShellProcessName: string;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKeyReadOnly('Software\Microsoft\Windows NT\CurrentVersion\WinLogon');
    Result := Reg.ReadString('Shell');
  finally
    Reg.Free;
  end;
end;

function GetShellProcessPid(const Name: string): Longword;
var
  Snapshot: THandle;
  Process: TProcessEntry32;
  B: Boolean;
begin
  Result := 0;
  Snapshot := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Snapshot <> INVALID_HANDLE_VALUE then
  try
    FillChar(Process, SizeOf(Process), 0);
    Process.dwSize := SizeOf(Process);
    B := Process32First(Snapshot, Process);
    while B do
    begin
      if CompareText(Process.szExeFile, Name) = 0 then
      begin
        Result := Process.th32ProcessID;
        Break;
      end;
      B := Process32Next(Snapshot, Process);
    end;
  finally
    CloseHandle(Snapshot);
  end;
end;

function GetShellHandle: THandle;
var
  Pid: Longword;
begin
  Pid := GetShellProcessPid(GetShellProcessName);
  Result := OpenProcess(PROCESS_ALL_ACCESS, False, Pid);
end;

procedure ExecuteProcessAsLoggedOnUser(FileName: string);
var
  ph: THandle;
  hToken, nToken: THandle;
  ProcInfo: TProcessInformation;
  StartInfo: TStartupInfo;
begin
  ph := GetShellHandle;
  if ph > 0 then
  begin
    if OpenProcessToken(ph, TOKEN_DUPLICATE or TOKEN_QUERY, hToken) then
    begin
      if DuplicateTokenEx(hToken, TOKEN_ASSIGN_PRIMARY or TOKEN_DUPLICATE or TOKEN_QUERY,
        nil, SecurityImpersonation, TokenPrimary, nToken) then
      begin
        if ImpersonateLoggedOnUser(nToken) then
        begin
          // Initialize then STARTUPINFO structure
          FillChar(StartInfo, SizeOf(TStartupInfo), 0);
          StartInfo.cb := SizeOf(TStartupInfo);
          // Specify that the process runs in the interactive desktop
          StartInfo.lpDesktop := PChar('WinSta0\Default');

          // Launch the process in the client's logon session
          CreateProcessAsUser(nToken, nil, PChar(FileName), nil, nil, False,
            CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, nil, StartInfo, ProcInfo);

          // End impersonation of client
          RevertToSelf();
        end;
        CloseHandle(nToken);
      end;
      CloseHandle(hToken);
    end;
  end;
end;

end.
