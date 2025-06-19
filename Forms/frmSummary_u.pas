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
  fFrm.Show;
end;

procedure TfrmSummary.btnNewClick(Sender: TObject);
var
  fFrm: TfrmNew;
begin
  fFrm := TfrmNew.Create(Self);
  fFrm.Show;
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
  if not Assigned(dmDB) then
    dmDB := TdmDB.Create(Self);

  dmDB.qryDB.SQL.Text := 'SELECT Title FROM TransactionsPlus ' +
    'WHERE Type = :Type';
  dmDB.qryDB.ParamByName('Type').AsString := 'OUT';
  dmDB.qryDB.Open;

  strGrdExpenses.BeginUpdate;

  try
    strGrdExpenses.ClearColumns;

    fTitleCol := TStringColumn.Create(strGrdExpenses);
    fTitleCol.Header := 'Title';
    fTitleCol.Width := 200;
    strGrdExpenses.AddObject(fTitleCol);

    strGrdExpenses.RowCount := dmDB.qryDB.RecordCount;

    Row := 1;
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

end.
