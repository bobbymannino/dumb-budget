unit frmNew_u;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ComboEdit,
  objCategory_u,
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
  private
    { Private declarations }
    Cats: TCategories;
  public
    { Public declarations }
  end;

var
  frmNew: TfrmNew;

implementation

{$R *.fmx}

procedure TfrmNew.FormCreate(Sender: TObject);
begin
  Cats := dmDB.GetCategories;

  for var i := 0 to High(Cats) do
  begin
    slctCat.Items.Add(Cats[i].Title);
  end;
end;

end.
