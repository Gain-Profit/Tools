unit Uutama;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFUtama }

  TFUtama = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FUtama: TFUtama;

implementation

uses uDm, uKotakMasuk, uKirimPesan;

{$R *.lfm}

{ TFUtama }

procedure TFUtama.Button1Click(Sender: TObject);
begin
  Application.CreateForm(TFKotakMasuk,FKotakMasuk);
  FKotakMasuk.ShowModal;
end;

procedure TFUtama.Button2Click(Sender: TObject);
begin
  Application.CreateForm(TFkirimPesan,FkirimPesan);
  FkirimPesan.ShowModal;
end;

{ TFUtama }


end.

