object ServiceMutasi: TServiceMutasi
  OldCreateOrder = False
  AllowPause = False
  DisplayName = 'GainService'
  OnStart = ServiceStart
  OnStop = ServiceStop
  Left = 412
  Top = 142
  Height = 163
  Width = 212
  object db: TmySQLDatabase
    ConnectOptions = []
    Params.Strings = (
      'Port=3306'
      'TIMEOUT=30')
    Left = 16
    Top = 16
  end
  object T_mutasi: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = T_mutasiTimer
    Left = 128
    Top = 16
  end
  object Q_service: TmySQLQuery
    Database = db
    Left = 64
    Top = 16
  end
  object Q_show: TmySQLQuery
    Database = db
    Left = 16
    Top = 64
  end
  object Q_rinci: TmySQLQuery
    Database = db
    Left = 64
    Top = 64
  end
end
