object FormUtama: TFormUtama
  Left = 81
  Top = 151
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Gain Profit Updater'
  ClientHeight = 442
  ClientWidth = 912
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid1: TcxGrid
    Left = 0
    Top = 41
    Width = 912
    Height = 382
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
        Caption = 'Nama'
        DataBinding.ValueType = 'String'
        Options.Editing = False
        Width = 137
      end
      object TableViewColumn2: TcxGridDBColumn
        Caption = 'Path'
        DataBinding.ValueType = 'String'
        Options.Editing = False
        Width = 75
      end
      object TableViewColumn3: TcxGridDBColumn
        Caption = 'MD5'
        DataBinding.ValueType = 'String'
        Options.Editing = False
        Width = 129
      end
      object TableViewColumn4: TcxGridDBColumn
        Caption = 'Versi'
        DataBinding.ValueType = 'String'
        Options.Editing = False
        Width = 65
      end
      object TableViewColumn5: TcxGridDBColumn
        Caption = 'Download'
        DataBinding.ValueType = 'String'
        Options.Editing = False
        Width = 278
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
    object btnBrowse: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 21
      Caption = 'Pilih Folder'
      TabOrder = 0
      OnClick = btnBrowseClick
    end
    object edtFolder: TEdit
      Left = 88
      Top = 8
      Width = 633
      Height = 21
      TabOrder = 1
      Text = 'D:\WORKSPACES\GAIN PROFIT\GAIN PROFIT'
    end
    object btnCek: TButton
      Left = 728
      Top = 8
      Width = 89
      Height = 21
      Caption = 'Cek'
      TabOrder = 2
      OnClick = btnCekClick
    end
    object btnSimpan: TButton
      Left = 824
      Top = 8
      Width = 81
      Height = 21
      Caption = 'Simpan'
      TabOrder = 3
      OnClick = btnSimpanClick
    end
  end
  object status: TStatusBar
    Left = 0
    Top = 423
    Width = 912
    Height = 19
    Panels = <
      item
        Text = 'Status'
        Width = 50
      end>
  end
  object zipApp: TAbZipper
    AutoSave = False
    DOSMode = False
    StoreOptions = [soStripDrive, soStripPath, soRemoveDots]
    Left = 8
    Top = 64
  end
end
