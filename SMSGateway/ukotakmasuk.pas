unit uKotakMasuk;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  DBGrids, ExtCtrls, StdCtrls;

type

  { TFKotakMasuk }

  TFKotakMasuk = class(TForm)
    btnRefresh: TButton;
    Button1: TButton;
    DBGrid1: TDBGrid;
    DsKotakMasuk: TDataSource;
    mmPesan: TMemo;
    Panel1: TPanel;
    QKotakMasuk: TSQLQuery;
    procedure btnRefreshClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure QKotakMasukAfterScroll(DataSet: TDataSet);
    procedure Refresh;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FKotakMasuk: TFKotakMasuk;
  RecTemp:LongInt;

implementation

uses uDm;

{$R *.lfm}

{ TFKotakMasuk }

procedure TFKotakMasuk.btnRefreshClick(Sender: TObject);
begin
  Refresh;
end;

procedure TFKotakMasuk.Button1Click(Sender: TObject);
begin
  dm.query(dm.Qexe,'update inbox set Processed="true" where ID="'+QKotakMasuk.FieldByName('ID').AsString+'"',False);
  dm.Trans.Commit;
  Refresh;
  QKotakMasuk.RecNo:=RecTemp;
end;

procedure TFKotakMasuk.FormShow(Sender: TObject);
begin
  Refresh;
end;

procedure TFKotakMasuk.QKotakMasukAfterScroll(DataSet: TDataSet);
begin
  mmpesan.Text := DataSet.FieldByName('TextDecoded').AsString;
  RecTemp:=DataSet.RecNo;
  Button1.Caption:=IntToStr(RecTemp);
end;

procedure TFKotakMasuk.Refresh;
begin
  dm.query(QKotakMasuk,'select ID,ReceivingDateTime,SenderNumber,TextDecoded from inbox order by ReceivingDateTime DESC',True);
end;

end.

