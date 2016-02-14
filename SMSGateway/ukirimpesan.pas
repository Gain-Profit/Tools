unit uKirimPesan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFkirimPesan }

  TFkirimPesan = class(TForm)
    Button1: TButton;
    Button2: TButton;
    edTujuan: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    mmPesan: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FkirimPesan: TFkirimPesan;

implementation

uses uDm;

{$R *.lfm}

{ TFkirimPesan }

procedure TFkirimPesan.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TFkirimPesan.Button1Click(Sender: TObject);
var
  SQL :string;
begin
  {
  SQL = Format('insert into outbox(DestinationNumber,TextDecoded,senderID,creatorID)values ("%s","%s","bagus","laz")',
  [edTujuan.Text,mmPesan.Text]);
  }

  dm.query(dm.Qexe,'insert into outbox(DestinationNumber,TextDecoded,creatorID)values '+
  '("'+edTujuan.Text+'","'+mmPesan.Text+'","laz")',False);
  dm.Trans.Commit;
end;

end.

