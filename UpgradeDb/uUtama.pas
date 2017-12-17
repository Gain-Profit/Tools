unit uUtama;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, DBAccess, MyAccess,
  Vcl.StdCtrls, Vcl.ExtCtrls, MemDS, Vcl.ComCtrls, DAScript, MyScript;

type
  TFrmUpgrade = class(TForm)
    Con: TMyConnection;
    Panel1: TPanel;
    Label1: TLabel;
    Button1: TButton;
    Panel2: TPanel;
    Label2: TLabel;
    Button2: TButton;
    EdFile: TEdit;
    Panel3: TPanel;
    Label3: TLabel;
    Button3: TButton;
    Od: TOpenDialog;
    Panel4: TPanel;
    Label4: TLabel;
    Button4: TButton;
    PanelInfo: TPanel;
    LblVersion: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    FDbVersion : string;
    FSqlFile: TFileName;
    FUpgradeTo: string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmUpgrade: TFrmUpgrade;

implementation

{$R *.dfm}

uses
  System.Zip, System.IOUtils, System.Hash;

const
  sSqlDbVersion = 'SELECT versi_terbaru FROM app_versi WHERE kode = "Database"';

procedure TFrmUpgrade.FormCreate(Sender: TObject);
begin
  od.InitialDir := ExtractFileDir(Application.ExeName);
end;

procedure TFrmUpgrade.Button1Click(Sender: TObject);
var
  LQuery: TMyQuery;
begin
  try
    Con.Connect;

    LQuery := TMyQuery.Create(nil);
    try
      LQuery.Connection := Con;
      LQuery.SQL.Text := sSqlDbVersion;
      LQuery.Open;
      FDbVersion := LQuery.Fields[0].AsString;
    finally
      LQuery.Free;
    end;

    LblVersion.Caption := LblVersion.Caption + FDbVersion;
    Button1.Enabled := False;
    Button2.Enabled := True;
  except on E: Exception do
    begin
      ShowMessageFmt('Tidak Dapat Terhubung Ke Database%s%s',
        [sLineBreak, E.Message]);
      Exit;
    end;
  end;
end;

procedure TFrmUpgrade.Button2Click(Sender: TObject);
begin
  if Od.Execute then
  begin
    EdFile.Text := Od.FileName;
    Button2.Enabled := False;
    Button3.Enabled := True;
  end;
end;

procedure TFrmUpgrade.Button3Click(Sender: TObject);
var
  LDirOutput, LDirFile, LSHA1File : string;
  LInfo : TStrings;
  LRequirement, LInfoSHA1File: string;
begin
  if not(TZipFile.IsValid(EdFile.Text)) then
  begin
    ShowMessageFmt('File %s Tidak Valid', [ExtractFileName(EdFile.Text)]);
    Exit;
  end;

  LDirOutput := TPath.Combine(TPath.GetTempPath, 'GPUpgrade');
  TZipFile.ExtractZipFile(EdFile.Text, LDirOutput);
  LDirFile := TPath.Combine(LDirOutput, TPath.GetFileNameWithoutExtension(EdFile.Text));
  LInfo := TStringList.Create;
  try
    LInfo.LoadFromFile( LDirFile + '\MANIFEST.info');
    LRequirement := LInfo.Values['Requirement'];
    FUpgradeTo := LInfo.Values['UpgradeTo'];
    FSqlFile := LDirFile + '\' +LInfo.Values['FileName'];
    LInfoSHA1File := UpperCase(LInfo.Values['SHA1File']);
  finally
    LInfo.Free;
  end;

  LSHA1File := UpperCase(THashSHA1.GetHashStringFromFile(FSqlFile));
  if (LSHA1File <> LInfoSHA1File) then
  begin
    ShowMessageFmt('File %s Tidak Valid', [ExtractFileName(EdFile.Text)]);
    Exit;
  end;

  if (FDbVersion <> LRequirement) then
  begin
    ShowMessageFmt('Untuk Upgrade Database ke Versi %s ' +
      'dibutuhkan Database versi %s, Database Sekarang Versi %s',
      [FUpgradeTo, LRequirement, FDbVersion]);
    Exit;
  end;

  Button3.Enabled := False;
  Button4.Enabled := True;
end;

procedure TFrmUpgrade.Button4Click(Sender: TObject);
var
  LScript: TMyScript;
begin
  LScript := TMyScript.Create(nil);
  try
    LScript.Connection := Con;
    try
      LScript.ExecuteFile(FSqlFile);
      Button4.Enabled := False;
      ShowMessageFmt('Selamat, Proses Upgrade Database ke Versi %s Berhasil',
        [FUpgradeTo]);
    except on E: Exception do
      ShowMessageFmt('Maaf, Terjadi Kesalahan saat Upgrade Database '+
      'dari versi %s ke versi %s, Pesan Erro:%s%s',[FDbVersion, FUpgradeTo,
      sLineBreak, E.Message]);
    end;
  finally
    LScript.Free;
  end;
end;

end.
