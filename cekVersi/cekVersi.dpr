program cekVersi;

uses
  Classes,
  WinInet,
  ShellAPI,
  Windows,
  Dialogs,
  Messages,
  Controls,
  SysUtils,
  Variants,
  uLkJSON;

function loadVersion(const Url: string): string;
var
  NetHandle: HINTERNET;
  UrlHandle: HINTERNET;
  Buffer: array[0..1024] of Char;
  BytesRead: dWord;
begin
  //cek koneksi
  Result := '';

  if not(InternetGetConnectedState(nil,0))then
  begin
    Exit;
  end;

  NetHandle := InternetOpen('Delphi 5.x', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);

  if Assigned(NetHandle) then 
  begin
    UrlHandle := InternetOpenUrl(NetHandle, PChar(Url), nil, 0, INTERNET_FLAG_RELOAD, 0);

    if Assigned(UrlHandle) then
      { UrlHandle valid? Proceed with download }
    begin
      FillChar(Buffer, SizeOf(Buffer), 0);
      repeat
        Result := Result + Buffer;
        FillChar(Buffer, SizeOf(Buffer), 0);
        InternetReadFile(UrlHandle, @Buffer, SizeOf(Buffer), BytesRead);
      until BytesRead = 0;
      InternetCloseHandle(UrlHandle);
    end
    else
      { UrlHandle is not valid. Raise an exception. }
      raise Exception.CreateFmt('Cannot open URL %s', [Url]);

    InternetCloseHandle(NetHandle);
  end
  else
    { NetHandle is not valid. Raise an exception }
    raise Exception.Create('Unable to initialize Wininet');
end;

//param 1 -> versi
//param 2 -> applikasi

var jsonApp,versi,download: string;
    js: TlkJsonObject;
begin
  jsonApp:= loadVersion('http://gain-profit.github.io/profit.json');
  js := TlkJSON.ParseText(jsonApp) as TlkJSONobject;

  versi     := VarToStr(js.Field['app'].Field['gudang'].Field['versi'].Value);
  download  := VarToStr(js.Field['app'].Field['gudang'].Field['download'].Value);

  if versi <>''then
  begin
    if paramStr(1)<> versi then
    begin
      if MessageDlg('Aplikasi '+ParamStr(2)+' Terbaru Telah keluar:' + #13#10 +
        'Versi terbaru : ' + versi + #13#10#13#10 +
        'Download Applikasi Terbaru?',  mtWarning, [mbYes, mbNo], 0) = mrYes
        then
      begin
        WinExec(PChar('rundll32 url.dll,FileProtocolHandler '+ download),
        SW_MAXIMIZE);
      end;
    end;
  end;
  

end.
 