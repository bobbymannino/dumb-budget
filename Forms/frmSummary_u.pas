unit frmSummary_u;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ExtCtrls,
  System.Rtti, FMX.Grid.Style, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Grid,
  Data.DB,
  dmDB_u,
  objTransaction_u, objCategory_u,
  frmNew_u, frmCategories_u;

type
  TfrmSummary = class(TForm)
    lblExpenses: TLabel;
    lblIncomes: TLabel;
    strGrdExpenses: TStringGrid;
    strGrdIncomes: TStringGrid;
    btnNew: TButton;
    btnCats: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnCatsClick(Sender: TObject);
  private
    { Private declarations }
    Tns: TTransactionsPlus;
    procedure RefreshTransactions;
    procedure SetupExpensesHeaders;
    procedure SetupIncomesHeaders;
    procedure RefreshExpenses;
    procedure RefreshIncomes;
  public
    { Public declarations }
  end;

var
  frmSummary: TfrmSummary;

implementation

{$R *.fmx}

procedure TfrmSummary.btnCatsClick(Sender: TObject);
var
  fFrm: TForm;
begin
  fFrm := TfrmCategories.Create(Self);
  fFrm.ShowModal;

  RefreshTransactions;
end;

procedure TfrmSummary.btnNewClick(Sender: TObject);
var
  fFrm: TfrmNew;
begin
  fFrm := TfrmNew.Create(Self);
  fFrm.ShowModal;

  RefreshTransactions;
end;

procedure TfrmSummary.FormCreate(Sender: TObject);
begin
  RefreshTransactions;
end;

procedure TfrmSummary.RefreshTransactions;
begin
  Tns := dmDB.GetTransactions;

  RefreshExpenses;
  RefreshIncomes;
end;

procedure TfrmSummary.RefreshExpenses;
var
  Epns: TTransactionsPlus;
begin
  lblExpenses.Text := 'Expenses';

  if Length(Tns) = 0 then
    Exit;

  for var i := 0 to High(Tns) do
  begin
    if Tns[i].CatType = TCategoryType.Expense then
    begin
      SetLength(Epns, Length(Epns) + 1);
      Epns[High(Epns)] := Tns[i];
    end;
  end;

  lblExpenses.Text := Format('Expenses (%d)', [Length(Epns)]);

  if Length(Epns) = 0 then
    Exit;

  strGrdExpenses.BeginUpdate;
  try
    strGrdExpenses.ClearColumns;
    strGrdExpenses.RowCount := 0;

    if strGrdExpenses.ColumnCount = 0 then
      SetupExpensesHeaders;

    strGrdExpenses.RowCount := Length(Epns);

    for var i := 0 to High(Epns) do
    begin
      strGrdExpenses.Cells[0, i] := Epns[i].Title;
      strGrdExpenses.Cells[1, i] := Epns[i].Amount.ToString;
      strGrdExpenses.Cells[2, i] := Epns[i].FreqQuantity.ToString;
      strGrdExpenses.Cells[3, i] := TTransaction.StringifyFreqUnit
        (Epns[i].FreqUnit);
      strGrdExpenses.Cells[4, i] := Epns[i].CatTitle;
    end;
  finally
    strGrdExpenses.EndUpdate;
  end;
end;

procedure TfrmSummary.SetupExpensesHeaders;
var
  fCol: TStringColumn;
begin
  fCol := TStringColumn.Create(strGrdExpenses);
  fCol.Header := 'Title';
  fCol.Width := 150;
  strGrdExpenses.AddObject(fCol);

  fCol := TStringColumn.Create(strGrdExpenses);
  fCol.Header := 'Amount';
  fCol.Width := 75;
  strGrdExpenses.AddObject(fCol);

  fCol := TStringColumn.Create(strGrdExpenses);
  fCol.Header := 'Per';
  fCol.Width := 50;
  strGrdExpenses.AddObject(fCol);

  fCol := TStringColumn.Create(strGrdExpenses);
  fCol.Header := 'Unit';
  fCol.Width := 75;
  strGrdExpenses.AddObject(fCol);

  fCol := TStringColumn.Create(strGrdExpenses);
  fCol.Header := 'Category';
  fCol.Width := 150;
  strGrdExpenses.AddObject(fCol);
end;

procedure TfrmSummary.RefreshIncomes;
var
  Epns: TTransactionsPlus;
begin
  lblIncomes.Text := 'Incomes';

  if Length(Tns) = 0 then
    Exit;

  for var i := 0 to High(Tns) do
  begin
    if Tns[i].CatType = TCategoryType.Income then
    begin
      SetLength(Epns, Length(Epns) + 1);
      Epns[High(Epns)] := Tns[i];
    end;
  end;

  lblIncomes.Text := Format('Incomes (%d)', [Length(Epns)]);

  if Length(Epns) = 0 then
    Exit;

  strGrdIncomes.BeginUpdate;
  try
    strGrdIncomes.ClearColumns;
    strGrdIncomes.RowCount := 0;

    if strGrdIncomes.ColumnCount = 0 then
      SetupIncomesHeaders;

    strGrdIncomes.RowCount := Length(Epns);

    for var i := 0 to High(Epns) do
    begin
      strGrdIncomes.Cells[0, i] := Epns[i].Title;
      strGrdIncomes.Cells[1, i] := Epns[i].Amount.ToString;
      strGrdIncomes.Cells[2, i] := Epns[i].FreqQuantity.ToString;
      strGrdIncomes.Cells[3, i] := TTransaction.StringifyFreqUnit
        (Epns[i].FreqUnit);
      strGrdIncomes.Cells[4, i] := Epns[i].CatTitle;
    end;
  finally
    strGrdIncomes.EndUpdate;
  end;
end;

procedure TfrmSummary.SetupIncomesHeaders;
var
  fCol: TStringColumn;
begin
  fCol := TStringColumn.Create(strGrdIncomes);
  fCol.Header := 'Title';
  fCol.Width := 150;
  strGrdIncomes.AddObject(fCol);

  fCol := TStringColumn.Create(strGrdIncomes);
  fCol.Header := 'Amount';
  fCol.Width := 75;
  strGrdIncomes.AddObject(fCol);

  fCol := TStringColumn.Create(strGrdIncomes);
  fCol.Header := 'Per';
  fCol.Width := 50;
  strGrdIncomes.AddObject(fCol);

  fCol := TStringColumn.Create(strGrdIncomes);
  fCol.Header := 'Unit';
  fCol.Width := 75;
  strGrdIncomes.AddObject(fCol);

  fCol := TStringColumn.Create(strGrdIncomes);
  fCol.Header := 'Category';
  fCol.Width := 150;
  strGrdIncomes.AddObject(fCol);
end;

{ TODO : export option }
{ TODO : import option }
{ TODO : edit transaction }
{ TODO : remove transaction }

end.
