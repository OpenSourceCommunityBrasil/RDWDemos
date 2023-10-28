library RestDWServerISAPI;

uses
  Winapi.ActiveX,
  System.Win.ComObj,
  Web.WebBroker,
  Web.Win.ISAPIApp,
  Web.Win.ISAPIThreadPool,
  uRDWDataModule in '..\uRDWDataModule.pas' {RDWDataModule: TServerMethodDataModule},
  uCGIWebModule in '..\uCGIWebModule.pas' {CGIWebModule: TWebModule},
  uConsts in '..\uConsts.pas';

{$R *.res}

exports
  GetExtensionVersion,
  HttpExtensionProc,
  TerminateExtension;

procedure TerminateThreads;
begin
end;

begin
  CoInitFlags                             := COINIT_MULTITHREADED;
  Application.Initialize;
  Application.WebModuleClass              := Nil;
  TISAPIApplication(Application).OnTerminate := TerminateThreads;
  Application.CreateForm(TCGIWebModule, CGIWebModule);
  Application.Run;
end.
