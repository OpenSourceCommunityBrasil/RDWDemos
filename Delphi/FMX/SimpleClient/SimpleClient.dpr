program SimpleClient;

uses
  System.StartUpCopy,
  FMX.Forms,
  uPrincipal in 'src\uPrincipal.pas' {fPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfPrincipal, fPrincipal);
  Application.Run;
end.
