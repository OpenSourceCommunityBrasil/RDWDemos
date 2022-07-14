program RestDWServerProject;

uses
  Vcl.Forms,
  RestDWServerFormU in 'RestDWServerFormU.pas' {RestDWForm},
  uDmService in 'uDmService.pas' {ServerMethodDM: TServerMethodDataModule},
  uDmService2 in 'uDmService2.pas' {ServerMethodDM2: TServerMethodDataModule},
  uSock in 'uSock.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TRestDWForm, RestDWForm);
  Application.Run;
end.
