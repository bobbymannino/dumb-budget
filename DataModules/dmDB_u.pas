unit dmDB_u;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, FMX.Dialogs;

type
  TdmDB = class(TDataModule)
    conn: TADOConnection;
    qry: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    function GetConnectionString: string;
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
  conn.ConnectionString := GetConnectionString;
  conn.LoginPrompt := False;

  try
    conn.Connected := True;

    CreateTables;
  except
    on e: Exception do
      ShowMessage('Failed to create tables');
  end;
end;

procedure TdmDB.DataModuleDestroy(Sender: TObject);
begin
  qry.Close;
  conn.Close;
end;

function TdmDB.GetDatabasePath: string;
var
  AppDataPath: string;
  AppFolder: string;
begin
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

function TdmDB.GetConnectionString: string;
var
  DatabasePath: string;
begin
  DatabasePath := GetDatabasePath;

  Result := Format
    ('Provider=MSDASQL.1;Extended Properties="Driver=SQLite3 ODBC Driver;Database=%s;StepAPI=0;SyncPragma=NORMAL;NoTXN=0;Timeout=100000;ShortNames=0;LongNames=0;NoCreat=0;NoWCHAR=0;FKSupport=0;JournalMode=WAL;OEMCP=0;LoadExt=;BigInt=0;JDConv=0;"',
    [DatabasePath]);
end;

procedure TdmDB.CreateTables;
begin
  try
    qry.SQL.Text := 'CREATE TABLE IF NOT EXISTS Categories (' +
      'CategoryID INTEGER PRIMARY KEY AUTOINCREMENT,' +
      'Title TEXT NOT NULL UNIQUE,' +
      'Type TEXT CHECK (Text IN (''IN'', ''OUT'')),' +
      'CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP' + ')';
    qry.ExecSQL;

    qry.SQL.Text := 'CREATE TABLE IF NOT EXISTS Transactions (' +
      'TransactionID INTEGER PRIMARY KEY AUTOINCREMENT,' +
      'Title TEXT NOT NULL UNIQUE,' + 'Amount REAL NOT NULL,' +
      'Quantity INTEGER NOT NULL,' +
      'Unit TEXT NOT NULL CHECK (Unit IN (''DAY'', ''WEEK'', ''FORTNIGHT'', ''MONTH'', ''YEAR'')),'
      + 'CategoryID INTEGER NOT NULL REFERENCES Categories (CategoryID),' +
      'CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP' + ')';
    qry.ExecSQL;
  except
    on e: Exception do
      raise Exception.create('Error creating tables: ' + e.Message);
  end;
end;

end.
