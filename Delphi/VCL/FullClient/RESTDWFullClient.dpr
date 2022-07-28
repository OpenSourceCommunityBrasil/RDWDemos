program RESTDWFullClient;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {fPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfPrincipal, fPrincipal);
  Application.Run;
end.
