object dmDB: TdmDB
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 1920
  Width = 2560
  PixelsPerInch = 192
  object connDB: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    Left = 100
    Top = 100
  end
  object qryDB: TFDQuery
    Connection = connDB
    Left = 300
    Top = 100
  end
end
