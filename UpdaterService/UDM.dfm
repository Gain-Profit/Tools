object dm: Tdm
  OldCreateOrder = False
  Left = 358
  Top = 174
  Height = 194
  Width = 173
  object xConn: TmySQLDatabase
    ConnectOptions = []
    Params.Strings = (
      'Port=3306'
      'TIMEOUT=30')
    Left = 24
    Top = 16
  end
  object QShow: TmySQLQuery
    Database = xConn
    Left = 24
    Top = 72
  end
end
