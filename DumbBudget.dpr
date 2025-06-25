program DumbBudget;

uses
  System.StartUpCopy,
  FMX.Forms,
  frmSummary_u in 'Forms\frmSummary_u.pas' {frmSummary},
  dmDB_u in 'DataModules\dmDB_u.pas' {dmDB: TDataModule},
  frmNew_u in 'Forms\frmNew_u.pas' {frmNew},
  frmCategories_u in 'Forms\frmCategories_u.pas' {frmCategories},
  objCategory_u in 'Objects\objCategory_u.pas',
  objTransaction_u in 'Objects\objTransaction_u.pas',
  fmeEditTransaction_u in 'Frames\fmeEditTransaction_u.pas' {fmeEditTransaction: TFrame},
  frmEdit_u in 'Forms\frmEdit_u.pas' {frmEdit},
  frmSettings_u in 'Forms\frmSettings_u.pas' {frmSettings};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmDB, dmDB);
  Application.CreateForm(TfrmSummary, frmSummary);
  Application.CreateForm(TfrmNew, frmNew);
  Application.CreateForm(TfrmCategories, frmCategories);
  Application.CreateForm(TfrmEdit, frmEdit);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.Run;
end.
