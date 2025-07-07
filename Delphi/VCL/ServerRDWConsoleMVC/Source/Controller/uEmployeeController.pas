unit uEmployeeController;

//{$MODE OBJFPC}{$H+}
{$APPTYPE CONSOLE}

interface

uses
  Classes, SysUtils, uRESTDWParams, uRESTDWConsts, uni, RscJSON;

type
  TEmployeeController = class
  public
    class var Conn: TUniConnection;
    class procedure HelloWorld(var Params: TRESTDWParams; const Result: TStringList; const RequestType: TRequestType; var StatusCode: Integer; RequestHeader: TStringList);
    class procedure GetAll(var Params: TRESTDWParams; const Result: TStringList; const RequestType: TRequestType; var StatusCode: Integer; RequestHeader: TStringList);
    class procedure Index(const Params: TRESTDWParams; var ContentType: string; const Result: TStringList; const RequestType: TRequestType);
  end;

implementation

class procedure TEmployeeController.HelloWorld(var Params: TRESTDWParams; const Result: TStringList; const RequestType: TRequestType; var StatusCode: Integer; RequestHeader: TStringList);
begin
  if Params.ItemsString['temp'] <> nil then
  begin
    if Params.ItemsString['temp'].AsString <> '' then
      Result.Text := 'Hello World REST Dataware...' + sLineBreak + Format('Param %s = %s', ['temp', Params.ItemsString['temp'].AsString])
    else
      Result.Text := 'Hello World REST Dataware...' + sLineBreak + Format('Params em URI Param 0 = %d, Param 1 = %d',
        [Params.ItemsString['temp1'].AsInteger, Params.ItemsString['temp2'].AsInteger]);
  end
  else
    Result.Text := 'Hello World REST Dataware...';
end;

class procedure TEmployeeController.GetAll(var Params: TRESTDWParams; const Result: TStringList; const RequestType: TRequestType; var StatusCode: Integer; RequestHeader: TStringList);
var
  Query: TUniQuery;
  JSON: TRscJsonObject;
begin
  Query := TUniQuery.Create(nil);
  JSON := TRscJsonObject.Create;
  try
//    Query.Connection := Conn;
//    Query.SQL.Text := 'SELECT EMP_NO, FIRST_NAME, LAST_NAME FROM employee';
//    Query.Open;

    JSON.AddPair('teste', '123');

//    JSON.DataMode := dmRAW;
//    JSON.Encoding := esANSI;
//    JSON.Utf8SpecialChars := True;
//    JSON.LoadFromDataset('', Query, False, Params.DataMode, 'dd/mm/yyyy hh:mm:ss', '.');

    Result.Text := JSON.ToJson;
  finally
    Query.Free;
    JSON.Free;
  end;
end;

class procedure TEmployeeController.Index(const Params: TRESTDWParams; var ContentType: string; const Result: TStringList; const RequestType: TRequestType);
begin
  ContentType := 'text/html';
  Result.Text := '<!DOCTYPE html>' +
    '<html>' +
    '<head><title>REST Dataware</title></head>' +
    '<body><h1>Hello, world!</h1><p>API usando MVC com RestDataware.</p></body>' +
    '</html>';
end;

end.
