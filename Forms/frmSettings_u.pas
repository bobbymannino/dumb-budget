unit frmSettings_u;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls,
{$IFDEF MSWINDOWS}
  Winapi.ShellAPI, Winapi.Windows,
{$ENDIF MSWINDOWS}
{$IFDEF POSIX}
  Posix.Stdlib,
{$ENDIF POSIX}
  dmDB_u;

type
  TfrmSettings = class(TForm)
    lblFormTitle: TLabel;
    btnExport: TButton;
    btnBackup: TButton;
    lblBobman: TLabel;
    procedure btnBackupClick(Sender: TObject);
    procedure lblBobmanClick(Sender: TObject);
    procedure lblBobmanMouseEnter(Sender: TObject);
    procedure lblBobmanMouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.fmx}

procedure TfrmSettings.btnBackupClick(Sender: TObject);
begin
  dmDB.Backup;
end;

procedure TfrmSettings.lblBobmanClick(Sender: TObject);
var
  fURL: string;
begin
  fURL := 'https://bobman.dev';

{$IFDEF MSWINDOWS}
  ShellExecute(0, 'OPEN', PChar(fURL), '', '', SW_SHOWNORMAL);
{$ENDIF MSWINDOWS}
{$IFDEF POSIX}
  _system(PAnsiChar('open ' + AnsiString(fURL)));
{$ENDIF POSIX}
end;

procedure TfrmSettings.lblBobmanMouseEnter(Sender: TObject);
begin
  lblBobman.TextSettings.FontColor := TAlphaColors.Blue;

  ShowMessage('Entered');
end;

procedure TfrmSettings.lblBobmanMouseLeave(Sender: TObject);
begin
  lblBobman.TextSettings.FontColor := TAlphaColors.Black;
end;

end.
