object FCheckIOManual: TFCheckIOManual
  Left = 274
  Top = 192
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'CHECK OUT'
  ClientHeight = 297
  ClientWidth = 397
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sLabel4: TsLabel
    Left = 8
    Top = 64
    Width = 76
    Height = 19
    Caption = 'Kode User'
    ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 2171169
    Font.Height = -16
    Font.Name = 'Rockwell'
    Font.Style = []
  end
  object sLabel5: TsLabel
    Left = 8
    Top = 120
    Width = 82
    Height = 19
    Caption = 'Nama User'
    ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 2171169
    Font.Height = -16
    Font.Name = 'Rockwell'
    Font.Style = []
  end
  object sLabel6: TsLabel
    Left = 8
    Top = 176
    Width = 70
    Height = 19
    Caption = 'Password'
    ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 2171169
    Font.Height = -16
    Font.Name = 'Rockwell'
    Font.Style = []
  end
  object lblStatus: TsLabel
    Left = 8
    Top = 8
    Width = 377
    Height = 29
    Alignment = taCenter
    AutoSize = False
    Caption = 'CHECK OUT'
    ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 2171169
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
  end
  object btnClose: TsBitBtn
    Left = 304
    Top = 248
    Width = 81
    Height = 33
    Cursor = crHandPoint
    Caption = '&Close'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Rockwell'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 4
    OnClick = btnCloseClick
    NumGlyphs = 2
    SkinData.SkinSection = 'BUTTON'
  end
  object btnCheck: TsButton
    Left = 160
    Top = 248
    Width = 115
    Height = 33
    Caption = 'CHECK OUT'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Rockwell'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btnCheckClick
    SkinData.SkinSection = 'BUTTON'
  end
  object Ed_Kd_User: TsEdit
    Left = 32
    Top = 88
    Width = 353
    Height = 27
    CharCase = ecUpperCase
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Rockwell'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = Ed_Kd_UserChange
    OnKeyDown = Ed_Kd_UserKeyDown
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'MS Sans Serif'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
  end
  object Ed_N_User: TsEdit
    Left = 32
    Top = 144
    Width = 353
    Height = 27
    CharCase = ecUpperCase
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Rockwell'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
    OnEnter = Ed_N_UserEnter
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'MS Sans Serif'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
  end
  object Ed_Password: TsEdit
    Left = 32
    Top = 200
    Width = 353
    Height = 27
    Color = clWhite
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Rockwell'
    Font.Style = []
    ParentFont = False
    PasswordChar = '@'
    TabOrder = 2
    OnKeyDown = Ed_PasswordKeyDown
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'MS Sans Serif'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
  end
end
