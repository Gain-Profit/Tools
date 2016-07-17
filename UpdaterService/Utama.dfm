object GainUpdater: TGainUpdater
  OldCreateOrder = False
  AllowPause = False
  DisplayName = 'Gain Updater'
  OnStart = ServiceStart
  OnStop = ServiceStop
  Left = 192
  Top = 125
  Height = 150
  Width = 215
  object Timer1: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = Timer1Timer
    Left = 16
    Top = 8
  end
end
