program ExemploServerCrossCompiler;

{$I ..\..\Source\Includes\uRESTDW.inc}

{$IFDEF RESTDWFPC}
 {$MODE OBJFPC}{$H+}
{$ELSE}
 {$APPTYPE CONSOLE}
{$ENDIF}

uses
  Classes,
  SysUtils,
  {$IFDEF FPC}
  uRESTDWFphttpBase,
  {$ENDIF }
  uRESTDWServerMethodClass,
  uRESTDWServerContext,
  uRESTDWServerEvents,
  uRESTDWParams,
  uRESTDWConsts,
  uRESTDWAuthenticators,
  uRESTDWIdBase,
  uRESTDWBasicDB,
  uRESTDWZeosDriver,
  ZConnection,
  ZDataset;

Type
 TServerClass   = Class(TServerBaseMethodClass)
 Public
  ZConnection         : TZConnection;
  ZQuery              : TZQuery;
  RESTDWServerContext : TRESTDWServerContext;
  RESTDWServerEvents  : TRESTDWServerEvents;
  RESTDWPoolerZeos    : TRESTDWPoolerDB;
  RESTDWZeosDriver    : TRESTDWZeosDriver;
  Procedure helloworld(Var Params           : TRESTDWParams;
                       Const Result         : TStringList;
                       Const RequestType    : TRequestType;
                       Var StatusCode       : Integer;
                       RequestHeader        : TStringList);
  Procedure Employee  (Var Params           : TRESTDWParams;
                       Const Result         : TStringList;
                       Const RequestType    : TRequestType;
                       Var StatusCode       : Integer;
                       RequestHeader        : TStringList);
  Procedure Index     (Const Params         : TRESTDWParams;
                       Var   ContentType    : String;
                       Const Result         : TStringList;
                       Const RequestType    : TRequestType);
  Constructor Create  (Sender               : TComponent);Override;
  Destructor  Destroy;Override;
 Published
End;

Var
 {$IFDEF FPC}
 ServicePoolerFpHTTP : TRESTDWFphttpServicePooler;
 {$ENDIF}
 ServicePoolerIndy   : TRESTDWIdServicePooler;
 AuthBasic           : TRESTDWAuthBasic;

Procedure TServerClass.Index(Const Params         : TRESTDWParams;
                             Var   ContentType    : String;
                             Const Result         : TStringList;
                             Const RequestType    : TRequestType);
Begin
 ContentType := 'text/html';
 Result.Text := '<!DOCTYPE html>' +
                '<html>' +
                '    <head>' +
                '        <title>REST Dataware FPC/vsCODE</title>' +
                '    </head>' +
                '    <body>' +
                '        <h1>Hello, world!</h1>' +
                '        <p>Esta e uma REST Dataware WebPascal web page.</p>' +
                '        <p>Contendo ' +
                '             <strong>Pagina principal</strong> e <em> paragrafo </em>.' +
                '        </p>' +
                '    </body>' +
                '</html>';
End;

procedure TServerClass.Employee(Var Params        : TRESTDWParams;
                                Const Result      : TStringList;
                                Const RequestType : TRequestType;
                                Var StatusCode    : Integer;
                                RequestHeader     : TStringList);
Var
 JSONValue: TRESTDWJSONValue;
begin
  Case RequestType Of
   rtGet  : Begin
             zQuery.Close;
             zQuery.SQL.Clear;
             zQuery.SQL.Add('select EMP_NO, FIRST_NAME, LAST_NAME from employee');
             JSONValue := TRESTDWJSONValue.Create;
             Try
              JSONValue.DataMode := dmRAW;
              JSONValue.Encoding := esANSI;
              JSONValue.Utf8SpecialChars := True;
             Finally
              JSONValue.LoadFromDataset('', zQuery, False, Params.DataMode, 'dd/mm/yyyy hh:mm:ss', '.');
              Result.Text := JSONValue.ToJson;
              JSONValue.Free;
            End;
           End;
   rtPost : Begin
             Result.Text := 'Respondendo POST';
            End;
  End;
end;


procedure TServerClass.helloworld(Var Params        : TRESTDWParams;
                                  Const Result      : TStringList;
                                  Const RequestType : TRequestType;
                                  Var StatusCode    : Integer;
                                  RequestHeader     : TStringList);
begin
 Result.Text := 'Hello World...';
