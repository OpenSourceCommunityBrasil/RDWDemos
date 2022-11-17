unit uDM;

interface

uses
  System.SysUtils, System.Classes,
  uRESTDWComponentBase, uRESTDWServerContext, uRESTDWParams, uRESTDWConsts,
  uRESTDWDataModule, uRESTDWServerEvents;

type
  TDM = class(TServerMethodDataModule)
    RESTDWServerContext1: TRESTDWServerContext;
    RESTDWServerEvents1: TRESTDWServerEvents;
    procedure index
      (const Params: TRESTDWParams; var ContentType: string;
      const Result: TMemoryStream; const RequestType: TRequestType;
      var StatusCode: Integer);
    procedure produto
      (const Params: TRESTDWParams; var ContentType: string;
      const Result: TMemoryStream; const RequestType: TRequestType;
      var StatusCode: Integer);
    procedure RESTDWServerEvents1EventsindexReplyEvent(
      var Params: TRESTDWParams; var Result: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  PATH = '..\..\src\html\';

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TDM.index
  (const Params: TRESTDWParams; var ContentType: string;
  const Result: TMemoryStream; const RequestType: TRequestType;
  var StatusCode: Integer);
begin
  Result.LoadFromFile(PATH + 'index.html');
end;

procedure TDM.produto
  (const Params: TRESTDWParams; var ContentType: string;
  const Result: TMemoryStream; const RequestType: TRequestType;
  var StatusCode: Integer);
begin
  Result.LoadFromFile(PATH + 'produto.html');
end;

procedure TDM.RESTDWServerEvents1EventsindexReplyEvent(
  var Params: TRESTDWParams; var Result: string);
begin
  Result := 'serverevents';
end;

end.
