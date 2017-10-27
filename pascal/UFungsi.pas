unit UFungsi;

interface

uses
  Classes, DB, sysutils, ShellAPI, windows, Winsock, Printers, WinSpool,
  IniFiles, DBAccess, MyAccess, System.Hash, System.Win.Registry;

type
  TVerCompare = (vLower, vEqual, vHigher);

  TVersion = class
  protected
    FMayor: Integer;
    FMinor: Integer;
    FRelease: Integer;
    FBuild: Integer;
  public
    property Mayor: Integer read FMayor;
    property Minor: Integer read FMinor;
    property Release: Integer read FRelease;
    property Build: Integer read FBuild;
    constructor Create(AMayor, AMinor, ARelease, ABuild: Integer); overload;
    constructor Create(const AVersion: String); overload;
    function AsString: string;
  end;

  TAppVersion = class(TVersion)
  public
    constructor Create(AFile: String);
  end;

  Tfungsi = class(TObject)
  private
    function GetSerial(AKode: string; APerusahaan: string): string;
  public
    function GetIPFromHost(var HostName, IPaddr, WSAErr: string): Boolean;
    procedure Amankan(pathin, pathout: string; Chave: Word);
    procedure HapusDir(const DirName: string);
    procedure LoadSQL(aQuery: TMyQuery; _SQL: string);
    procedure SaveToFile(aQuery: TMyQuery; _SQL, nm_file: string);
    procedure SQLExec(aQuery: TMyQuery; _SQL: string; isSearch: boolean);
    procedure CetakFile(const sFileName: string);
    procedure OpenCashDrawer;
    function AmbilIniFile(nama_file, Section, Ident: string; def: string = ''): string;
    procedure SimpanIniFile(nama_file, Section, Ident, value: string);
    function AddSpace(Count: integer; Text: string; AsTail: boolean = false): string;
    function TulisFormat(Text: string; lebar: integer; Alignment: TAlignment =
      taleftjustify): string;
    function CekSerial(KdPerusahaan: string; NamaPerusahaan: string): Boolean;
  end;

var
  fungsi: Tfungsi;

  // general function or procedure
  function MyDate(Date: TDateTime): string;
  function CompareVersion(ALeft, ARight: TVersion): TVerCompare;

implementation

{ TVersion }

constructor TVersion.Create(AMayor, AMinor, ARelease, ABuild: Integer);
begin
  self.FMayor := AMayor;
  Self.FMinor := AMinor;
  Self.FRelease := ARelease;
  Self.FBuild := ABuild;
end;

constructor TVersion.Create(const AVersion: String);
var
  LVersion : TStrings;
begin
  LVersion := TStringList.Create;
  LVersion.Delimiter := '.';
  LVersion.DelimitedText := AVersion;

  self.FMayor := 0;
  Self.FMinor := 0;
  Self.FRelease := 0;
  Self.FBuild := 0;

  if LVersion.Count > 0 then
    self.FMayor := StrToIntDef(LVersion[0],0);

  if LVersion.Count > 1 then
    self.FMinor := StrToIntDef(LVersion[1],0);

  if LVersion.Count > 2 then
    self.FRelease := StrToIntDef(LVersion[2],0);

  if LVersion.Count > 3 then
    self.FBuild := StrToIntDef(LVersion[3],0);

  FreeAndNil(LVersion);
end;

function TVersion.AsString: string;
begin
  Result := Format('%d.%d.%d.%d', [Self.FMayor, Self.FMinor, Self.FRelease, Self.FBuild]);
end;

{ TAppVersion }

constructor TAppVersion.Create(AFile: String);
var
  V1, V2, V3, V4: Word;
  VerInfoSize, VerValueSize, Dummy: DWORD;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(AFile), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
  with VerValue^ do
  begin
    V1 := dwFileVersionMS shr 16;
    V2 := dwFileVersionMS and $FFFF;
    V3 := dwFileVersionLS shr 16;
    V4 := dwFileVersionLS and $FFFF;
  end;
  FreeMem(VerInfo, VerInfoSize);

  inherited Create(V1, V2, V3, V4);
