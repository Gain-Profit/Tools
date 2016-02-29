unit UCheckIOManual;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sEdit, sButton, Buttons, sBitBtn, sLabel;

type
  TFCheckIOManual = class(TForm)
    sLabel4: TsLabel;
    sLabel5: TsLabel;
    sLabel6: TsLabel;
    btnClose: TsBitBtn;
    btnCheck: TsButton;
    Ed_Kd_User: TsEdit;
    Ed_N_User: TsEdit;
    Ed_Password: TsEdit;
    lblStatus: TsLabel;
    procedure Ed_Kd_UserKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCheckClick(Sender: TObject);
    procedure Ed_N_UserEnter(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure Ed_PasswordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Ed_Kd_UserChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure verifikasi;
    procedure bersih;
  private
    { Private declarations }
  public
    { Public declarations }
    jenis:string;
  end;

var
  FCheckIOManual: TFCheckIOManual;
  mgs:TMsg;
  userRealName, userPassword : string;
  parentPath, idUser,namaUser:string;

implementation

uses UDM, USukses;

{$R *.dfm}

procedure TFCheckIOManual.Ed_Kd_UserKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  sql : string;
begin
  if key=vk_return then
  begin
    PeekMessage(Mgs, 0, WM_CHAR, WM_CHAR, PM_REMOVE );
    sql:= 'SELECT n_user, `password` FROM tb_user WHERE ' +
          'kd_user="'+ed_kd_user.Text+'"';
    dm.SQLExec(dm.QShow,sql,true);
    if dm.Qshow.Eof then
    Begin
    messagedlg('Kode ini tidak terdaftar...',mtError,[mbOk],0);
    ed_kd_user.SetFocus;
    End else
    begin
      userRealName:= dm.Qshow.FieldByName('n_user').AsString;
      userPassword:= dm.Qshow.FieldByName('password').AsString;
      ed_password.Enabled:= true;
      Ed_Password.SetFocus;
      Ed_N_User.Text:= userRealName;
    end;
  end;

  if key=vk_escape then close;
end;

procedure TFCheckIOManual.btnCheckClick(Sender: TObject);
var
  passs:string;
begin
  if ed_n_user.Text<>'' then
  begin
    dm.SQLExec(dm.QShow,'select md5("'+ed_password.Text+'")as passs',true);
    passs:=dm.QShow.fieldbyname('passs').AsString;

    if compareText(userPassword,passs)<>0 then
    begin
      messagedlg('Password salah..',mtError,[mbOk],0);
      ed_password.Clear;
      ed_password.SetFocus;
    end else
    begin
      idUser    := Ed_Kd_User.Text;
      namaUser  := Ed_N_User.Text;
      verifikasi;
    end;
  end;
end;

procedure TFCheckIOManual.Verifikasi;
var
  sql,sqlQuery,checkin_time,saiki : string;
begin
  dm.SQLExec(dm.QShow,'SELECT now() as saiki',True);
  saiki := dm.QShow.FieldByName('saiki').AsString;
  saiki := FormatDateTime('YYYY-MM-DD hh:mm:ss',
                      StrToDateTime(saiki));

  sqlQuery := Format('SELECT checkin_time FROM tb_checkinout WHERE ' +
  'user_id = "%s" AND ISNULL(checkout_time)',[idUser]);

  dm.SQLExec(dm.QShow,sqlQuery,True);

  if jenis = 'OUT' then
  begin
    if not(dm.QShow.Eof) then
    begin
      checkin_time := dm.QShow.FieldByName('checkin_time').AsString;
      checkin_time := FormatDateTime('YYYY-MM-DD hh:mm:ss',
                      StrToDateTime(checkin_time));
      sql := Format('UPDATE tb_checkinout SET checkout_time = "%s", ' +
      'checkout_method = "MANUAL" WHERE user_id = "%s" AND checkin_time = "%s"',
      [saiki,idUser,checkin_time]);
    end else
    begin
      ShowMessage('TIDAK DAPAT CHECK OUT...'#10#13'' +
                  'User Ini Belum Melakukan CHECK IN');
      Exit;
    end;
  end else
  begin
    if not(dm.QShow.Eof) then
    begin
      ShowMessage('TIDAK DAPAT CHECK IN...'#10#13'' +
                  'User Ini Belum Melakukan CHECK OUT');
      Exit;
    end else
    begin
      sql := Format('INSERT INTO tb_checkinout (user_id, checkin_time, ' +
      'checkin_method) VALUES ("%s", "%s", "MANUAL")',[idUser,saiki]);
    end;
  end;

  dm.SQLExec(dm.Qexe,sql,False);

  Application.CreateForm(TFSukses, FSukses);
  FSukses.jenis := jenis;
  FSukses.lblCheck.Caption := saiki;
  FSukses.lblKode.Caption := idUser;
  FSukses.lblNama.Caption := namaUser;
  if FileExists(parentPath+'image/'+idUser+'.jpg') then
  FSukses.imgSidikJari.Picture.LoadFromFile(parentPath+'image/'+idUser+'.jpg');
  FSukses.ShowModal;
  dm.refreshTable;
  bersih;
end;


procedure TFCheckIOManual.Ed_N_UserEnter(Sender: TObject);
begin
  ed_kd_user.SetFocus;
end;

procedure TFCheckIOManual.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFCheckIOManual.Ed_PasswordKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key=vk_return then
  begin
    PeekMessage(Mgs, 0, WM_CHAR, WM_CHAR, PM_REMOVE );
    btnCheckClick(Sender);
  end;
end;

procedure TFCheckIOManual.Ed_Kd_UserChange(Sender: TObject);
begin
  Ed_N_User.Clear;
  Ed_Password.Clear;
end;

procedure TFCheckIOManual.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_escape then
  Close;
end;

procedure TFCheckIOManual.FormShow(Sender: TObject);
begin
  Caption := 'CHECK '+ jenis;
  lblStatus.Caption := Caption;
  btnCheck.Caption := Caption;
  parentPath := ExtractFilePath(ExcludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)));
end;

procedure TFCheckIOManual.bersih;
begin
  Ed_Kd_User.Clear;
  Ed_N_User.Clear;
  Ed_Password.Clear;
  Ed_Kd_User.SetFocus;
end;

end.
