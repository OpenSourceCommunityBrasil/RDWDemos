program RESTDWFullServer;

uses
  {$IFDEF UNIX}
  cthreads, cmem,
  {$ENDIF}
  Forms, Interfaces,
  uprincipal in 'src\uprincipal.pas' {RestDWForm},
  udatamodule in 'src\udatamodule.pas' {DataModule1: TDataModule};

{.$R *.res}

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfPrincipal, fPrincipal);
  Application.Run;
end.
