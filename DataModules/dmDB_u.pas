unit dmDB_u;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TdmDB = class(TDataModule)
    connDB: TFDConnection;
    qryDB: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    function GetDatabasePath: string;
    procedure CreateTables;
  public
    { Public declarations }
  end;

var
  dmDB: TdmDB;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

procedure TdmDB.DataModuleCreate(Sender: TObject);
begin
  connDB.Params.Clear;
  connDB.Params.Add('Database=' + GetDatabasePath);
  connDB.Params.Add('DriverID=SQLite');

  try
    connDB.Connected := True;
  except
    on e: Exception do
      ShowMessage('Failed to connect to the database');
  end;

  try
    CreateTables;
  except
    on e: Exception do
      ShowMessage(e.Message);
  end;
end;

procedure TdmDB.DataModuleDestroy(Sender: TObject);
begin
  qryDB.Close;
  connDB.Close;
end;

function TdmDB.GetDatabasePath: string;
var
  AppDataPath: string;
  AppFolder: string;
begin
  { TODO : Add path for macOS }
  AppDataPath := GetEnvironmentVariable('LOCALAPPDATA');

  if AppDataPath = '' then
    AppDataPath := GetEnvironmentVariable('APPDATA');

  AppFolder := 'DumbBudget';

  Result := IncludeTrailingPathDelimiter(AppDataPath) +
    IncludeTrailingPathDelimiter(AppFolder);

  if not DirectoryExists(Result) then
    ForceDirectories(Result);

  Result := Result + 'Database.db';
end;

procedure TdmDB.CreateTables;
begin
  try
    qryDB.SQL.Text := 'CREATE TABLE IF NOT EXISTS Categories (' +
      'CategoryID INTEGER PRIMARY KEY AUTOINCREMENT,' +
      'Title TEXT NOT NULL UNIQUE,' +
      'Type TEXT CHECK (Type IN (''IN'', ''OUT'')),' +
      'CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP' + ')';
    qryDB.ExecSQL;

    qryDB.SQL.Text := 'CREATE TABLE IF NOT EXISTS Transactions (' +
      'TransactionID INTEGER PRIMARY KEY AUTOINCREMENT,' +
      'Title TEXT NOT NULL UNIQUE,' + 'Amount REAL NOT NULL,' +
      'Quantity INTEGER NOT NULL,' +
      'Unit TEXT NOT NULL CHECK (Unit IN (''DAY'', ''WEEK'', ''FORTNIGHT'', ''MONTH'', ''YEAR'')),'
      + 'CategoryID INTEGER NOT NULL REFERENCES Categories (CategoryID),' +
      'CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP' + ')';
    qryDB.ExecSQL;

    qryDB.SQL.Text := 'CREATE VIEW IF NOT EXISTS TransactionsPlus AS ' +
      'SELECT t.*, c.Title as Category, c.CategoryID, c.Type ' +
      'FROM Transactions t ' +
      'JOIN Categories c on c.CategoryID = t.CategoryID';
    qryDB.ExecSQL;
  except
    on e: Exception do
      raise Exception.create('Error creating tables: ' + e.Message);
  end;
end;

end.
