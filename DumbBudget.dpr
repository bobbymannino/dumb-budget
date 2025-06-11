program DumbBudget;

uses
  System.StartUpCopy,
  FMX.Forms,
  frmSummary_u in 'Forms\frmSummary_u.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
