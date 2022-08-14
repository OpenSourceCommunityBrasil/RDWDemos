program RESTDWCGIService;

{$APPTYPE CONSOLE}

uses
  WebBroker,
  CGIApp,
  uCGIWebModule in 'uCGIWebModule.pas' {CGIWebModule: TWebModule},
  uRDWDataModule in 'uRDWDataModule.pas' {RDWDataModule: TServerMethodDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.WebModuleClass := TCGIWebModule;
//  Application.WebModuleClass              := Nil;
  Application.CreateForm(TCGIWebModule, CGIWebModule);
  Application.Run;
end.
