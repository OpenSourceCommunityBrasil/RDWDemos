unit uDM;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, uRESTDWDatamodule, uRESTDWServerEvents, uRESTDWParams, uRESTDWConsts;

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

procedure TDM.RESTDWServerEvents1EventstesteReplyEventByType(var Params: TRESTDWParams;
  var Result: String; const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
begin
  case RequestType of
  rtGet: Result := 'GET OK';
  rtPost: Result := 'POST OK';
  rtPut: Result := 'PUT OK';
  rtPatch: Result := 'PATCH OK';
  rtDelete: Result := 'DELETE OK';
  end;
end;

end.

