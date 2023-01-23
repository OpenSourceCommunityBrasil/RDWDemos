program WebPascalFullServer;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  uPrincipal in 'src\uPrincipal.pas' {fPrincipal},
  uDMWebPascal in 'src\uDMWebPascal.pas' {DMWebPascal: TDataModule},
  uSock in 'src\uSock.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfPrincipal, fPrincipal);
  Application.Run;
end.
