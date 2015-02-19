program cekVersi;

uses
  Windows,
  Dialogs,
  Variants,
  uLkJSON,
  ExtActns;

function Download_HTM( const sURL, sLocalFileName : string): boolean;
begin
  Result := True;
   with TDownLoadURL.Create( nil) do
   try
    URL:=sURL;
    Filename:=sLocalFileName;
     try
      ExecuteTarget( nil) ;
     except
      Result:=False
     end;
   finally
    Free;
   end;
end;

//param 1 -> versi
//param 2 -> applikasi

var versi,download: string;
    js: TlkJsonObject;
begin
  if NOT Download_HTM('http://gain-profit.github.io/profit.json','profit.json') then
  begin
    Exit;
  end;

  try
    js := TlkJSONstreamed.loadfromfile('profit.json') as TlkJsonObject;
    versi     := VarToStr(js.Field['app'].Field[ParamStr(2)].Field['versi'].Value);
    download  := VarToStr(js.Field['app'].Field[ParamStr(2)].Field['download'].Value);
  except
    exit;
  end;

  if versi <>''then
  begin
    if paramStr(1)<> versi then
    begin
      ShowMessage('Aplikasi '+ParamStr(2)+' Terbaru Telah keluar:' + #13#10 +
      'Versi terbaru : ' + versi + #13#10#13#10 +
      'Download Applikasi Terbaru!!!' );

      WinExec(PChar('rundll32 url.dll,FileProtocolHandler '+ download),
      SW_MAXIMIZE);
    end;
  end;
end.
 