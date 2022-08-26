program FileServer;

{$MODE Delphi}

uses
  {$IFDEF UNIX}
  cthreads, cmem,
  {$ENDIF}
  Forms, Interfaces,
  uPrincipal in 'uPrincipal.pas' {fServer},
  uDMFileServer in 'uDMFileServer.pas' {dmFileServer: TDataModule};

{.$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfServer, fServer);
  Application.Run;

end.
