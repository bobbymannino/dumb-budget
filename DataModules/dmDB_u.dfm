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
    Left = 176
    Top = 104
  end
  object qryDB: TFDQuery
    Connection = connDB
    Left = 456
    Top = 128
  end
  object tblCategories: TFDTable
    Connection = connDB
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'Categories'
    Left = 176
    Top = 288
  end
end
