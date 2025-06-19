unit frmNew_u;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ComboEdit;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNew: TfrmNew;

implementation

{$R *.fmx}

end.
