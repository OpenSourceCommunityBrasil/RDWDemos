program RESTDWFullServer;

uses
  Vcl.Forms,
  uPrincipal in 'src\uPrincipal.pas' {fPrincipal},
  uDMPrincipal in 'src\uDMPrincipal.pas' {DMPrincipal: TServerMethodDataModule},
  uDMSecundario in 'src\uDMSecundario.pas' {DMSecundario: TServerMethodDataModule},
  uSock in 'src\uSock.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfPrincipal, fPrincipal);
  Application.Run;
end.
