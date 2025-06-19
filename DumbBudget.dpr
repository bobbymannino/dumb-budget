program DumbBudget;

uses
  System.StartUpCopy,
  FMX.Forms,
  frmSummary_u in 'Forms\frmSummary_u.pas' {frmSummary},
  dmDB_u in 'DataModules\dmDB_u.pas' {dmDB: TDataModule},
  frmNew_u in 'Forms\frmNew_u.pas' {frmNew};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmSummary, frmSummary);
  Application.CreateForm(TdmDB, dmDB);
  Application.CreateForm(TfrmNew, frmNew);
  Application.Run;
end.
