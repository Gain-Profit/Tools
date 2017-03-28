object Form1: TForm1
  Left = 205
  Top = 125
  Width = 915
  Height = 480
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Lv: TListView
    Left = 0
    Top = 41
    Width = 899
    Height = 400
    Align = alClient
    Columns = <
      item
        Caption = 'File Name'
        Width = 500
      end
      item
        Caption = 'Version'
        Width = 100
      end
      item
        Caption = 'MD5'
        Width = 250
      end>
    TabOrder = 0
    ViewStyle = vsReport
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 899
    Height = 41
    Align = alTop
    TabOrder = 1
    object BtnVersi: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Versi Laporan'
      TabOrder = 0
      OnClick = BtnVersiClick
    end
    object EdDir: TEdit
      Left = 88
      Top = 8
      Width = 713
      Height = 21
      ReadOnly = True
      TabOrder = 1
      Text = 'D:\WORKSPACES\GAIN PROFIT\GAIN PROFIT\laporan\'
      OnDblClick = EdDirDblClick
    end
    object BtnSimpan: TButton
      Left = 816
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Simpan'
      TabOrder = 2
      OnClick = BtnSimpanClick
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 104
    Top = 40
  end
end
