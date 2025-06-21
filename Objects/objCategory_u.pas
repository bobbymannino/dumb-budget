unit objCategory_u;

interface

type
  TCategoryType = (Income, Expense);

  TCategory = record
  private
    fID: Integer;
    fTitle: string;
    fCreatedAt: TDateTime;
    fCatType: TCategoryType;
  public
    property ID: Integer read fID write fID;
    property Title: string read fTitle write fTitle;
    property CreatedAt: TDateTime read fCreatedAt write fCreatedAt;
    property CatType: TCategoryType read fCatType write fCatType;
    class function StringifyCatType(const aCatType: TCategoryType)
      : string; static;
    class function ParseCatType(const aCatType: string): TCategoryType; static;
    function ToString: string;

    constructor Create(const aID: Integer; const aTitle: string;
      const aCreatedAt: TDateTime; const aCatType: TCategoryType);
  end;

  TCategories = TArray<TCategory>;

implementation

uses
  System.SysUtils;

{ TCategory }

constructor TCategory.Create(const aID: Integer; const aTitle: string;
  const aCreatedAt: TDateTime; const aCatType: TCategoryType);
begin
  fID := aID;
  fTitle := aTitle;
  fCreatedAt := aCreatedAt;
  fCatType := aCatType;
end;

class function TCategory.ParseCatType(const aCatType: string): TCategoryType;
begin
  if aCatType = 'IN' then
    Result := TCategoryType.Income
  else if aCatType = 'OUT' then
    Result := TCategoryType.Expense
  else
    raise Exception.CreateFmt('Invalid category type: "%s"', [aCatType]);
end;

class function TCategory.StringifyCatType(const aCatType
  : TCategoryType): string;
begin
  Case aCatType of
    TCategoryType.Income:
      Result := 'IN';
    TCategoryType.Expense:
      Result := 'OUT';
  End;
end;

function TCategory.ToString: string;
begin
  Result := Format('ID: %d, Title: %s, Type: %s, CreatedAt: %s',
    [ID, Title, TCategory.StringifyCatType(CatType), DateToStr(CreatedAt)]);
end;

end.
