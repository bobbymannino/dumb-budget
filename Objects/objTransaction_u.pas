unit objTransaction_u;

interface

uses objCategory_u;

type
  TTransactionFreqUnit = (DAY, WEEK, FORTNIGHT, MONTH, YEAR);

  TTransaction = class
  private
    fID, fFreqQuantity, fCatID: Integer;
    fTitle: string;
    fCreatedAt: TDateTime;
    fFreqUnit: TTransactionFreqUnit;
    fAmount: Double;
  public
    property ID: Integer read fID write fID;
    property Title: string read fTitle write fTitle;
    property FreqQuantity: Integer read fFreqQuantity write fFreqQuantity;
    property CatID: Integer read fCatID write fCatID;
    property CreatedAt: TDateTime read fCreatedAt write fCreatedAt;
    property FreqUnit: TTransactionFreqUnit read fFreqUnit write fFreqUnit;
    property Amount: Double read fAmount write fAmount;
    class function StringifyFreqUnit(const aFreqUnit: TTransactionFreqUnit)
      : string; static;
    class function ParseFreqUnit(const aFreqUnit: string)
      : TTransactionFreqUnit; static;
    class function CreateEmpty: TTransaction; static;
    function ToString: string; override;

    constructor Create(const aID, aCatID, aFreqQuantity: Integer;
      const aTitle: string; const aAmount: Double; const aCreatedAt: TDateTime;
      const aFreqUnit: TTransactionFreqUnit);
  end;

  TTransactions = TArray<TTransaction>;

  TTransactionPlus = class(TTransaction)
  private
    fCatTitle: string;
    fCatType: TCategoryType;
  public
    property CatTitle: string read fCatTitle write fCatTitle;
    property CatType: TCategoryType read fCatType write fCatType;
    class function CreateEmpty: TTransactionPlus; static;
    function ToString: string; override;

    constructor Create(const aID, aCatID, aFreqQuantity: Integer;
      const aTitle, aCatTitle: string; const aAmount: Double;
      const aCreatedAt: TDateTime; const aFreqUnit: TTransactionFreqUnit;
      const aCatType: TCategoryType);
  end;

  TTransactionsPlus = TArray<TTransactionPlus>;

implementation

uses
  System.SysUtils, System.TypInfo;

{ TTransaction }

constructor TTransaction.Create(const aID, aCatID, aFreqQuantity: Integer;
  const aTitle: string; const aAmount: Double; const aCreatedAt: TDateTime;
  const aFreqUnit: TTransactionFreqUnit);
begin
  ID := aID;
  Title := aTitle;
  Amount := aAmount;
  FreqQuantity := aFreqQuantity;
  FreqUnit := aFreqUnit;
  CatID := aCatID;
  CreatedAt := aCreatedAt;
end;

class function TTransaction.CreateEmpty: TTransaction;
begin
  Result := TTransaction.Create(0, 0, 0, '', 0.0, Date,
    TTransactionFreqUnit.DAY);
end;

class function TTransaction.ParseFreqUnit(const aFreqUnit: string)
  : TTransactionFreqUnit;
begin
  if aFreqUnit = 'DAY' then
    Result := TTransactionFreqUnit.DAY
  else if aFreqUnit = 'WEEK' then
    Result := TTransactionFreqUnit.WEEK
  else if aFreqUnit = 'FORTNIGHT' then
    Result := TTransactionFreqUnit.FORTNIGHT
  else if aFreqUnit = 'MONTH' then
    Result := TTransactionFreqUnit.MONTH
  else if aFreqUnit = 'YEAR' then
    Result := TTransactionFreqUnit.YEAR
  else
    raise Exception.CreateFmt('Invalid transaction frequency unit: "%s"',
      [aFreqUnit]);
end;

class function TTransaction.StringifyFreqUnit(const aFreqUnit
  : TTransactionFreqUnit): string;
begin
  Case aFreqUnit of
    TTransactionFreqUnit.DAY:
      Result := 'DAY';
    TTransactionFreqUnit.WEEK:
      Result := 'WEEK';
    TTransactionFreqUnit.FORTNIGHT:
      Result := 'FORTNIGHT';
    TTransactionFreqUnit.MONTH:
      Result := 'MONTH';
    TTransactionFreqUnit.YEAR:
      Result := 'YEAR';
  End;
end;

function TTransaction.ToString: string;
begin
  Result := Format
    ('ID: %d, Title: %s, CategoryID: %d, FreqUnit: %s, FreqQuantity: %d, CreatedAt: %s',
    [ID, Title, CatID, TTransaction.StringifyFreqUnit(FreqUnit), FreqQuantity,
    DateToStr(CreatedAt)]);
end;

{ TTransactionPlus }

constructor TTransactionPlus.Create(const aID, aCatID, aFreqQuantity: Integer;
  const aTitle, aCatTitle: string; const aAmount: Double;
  const aCreatedAt: TDateTime; const aFreqUnit: TTransactionFreqUnit;
  const aCatType: TCategoryType);
begin
  inherited Create(aID, aCatID, aFreqQuantity, aTitle, aAmount, aCreatedAt,
    aFreqUnit);

  CatType := aCatType;
  CatTitle := aCatTitle;
end;

class function TTransactionPlus.CreateEmpty: TTransactionPlus;
begin
  Result := TTransactionPlus.Create(0, 0, 0, '', '', 0.0, Date,
    TTransactionFreqUnit.DAY, TCategoryType.Income);
end;

function TTransactionPlus.ToString: string;
begin
  Result := Format
    ('ID: %d, Title: %s, Amount: %f, CategoryID: %d, CategoryType: %s, CategoryTitle: %s, FreqUnit: %s, FreqQuantity: %d, CreatedAt: %s',
    [ID, Title, Amount, CatID, TCategory.StringifyCatType(CatType), CatTitle,
    TTransaction.StringifyFreqUnit(FreqUnit), FreqQuantity,
    DateToStr(CreatedAt)]);
end;

end.
