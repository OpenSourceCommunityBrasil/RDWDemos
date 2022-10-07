unit udm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, uRESTDWDataModule, uRESTDWServerEvents, uRESTDWParams,
  uRESTDWServerContext, uRESTDWConsts;

type

  { TDM }

  TDM = class(TServerMethodDataModule)
    RESTDWServerContext1: TRESTDWServerContext;
    RESTDWServerEvents1: TRESTDWServerEvents;
    procedure relatorio(
      const Params: TRESTDWParams; var ContentType: String;
      const Result: TMemoryStream; const RequestType: TRequestType;
      var StatusCode: Integer);
    procedure RESTDWServerEvents1EventstestebodyReplyEventByType(
      var Params: TRESTDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: integer;
      RequestHeader: TStringList);
    procedure RESTDWServerEvents1EventstesteReplyEventByType(
      var Params: TRESTDWParams; var Result: string; const RequestType: TRequestType;
      var StatusCode: integer; RequestHeader: TStringList);
  private

  public

  end;

var
  DM: TDM;

implementation

{$R *.lfm}

{ TDM }

procedure TDM.RESTDWServerEvents1EventstesteReplyEventByType(
  var Params: TRESTDWParams; var Result: string; const RequestType: TRequestType;
  var StatusCode: integer; RequestHeader: TStringList);
begin
  case RequestType of
    rtGet: begin
      StatusCode := 200;
      Result := 'GET OK';
    end;
    rtPost: begin
      StatusCode := 201;
      Result := 'POST OK';
    end;
    rtPut: begin
      StatusCode := 201;
      Result := 'PUT OK';
    end;
    rtPatch: begin
      StatusCode := 201;
      Result := 'PATCH OK';
    end;
    rtDelete: begin
      StatusCode := 200;
      Result := 'DELETE OK';
    end;
  end;
end;

procedure TDM.RESTDWServerEvents1EventstestebodyReplyEventByType(
  var Params: TRESTDWParams; var Result: string; const RequestType: TRequestType;
  var StatusCode: integer; RequestHeader: TStringList);
begin
  if RequestType = rtPost then
    Result := 'Body content: ' + Params.RawBody.AsString;
end;

procedure TDM.relatorio(
  const Params: TRESTDWParams; var ContentType: String;
  const Result: TMemoryStream; const RequestType: TRequestType;
  var StatusCode: Integer);
begin
  ContentType := GetMIMEType('.\relatorio.pdf');
  Result.LoadFromFile('.\relatorio.pdf');
end;

end.
