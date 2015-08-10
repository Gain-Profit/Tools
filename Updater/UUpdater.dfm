object Form1: TForm1
  Left = 230
  Top = 185
  Width = 928
  Height = 480
  Caption = 'Updater'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid1: TcxGrid
    Left = 0
    Top = 41
    Width = 912
    Height = 400
    Align = alClient
    TabOrder = 0
    object TableView: TcxGridDBTableView
      NavigatorButtons.ConfirmDelete = False
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      object TableViewColumn1: TcxGridDBColumn
        Caption = 'Aplikasi'
        DataBinding.ValueType = 'String'
        Options.Editing = False
        Width = 115
      end
      object TableViewColumn2: TcxGridDBColumn
        Caption = 'Versi Sekarang'
        DataBinding.ValueType = 'String'
        Options.Editing = False
        Width = 83
      end
      object TableViewColumn3: TcxGridDBColumn
        Caption = 'Versi Terbaru'
        DataBinding.ValueType = 'String'
        Options.Editing = False
        Width = 80
      end
      object TableViewColumn4: TcxGridDBColumn
        Caption = 'Aksi'
        DataBinding.ValueType = 'String'
        Options.Editing = False
        Width = 214
      end
    end
    object Level: TcxGridLevel
      GridView = TableView
    end
  end
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 912
    Height = 41
    Align = alTop
    TabOrder = 1
    DesignSize = (
      912
      41)
    object btnCek: TButton
      Left = 8
      Top = 8
      Width = 185
      Height = 25
      Caption = 'Cek Semua Aplikasi'
      TabOrder = 0
      OnClick = btnCekClick
    end
    object btnJalankan: TButton
      Left = 736
      Top = 8
      Width = 171
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Jalankan Aksi'
      Enabled = False
      TabOrder = 1
      OnClick = btnJalankanClick
    end
    object pbDownload: TProgressBar
      Left = 200
      Top = 8
      Width = 529
      Height = 17
      ParentShowHint = False
      Smooth = True
      ShowHint = True
      TabOrder = 2
    end
  end
end
