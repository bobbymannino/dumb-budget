unit objTransaction_u;

interface

type
  TTransactionFreqUnit = (DAY, WEEK, FORTNIGHT, MONTH, YEAR);

  TTransaction = record
  private
    fID, fFreqQuantity, fCatID: Integer;
    fTitle: string;
    fCreatedAt: TDateTime;
    fFreqUnit: TTransactionFreqUnit;
  public
    property ID: Integer read fID write fID;
    property Title: string read fTitle write fTitle;
    property FreqQuantity: Integer read fFreqQuantity write fFreqQuantity;
    property CatID: Integer read fCatID write fCatID;
    property CreatedAt: TDateTime read fCreatedAt write fCreatedAt;
    property FreqUnit: TTransactionFreqUnit read fFreqUnit write fFreqUnit;
    function ToString: string;

    constructor Create(const aID, aCatID, aFreqQuantity: Integer;
      const aTitle: string; const aCreatedAt: TDateTime;
      const aFreqUnit: TTransactionFreqUnit);
  end;

  TTransactions = TArray<TTransaction>;

implementation

uses
  System.SysUtils, System.TypInfo;

{ TTransaction }

constructor TTransaction.Create(const aID, aCatID, aFreqQuantity: Integer;
  const aTitle: string; const aCreatedAt: TDateTime;
  const aFreqUnit: TTransactionFreqUnit);
begin
  ID := aID;
  Title := aTitle;
  FreqQuantity := aFreqQuantity;
  FreqUnit := aFreqUnit;
  CatID := aCatID;
  CreatedAt := aCreatedAt;
end;

function TTransaction.ToString: string;
begin
  Result := Format
    ('ID: %d, Title: %s, CategoryID: %d, FreqUnit: %s, FreqQuantity: %d, CreatedAt: %s',
    [ID, Title, CatID, GetEnumName(TypeInfo(TTransactionFreqUnit), Ord(FreqUnit)
    ), FreqQuantity, DateToStr(CreatedAt)]);
end;

end.
