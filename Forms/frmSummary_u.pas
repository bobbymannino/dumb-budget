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
    procedure SetupExpenses;
    procedure SetupExpensesHeaders;
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
end;

procedure TfrmSummary.btnNewClick(Sender: TObject);
var
  fFrm: TfrmNew;
begin
  fFrm := TfrmNew.Create(Self);
  fFrm.ShowModal;
end;

procedure TfrmSummary.FormCreate(Sender: TObject);
begin
  Tns := dmDB.GetTransactions;

  SetupExpenses;
end;

procedure TfrmSummary.SetupExpenses;
var
  Epns: TTransactionsPlus;
begin
  for var i := 0 to High(Tns) do
  begin
    if Tns[i].CatType = TCategoryType.Income then
      Epns[High(Epns)] := Tns[i];
  end;

  strGrdExpenses.BeginUpdate;
  try
    strGrdExpenses.ClearColumns;
    strGrdExpenses.RowCount := 0;

    if strGrdExpenses.ColumnCount = 0 then
      SetupExpensesHeaders;

    strGrdExpenses.RowCount := Length(Epns);

    for var i := 0 to High(Epns) do
    begin
      strGrdExpenses.Cells[0, i] := dmDB.qryDB.FieldByName('Title').AsString;
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
  fCol.Width := 200;
  strGrdExpenses.AddObject(fCol);

  { TODO : Add other headers }
end;

{ TODO : export option }
{ TODO : import option }

end.
