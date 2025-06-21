unit frmNew_u;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ComboEdit,
  objCategory_u, objTransaction_u,
  dmDB_u;

type
  TfrmNew = class(TForm)
    lblFormTitle: TLabel;
    btnAdd: TButton;
    inpTitle: TEdit;
    inpAmount: TEdit;
    slctFreqUnit: TComboEdit;
    inpFreqAmount: TEdit;
    slctCat: TComboEdit;
    lblTitle: TLabel;
    lblCat: TLabel;
    lblAmount: TLabel;
    lblFreq: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
  private
    { Private declarations }
    Cats: TCategories;
  public
    { Public declarations }
  end;

var
  frmNew: TfrmNew;

implementation

uses
  System.TypInfo;

{$R *.fmx}

procedure TfrmNew.btnAddClick(Sender: TObject);
var
  fTns: TTransaction;
begin
  fTns := TTransaction.CreateEmpty;

  fTns.Title := inpTitle.Text.Trim;
  if fTns.Title = EmptyStr then
  begin
    ShowMessage('Title is invalid');
    Exit;
  end;

  fTns.FreqQuantity := inpFreqAmount.Text.ToInteger;
  if fTns.FreqQuantity < 1 then
  begin
    ShowMessage('Frequency quantity is invalid');
    Exit;
  end;

  fTns.FreqUnit := TTransactionFreqUnit(slctFreqUnit.ItemIndex);

  if slctCat.ItemIndex = -1 then
  begin
    ShowMessage('Select a category');
    Exit;
  end;

  fTns.CatID := Cats[slctCat.ItemIndex].ID;

  try
    dmDB.CreateTransaction(fTns);

    Close;
  except on e : Exception do
    ShowMessage('Failed to create transaction');
  end;
end;

procedure TfrmNew.FormCreate(Sender: TObject);
begin
  Cats := dmDB.GetCategories;

  for var i := 0 to High(Cats) do
  begin
    slctCat.Items.Add(Cats[i].Title);
  end;
end;

end.
