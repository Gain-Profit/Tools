object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 358
  Top = 174
  Height = 415
  Width = 289
  object xConn: TMyConnection
    Left = 24
    Top = 16
  end
  object Qexe: TMyQuery
    Connection = xConn
    Left = 88
    Top = 16
  end
  object QShow: TMyQuery
    Connection = xConn
    Left = 24
    Top = 72
  end
  object sm: TsSkinManager
    AnimEffects.BlendOnMoving.Active = True
    AnimEffects.DialogShow.Time = 100
    AnimEffects.FormShow.Time = 100
    AnimEffects.FormHide.Time = 100
    AnimEffects.DialogHide.Time = 100
    AnimEffects.PageChange.Time = 60
    AnimEffects.SkinChanging.Time = 200
    Active = False
    ExtendedBorders = True
    InternalSkins = <>
    SkinDirectory = 'Skins'
    SkinName = 'Air'
    SkinInfo = 'N/A'
    ThirdParty.ThirdEdits = 
      'TEdit'#13#10'TMemo'#13#10'TMaskEdit'#13#10'TLabeledEdit'#13#10'THotKey'#13#10'TListBox'#13#10'TCheck' +
      'ListBox'#13#10'TRichEdit'#13#10'TDateTimePicker'#13#10'TDBListBox'#13#10'TDBMemo'#13#10'TDBLoo' +
      'kupListBox'#13#10'TDBRichEdit'#13#10'TDBCtrlGrid'#13#10'TDBEdit'#13#10
    ThirdParty.ThirdButtons = 'TButton'#13#10
    ThirdParty.ThirdBitBtns = 'TBitBtn'#13#10
    ThirdParty.ThirdCheckBoxes = 'TCheckBox'#13#10'TRadioButton'#13#10'TGroupButton'#13#10'TDBCheckBox'#13#10
    ThirdParty.ThirdGroupBoxes = 'TGroupBox'#13#10'TRadioGroup'#13#10'TDBRadioGroup'#13#10
    ThirdParty.ThirdListViews = 'TListView'#13#10
    ThirdParty.ThirdPanels = 'TPanel'#13#10'TDBNavigator'#13#10'TDBCtrlPanel'#13#10
    ThirdParty.ThirdGrids = 'TStringGrid'#13#10'TDrawGrid'#13#10'TDBGrid'#13#10'Tcxgrid'#13#10'TAbZipView'#13#10
    ThirdParty.ThirdTreeViews = 'TTreeView'#13#10'TDBTreeView'#13#10
    ThirdParty.ThirdComboBoxes = 'TComboBox'#13#10'TColorBox'#13#10'TDBComboBox'#13#10
    ThirdParty.ThirdWWEdits = ' '#13#10
    ThirdParty.ThirdVirtualTrees = ' '#13#10
    ThirdParty.ThirdGridEh = ' '#13#10
    ThirdParty.ThirdPageControl = 'TPageControl'#13#10
    ThirdParty.ThirdTabControl = 'TTabControl'#13#10
    ThirdParty.ThirdToolBar = 'TToolBar'#13#10
    ThirdParty.ThirdStatusBar = 'TStatusBar'#13#10
    ThirdParty.ThirdSpeedButton = 'TSpeedButton'#13#10'TNavButton'#13#10
    ThirdParty.ThirdScrollControl = ' '
    ThirdParty.ThirdUpDown = ' '
    ThirdParty.ThirdScrollBar = ' '
    ThirdParty.ThirdStaticText = ' '
    ThirdParty.ThirdNativePaint = ' '
    Left = 216
    Top = 24
  end
  object dsStatus: TDataSource
    DataSet = QStatus
    Left = 88
    Top = 128
  end
  object QStatus: TMyQuery
    Connection = xConn
    Left = 24
    Top = 128
  end
end
