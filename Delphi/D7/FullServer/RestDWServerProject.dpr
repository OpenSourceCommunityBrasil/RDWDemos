program RestDWServerProject;

uses
  Forms,
  RestDWServerFormU in 'RestDWServerFormU.pas' {RestDWForm},
  uDmService in 'uDmService.pas' {ServerMethodDM: TServerMethodDataModule},
  uSock in 'uSock.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TRestDWForm, RestDWForm);
  Application.CreateForm(TServerMethodDM, ServerMethodDM);
  Application.Run;
end.
