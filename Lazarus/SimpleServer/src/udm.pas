unit udm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, uRESTDWDataModule, uRESTDWServerEvents, uRESTDWParams, uRESTDWConsts;

type

  { TDM }

  TDM = class(TServerMethodDataModule)
    RESTDWServerEvents1: TRESTDWServerEvents;
    procedure RESTDWServerEvents1EventstesteReplyEventByType(var Params: TRESTDWParams;
      var Result: String; const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
  private

  public

  end;

var
  DM: TDM;

implementation

{$R *.lfm}

{ TDM }

procedure TDM.RESTDWServerEvents1EventstesteReplyEventByType(var
  Params: TRESTDWParams; var Result: String; const RequestType: TRequestType; var
  StatusCode: Integer; RequestHeader: TStringList);
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

end.

