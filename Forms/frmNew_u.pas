unit frmNew_u;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ComboEdit,
  fmeEditTransaction_u,
  objTransaction_u,
  dmDB_u;

type
  TfrmNew = class(TForm)
    lblFormTitle: TLabel;
    fmeEditTransaction: TfmeEditTransaction;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure AfterSubmitFn(const aTns: TTransaction);
  public
    { Public declarations }
  end;

var
  frmNew: TfrmNew;

implementation

uses
  System.TypInfo;

{$R *.fmx}

procedure TfrmNew.AfterSubmitFn(const aTns: TTransaction);
begin
  try
    dmDB.CreateTransaction(aTns);
    fmeEditTransaction.ClearInputs;
  except
    on e: Exception do
      ShowMessage(e.Message);
  end;
end;

procedure TfrmNew.FormCreate(Sender: TObject);
begin
  fmeEditTransaction.SetSubmitButtonText('Add');
  fmeEditTransaction.SetAfterSubmitFn(AfterSubmitFn);
  fmeEditTransaction.FetchCategories;
end;

end.
