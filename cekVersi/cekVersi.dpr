program cekVersi;

uses
  Classes,
  WinInet,
  ShellAPI,
  Windows,
  Dialogs,
  Messages,
  Controls,
  SysUtils;

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
//param 2 -> cek
//param 3 -> dowmload
//param 4 -> nama aplikasi

var Appterbaru: string;
begin
  Appterbaru:= loadVersion(paramStr(2));

  if Appterbaru <>''then
  begin
    if paramStr(1)<> Appterbaru then
    begin
      if MessageDlg('Aplikasi '+ParamStr(4)+' Terbaru Telah keluar:' + #13#10 +
        'Versi terbaru : ' + Appterbaru + #13#10#13#10 +
        'Download Applikasi Terbaru?',  mtWarning, [mbYes, mbNo], 0) = mrYes
        then
      begin
        WinExec(PChar('rundll32 url.dll,FileProtocolHandler '+ paramStr(3)),
        SW_MAXIMIZE);
      end;
    end;
  end;

end.
 