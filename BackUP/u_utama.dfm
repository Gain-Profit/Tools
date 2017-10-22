object FrmBackup: TFrmBackup
  Left = 474
  Top = 281
  BorderStyle = bsDialog
  Caption = 'Auto BackUp'
  ClientHeight = 192
  ClientWidth = 245
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lb_time: TLabel
    Left = 0
    Top = 0
    Width = 245
    Height = 65
    Align = alTop
    Alignment = taCenter
    Caption = '00:00:00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -53
    Font.Name = 'Rockwell'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitWidth = 212
  end
  object sb: TStatusBar
    Left = 0
    Top = 173
    Width = 245
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Width = 100
      end
      item
        Width = 100
      end>
  end
  object BtnBackup: TButton
    Left = 8
    Top = 144
    Width = 233
    Height = 25
    Caption = 'Backup Manual'
    TabOrder = 1
    OnClick = BtnBackupClick
  end
  object gb_pilihan: TRadioGroup
    Left = 8
    Top = 64
    Width = 233
    Height = 49
    Caption = 'Pilihan'
    Columns = 2
    ItemIndex = 2
    Items.Strings = (
      'Strukturnya Saja'
      'Datanya saja'
      'kedua duanya')
    TabOrder = 2
  end
  object ed_nama: TEdit
    Left = 8
    Top = 120
    Width = 233
    Height = 21
    TabOrder = 3
    OnKeyDown = ed_namaKeyDown
  end
  object db: TMyConnection
    Top = 8
  end
  object TmrBackup: TTimer
    Enabled = False
    OnTimer = TmrBackupTimer
    Left = 72
    Top = 8
  end
  object PopupMenu1: TPopupMenu
    Left = 40
    Top = 8
    object open1: TMenuItem
      Caption = 'open'
      OnClick = open1Click
    end
    object exit1: TMenuItem
      Caption = 'exit'
      OnClick = exit1Click
    end
  end
end
