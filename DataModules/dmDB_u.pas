unit dmDB_u;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  objCategory_u, objTransaction_u, FireDAC.VCLUI.Wait;

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
    procedure DeleteTransaction(const aTnsID: Integer);
    procedure UpdateTransaction(const aTns: TTransaction);
    procedure CreateTransaction(const aTns: TTransaction);
    function GetTransactions: TTransactionsPlus;
    procedure CreateCategory(const aCat: TCategory);
    function GetCategories: TCategories;
  end;

var
  dmDB: TdmDB;

implementation

uses
  System.TypInfo;

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
      ShowMessage('Failed to create tables');
  end;
end;

procedure TdmDB.DataModuleDestroy(Sender: TObject);
begin
  qryDB.Close;
  connDB.Close;
end;

procedure TdmDB.DeleteTransaction(const aTnsID: Integer);
begin
  qryDB.SQL.Text := 'DELETE FROM Transactions WHERE TransactionID = :TnsID';

  qryDB.ParamByName('TnsID').AsInteger := aTnsID;

  try
    qryDB.ExecSQL;
  except
    on e: Exception do
      raise Exception.Create('Failed to update transaction');
  end;
end;

function TdmDB.GetDatabasePath: string;
var
  AppDataPath: string;
  AppFolder: string;
begin
  AppFolder := 'DumbBudget';

  // Windows: /Users/<me>/AppData/Local/DumbBudget/Database.db
  // Mac: /Users/<me>/Application Support/DumbBudget/Database.db

  { DONE 1 -cBuild : Add path for macOS }

{$IFDEF DARWIN}
  AppDataPath := GetEnvironmentVariable('HOME') +
    '/Library/Application Support';
{$ELSE}
  AppDataPath := GetEnvironmentVariable('LOCALAPPDATA');
  if AppDataPath = '' then
    AppDataPath := GetEnvironmentVariable('APPDATA');
{$ENDIF}
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
      'SELECT t.*, c.Title as Category, c.Type ' + 'FROM Transactions t ' +
      'JOIN Categories c on c.CategoryID = t.CategoryID';
    qryDB.ExecSQL;
  except
    on e: Exception do
      raise Exception.Create('Error creating tables: ' + e.Message);
  end;
end;

function TdmDB.GetTransactions: TTransactionsPlus;
var
  fTns: TTransactionPlus;
  i: Integer;
begin
  qryDB.SQL.Text := 'SELECT * FROM TransactionsPlus ORDER BY Type, Title';

  try
    qryDB.Open;

    if qryDB.RecordCount = 0 then
      Exit;

    SetLength(Result, qryDB.RecordCount);

    i := 0;
    qryDB.First;
    while not qryDB.Eof do
    begin
      fTns := TTransactionPlus.CreateEmpty;
      fTns.ID := qryDB.FieldByName('TransactionID').AsInteger;
      fTns.Title := qryDB.FieldByName('Title').AsString;
      fTns.Amount := qryDB.FieldByName('Amount').AsFloat;
      fTns.FreqQuantity := qryDB.FieldByName('Quantity').AsInteger;
      fTns.FreqUnit := TTransaction.ParseFreqUnit(qryDB.FieldByName('Unit')
        .AsString);
      fTns.CatID := qryDB.FieldByName('CategoryID').AsInteger;
      fTns.CatTitle := qryDB.FieldByName('Category').AsString;
      fTns.CatType := TCategory.ParseCatType(qryDB.FieldByName('Type')
        .AsString);
      fTns.CreatedAt := qryDB.FieldByName('CreatedAt').AsDateTime;

      Result[i] := fTns;

      Inc(i);
      qryDB.Next;
    end;
  finally
    qryDB.Close;
  end;
end;

procedure TdmDB.UpdateTransaction(const aTns: TTransaction);
begin
  qryDB.SQL.Text := 'UPDATE Transactions SET ' + 'Title = :Title, ' +
    'CategoryID = :CatID, ' + 'Amount = :Amount, ' + 'Unit = :Unit, ' +
    'Quantity = :Freq ' + 'WHERE TransactionID = :TnsID';

  qryDB.ParamByName('Title').AsString := aTns.Title;
  qryDB.ParamByName('CatID').AsInteger := aTns.CatID;
  qryDB.ParamByName('Freq').AsInteger := aTns.FreqQuantity;
  qryDB.ParamByName('Amount').AsFloat := aTns.Amount;
  qryDB.ParamByName('Unit').AsString := TTransaction.StringifyFreqUnit
    (aTns.FreqUnit);

  qryDB.ParamByName('TnsID').AsInteger := aTns.ID;

  try
    qryDB.ExecSQL;
  except
    on e: Exception do
      raise Exception.Create('Failed to update transaction');
  end;
end;

procedure TdmDB.CreateTransaction(const aTns: TTransaction);
begin
  qryDB.SQL.Text :=
    'INSERT INTO Transactions (Title, CategoryID, Amount, Unit, Quantity) VALUES (:Title, :CatID, :Amount, :Unit, :Freq)';
  qryDB.ParamByName('Title').AsString := aTns.Title;
  qryDB.ParamByName('CatID').AsInteger := aTns.CatID;
  qryDB.ParamByName('Freq').AsInteger := aTns.FreqQuantity;
  qryDB.ParamByName('Amount').AsFloat := aTns.Amount;
  qryDB.ParamByName('Unit').AsString := TTransaction.StringifyFreqUnit
    (aTns.FreqUnit);

  try
    qryDB.ExecSQL;
  except
    on e: Exception do
    begin
      ShowMessage('Failed to create transaction');
      raise Exception.Create('Failed to create transaction');
    end;
  end;
end;

function TdmDB.GetCategories: TCategories;
var
  fCat: TCategory;
  i: Integer;
begin
  qryDB.SQL.Text :=
    'SELECT CategoryID, Title, Type, CreatedAt FROM Categories ORDER BY Type, Title';
  qryDB.Open;
  try
    if qryDB.RecordCount = 0 then
      Exit;

    SetLength(Result, qryDB.RecordCount);

    i := 0;
    qryDB.First;
    while not qryDB.Eof do
    begin
      fCat.ID := qryDB.FieldByName('CategoryID').AsInteger;
      fCat.Title := qryDB.FieldByName('Title').AsString;
      fCat.CreatedAt := qryDB.FieldByName('CreatedAt').AsDateTime;
      fCat.CatType := TCategory.ParseCatType(qryDB.FieldByName('Type')
        .AsString);

      Result[i] := fCat;

      Inc(i);
      qryDB.Next;
    end;
  finally
    qryDB.Close;
  end;
end;

procedure TdmDB.CreateCategory(const aCat: TCategory);
begin
  qryDB.SQL.Text :=
    'INSERT INTO Categories (Title, Type) VALUES (:Title, :Type)';
  qryDB.ParamByName('Title').AsString := aCat.Title;
  qryDB.ParamByName('Type').AsString := TCategory.StringifyCatType
    (aCat.CatType);

  qryDB.ExecSQL;
end;

end.
