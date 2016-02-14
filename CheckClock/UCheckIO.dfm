object FChekIO: TFChekIO
  Left = 280
  Top = 249
  Width = 657
  Height = 394
  Caption = 'CHECK (IN / OUT)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object imgJari: TImage
    Left = 8
    Top = 8
    Width = 121
    Height = 129
  end
  object lbl1: TLabel
    Left = 328
    Top = 8
    Width = 36
    Height = 13
    Caption = 'User ID'
  end
  object lbl2: TLabel
    Left = 328
    Top = 32
    Width = 28
    Height = 13
    Caption = 'Nama'
  end
  object mmoInfo: TMemo
    Left = 136
    Top = 2
    Width = 185
    Height = 289
    Ctl3D = True
    Enabled = False
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 0
  end
  object edID: TEdit
    Left = 376
    Top = 8
    Width = 121
    Height = 19
    Ctl3D = False
    Enabled = False
    ParentCtl3D = False
    TabOrder = 1
  end
  object edNama: TEdit
    Left = 376
    Top = 40
    Width = 121
    Height = 19
    Ctl3D = False
    Enabled = False
    ParentCtl3D = False
    TabOrder = 2
  end
  object FPVer: TFinFPVer
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    OnFPVerificationStatus = FPVerFPVerificationStatus
    OnFPVerificationID = FPVerFPVerificationID
    OnFPVerificationImage = FPVerFPVerificationImage
    Left = 32
    Top = 152
  end
end
