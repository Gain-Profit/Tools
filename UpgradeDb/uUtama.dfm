object FrmUpgrade: TFrmUpgrade
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Upgrade Database Gain Profit'
  ClientHeight = 232
  ClientWidth = 457
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 36
    Width = 457
    Height = 41
    Align = alTop
    TabOrder = 0
    ExplicitLeft = 136
    ExplicitTop = 104
    ExplicitWidth = 185
    object Label1: TLabel
      Left = 8
      Top = 14
      Width = 207
      Height = 13
      Caption = '1. Hubungkan Ke Database Terlebih dahulu'
    end
    object Button1: TButton
      Left = 368
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Connect'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 77
    Width = 457
    Height = 72
    Align = alTop
    TabOrder = 1
    ExplicitTop = 41
    ExplicitWidth = 455
    object Label2: TLabel
      Left = 8
      Top = 14
      Width = 264
      Height = 13
      Caption = '2. Load Data yang digunakan untuk Upgrade Database'
    end
    object Button2: TButton
      Left = 368
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Load'
      Enabled = False
      TabOrder = 0
      OnClick = Button2Click
    end
    object EdFile: TEdit
      Left = 8
      Top = 40
      Width = 435
      Height = 21
      ReadOnly = True
      TabOrder = 1
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 149
    Width = 457
    Height = 41
    Align = alTop
    TabOrder = 2
    ExplicitLeft = -8
    ExplicitTop = 145
    object Label3: TLabel
      Left = 8
      Top = 14
      Width = 127
      Height = 13
      Caption = '3. Cek Keabsahan dari File'
    end
    object Button3: TButton
      Left = 368
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Cek File'
      Enabled = False
      TabOrder = 0
      OnClick = Button3Click
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 190
    Width = 457
    Height = 41
    Align = alTop
    TabOrder = 3
    ExplicitTop = 121
    object Label4: TLabel
      Left = 8
      Top = 14
      Width = 183
      Height = 13
      Caption = '4. Jalankan Proses Upgrade Database'
    end
    object Button4: TButton
      Left = 368
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Execute'
      Enabled = False
      TabOrder = 0
      OnClick = Button4Click
    end
  end
  object PanelInfo: TPanel
    Left = 0
    Top = 0
    Width = 457
    Height = 36
    Align = alTop
    TabOrder = 4
    ExplicitLeft = -8
    ExplicitTop = -1
    object LblVersion: TLabel
      Left = 8
      Top = 10
      Width = 162
      Height = 13
      Caption = 'Versi Database Sekarang adalah: '
    end
  end
  object Con: TMyConnection
    Database = 'profit'
    Port = 33066
    Username = 'root'
    Server = 'localhost'
    LoginPrompt = False
    Left = 280
    Top = 8
    EncryptedPassword = 
      'B8FFBFFF96FF91FFA0FFAFFF8DFFCFFF99FFDEFF8BFFA0FF9CFF9AFF91FF8BFF' +
      '9AFF8DFFA0FF9BFF9EFF8BFF9EFF9DFF9EFF8CFF9AFF'
  end
  object Od: TOpenDialog
    Filter = 'Gain Profit Upgrade|*.gpu'
    Left = 320
    Top = 49
  end
end
