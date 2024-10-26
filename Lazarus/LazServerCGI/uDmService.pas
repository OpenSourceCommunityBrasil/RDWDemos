unit uDmService;

interface

uses
  SysUtils, Classes, IBConnection, sqldb, mysql55conn, mysql50conn,
  uRESTDWDatamodule, uRESTDWJSONObject, Dialogs, ZConnection, ZDataset,
  uRESTDWConsts, uRESTDWBasicDB, uRESTDWServerEvents, uRESTDWServerContext,
  uRESTDWParams, uRESTDWAuthenticators, uRESTDWTools, uRESTDWZeosDriver,
  uConsts;

Const
 Const404Page = '404.html';

type

  { TServerMethodDM }

  TServerMethodDM = class(TServerMethodDataModule)
    dwcrEmployee: TRESTDWContextRules;
    DWServerContext1: TRESTDWServerContext;
    DWServerEvents1: TRESTDWServerEvents;
    RESTDWPoolerZEOS: TRESTDWPoolerDB;
    RESTDWZeosDriver1: TRESTDWZeosDriver;
    ZConnection1: TZConnection;
    FDQuery1: TZQuery;
    FDQLogin: TZQuery;
    procedure dwcrEmployeeItemsdatatableRequestExecute(const Params: TRESTDWParams;
      Var ContentType, Result: String);
    procedure DWServerContext1ContextListangularReplyRequest(
      const Params: TRESTDWParams; Var ContentType, Result: String;
      const RequestType: TRequestType);
    procedure DWServerContext1ContextListindexReplyRequest(
      const Params: TRESTDWParams; Var ContentType, Result: String;
      const RequestType: TRequestType);
    procedure DWServerContext1ContextListinitReplyRequest(
      const Params: TRESTDWParams; Var ContentType, Result: String;
      const RequestType: TRequestType);
    procedure DWServerContext1ContextListopenfileReplyRequestStream(
      const Params: TRESTDWParams; Var ContentType: String;
      Var Result: TMemoryStream; const RequestType: TRequestType);
    procedure DWServerEvents1EventsgetemployeeReplyEvent(Var Params: TRESTDWParams;
      Var Result: String);
    procedure DWServerEvents1EventsservertimeReplyEvent(Var Params: TRESTDWParams;
      Var Result: String);
    procedure DWServerEvents1EventstempReplyEvent(var Params: TRESTDWParams;
      var Result: String);
    procedure DWServerEvents1EventstempReplyEventByType(
      var Params: TRESTDWParams; var Result: String;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
    procedure DWServerEvents1EventstesteReplyEvent(Var Params: TRESTDWParams;
      Var Result: String);
    procedure Server_FDConnectionBeforeConnect(Sender: TObject);
    procedure ZConnection1BeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ServerMethodDM: TServerMethodDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.lfm}

procedure TServerMethodDM.DWServerEvents1EventsservertimeReplyEvent(
  Var Params: TRESTDWParams; Var Result: String);
begin
 If Params.ItemsString['inputdata'].AsString <> '' Then //servertime
  Params.ItemsString['result'].AsDateTime := Now
 Else
  Params.ItemsString['result'].AsDateTime := Now - 1;
 Params.ItemsString['resultstring'].AsString := 'testservice';
end;

procedure TServerMethodDM.DWServerEvents1EventstempReplyEvent(
  var Params: TRESTDWParams; var Result: String);
begin
end;

