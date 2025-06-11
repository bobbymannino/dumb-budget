object dmDB: TdmDB
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 1920
  Width = 2560
  PixelsPerInch = 192
  object conn: TADOConnection
    Left = 200
    Top = 136
  end
  object qry: TADOQuery
    Connection = conn
    Parameters = <>
    Left = 416
    Top = 144
  end
end
