program RESTDWWebPascal;

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Forms, Interfaces,
  uPrincipal in 'src/RestDWServerFormU.pas' {RestDWForm},
  udmwebpascal in 'src/udmwebpascal.pas' {DataModule1: TDataModule},
  uSock in 'src/uSock.pas';

{.$R *.res}

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TRestDWForm, RestDWForm);
  Application.Run;
end.