end;

{ Tfungsi }

function Tfungsi.GetIPFromHost(var HostName, IPaddr, WSAErr: string): Boolean;
type
  Name = array[0..100] of AnsiChar;

  PName = ^Name;
var
  HEnt: pHostEnt;
  HName: PName;
  WSAData: TWSAData;
  i: Integer;
begin
  Result := False;
  if WSAStartup($0101, WSAData) <> 0 then
  begin
    WSAErr := 'Winsock is not responding."';
    Exit;
  end;
  IPaddr := '';
  New(HName);
  if GetHostName(HName^, SizeOf(Name)) = 0 then
  begin
    HostName := string(AnsiString(HName^));
    HEnt := GetHostByName(HName^);
    for i := 0 to HEnt^.h_length - 1 do
      IPaddr := Concat(IPaddr, IntToStr(Ord(HEnt^.h_addr_list^[i])) + '.');
    SetLength(IPaddr, Length(IPaddr) - 1);
    Result := True;
  end
  else
  begin
    case WSAGetLastError of
      WSANOTINITIALISED:
        WSAErr := 'WSANotInitialised';
      WSAENETDOWN:
        WSAErr := 'WSAENetDown';
      WSAEINPROGRESS:
        WSAErr := 'WSAEInProgress';
    end;
  end;
  Dispose(HName);
  WSACleanup;
end;

function Tfungsi.GetSerial(AKode, APerusahaan: string): string;
var
  LSerial : string;
  Str1, Str2, Str3, Str4, Str5: string;
begin
  LSerial := THashSHA1.GetHashString('GAIN' + AKode + APerusahaan + 'PROFIT');
  Str1 := Copy(LSerial, 34, 5);
  Str2 := Copy(LSerial, 8, 6);
  Str3 := Copy(LSerial, 25, 3);
  Str4 := Copy(LSerial, 12, 4);
  Str5 := Copy(LSerial, 2, 5);

  LSerial := Format('%s-%s-%s-%s-%s', [Str1, Str2, Str3, Str4, Str5]);
  Result := UpperCase(LSerial);
end;

procedure Tfungsi.Amankan(pathin, pathout: string; Chave: Word);
var
  InMS, OutMS: TMemoryStream;
  cnt: Integer;
  C: byte;
begin
  InMS := TMemoryStream.Create;
  OutMS := TMemoryStream.Create;
  try
    InMS.LoadFromFile(pathin);
    InMS.Position := 0;
    for cnt := 0 to InMS.Size - 1 do
    begin
      InMS.Read(C, 1);
      C := (C xor not (ord(chave shr cnt)));
      OutMS.Write(C, 1);
    end;
    OutMS.SaveToFile(pathout);
  finally
    InMS.Free;
    OutMS.Free;
  end;
end;

procedure Tfungsi.HapusDir(const DirName: string);
var
  FileOp: TSHFileOpStruct;
