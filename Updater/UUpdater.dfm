object FUpdater: TFUpdater
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
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid1: TcxGrid
    Left = 0
    Top = 41
    Width = 912
    Height = 381
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
        Caption = 'File'
        DataBinding.ValueType = 'String'
        Options.Editing = False
        Width = 141
      end
      object TableViewColumn2: TcxGridDBColumn
        Caption = 'Versi Terbaru'
        DataBinding.ValueType = 'String'
        Options.Editing = False
        Width = 103
      end
      object TableViewColumn3: TcxGridDBColumn
        Caption = 'Versi Sekarang'
        DataBinding.ValueType = 'String'
        Options.Editing = False
        Width = 98
      end
      object TableViewColumn4: TcxGridDBColumn
        Caption = 'Aksi'
        DataBinding.ValueType = 'String'
        Options.Editing = False
        Width = 72
      end
      object TableViewColumn5: TcxGridDBColumn
        Caption = 'URL Download'
        DataBinding.ValueType = 'String'
        Options.Editing = False
        Width = 270
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
      Height = 25
      ParentShowHint = False
      Smooth = True
      ShowHint = True
      TabOrder = 2
    end
  end
  object status: TStatusBar
    Left = 0
    Top = 422
    Width = 912
    Height = 19
    Panels = <
      item
        Text = 'Status'
        Width = 50
      end>
  end
  object Laporan: TfrxReport
    Version = '4.9.35'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 42229.882180833330000000
    ReportOptions.LastChange = 42229.882180833330000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 24
    Top = 96
    Datasets = <>
    Variables = <>
    Style = <>
  end
  object frxBarCodeObject1: TfrxBarCodeObject
    Left = 72
    Top = 96
  end
  object UnZipApp: TAbUnZipper
    OnArchiveItemProgress = UnZipAppArchiveItemProgress
    Left = 112
    Top = 96
  end
end
