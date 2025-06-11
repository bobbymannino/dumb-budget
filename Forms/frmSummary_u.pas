unit frmSummary_u;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  dmDB_u, System.Rtti, FMX.Grid.Style, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Grid;

type
  TfrmSummary = class(TForm)
    grdTransactions: TGrid;
    lblTitle: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSummary: TfrmSummary;

implementation

{$R *.fmx}

end.
