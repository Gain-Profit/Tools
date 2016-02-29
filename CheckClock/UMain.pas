unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, sStatusBar, StdCtrls, Buttons, sBitBtn, sLabel,
  cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, cxTextEdit, cxSpinEdit, mySQLDbTables,
  ExtCtrls;

type
  TFMain = class(TForm)
    sb: TsStatusBar;
    btnCheckIn: TsBitBtn;
    btnCheckOut: TsBitBtn;
    lbl1: TsLabel;
    lbl2: TsLabel;
    grid: TcxGrid;
    View: TcxGridDBTableView;
    Level: TcxGridLevel;
    vwUserId: TcxGridDBColumn;
    vwNama: TcxGridDBColumn;
    vwKondisi: TcxGridDBColumn;
    Timer1: TTimer;
    Q_time: TmySQLQuery;
    lbTime: TsLabel;
    function methodManual:Boolean;
    procedure FormCreate(Sender: TObject);
    procedure btnCheckInClick(Sender: TObject);
    procedure btnCheckOutClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

uses UDM, UCheckIO, UCheckIOManual;

{$R *.dfm}

function program_versi:string;
var V1, V2, V3, V4: Word;
   VerInfoSize, VerValueSize, Dummy : DWORD;
   VerInfo : Pointer;
   VerValue : PVSFixedFileInfo;
begin
VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
GetMem(VerInfo, VerInfoSize);
GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
With VerValue^ do
begin
  V1 := dwFileVersionMS shr 16;
  V2 := dwFileVersionMS and $FFFF;
  V3 := dwFileVersionLS shr 16;
  V4 := dwFileVersionLS and $FFFF;
end;
FreeMem(VerInfo, VerInfoSize);

Result := IntToStr(V1) + '.'
            + IntToStr(V2) + '.'
            + IntToStr(V3) + '.'
            + IntToStr(V4);
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  sb.Panels[0].Text := program_versi;
  sb.Panels[1].Text := dm.xConn.DatabaseName + '@' +dm.xConn.Host;
end;


function TFMain.methodManual: Boolean;
var
  sql: string;
begin
  sql:= 'SELECT nilai FROM tb_settings WHERE parameter ="fingerprint"';
  dm.SQLExec(dm.QShow,sql,True);
  Result:= dm.QShow.FieldByName('nilai').AsBoolean;
end;

procedure TFMain.btnCheckInClick(Sender: TObject);
begin
  if methodManual then
  begin
    Application.CreateForm(TFCheckIOManual, FCheckIOManual);
    FCheckIOManual.jenis := 'IN';
    FCheckIOManual.ShowModal;
  end else
  begin
    Application.CreateForm(TFChekIO,FChekIO);
    FChekIO.jenis := 'IN';
    FChekIO.ShowModal;
  end;
end;

procedure TFMain.btnCheckOutClick(Sender: TObject);
begin
  if methodManual then
  begin
    Application.CreateForm(TFCheckIOManual, FCheckIOManual);
    FCheckIOManual.jenis := 'OUT';
    FCheckIOManual.ShowModal;
  end else
  begin
    Application.CreateForm(TFChekIO,FChekIO);
    FChekIO.jenis := 'OUT';
    FChekIO.ShowModal;
  end;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  dm.refreshTable;
end;

procedure TFMain.ViewCustomDrawCell(Sender: TcxCustomGridTableView;
  ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
  var ADone: Boolean);
begin
  if (AViewInfo.Text = 'CHECKOUT') then
  begin
    ACanvas.Font.Color := clYellow;
    ACanvas.Brush.Color := clRed;
  end else
  if (AViewInfo.Text = 'CHECKIN') then
  begin
    ACanvas.Font.Color := clYellow;
    ACanvas.Brush.Color := clBlue;
  end;
end;
procedure TFMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_escape then
  Close;
end;

procedure TFMain.Timer1Timer(Sender: TObject);
begin
  try
    dm.SQLExec(Q_time,'select now() as sekarang',True);

    sb.Panels[2].Text:=formatdatetime('dd mmm yyyy', Q_time.fieldbyname('sekarang').AsDateTime);
    lbTime.Caption:=FormatDateTime('hh:nn:ss',Q_time.fieldbyname('sekarang').AsDateTime);
  except
    Timer1.Enabled:= False;
    if (MessageDlg('KONEKSI TERPUTUS DENGAN SERVER...'+#13+#10+'coba '+
    'hubungkan kembali??????', mtWarning, [mbOK], 0) = mrOk) then
    begin
      Timer1.Enabled:= True;
    end;
  end;
end;

end.
