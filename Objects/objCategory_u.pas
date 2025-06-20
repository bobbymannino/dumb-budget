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

function TCategory.ToString: string;
var
  ftype: string;
begin
  if fCatType = TCategoryType.Income then
    ftype := 'Income'
  else
    ftype := 'Expense';

  Result := Format('ID: %d, Title: %s, Type: %s, CreatedAt: %s',
    [ID, Title, ftype, DateToStr(CreatedAt)]);
end;

end.
