unit frmEdit_u;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls,
  fmeEditTransaction_u,
  objTransaction_u,
  dmDB_u;

type
  TfrmEdit = class(TForm)
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
  frmEdit: TfrmEdit;

implementation

{$R *.fmx}

procedure TfrmEdit.AfterSubmitFn(const aTns: TTransaction);
begin
  try
    dmDB.UpdateTransaction(aTns);
    Close;
  except
    on e: Exception do
      ShowMessage(e.Message);
  end;
end;

procedure TfrmEdit.FormCreate(Sender: TObject);
begin
  fmeEditTransaction.SetSubmitButtonText('Save');
  fmeEditTransaction.SetAfterSubmitFn(AfterSubmitFn);
  fmeEditTransaction.FetchCategories;
end;

end.
