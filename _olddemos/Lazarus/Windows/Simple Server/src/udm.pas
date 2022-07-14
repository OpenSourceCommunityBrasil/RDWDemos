unit udm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SysTypes, uDWJSONObject, uDWConsts, uDWConstsData,
  uDWDatamodule, uRESTDWServerEvents, uDWJSONTools,
  uDWConstsCharset, uRESTDWPoolerDB;

type

  { TDM }

  TDM = class(TServerMethodDataModule)
  DWServerEvents1: TDWServerEvents;
  procedure DWServerEvents1EventshelloReplyEvent(var Params: TDWParams; var
    Result: String);
Private

Public

end;

var
  DM: TDM;

implementation

{$R *.lfm}

{ TDM }

procedure TDM.DWServerEvents1EventshelloReplyEvent(var Params: TDWParams; var
  Result: String);
begin
  Result := 'hello';
end;

end.