procedure TServerMethodDM.DWServerEvents1EventstempReplyEventByType(
  var Params: TRESTDWParams; var Result: String;
  const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
begin
 Case RequestType Of
  rtGet  : result := 'GET '  + Params.ToJSON;
  rtPost : result := 'POST ' + Params.ToJSON;
 end;
end;

procedure TServerMethodDM.DWServerEvents1EventsgetemployeeReplyEvent(
  Var Params: TRESTDWParams; Var Result: String);
Var
 JSONValue: TRESTDWJSONValue;
begin
 JSONValue          := TRESTDWJSONValue.Create;
 Try
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from employee');
  FDQuery1.Open;
  JSONValue.Encoding := Encoding;
  JSONValue.Encoded  := False;
  JSONValue.DatabaseCharSet := RESTDWZeosDriver1.DatabaseCharSet;
  JSONValue.LoadFromDataset('employee', FDQuery1, False,  Params.DataMode);
  Params.ItemsString['result'].AsObject  := JSONValue.ToJSON;
 Finally
  JSONValue.Free;
 End;
end;

procedure TServerMethodDM.DWServerContext1ContextListinitReplyRequest(
  const Params: TRESTDWParams; Var ContentType, Result: String;
  const RequestType: TRequestType);
begin
 Result := '<!DOCTYPE html> ' +
           '<html>' +
           '  <head>' +
           '    <meta charset="utf-8">' +
           '    <title>My test page</title>' +
           '    <link href=''http://fonts.googleapis.com/css?family=Open+Sans'' rel=''stylesheet'' type=''text/css''>' +
           '  </head>' +
           '  <body>' +
           '    <h1>REST Dataware is cool - Lazarus CGI</h1>' +
           '    <img src="http://www.resteasyobjects.com.br/myimages/LogoDW.png" alt="The REST Dataware logo: Powerfull Web Service.">' +
           '  ' +
           '  ' +
           '    <p>working together to keep the Internet alive and accessible, help us to help you. Be free.</p>' +
           ' ' +
           '    <p><a href="http://www.restdw.com.br/">REST Dataware site</a> to learn and help us.</p>' +
           '  </body>' +
           '</html>';
end;

procedure TServerMethodDM.DWServerContext1ContextListopenfileReplyRequestStream(
  const Params: TRESTDWParams; Var ContentType: String; Var Result: TMemoryStream;
  const RequestType: TRequestType);
Var
 vNotFound   : Boolean;
 vFileName   : String;
 vStringStream : TStringStream;
begin
 vNotFound := True;
 Result    := TMemoryStream.Create;
 If Params.ItemsString['filename'] <> Nil Then
  Begin
   vFileName := '.\www\' + DecodeStrings(Params.ItemsString['filename'].AsString, csUndefined);
   vNotFound := Not FileExists(vFileName);
   If Not vNotFound Then
    Begin
     Try
      Result.LoadFromFile(vFileName);
//      ContentType := GetMIMEType(vFileName);
     Finally
     End;
    End;
  End;
 If vNotFound Then
  Begin
   vStringStream := TStringStream.Create('<!DOCTYPE html> ' +
                                         '<html>' +
                                         '  <head>' +
                                         '    <meta charset="utf-8">' +
                                         '    <title>My test page</title>' +
                                         '    <link href=''http://fonts.googleapis.com/css?family=Open+Sans'' rel=''stylesheet'' type=''text/css''>' +
                                         '  </head>' +
                                         '  <body>' +
                                         '    <h1>REST Dataware</h1>' +
                                         '    <img src="http://www.resteasyobjects.com.br/myimages/LogoDW.png" alt="The REST Dataware logo: Powerfull Web Service.">' +
                                         '  ' +
                                         '  ' +
                                         Format('    <p>File "%s" not Found.</p>', [vFileName]) +
                                         '  </body>' +
                                         '</html>');
   Try
    vStringStream.Position := 0;
    Result.CopyFrom(vStringStream, vStringStream.Size);
   Finally
    vStringStream.Free;
   End;
  End;
end;

procedure TServerMethodDM.DWServerContext1ContextListindexReplyRequest(
  const Params: TRESTDWParams; Var ContentType, Result: String;
  const RequestType: TRequestType);
var
 s : TStringlist;
begin
 s := TStringlist.Create;
 Try
  s.LoadFromFile('.\www\index.html');
  Result := s.Text;
 Finally
  s.Free;
 End;
end;

procedure TServerMethodDM.DWServerContext1ContextListangularReplyRequest(
  const Params: TRESTDWParams; Var ContentType, Result: String;
  const RequestType: TRequestType);
var
 s : TStringlist;
begin
 s := TStringlist.Create;
 Try
  s.LoadFromFile('.\www\dw_angular.html');
  Result := s.Text;
 Finally
  s.Free;
 End;
end;

procedure TServerMethodDM.dwcrEmployeeItemsdatatableRequestExecute(
  const Params: TRESTDWParams; Var ContentType, Result: String);
Var
 JSONValue :  TRESTDWJSONValue;
begin
 JSONValue := TRESTDWJSONValue.Create;
 Try
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from employee');
  Try
   FDQuery1.Open;
   JSONValue.DataMode := dmRAW;
   JSONValue.Encoding := Encoding;
   JSONValue.DatabaseCharSet := RESTDWZeosDriver1.DatabaseCharSet;
   JSONValue.LoadFromDataset('', FDQuery1, False,  JSONValue.DataMode, 'dd/mm/yyyy', '.');
   Result := JSONValue.ToJson;
  Except
   On E : Exception Do
    Begin
     Result := Format('{"Error":"%s"}', [E.Message]);
    End;
  End;
 Finally
  JSONValue.Free;
 End;
end;

procedure TServerMethodDM.DWServerEvents1EventstesteReplyEvent(
  Var Params: TRESTDWParams; Var Result: String);
begin
 Result := Format('{"Message":"%s"}', [Params.ItemsString['entrada'].AsString]);
end;

procedure TServerMethodDM.Server_FDConnectionBeforeConnect(Sender: TObject);
Begin
 TIBConnection(Sender).HostName     := Servidor;
 TIBConnection(Sender).DatabaseName := pasta + database;
 TIBConnection(Sender).UserName     := usuario_BD;
 TIBConnection(Sender).Password     := senha_BD;
end;

procedure TServerMethodDM.ZConnection1BeforeConnect(Sender: TObject);
begin
 TZConnection(Sender).Database := pasta + database;
 TZConnection(Sender).HostName := Servidor;
 TZConnection(Sender).Port     := porta_BD;
 TZConnection(Sender).User     := Usuario_BD;
 TZConnection(Sender).Password := Senha_BD;
 TZConnection(Sender).LoginPrompt := FALSE;
end;

end.
