unit UnitUtama;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGrid, ExtCtrls, IdHTTP, uLkJSON, ExtActns, ComCtrls, frxBarcode, frxClass,
  AbBase, AbBrowse, AbZBrows, AbUnzper, TlHelp32, AbComCtrls, AbArcTyp, ShellAPI,
  FileCtrl, IdHashMessageDigest, idHash, AbZipper;

type
  TFormUtama = class(TForm)
    TableView: TcxGridDBTableView;
    Level: TcxGridLevel;
    cxGrid1: TcxGrid;
    TableViewColumn1: TcxGridDBColumn;
    TableViewColumn2: TcxGridDBColumn;
    TableViewColumn3: TcxGridDBColumn;
    pnl1: TPanel;
    TableViewColumn4: TcxGridDBColumn;
    TableViewColumn5: TcxGridDBColumn;
    status: TStatusBar;
    btnBrowse: TButton;
    edtFolder: TEdit;
    btnCek: TButton;
    btnSimpan: TButton;
    zipApp: TAbZipper;
    function _get(baris, kolom: Integer): string;
    procedure _set(baris, kolom: Integer; _isi: variant);
    procedure FormCreate(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnCekClick(Sender: TObject);
    procedure btnSimpanClick(Sender: TObject);
  private
  public
    thisPath: string;
  end;

var
  FormUtama: TFormUtama;
  Json: string;

implementation

{$R *.dfm}

function GetInfoApp(const FileName: string; jenis: string): string;
type
  PLandCodepage = ^TLandCodepage;

  TLandCodepage = record
    wLanguage, wCodePage: word;
  end;
var
  dummy, len: cardinal;
  buf, pntr: pointer;
  lang: string;
begin
  len := GetFileVersionInfoSize(PChar(FileName), dummy);
  if len = 0 then
    RaiseLastOSError;
  GetMem(buf, len);
  try
    if not GetFileVersionInfo(PChar(FileName), 0, len, buf) then
      RaiseLastOSError;

    if not VerQueryValue(buf, '\VarFileInfo\Translation\', pntr, len) then
      RaiseLastOSError;

    lang := Format('%.4x%.4x', [PLandCodepage(pntr)^.wLanguage, PLandCodepage(pntr)
      ^.wCodePage]);

    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + jenis), pntr, len) then
      result := PChar(pntr);
  finally
    FreeMem(buf);
  end;
end;

procedure ListFileDir(Path, extensi: string; FileList: TStrings);
var
  SR: TSearchRec;
begin
  if FindFirst(Path + '\*.*', faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Attr <> faDirectory) then
      begin
        if ExtractFileExt(SR.Name) = extensi then
        begin
          FileList.Add(Path + '\' + SR.Name);
        end;
      end
      else
      begin
        if not (SR.Name = '.') and not (SR.Name = '..') then
        begin
          ListFileDir(Path + '\' + SR.Name, extensi, FileList);
        end;
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

//returns MD5 has for a file
function MD5(const fileName: string): string;
var
  idmd5: TIdHashMessageDigest5;
  fs: TFileStream;
begin
  idmd5 := TIdHashMessageDigest5.Create;
  fs := TFileStream.Create(fileName, fmOpenRead or fmShareDenyWrite);
  try
    result := idmd5.AsHex(idmd5.HashValue(fs));
  finally
    fs.Free;
    idmd5.Free;
  end;
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

procedure TFormUtama._set(baris, kolom: Integer; _isi: variant);
begin
  TableView.DataController.SetValue(baris, kolom, _isi);
end;

function TFormUtama._get(baris, kolom: Integer): string;
begin
  Result := TableView.DataController.getValue(baris, kolom);
end;

procedure TFormUtama.FormCreate(Sender: TObject);
var
  tempat: string;
begin
  tempat := edtFolder.Text;
  ThisPath := StringReplace(tempat, '\', '/', [rfReplaceAll]);
end;

procedure TFormUtama.btnBrowseClick(Sender: TObject);
var
  chosenDirectory: string;
begin
  if selectdirectory('Select a directory', '', chosenDirectory) then
    edtFolder.Text := chosenDirectory;
end;

procedure TFormUtama.btnCekClick(Sender: TObject);
var
  listFile: TStringList;
  NoItem: Integer;
  companyName, internalName: string;
  fullNama, namaSaja, nama, path, md5file, versi, download, FileNameZip: string;
begin
  listFile := TStringList.Create;

  ListFileDir(edtFolder.Text, '.exe', ListFile);

  TableView.DataController.RecordCount := listFile.Count;
  for NoItem := 0 to listFile.Count - 1 do
  begin
    fullNama := listFile.Strings[NoItem];
    nama := ExtractFileName(fullNama);
    namaSaja := Copy(nama, 0, Length(nama) - 4);
    path := Copy(fullNama, Length(edtFolder.Text) + 1, Length(fullNama) - Length
      (edtFolder.Text) - Length(nama));
    md5file := MD5(fullNama);
    versi := program_versi(fullNama);
    // ambil info untuk company name
    companyName := GetInfoApp(fullNama, '\CompanyName');
    // ambil info untuk Internal name
    internalName := GetInfoApp(fullNama, '\InternalName');
    FileNameZip := namaSaja + '-' + versi + '.zip';
    download := 'https://github.com/' + companyName + '/' + internalName +
      '/releases/download/v' + versi + '/' + FileNameZip;

    _set(NoItem, 0, nama);
    _set(NoItem, 1, StringReplace(path, '\', '/', [rfReplaceAll]));
    _set(NoItem, 2, md5file);
    _set(NoItem, 3, versi);
    _set(NoItem, 4, download);

    //zipApp.BaseDirectory := edtFolder.Text + path;
    zipApp.FileName := edtFolder.Text + path + FileNameZip;
    zipApp.AddFiles(fullNama, 0);
    zipApp.CloseArchive;
  end;
  TableView.ApplyBestFit();
end;

procedure TFormUtama.btnSimpanClick(Sender: TObject);
var
  X: TextFile;
  js, jsonDetail: TlkJSONobject;
  jsonList: TlkJSONlist;
  no, i: Integer;
  json: string;
begin
  try
    js := TlkJSONobject.Create(False);
    jsonList := TlkJSONlist.Create;

    for no := 0 to TableView.DataController.RecordCount - 1 do
    begin
      jsonDetail := TlkJSONobject.Create(False);
      jsondetail.Add('nama', _get(no, 0));
      jsondetail.Add('path', _get(no, 1));
      jsondetail.Add('md5_file', _get(no, 2));
      jsondetail.Add('versi', _get(no, 3));
      jsondetail.Add('download', _get(no, 4));
      jsonList.Add(jsonDetail);
    end;
    js.Add('profit', jsonList);

    i := 0;
    json := GenerateReadableText(js, i);

    assignfile(X, 'updater.json');
    rewrite(X);
    write(X, json);
    closefile(X);

    showmessage('penyimpanan data Berhasil');
  except
    on E: Exception do
    begin
      showmessage('SIMPAN DATA GAGAL...'#10#13'' + E.message);
    end;
  end;
end;

end.

