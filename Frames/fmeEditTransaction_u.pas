unit fmeEditTransaction_u;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ComboEdit, FMX.Controls.Presentation, FMX.Edit,
  dmDB_u,
  objTransaction_u, objCategory_u;

type
  TAfterSubmitFn = procedure(const aTns: TTransaction) of object;

  TfmeEditTransaction = class(TFrame)
    inpTitle: TEdit;
    btnSubmit: TButton;
    inpAmount: TEdit;
    slctFreqUnit: TComboEdit;
    inpFreqAmount: TEdit;
    slctCat: TComboEdit;
    lblTitle: TLabel;
    lblCat: TLabel;
    lblAmount: TLabel;
    lblFreq: TLabel;
    procedure btnSubmitClick(Sender: TObject);
  private
    { Private declarations }
    Cats: TCategories;
    AfterSubmitFn: TAfterSubmitFn;
    TnsID: Integer;
  public
    { Public declarations }
    procedure Populate(const aTns: TTransaction);
    procedure SetSubmitButtonText(const aTxt: string);
    procedure SetAfterSubmitFn(const aAfterSubmitFn: TAfterSubmitFn);
    procedure ClearInputs;
    procedure FetchCategories;
  end;

implementation

{$R *.fmx}
{ TfmeEditTransaction }

procedure TfmeEditTransaction.btnSubmitClick(Sender: TObject);
var
  fTns: TTransaction;
begin
  fTns := TTransaction.CreateEmpty;
  fTns.ID := TnsID;

  fTns.Title := inpTitle.Text.Trim;
  if fTns.Title = EmptyStr then
    raise Exception.Create('Title is invalid');

  fTns.FreqQuantity := inpFreqAmount.Text.ToInteger;
  if fTns.FreqQuantity < 1 then
    raise Exception.Create('Frequency quantity is invalid');

  fTns.Amount := inpAmount.Text.ToDouble;
  if fTns.Amount < 0 then
    raise Exception.Create('Amount is invalid');

  fTns.FreqUnit := TTransactionFreqUnit(slctFreqUnit.ItemIndex);

  if slctCat.ItemIndex = -1 then
    raise Exception.Create('Select a category');

  fTns.CatID := Cats[slctCat.ItemIndex].ID;

  if Assigned(AfterSubmitFn) then
    AfterSubmitFn(fTns);
end;

procedure TfmeEditTransaction.ClearInputs;
begin
  inpTitle.Text := '';
  inpAmount.Text := '';
  inpFreqAmount.Text := '';
end;

procedure TfmeEditTransaction.FetchCategories;
begin
  Cats := dmDB.GetCategories;

  for var i := 0 to High(Cats) do
  begin
    slctCat.Items.Add(Cats[i].Title);
  end;
end;

procedure TfmeEditTransaction.Populate(const aTns: TTransaction);
begin
  inpTitle.Text := aTns.Title;
  inpAmount.Text := aTns.Amount.ToString;
  inpFreqAmount.Text := aTns.FreqQuantity.ToString;

  for var i := 0 to Length(Cats) do
  begin
    if Cats[i].ID = aTns.CatID then
    begin
      slctCat.ItemIndex := i;
      Break;
    end;
  end;

  slctFreqUnit.ItemIndex := Ord(aTns.FreqUnit);

  TnsID := aTns.ID;
end;

procedure TfmeEditTransaction.SetAfterSubmitFn(const aAfterSubmitFn
  : TAfterSubmitFn);
begin
  AfterSubmitFn := aAfterSubmitFn;
end;

procedure TfmeEditTransaction.SetSubmitButtonText(const aTxt: string);
begin
  btnSubmit.Text := aTxt;
end;

end.
