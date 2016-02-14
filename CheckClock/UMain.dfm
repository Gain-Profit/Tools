object FMain: TFMain
  Left = 192
  Top = 125
  Width = 928
  Height = 480
  Caption = 'CHECK CLOCK'
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
  object sb: TsStatusBar
    Left = 0
    Top = 422
    Width = 912
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    SkinData.SkinSection = 'STATUSBAR'
  end
  object sBitBtn1: TsBitBtn
    Left = 112
    Top = 160
    Width = 113
    Height = 153
    Caption = 'sBitBtn1'
    TabOrder = 1
    SkinData.SkinSection = 'BUTTON'
  end
  object sBitBtn2: TsBitBtn
    Left = 328
    Top = 160
    Width = 209
    Height = 145
    Caption = 'sBitBtn2'
    TabOrder = 2
    SkinData.SkinSection = 'BUTTON'
  end
end