begin
  FillChar(FileOp, SizeOf(FileOp), 0);
  FileOp.wFunc := FO_DELETE;
  FileOp.pFrom := PChar(DirName + #0); //double zero-terminated
  FileOp.fFlags := FOF_SILENT or FOF_NOERRORUI or FOF_NOCONFIRMATION;
  SHFileOperation(FileOp);
end;

procedure Tfungsi.LoadSQL(aQuery: TMyQuery; _SQL: string);
begin
  with aQuery do
  begin
    DisableControls;
    Close;
    sql.Clear;
    SQL.LoadFromFile(_SQL);
    ExecSQL;
    EnableControls;
  end;
end;

procedure Tfungsi.SaveToFile(aQuery: TMyQuery; _SQL, nm_file: string);
var
  I: Integer;
  X: TextFile;
  S1: string;
begin
  assignfile(X, nm_file);
  rewrite(X);

  SQLExec(aQuery, _SQL, True);
  while not aQuery.Eof do
  begin
    S1 := '';
    for I := 0 to aQuery.FieldCount - 1 do
    begin
      if aQuery.Fields[I].DataType in [ftSmallint, ftInteger, ftFloat,
        ftCurrency, ftLargeint] then
        S1 := S1 + floattostr(aQuery.Fields[I].AsFloat) + '&'
      else if aQuery.Fields[I].DataType in [ftDate] then
        S1 := S1 + '#' + formatdatetime('yyyy-MM-dd', aQuery.Fields[I].AsDateTime) + '#&'
      else if aQuery.Fields[I].DataType in [ftDateTime] then
        S1 := S1 + '#' + formatdatetime('yyyy-MM-dd hh:nn:ss', aQuery.Fields[I].AsDateTime)
          + '#&'
      else
        S1 := S1 + '#' + aQuery.Fields[I].AsString + '#&';
    end;

    S1 := Format('%s%s%s', ['<', S1, '>']);
    Write(X, S1);

    aQuery.Next;
  end;
  closefile(X);
  amankan(nm_file, nm_file, 9966);
end;

procedure Tfungsi.SQLExec(aQuery: TmyQuery; _SQL: string; isSearch: boolean);
begin
  with aQuery do
  begin
    SQL.Text := _SQL;
    if isSearch then
      Open
    else
      ExecSQL;
  end;
end;

function Tfungsi.AmbilIniFile(nama_file, Section, Ident: string; def: string =
  ''): string;
var
  a: TIniFile;
begin
  a := TIniFile.Create(nama_file);
  try
    Result := a.ReadString(Section, Ident, def);
  finally
    a.Free;
  end;
end;

procedure Tfungsi.SimpanIniFile(nama_file, Section, Ident, value: string);
var
  a: TIniFile;
begin
  a := TIniFile.Create(nama_file);
  try
    a.WriteString(Section, Ident, value);
  finally
    a.Free;
  end;
end;

function Tfungsi.AddSpace(Count: integer; Text: string; AsTail: boolean = false): string;
var
  i: integer;
  s: string;
begin
  s := '';
  for i := 1 to Count do
    s := s + ' ';
  if AsTail then
    Result := Text + s
  else
    Result := s + Text;
end;

function Tfungsi.TulisFormat(Text: string; lebar: integer; Alignment: TAlignment
  = taleftjustify): string;
var
  left: integer;
begin
  if Length(Text) > lebar then
    Text := Copy(Text, 1, lebar - 1);

  case Alignment of
    taRightJustify:
      left := lebar - Length(Text);
    taCenter:
      left := (lebar div 2) - (Length(Text) div 2);
  else
    left := 0;
  end;
  if left < 0 then
    left := 0;

  result := addspace(left, text);
end;

function Tfungsi.CekSerial(KdPerusahaan, NamaPerusahaan: string): Boolean;
var
  Registry: TRegistry;
  LRegSerial, LKompSerial : string;
begin
  Registry := TRegistry.Create(KEY_READ);
  try
  Registry.RootKey := HKEY_LOCAL_MACHINE;
  // False because we do not want to create it if it doesn't exist
  Registry.OpenKey('SOFTWARE\Ngadep\GainProfit\Serial', False);
  LRegSerial := Registry.ReadString('Serial' + KdPerusahaan);
  LKompSerial := GetSerial(KdPerusahaan, NamaPerusahaan);
  Result := CompareStr(LRegSerial, LKompSerial) = 0;
  finally
    Registry.Free;
  end;
end;

procedure Tfungsi.CetakFile(const sFileName: string);
const
  cBUFSIZE = 16384;
type
  TDoc_Info_1 = record
    pDocName: pChar;
    pOutputFile: pChar;
    pDataType: pChar;
  end;
var
  Count: Cardinal;
  BytesWritten: Cardinal;
  hPrinter: THandle;
  hDeviceMode: THandle;
  Device: array[0..255] of Char;
  Driver: array[0..255] of Char;
  Port: array[0..255] of Char;
  DocInfo: TDoc_Info_1;
  f: file;
  Buffer: Pointer;
begin
  Printer.PrinterIndex := -1;
  Printer.GetPrinter(Device, Driver, Port, hDeviceMode);
  if not WinSpool.OpenPrinter(@Device, hPrinter, Nil) then
    Exit;
  DocInfo.pDocName := 'Report';
  DocInfo.pOutputFile := Nil;
  DocInfo.pDatatype := 'RAW';

  if StartDocPrinter(hPrinter, 1, @DocInfo) = 0 then
  begin
    WinSpool.ClosePrinter(hPrinter);
    Exit;
  end;

  if not StartPagePrinter(hPrinter) then
  begin
    EndDocPrinter(hPrinter);
    WinSpool.ClosePrinter(hPrinter);
    Exit;
  end;

  System.Assign(f, sFileName);
  try
    Reset(f, 1);
    GetMem(Buffer, cBUFSIZE);
    while not Eof(f) do
    begin
      Blockread(f, Buffer^, cBUFSIZE, Count);
      if Count > 0 then
      begin
        if not WritePrinter(hPrinter, Buffer, Count, BytesWritten) then
        begin
          EndPagePrinter(hPrinter);
          EndDocPrinter(hPrinter);
          WinSpool.ClosePrinter(hPrinter);
          FreeMem(Buffer, cBUFSIZE);
          Exit;
        end;
      end;
    end;
    FreeMem(Buffer, cBUFSIZE);
    EndDocPrinter(hPrinter);
    WinSpool.ClosePrinter(hPrinter);
  finally
    System.CloseFile(f);
  end;
end;

procedure Tfungsi.OpenCashDrawer;
const
  cBUFSIZE = 16384;
type
  TDoc_Info_1 = record
    pDocName: pChar;
    pOutputFile: pChar;
    pDataType: pChar;
  end;
var
  BytesWritten: Cardinal;
  hPrinter: THandle;
  hDeviceMode: THandle;
  Device: array[0..255] of Char;
  Driver: array[0..255] of Char;
  Port: array[0..255] of Char;
  DocInfo: TDoc_Info_1;
  Code: AnsiString;
begin
  try
    Code := AnsiChar(27) + AnsiChar(112) + AnsiChar(0) + AnsiChar(64) + AnsiChar(240);

    Printer.PrinterIndex := -1;
    Printer.GetPrinter(Device, Driver, Port, hDeviceMode);
    if not WinSpool.OpenPrinter(@Device, hPrinter, Nil) then
      Exit;
    DocInfo.pDocName := 'Report';
    DocInfo.pOutputFile := Nil;
    DocInfo.pDatatype := 'RAW';

    WinSpool.StartDocPrinter(hPrinter, 1, @DocInfo);
    WinSpool.StartPagePrinter(hPrinter);
    WinSpool.WritePrinter(hPrinter, PAnsiChar(Code), Length(Code), BytesWritten);
    WinSpool.EndPagePrinter(hPrinter);
    WinSpool.EndDocPrinter(hPrinter);
    WinSpool.ClosePrinter(hPrinter);
  except
    // do nothing
  end;
end;

{ General Function/Procedure }
function MyDate(Date: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-MM-dd', Date);
end;

function CompareVersion(ALeft, ARight: TVersion): TVerCompare;
begin
  Result := vEqual;

  if (ALeft.Mayor > ARight.Mayor) then
  begin
    Result := vHigher;
    Exit;
  end;

  if (ALeft.Mayor < ARight.Mayor) then
  begin
    Result := vLower;
    Exit;
  end;

  if (ALeft.Minor > ARight.Minor) then
  begin
    Result := vHigher;
    Exit;
  end;

  if (ALeft.Minor < ARight.Minor) then
  begin
    Result := vLower;
    Exit;
  end;

  if (ALeft.Release > ARight.Release) then
  begin
    Result := vHigher;
    Exit;
  end;

  if (ALeft.Release < ARight.Release) then
  begin
    Result := vLower;
    Exit;
  end;

  if (ALeft.Build > ARight.Build) then
  begin
    Result := vHigher;
    Exit;
  end;

  if (ALeft.Build < ARight.Build) then
  begin
    Result := vLower;
    Exit;
  end;
end;

end.

