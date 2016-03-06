object dm: Tdm
  OldCreateOrder = False
  Left = 358
  Top = 174
  Height = 194
  Width = 173
  object xConn: TmySQLDatabase
    DatabaseName = 'profit'
    UserName = 'root'
    UserPassword = 'server'
    Host = 'localhost'
    ConnectOptions = []
    Params.Strings = (
      'Port=3306'
      'TIMEOUT=30'
      'DatabaseName=profit'
      'Host=localhost'
      'UID=root'
      'PWD=server')
    Left = 24
    Top = 16
  end
  object QShow: TmySQLQuery
    Database = xConn
    Left = 24
    Top = 72
  end
end
