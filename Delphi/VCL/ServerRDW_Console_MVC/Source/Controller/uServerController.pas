unit uServerController;

//{$MODE OBJFPC}{$H+}
{$APPTYPE CONSOLE}

interface

uses
  Classes, SysUtils, uRESTDWServerMethodClass, uRESTDWServerContext, uRESTDWServerEvents,
  uRESTDWParams, uRESTDWConsts
  , Uni
  , Data.DB
  , UniProvider
  , OracleUniProvider

  , uEmployeeController;

type
  TServerController = class(TServerBaseMethodClass)
  private
    FContext: TRESTDWServerContext;
    FEvents: TRESTDWServerEvents;
    FConn: TUniConnection;
  public
    constructor Create(Sender: TComponent); override;
    destructor Destroy; override;
  published
  end;

implementation

constructor TServerController.Create(Sender: TComponent);
var
  Event: TRESTDWEvent;
  Context: TRESTDWContext;
begin
  inherited Create(Sender);

  FContext := TRESTDWServerContext.Create(Self);
  FEvents := TRESTDWServerEvents.Create(Self);

  Event := TRESTDWEvent(FEvents.Events.Add);
  Event.DataMode  :=  dmRAW;
  Event.EventName := 'employee';
  Event.BaseUrl := '/api/';
  Event.OnReplyEventByType := TEmployeeController.GetAll;

  Event := TRESTDWEvent(FEvents.Events.Add);
  Event.DataMode  :=  dmRAW;
  Event.EventName := 'helloworld';
  Event.BaseUrl := '/api/';
  Event.OnReplyEventByType := TEmployeeController.HelloWorld;

  Context := TRESTDWContext(FContext.ContextList.Add);
  Context.ContextName := 'index';
  Context.OnReplyRequest := TEmployeeController.Index;

  FConn := TUniConnection.Create(Self);

  FConn.Server       := '10.5.5.190' + ':' + '1521'  + '/'  + 'f3ipro';
  FConn.Port         := 1521;
  FConn.ProviderName := 'ORACLE';
  FConn.Username     := 'integrado';
  FConn.Password     := 'axw6wU9zcf';
  FConn.Database     := 'f3ipro';
  FConn.SpecificOptions.Add('Direct=True');
  FConn.LoginPrompt :=  False;

  FConn.Connected := True;

  TEmployeeController.Conn := FConn;
end;

destructor TServerController.Destroy;
begin
  FContext.Free;
  FEvents.Free;
  FConn.Connected := False;
  FConn.Free;
  inherited;
end;

end.
