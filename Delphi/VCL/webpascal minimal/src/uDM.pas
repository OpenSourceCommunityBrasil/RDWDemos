unit uDM;

interface

uses
  System.SysUtils, System.Classes,
  uRESTDWComponentBase, uRESTDWServerContext, uRESTDWParams, uRESTDWConsts,
  uRESTDWDataModule;

type
  TDM = class(TServerMethodDataModule)
    RESTDWServerContext1: TRESTDWServerContext;
    procedure index
      (const Params: TRESTDWParams; var ContentType: string;
      const Result: TMemoryStream; const RequestType: TRequestType;
      var StatusCode: Integer);
    procedure produto
      (const Params: TRESTDWParams; var ContentType: string;
      const Result: TMemoryStream; const RequestType: TRequestType;
      var StatusCode: Integer);
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

end.
