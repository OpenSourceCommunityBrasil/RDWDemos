unit dmdwcgiserver;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, uRESTDWBase, httpdefs, fpHTTP, fpWeb, ServerUtils;

type

  { TdwCGIService }

  TdwCGIService = class(TFPWebModule)
    RESTServiceCGI01: TRESTServiceCGI;
    constructor CreateNew(AOwner: TComponent; CreateMode: Integer); override;
    procedure DataModuleCreate(Sender: TObject);
  private
   procedure Request(Sender: TObject; ARequest: TRequest;
                     AResponse: TResponse; var Handled: Boolean);
  public

  end;

var
  dwCGIService: TdwCGIService;

implementation

{$R *.lfm}

uses uDmService;

procedure TdwCGIService.Request(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
begin
 If RESTServiceCGI01 <> Nil Then
  RESTServiceCGI01.Command(ARequest, AResponse, Handled);
end;

constructor TdwCGIService.CreateNew(AOwner: TComponent; CreateMode: Integer);
begin
  inherited CreateNew(AOwner, CreateMode);
  onRequest := @Request;
end;

procedure TdwCGIService.DataModuleCreate(Sender: TObject);
begin
 RESTServiceCGI01.RootPath          := '.\';
 RESTServiceCGI01.ServerMethodClass := TServerMethodDM;
 RESTServiceCGI01.ServerContext     := '';

 //RESTServiceCGI01.AuthenticationOptions.AuthorizationOption := rdwAOBasic;
 //TRDWAuthOptionBasic(RESTServiceCGI01.AuthenticationOptions.OptionParams).Username := 'teste';
 //TRDWAuthOptionBasic(RESTServiceCGI01.AuthenticationOptions.OptionParams).Password := 'teste';
end;


initialization
  RegisterHTTPModule('', TdwCGIService);
end.

