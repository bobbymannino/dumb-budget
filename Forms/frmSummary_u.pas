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
  SetupExpenses;
end;

procedure TfrmSummary.SetupExpenses;
var
  Row: Integer;
  fTitleCol: TStringColumn;
begin
  dmDB.qryDB.SQL.Text := 'SELECT Title FROM TransactionsPlus WHERE Type = :Type ORDER BY Title';
  dmDB.qryDB.ParamByName('Type').AsString := 'OUT';
  dmDB.qryDB.Open;

  strGrdExpenses.BeginUpdate;
  try
    strGrdExpenses.ClearColumns;
    strGrdExpenses.RowCount := 0;

    if strGrdExpenses.ColumnCount = 0 then
      SetupExpensesHeaders;

    strGrdExpenses.RowCount := dmDB.qryDB.RecordCount;

    Row := 0;
    dmDB.qryDB.First;

    while not dmDB.qryDB.Eof do
    begin
      strGrdExpenses.Cells[0, Row] := dmDB.qryDB.FieldByName('Title').AsString;

      Inc(Row);
      dmDB.qryDB.Next;
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
end;

end.
