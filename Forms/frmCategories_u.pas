unit frmCategories_u;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Rtti, FMX.Grid.Style,
  FMX.ScrollBox, FMX.Grid, FMX.Bind.Grid, FMX.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  dmDB_u, FMX.Edit, FMX.ListBox;

type
  TfrmCategories = class(TForm)
    lblFormTitle: TLabel;
    strGrdCats: TStringGrid;
    slctType: TComboBox;
    inpTitle: TEdit;
    lblTitle: TLabel;
    btnAdd: TButton;
    lblType: TLabel;
    btnClose: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateGrid;
    procedure SetUpGrid;
  public
    { Public declarations }
  end;

var
  frmCategories: TfrmCategories;

implementation

{$R *.fmx}

procedure TfrmCategories.btnAddClick(Sender: TObject);
var
  fIsIncome: Boolean;
  fTitle: string;
begin
  fTitle := inpTitle.Text.Trim;
  if fTitle = EmptyStr then
  begin
    ShowMessage('Title is invalid');
    inpTitle.SetFocus;
    Exit;
  end;

  fIsIncome := slctType.Items[slctType.ItemIndex] = 'Income';

  try
    dmDB.CreateCategory(fTitle, fIsIncome);

    inpTitle.Text := '';

    UpdateGrid;
  except
    on e: Exception do
      ShowMessage('Failed to create category');
  end;
end;

procedure TfrmCategories.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCategories.FormCreate(Sender: TObject);
begin
  UpdateGrid;
end;

procedure TfrmCategories.SetUpGrid;
var
  fCol : TStringColumn;
begin
  fCol := TStringColumn.Create(strGrdCats);
  fCol.Header := 'Type';
  fCol.Width := 100;
  strGrdCats.AddObject(fCol);

  fCol := TStringColumn.Create(strGrdCats);
  fCol.Header := 'Title';
  fCol.Width := 200;
  strGrdCats.AddObject(fCol);
end;

procedure TfrmCategories.UpdateGrid;
var
  Row: Integer;
begin
  if not Assigned(dmDB) then
    dmDB := TdmDB.Create(nil);

  dmDB.qryDB.SQL.Text :=
    'SELECT CategoryID, Title, Type FROM Categories ORDER BY Type, Title';
  dmDB.qryDB.Open;

  strGrdCats.BeginUpdate;
  try
    strGrdCats.ClearColumns;
    strGrdCats.RowCount := 0;

    if dmDB.qryDB.RecordCount > 0 then
    begin
      if strGrdCats.ColumnCount = 0 then
        SetUpGrid;

      strGrdCats.RowCount := dmDB.qryDB.RecordCount;
      Row := 0;

      dmDB.qryDB.First;
      while not dmDB.qryDB.Eof do
      begin
        if dmDB.qryDB.FieldByName('Type').AsString = 'IN' then
          strGrdCats.Cells[0, Row] := 'INCOME'
        else
          strGrdCats.Cells[0, Row] := 'EXPENSE';

        strGrdCats.Cells[1, Row] := dmDB.qryDB.FieldByName('Title').AsString;

        Inc(Row);
        dmDB.qryDB.Next;
      end;
    end;
  finally
    strGrdCats.EndUpdate;
  end;
end;

end.
