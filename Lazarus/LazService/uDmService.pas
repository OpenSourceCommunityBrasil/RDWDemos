unit uDmService;

interface

uses
  SysUtils, Classes, uRESTDWDatamodule, Dialogs, ZConnection, ZDataset,
  uRESTDWServerEvents, uRESTDWServerContext, uRESTDWBasicDB, uRESTDWZeosDriver,
  uConsts, uRESTDWParams;

Const
 Const404Page = '404.html';

type

  { TServerMethodDM }

  TServerMethodDM = class(TServerMethodDataModule)
    DWServerContext1: TRESTDWServerContext;
    DWServerEvents1: TRESTDWServerEvents;
    RESTDWPoolerDB: TRESTDWPoolerDB;
    RESTDWPoolerZEOS: TRESTDWPoolerDB;
    RESTDWZeosDriver1: TRESTDWZeosDriver;
    ZConnection1: TZConnection;
    FDQuery1: TZQuery;
    FDQLogin: TZQuery;
    procedure DWServerEvents1EventshelloworldReplyEvent(
      var Params: TRESTDWParams; const Result: TStringList);
    procedure DWServerEvents1EventsservertimeReplyEvent(
      var Params: TRESTDWParams; const Result: TStringList);
    procedure ZConnection1BeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ServerMethodDM: TServerMethodDM;

implementation

{$R *.lfm}

procedure TServerMethodDM.ZConnection1BeforeConnect(Sender: TObject);
begin
 TZConnection(Sender).Database := pasta + database;
 TZConnection(Sender).HostName := Servidor;
 TZConnection(Sender).Port     := porta_BD;
 TZConnection(Sender).User     := Usuario_BD;
 TZConnection(Sender).Password := Senha_BD;
 TZConnection(Sender).LoginPrompt := FALSE;
end;

procedure TServerMethodDM.DWServerEvents1EventsservertimeReplyEvent(
  var Params: TRESTDWParams; const Result: TStringList);
begin
  Params.ItemsString['result'].AsDateTime := Now;
end;

procedure TServerMethodDM.DWServerEvents1EventshelloworldReplyEvent(
  var Params: TRESTDWParams; const Result: TStringList);
begin
  If Params.ItemsString['temp'].AsString <> '' Then
    Result.Text := 'Hello World RDW Refactor...' + sLineBreak +
      Format('Param %s = %s', ['temp', Params.ItemsString['temp'].AsString])
  Else
  Begin
    Result.Text := 'Hello World RDW Refactor...' + sLineBreak +
      Format('Params em URI Param 0 = %d, Param 1 = %d',
      [Params.ItemsString['temp1'].AsInteger,
      Params.ItemsString['temp2'].AsInteger])
  End;
end;

end.
