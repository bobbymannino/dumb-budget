unit frmCategories_u;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Rtti, FMX.Grid.Style,
  FMX.ScrollBox, FMX.Grid, FMX.Bind.Grid, FMX.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  FMX.Edit, FMX.ListBox,
  objCategory_u,
  dmDB_u;

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
  fCol: TStringColumn;
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
  fCats: TCategories;
begin
  if not Assigned(dmDB) then
    dmDB := TdmDB.Create(nil);

  fCats := dmDB.GetCategories;

  strGrdCats.BeginUpdate;
  try
    strGrdCats.ClearColumns;
    strGrdCats.RowCount := 0;

    if Length(fCats) > 0 then
    begin
      if strGrdCats.ColumnCount = 0 then
        SetUpGrid;

      strGrdCats.RowCount := Length(fCats);

      for Row := 0 to High(fCats) do
      begin
        if fCats[Row].CatType = TCategoryType.Income then
          strGrdCats.Cells[0, Row] := 'INCOME'
        else
          strGrdCats.Cells[0, Row] := 'EXPENSE';

        strGrdCats.Cells[1, Row] := fCats[Row].Title;
      end;
    end;
  finally
    strGrdCats.EndUpdate;
  end;
end;

end.