end;

 Constructor TServerClass.Create(Sender : TComponent);
 Var
  Event   : TRESTDWEvent;
  Context : TRESTDWContext;
 Begin
  Inherited Create(Sender);
  RESTDWServerContext                   := TRESTDWServerContext.Create(Self);
  RESTDWServerContext.Name              := 'ServerContext';
  RESTDWServerEvents                    := TRESTDWServerEvents.Create(Self);
  RESTDWServerEvents.Name               := 'ServerEvents';
  Event                                 := RESTDWServerEvents.Events.AddEvent        ('helloworld', '/api/fpc/',  {$IFDEF FPC}TDWReplyEventByType(@helloworld){$ELSE}helloworld{$ENDIF});
  Event.Routes.Get.Active               := True;
  Event.Routes.Get.NeedAuthorization    := True;
  Event                                 := RESTDWServerEvents.Events.AddEvent        ('employee',   '/api/fpc/',  {$IFDEF FPC}TDWReplyEventByType(@Employee){$ELSE}Employee{$ENDIF});
  Event.Routes.Get.Active               := True;
  Event.Routes.Get.NeedAuthorization    := True;
  Context                               := RESTDWServerContext.ContextList.AddContext('index',      '/html/fpc/', {$IFDEF FPC}TRESTDWReplyRequest(@Index){$ELSE}Index{$ENDIF});
  Context.Routes.Get.Active             := True;
  Context.Routes.Get.NeedAuthorization  := False;
  Context.Routes.Post.Active            := True;
  Context.Routes.Post.NeedAuthorization := True;
  ZConnection                           := TZConnection.Create(Self);
  ZQuery                                := TZQuery.Create(Self);
  ZQuery.Connection                     := ZConnection;
  ZConnection.Database                  := 'C:\Meus Dados\Projetos\SUGV\Componentes\XyberPower\REST_Controls\CORE\Demos\EMPLOYEE.FDB';
  ZConnection.Protocol                  := 'firebird';
  ZConnection.Port                      := 3050;
  ZConnection.Hostname                  := '127.0.0.1';
  ZConnection.User                      := 'SYSDBA';
  ZConnection.Password                  := 'masterkey';
  ZConnection.Connected                 := True;
  RESTDWPoolerZeos                      := TRESTDWPoolerDB.Create(Self);
  RESTDWPoolerZeos.Name                 := 'FPC_ZeosPooler';
  RESTDWZeosDriver                      := TRESTDWZeosDriver.Create(Self);
  RESTDWPoolerZeos.RESTDriver           := RESTDWZeosDriver;
  RESTDWZeosDriver.Connection           := ZConnection;
  RESTDWZeosDriver.DatabaseCharSet      := csWin1252;
  RESTDWPoolerZeos.Active               := True;
End;

 Destructor  TServerClass.Destroy;
 Begin
  RESTDWServerContext.Free;
  RESTDWServerEvents.Free;
  ZConnection.Connected    := False;
  ZQuery.Free;
  ZConnection.Free;
  RESTDWPoolerZeos.Free;
  RESTDWZeosDriver.Free;
  Inherited;
 End;
begin 
 {$IFDEF FPC}
 ServicePoolerFpHTTP := TRESTDWFphttpServicePooler.Create(Nil);
 {$ENDIF}
 ServicePoolerIndy   := TRESTDWIdServicePooler.Create(Nil);
 AuthBasic           := TRESTDWAuthBasic.Create(Nil);
 AuthBasic.Username  := 'fpc';
 AuthBasic.Password  := 'restdw';
 Try
  {$IFDEF FPC}
   ServicePoolerFpHttp.ServerMethodClass := TServerClass;
   ServicePoolerFpHttp.ServicePort       := 8082;
   ServicePoolerFpHttp.Authenticator     := AuthBasic;
   ServicePoolerFpHttp.Active            := True;
  {$ENDIF}
  ServicePoolerIndy.ServerMethodClass   := TServerClass;
  {$IFDEF FPC}
   ServicePoolerIndy.ServicePort        := 8083;
  {$ELSE}
   ServicePoolerIndy.ServicePort        := 8082;
  {$ENDIF}
  ServicePoolerIndy.Authenticator       := AuthBasic;
  ServicePoolerIndy.Active              := True;
 Finally
  WriteLn('Server Online...');
  ReadLn;
  {$IFDEF FPC}
   ServicePoolerFpHttp.Active            := False;
   ServicePoolerFpHttp.Free;
  {$ENDIF}
  ServicePoolerIndy.Active              := False;
  ServicePoolerIndy.Free;
 End;
end.
