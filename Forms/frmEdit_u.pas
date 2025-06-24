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
    btnDelete: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
    fTns: TTransaction;
    procedure AfterSubmitFn(const aTns: TTransaction);
    procedure SetTns(const aTns: TTransaction);
  public
    property Tns: TTransaction read fTns write SetTns;
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

procedure TfrmEdit.btnDeleteClick(Sender: TObject);
begin
  if not Assigned(Tns) then
  begin
    ShowMessage('No ID has been set');
    Exit;
  end;

  if MessageDlg('Are you sure you want to delete this transaction?',
    TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOk, TMsgDlgBtn.mbCancel], 0) = mrOk
  then
  begin
    try
       dmDB.DeleteTransaction(Tns.ID);

       Close;
    except
      on e: Exception do
        ShowMessage('Failed to delete transaction');
    end;
  end;

end;

procedure TfrmEdit.FormCreate(Sender: TObject);
begin
  fmeEditTransaction.SetSubmitButtonText('Save');
  fmeEditTransaction.SetAfterSubmitFn(AfterSubmitFn);
  fmeEditTransaction.FetchCategories;
end;

procedure TfrmEdit.SetTns(const aTns: TTransaction);
begin
  fTns := aTns;

  fmeEditTransaction.Populate(fTns);
end;

end.
