program DumbBudget;

uses
  System.StartUpCopy,
  FMX.Forms,
  frmSummary_u in 'Forms\frmSummary_u.pas' {frmSummary},
  dmDB_u in 'DataModules\dmDB_u.pas' {dmDB: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmSummary, frmSummary);
  Application.CreateForm(TdmDB, dmDB);
  Application.Run;
end.
