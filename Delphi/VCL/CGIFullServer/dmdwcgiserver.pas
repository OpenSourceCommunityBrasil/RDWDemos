unit dmdwcgiserver;

// Criação de Exemplo usando CGI para Apache Server feito por "Gilberto Rocha da Silva",
//para uso do Componente TRESTServiceCGI

interface

uses
  SysUtils, Classes, HTTPApp, WSDLPub, SOAPPasInv, SOAPHTTPPasInv,
  SOAPHTTPDisp, WebBrokerSOAP, Soap.InvokeRegistry, Soap.WSDLIntf,
  System.TypInfo, Soap.WebServExp, Soap.WSDLBind, Xml.XMLSchema,
  uDmService, uRESTDWAbout, uRESTDWBasic,
  uRESTDWShellServices;

type
  TdwCGIService = class(TWebModule)
    RESTDWShellService1: TRESTDWShellService;
    procedure dwCGIServiceDefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dwCGIService: TdwCGIService;

implementation

uses WebReq;

{$R *.dfm}


procedure TdwCGIService.dwCGIServiceDefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
 If RESTDWShellService1 <> Nil Then
  RESTDWShellService1.Command(Request, Response, Handled);
end;

procedure TdwCGIService.WebModuleCreate(Sender: TObject);
begin
 RESTDWShellService1.RootPath := '.\';
 RESTDWShellService1.ServerMethodClass := TServerMethodDM;
end;

initialization
  WebRequestHandler.WebModuleClass := TdwCGIService;

end.
