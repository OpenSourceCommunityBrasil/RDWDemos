UNIT uDMPrincipal;

INTERFACE

{$DEFINE APPWIN}

USES
  SysUtils, Classes, System.JSON, Dialogs,

  Data.DB,
  FireDAC.Dapt, FireDAC.Phys.FBDef, FireDAC.UI.Intf, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Comp.Client, FireDAC.Comp.UI, FireDAC.Phys.IBBase,
  FireDAC.Stan.StorageJSON, FireDAC.Phys.ODBCBase,
  uRESTDWConsts, uRESTDWServerEvents, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.Dapt.Intf, FireDAC.Comp.DataSet, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.MySQL, FireDAC.Phys.PGDef, FireDAC.Phys.PG, FireDAC.Moni.Base,
  FireDAC.Moni.RemoteClient, FireDAC.Stan.StorageBin,
  uRESTDWDataUtils,
  uRESTDWDatamodule, uRESTDWMassiveBuffer, uRESTDWJSONObject, uRESTDWAbout,
  uRESTDWServerContext, uRESTDWBasicDB, uRESTDWParams, uRESTDWBasicTypes,
  uRESTDWTools, uRESTDWBasic, uRESTDWMimeTypes,
  uPrincipal, uRESTDWDriverBase, uRESTDWFireDACDriver, ZAbstractConnection,
  ZConnection, uRESTDWZeosDriver, FireDAC.Phys.MSSQLDef, FireDAC.Phys.MSSQL;

Const
  WelcomeSample = True;
  Const404Page = 'www\404.html';

TYPE
  TServerMethodDM = CLASS(TServerMethodDataModule)
    RESTDWPoolerDB: TRESTDWPoolerDB;
    Server_FDConnection: TFDConnection;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDTransaction1: TFDTransaction;
    FDQuery1: TFDQuery;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    FDMoniRemoteClientLink1: TFDMoniRemoteClientLink;
    FDQuery2: TFDQuery;
    FDQLogin: TFDQuery;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    RESTDWServerEvents: TRESTDWServerEvents;
    RESTDWFireDACDriver1: TRESTDWFireDACDriver;
    RESTDWPoolerZEOS: TRESTDWPoolerDB;
    RESTDWZeosDriver1: TRESTDWZeosDriver;
    ZConnection1: TZConnection;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    PROCEDURE Server_FDConnectionBeforeConnect(Sender: TObject);
    PROCEDURE Server_FDConnectionError(ASender, AInitiator: TObject;
      VAR AException: Exception);
    procedure DWServerEvents1EventsloaddataseteventReplyEvent
      (var Params: TRESTDWParams; var Result: string);
    procedure DWServerEvents1EventsgetemployeeReplyEvent
      (var Params: TRESTDWParams; var Result: string);
    procedure DWServerEvents1EventsgetemployeeDWReplyEvent
      (var Params: TRESTDWParams; var Result: string);
    procedure DWServerEvents1EventseventintReplyEvent(var Params: TRESTDWParams;
      var Result: string);
    procedure DWServerEvents1EventseventdatetimeReplyEvent
      (var Params: TRESTDWParams; var Result: string);
    procedure DWServerEvents1EventshelloworldReplyEvent
      (var Params: TRESTDWParams; var Result: string);
    procedure DWServerEvents2Eventshelloworld2ReplyEvent
      (var Params: TRESTDWParams; var Result: string);
    procedure RESTDWDriverFD1PrepareConnection(var ConnectionDefs
      : TConnectionDefs);
    procedure DWServerContext1ContextListinitReplyRequest
      (const Params: TRESTDWParams; var ContentType, Result: string;
      const RequestType: TRequestType);
    procedure DWServerContext1ContextListzsendReplyRequest
      (const Params: TRESTDWParams; var ContentType, Result: string;
      const RequestType: TRequestType);
    procedure DWServerContext1ContextListangularReplyRequest
      (const Params: TRESTDWParams; var ContentType, Result: string;
      const RequestType: TRequestType);
    procedure DWServerContext1ContextListphpReplyRequest
      (const Params: TRESTDWParams; var ContentType, Result: string;
      const RequestType: TRequestType);
    procedure DWServerContext1ContextListindexReplyRequest
      (const Params: TRESTDWParams; var ContentType, Result: string;
      const RequestType: TRequestType);
    procedure dwcrEmployeeItemsdatatableRequestExecute
      (const Params: TRESTDWParams; var ContentType, Result: string);
    procedure DWServerEvents1EventsassynceventReplyEvent
      (var Params: TRESTDWParams; var Result: string);
    procedure DWServerEvents1EventshelloworldRDWReplyEvent
      (var Params: TRESTDWParams; var Result: string);
    procedure FDQuery1AfterScroll(DataSet: TDataSet);
    procedure DWSETESTEEventsservertimeReplyEventByType
      (var Params: TRESTDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
    procedure ServerMethodDataModuleCreate(Sender: TObject);
    procedure DWServerContext1ContextListopenfileReplyRequestStream
      (const Params: TRESTDWParams; var ContentType: string;
      const Result: TMemoryStream; const RequestType: TRequestType;
      var StatusCode: Integer);
    procedure ServerMethodDataModuleMassiveProcess(var MassiveDataset
      : TMassiveDatasetBuffer; var Ignore: Boolean);
    procedure ServerMethodDataModuleGetToken(Welcomemsg, AccessTag: string;
      Params: TRESTDWParams; AuthOptions: TRESTDWAuthTokenParam;
      var ErrorCode: Integer; var ErrorMessage, TokenID: string;
      var Accept: Boolean);
    procedure ServerMethodDataModuleUserTokenAuth(Welcomemsg, AccessTag: string;
      Params: TRESTDWParams; AuthOptions: TRESTDWAuthTokenParam;
      var ErrorCode: Integer; var ErrorMessage, TokenID: string;
      var Accept: Boolean);
    procedure DWServerContext1ContextListindexReplyRequestStream
      (const Params: TRESTDWParams; var ContentType: string;
      const Result: TMemoryStream; const RequestType: TRequestType;
      var StatusCode: Integer);
    procedure RESTDWServerEventsEventshelloworldReplyEvent(
      var Params: TRESTDWParams; const Result: TStringList);
    procedure RESTDWServerEventsEventsservertimeReplyEvent(
      var Params: TRESTDWParams; const Result: TStringList);
    procedure RESTDWServerEventsEventspingReplyEvent(var Params: TRESTDWParams;
      const Result: TStringList);
    procedure ZConnection1BeforeConnect(Sender: TObject);
  PRIVATE
    { Private declarations }
    vIDVenda: Integer;
    vConnectFromClient: Boolean;
    function GetGenID(GenName: String): Integer;
    procedure employeeReplyEvent(var Params: TRESTDWParams;
      dJsonMode: TDataMode; Var Result: String);
  PUBLIC
    { Public declarations }
  END;

VAR
  ServerMethodDM: TServerMethodDM;

IMPLEMENTATION

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TServerMethodDM.employeeReplyEvent(var Params: TRESTDWParams;
  dJsonMode: TDataMode; Var Result: String);
Var
  JSONValue: TRESTDWJSONValue;
begin
  JSONValue := TRESTDWJSONValue.Create;
  Try
    FDQuery1.Close;
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('select * from employee');
    Try
      FDQuery1.Open;
      JSONValue.DataMode := Params.DataMode;
      JSONValue.Encoding := Encoding;
      If Params.DataMode = dmRAW Then
      Begin
        JSONValue.Utf8SpecialChars := True;
        JSONValue.LoadFromDataset('', FDQuery1, False, Params.DataMode,
          'dd/mm/yyyy hh:mm:ss', '.');
        Result := JSONValue.ToJson;
      End
      Else
      Begin
        JSONValue.LoadFromDataset('employee', FDQuery1, False, Params.DataMode);
        Params.ItemsString['result'].AsObject := JSONValue.ToJson;
      End;
    Except
      On E: Exception Do
      Begin
        Result := Format('{"Error":"%s"}', [E.Message]);
      End;
    End;
  Finally
    JSONValue.Free;
  End;
end;

procedure TServerMethodDM.FDQuery1AfterScroll(DataSet: TDataSet);
begin
  If FDQuery1.FieldByName('emp_no') <> Nil Then
  Begin
    FDQuery2.Close;
    FDQuery2.ParamByName('emp_no').AsInteger := FDQuery1.FieldByName('emp_no')
      .AsInteger;
    FDQuery2.Open;
  End;
end;

procedure TServerMethodDM.dwcrEmployeeItemsdatatableRequestExecute
  (const Params: TRESTDWParams; var ContentType, Result: string);
Var
  JSONValue: TRESTDWJSONValue;
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
      JSONValue.LoadFromDataset('', FDQuery1, False, JSONValue.DataMode,
        'dd/mm/yyyy', '.');
      JSONValue.LoadFromDataset('', FDQuery1, False, JSONValue.DataMode,
        'dd/mm/yyyy', '.');
      Result := JSONValue.ToJson;
    Except
      On E: Exception Do
      Begin
        Result := Format('{"Error":"%s"}', [E.Message]);
      End;
    End;
  Finally
    JSONValue.Free;
  End;
end;

procedure TServerMethodDM.DWServerContext1ContextListangularReplyRequest
  (const Params: TRESTDWParams; var ContentType, Result: string;
  const RequestType: TRequestType);
var
  s: TStringList;
begin
  s := TStringList.Create;
  Try
    s.LoadFromFile('.\www\dw_angular.html');
    Result := s.Text;
  Finally
    s.Free;
  End;
end;

procedure TServerMethodDM.DWServerContext1ContextListindexReplyRequest
  (const Params: TRESTDWParams; var ContentType, Result: string;
  const RequestType: TRequestType);
var
  s: TStringList;
begin
  s := TStringList.Create;
  Try
    s.LoadFromFile('.\www\index.html');
    Result := s.Text;
  Finally
    s.Free;
  End;
end;

procedure TServerMethodDM.DWServerContext1ContextListindexReplyRequestStream
  (const Params: TRESTDWParams; var ContentType: string;
  const Result: TMemoryStream; const RequestType: TRequestType;
  var StatusCode: Integer);
begin
  Result.LoadFromFile('.\www\index.html');
  Result.Position := 0;
end;

procedure TServerMethodDM.DWServerContext1ContextListinitReplyRequest
  (const Params: TRESTDWParams; var ContentType, Result: string;
  const RequestType: TRequestType);
begin
  Result := '<!DOCTYPE html> ' + '<html>' + '  <head>' +
    '    <meta charset="utf-8">' +
    '    <title>REST Dataware - Webpascal</title>' +
    '    <link href=''http://fonts.googleapis.com/css?family=Open+Sans'' rel=''stylesheet'' type=''text/css''>'
    + '  </head>' + '  <body>' + '    <h1>REST Dataware is cool</h1>' +
    '    <img src="http://www.resteasyobjects.com.br/myimages/LogoDW.png" alt="The REST Dataware logo: Powerfull Web Service.">'
    + '  ' + '  ' +
    '    <p>working together to keep the Internet alive and accessible, help us to help you. Be free.</p>'
    + ' ' + '    <p><a href="http://www.restdw.com.br/">REST Dataware site</a> to learn and help us.</p>'
    + '  </body>' + '</html>';
end;

procedure TServerMethodDM.DWServerContext1ContextListopenfileReplyRequestStream
  (const Params: TRESTDWParams; var ContentType: string;
  const Result: TMemoryStream; const RequestType: TRequestType;
  var StatusCode: Integer);
Var
  vNotFound: Boolean;
  vFileName: String;
  vStringStream: TStringStream;
begin
  vNotFound := True;
  If Params.ItemsString['filename'] <> Nil Then
  Begin
    vFileName := '.\www\' + DecodeStrings(Params.ItemsString['filename']
      .AsString);
    vNotFound := Not FileExists(vFileName);
    If Not vNotFound Then
    Begin
      Try
        Result.LoadFromFile(vFileName);
        ContentType := TRESTDWMIMEType.GetMIMEType(vFileName);
      Finally
      End;
    End;
  End;
  If vNotFound Then
  Begin
    vStringStream := TStringStream.Create('<!DOCTYPE html> ' + '<html>' +
      '  <head>' + '    <meta charset="utf-8">' +
      '    <title>My test page</title>' +
      '    <link href=''http://fonts.googleapis.com/css?family=Open+Sans'' rel=''stylesheet'' type=''text/css''>'
      + '  </head>' + '  <body>' + '    <h1>REST Dataware</h1>' +
      '    <img src="http://www.resteasyobjects.com.br/myimages/LogoDW.png" alt="The REST Dataware logo: Powerfull Web Service.">'
      + '  ' + '  ' + Format('    <p>File "%s" not Found.</p>', [vFileName]) +
      '  </body>' + '</html>');
    Try
      vStringStream.Position := 0;
      Result.CopyFrom(vStringStream, vStringStream.Size);
    Finally
      vStringStream.Free;
    End;
  End;
end;

procedure TServerMethodDM.DWServerContext1ContextListphpReplyRequest
  (const Params: TRESTDWParams; var ContentType, Result: string;
  const RequestType: TRequestType);
var
  s: TStringList;
begin
  s := TStringList.Create;
  Try
    s.LoadFromFile('.\www\index_php.html');
    Result := s.Text;
  Finally
    s.Free;
  End;
end;

procedure TServerMethodDM.DWServerContext1ContextListzsendReplyRequest
  (const Params: TRESTDWParams; var ContentType, Result: string;
  const RequestType: TRequestType);
var
  s: TStringList;
begin
  s := TStringList.Create;
  Try
    s.LoadFromFile('.\zenvia\data\envio_simples.php');
    Result := s.Text;
  Finally
    s.Free;
  End;
end;

procedure TServerMethodDM.DWServerEvents1EventsassynceventReplyEvent
  (var Params: TRESTDWParams; var Result: string);
Var
  vstringtime: TStringList;
begin
  vstringtime := TStringList.Create;
  Try
    vstringtime.Add(DateTimeToStr(Now));
    vstringtime.SaveToFile(ExtractFilePath(Paramstr(0)) + 'assynctime.txt');
  Finally
    vstringtime.Free;
  End;
end;

procedure TServerMethodDM.DWServerEvents1EventseventdatetimeReplyEvent
  (var Params: TRESTDWParams; var Result: string);
begin
  Params.ItemsString['result'].AsDateTime := Params.ItemsString['mydatetime']
    .AsDateTime + 1;
end;

procedure TServerMethodDM.DWServerEvents1EventseventintReplyEvent
  (var Params: TRESTDWParams; var Result: string);
begin
  Params.ItemsString['result'].AsInteger :=
    Random(Params.ItemsString['mynumber'].AsInteger);
end;

procedure TServerMethodDM.DWServerEvents1EventsgetemployeeDWReplyEvent
  (var Params: TRESTDWParams; var Result: string);
begin
  employeeReplyEvent(Params, Params.DataMode, Result);
end;

procedure TServerMethodDM.DWServerEvents1EventsgetemployeeReplyEvent
  (var Params: TRESTDWParams; var Result: string);
Begin
  employeeReplyEvent(Params, Params.DataMode, Result);
End;

procedure TServerMethodDM.DWServerEvents1EventshelloworldRDWReplyEvent
  (var Params: TRESTDWParams; var Result: string);
begin
  Params.ItemsString['result'].AsString := 'Hello World : ' +
    QuotedSTR(Params.ItemsString['entrada'].AsString);
end;

procedure TServerMethodDM.DWServerEvents1EventshelloworldReplyEvent
  (var Params: TRESTDWParams; var Result: string);
begin
  Result := Format('Hello World :"%s"',
    [Params.ItemsString['entrada'].AsString]);
end;

procedure TServerMethodDM.DWServerEvents1EventsloaddataseteventReplyEvent
  (var Params: TRESTDWParams; var Result: string);
Var
  JSONValue: TRESTDWJSONValue;
BEGIN
  If Params.ItemsString['sql'] <> Nil Then
  Begin
    JSONValue := TRESTDWJSONValue.Create;
    Try
      FDQuery1.Close;
      FDQuery1.SQL.Clear;
      FDQuery1.SQL.Add(Params.ItemsString['sql'].AsString);
      Try
        FDQuery1.Open;
        JSONValue.Encoding := Encoding;
        JSONValue.LoadFromDataset('temp', FDQuery1, True);
        Params.ItemsString['result'].AsString := JSONValue.ToJson;
      Except
        On E: Exception Do
        Begin
          Result := Format('{"Error":"%s"}', [E.Message]);
        End;
      End;
    Finally
      JSONValue.Free;
    End;
  End;
end;

procedure TServerMethodDM.DWServerEvents2Eventshelloworld2ReplyEvent
  (var Params: TRESTDWParams; var Result: string);
begin
  Result := 'Sou eu ServerEvent2';
end;

procedure TServerMethodDM.DWSETESTEEventsservertimeReplyEventByType
  (var Params: TRESTDWParams; var Result: string;
  const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
begin
  If Params.ItemsString['inputdata'].AsString <> '' Then // servertime
    Params.ItemsString['result'].AsDateTime := Now
  Else
    Params.ItemsString['result'].AsDateTime := Now - 1;
  Params.ItemsString['resultstring'].AsString := Params.ItemsString
    ['inputdata'].AsString;
End;

Function TServerMethodDM.GetGenID(GenName: String): Integer;
Var
  vTempClient: TFDQuery;
Begin
  vTempClient := TFDQuery.Create(Nil);
  Result := -1;
  Try
    vTempClient.Connection := Server_FDConnection;
    vTempClient.SQL.Add(Format('select gen_id(%s, 1)GenID From rdb$database',
      [GenName]));
    vTempClient.Active := True;
    Result := vTempClient.FindField('GenID').AsInteger;
  Except

  End;
  vTempClient.Free;
End;

procedure TServerMethodDM.RESTDWDriverFD1PrepareConnection(var ConnectionDefs
  : TConnectionDefs);
begin
  vConnectFromClient := True;
  ConnectionDefs.DatabaseName := IncludeTrailingPathDelimiter
    (fPrincipal.EdPasta.Text) + ConnectionDefs.DatabaseName;
  ConnectionDefs.HostName := 'localhost';
  ConnectionDefs.dbPort := 3050;
  ConnectionDefs.Username := 'sysdba';
  ConnectionDefs.Password := 'masterkey';
end;

procedure TServerMethodDM.RESTDWServerEventsEventshelloworldReplyEvent(
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

procedure TServerMethodDM.RESTDWServerEventsEventspingReplyEvent(
  var Params: TRESTDWParams; const Result: TStringList);
begin
 result.Text := 'pong';
end;

procedure TServerMethodDM.RESTDWServerEventsEventsservertimeReplyEvent(
  var Params: TRESTDWParams; const Result: TStringList);
begin
  Params.ItemsString['result'].AsDateTime := Now;
end;

procedure TServerMethodDM.ServerMethodDataModuleCreate(Sender: TObject);
begin
  vConnectFromClient := False;
  RESTDWPoolerDB.Active := fPrincipal.CbPoolerState.Checked;
end;

procedure TServerMethodDM.ServerMethodDataModuleGetToken(Welcomemsg,
  AccessTag: string; Params: TRESTDWParams; AuthOptions: TRESTDWAuthTokenParam;
  var ErrorCode: Integer; var ErrorMessage, TokenID: string;
  var Accept: Boolean);
Var
  vMyClient, vMyPass: String;
  Function RejectURL: String;
  Var
    v404Error: TStringList;
  Begin
    v404Error := TStringList.Create;
    Try
{$IFDEF APPWIN}
      v404Error.LoadFromFile(fPrincipal.RESTDWIdServicePooler1.RootPath +
        Const404Page);
{$ELSE}
      v404Error.LoadFromFile('.\www\' + Const404Page);
{$ENDIF}
      Result := v404Error.Text;
    Finally
      v404Error.Free;
    End;
  End;

begin
  vMyClient := '';
  vMyPass := vMyClient;
  If (Params.ItemsString['username'] <> Nil) And
    (Params.ItemsString['password'] <> Nil) Then
  Begin
    vMyClient := Params.ItemsString['username'].AsString;
    vMyPass := Params.ItemsString['password'].AsString;
  End
  Else
  Begin
    vMyClient := Copy(Welcomemsg, InitStrPos, Pos('|', Welcomemsg) - 1);
    Delete(Welcomemsg, InitStrPos, Pos('|', Welcomemsg));
    vMyPass := Trim(Welcomemsg);
  End;
  Accept := Not((vMyClient = '') Or (vMyPass = ''));
  If Accept Then
  Begin
    FDQLogin.Close;
    FDQLogin.SQL.Clear;
    FDQLogin.SQL.Add
      ('select * from TB_USUARIO where Upper(NM_LOGIN) = Upper(:NM_LOGIN) and Upper(DS_SENHA) = Upper(:DS_SENHA)');
    Try
      FDQLogin.ParamByName('NM_LOGIN').AsString := vMyClient;
      FDQLogin.ParamByName('DS_SENHA').AsString := vMyPass;
      FDQLogin.Open;
    Finally
      Accept := Not(FDQLogin.EOF);
      If Not Accept Then
      Begin
        ErrorMessage := cInvalidAuth;
        ErrorCode := 401;
      End
      Else
        TokenID := AuthOptions.GetToken(Format('{"id":"%s", "login":"%s"}',
          [FDQLogin.FindField('ID_PESSOA').AsString,
          FDQLogin.FindField('NM_LOGIN').AsString]));
      FDQLogin.Close;
    End;
  End
  Else
  Begin
    ErrorMessage := cInvalidAuth;
    ErrorCode := 401;
  End;
end;

procedure TServerMethodDM.ServerMethodDataModuleMassiveProcess(var MassiveDataset
  : TMassiveDatasetBuffer; var Ignore: Boolean);
begin
  { //Esse código é para manipular o evento nao permitindo que sejam alteradas por massive outras
    //tabelas diferentes de employee e se você alterar o campo last_name no client ele substitui o valor
    //pelo valor setado abaixo
    Ignore := (MassiveDataset.MassiveMode in [mmInsert, mmUpdate, mmDelete]) and
    (lowercase(MassiveDataset.TableName) <> 'employee');
  }
  If MassiveDataset.MassiveMode = mmInsert Then
  Begin
    If lowercase(MassiveDataset.TableName) = 'vendas' Then
    Begin
      If MassiveDataset.Fields.FieldByName('ID') <> Nil Then
        If (MassiveDataset.Fields.FieldByName('ID').Value <= 0) then
        Begin
          vIDVenda := GetGenID('GEN_' + lowercase(MassiveDataset.TableName));
          MassiveDataset.Fields.FieldByName('ID').Value := IntToStr(vIDVenda);
          MassiveDataset.Fields.FieldByName('DATA').Value := Now;
        End
        Else
          vIDVenda := StrToInt(MassiveDataset.Fields.FieldByName('ID').Value)
    End
    Else If lowercase(MassiveDataset.TableName) = 'vendas_items' Then
    Begin
      If MassiveDataset.Fields.FieldByName('ID_VENDA') <> Nil Then
        If (MassiveDataset.Fields.FieldByName('ID_VENDA').Value <= 0) then
          MassiveDataset.Fields.FieldByName('ID_VENDA').Value :=
            IntToStr(vIDVenda);
      If MassiveDataset.Fields.FieldByName('ID_ITEMS') <> Nil Then
        If (MassiveDataset.Fields.FieldByName('ID_ITEMS').Value <= 0) then
          MassiveDataset.Fields.FieldByName('ID_ITEMS').Value :=
            IntToStr(GetGenID('GEN_' + lowercase(MassiveDataset.TableName)));
    End;
  End;
end;

Procedure TServerMethodDM.ServerMethodDataModuleUserTokenAuth(Welcomemsg,
  AccessTag: string; Params: TRESTDWParams; AuthOptions: TRESTDWAuthTokenParam;
  Var ErrorCode: Integer; var ErrorMessage, TokenID: string;
  Var Accept: Boolean);
begin
  // Novo código para validação
  Accept := True;
  // AuthOptions.BeginTime
  // AuthOptions.EndTime
  // AuthOptions.Secrets
end;

PROCEDURE TServerMethodDM.Server_FDConnectionBeforeConnect(Sender: TObject);
Var
 Driver_BD,
 Porta_BD,
 Servidor_BD,
 DataBase,
 Pasta_BD,
 Usuario_BD,
 Senha_BD   : String;
Begin
 {$IFDEF APPWIN}
 database     := fPrincipal.EdBD.Text;
 Driver_BD    := fPrincipal.CbDriver.Text;
 If fPrincipal.CkUsaURL.Checked Then
  Servidor_BD := fPrincipal.EdURL.Text
 Else
  Servidor_BD := fPrincipal.DatabaseIP;
 Case fPrincipal.CbDriver.ItemIndex Of
  0 : Begin
       Pasta_BD := IncludeTrailingPathDelimiter(fPrincipal.EdPasta.Text);
       Database := fPrincipal.edBD.Text;
       Database := Pasta_BD + Database;
      End;
  1 : Database := fPrincipal.EdBD.Text;
  3 : Driver_BD := 'PG';
 End;
 Porta_BD   := fPrincipal.EdPortaBD.Text;
 Usuario_BD := fPrincipal.EdUserNameBD.Text;
 Senha_BD   := fPrincipal.EdPasswordBD.Text;
 {$ELSE}
 Servidor_BD := servidor;
 Porta_BD    := IntToStr(portaBD);
 Database    := pasta + databaseC;
 Usuario_BD  := usuarioBD;
 Senha_BD    := senhaBD;
 Driver_BD   := DriverBD;
 {$ENDIF}
 TFDConnection(Sender).Params.Clear;
 TFDConnection(Sender).Params.Add('DriverID='  + Driver_BD);
 TFDConnection(Sender).Params.Add('Server='    + Servidor_BD);
 TFDConnection(Sender).Params.Add('Port='      + Porta_BD);
 TFDConnection(Sender).Params.Add('Database='  + Database);
 TFDConnection(Sender).Params.Add('User_Name=' + Usuario_BD);
 TFDConnection(Sender).Params.Add('Password='  + Senha_BD);
 TFDConnection(Sender).Params.Add('LoginTimeout=0');
 TFDConnection(Sender).Params.Add('Protocol=TCPIP');
 TFDConnection(Sender).DriverName                        := Driver_BD;
 TFDConnection(Sender).LoginPrompt                       := FALSE;
 TFDConnection(Sender).UpdateOptions.CountUpdatedRecords := False;
End;

PROCEDURE TServerMethodDM.Server_FDConnectionError(ASender, AInitiator: TObject;
  VAR AException: Exception);
BEGIN
  fPrincipal.memoResp.Lines.Add(AException.Message);
END;

procedure TServerMethodDM.ZConnection1BeforeConnect(Sender: TObject);
VAR
  Driver_BD: STRING;
  Porta_BD: STRING;
  Servidor_BD: STRING;
  DataBase: STRING;
  Pasta_BD: STRING;
  Usuario_BD: STRING;
  Senha_BD: STRING;
BEGIN
   DataBase := fPrincipal.EdBD.Text;
   Driver_BD := fPrincipal.CbDriver.Text;
   If fPrincipal.CkUsaURL.Checked Then
    Servidor_BD := fPrincipal.EdURL.Text
   Else
    Servidor_BD := fPrincipal.DatabaseIP;
   Case fPrincipal.CbDriver.ItemIndex Of
    0 : Begin
         Pasta_BD := IncludeTrailingPathDelimiter(fPrincipal.EdPasta.Text);
         Database := fPrincipal.edBD.Text;
         Database := Pasta_BD + Database;
        End;
    1 : Database := fPrincipal.EdBD.Text;
   End;
   Porta_BD   := fPrincipal.EdPortaBD.Text;
   Usuario_BD := fPrincipal.EdUserNameBD.Text;
   Senha_BD   := fPrincipal.EdPasswordBD.Text;
   TZConnection(Sender).Database := Database;
   TZConnection(Sender).HostName := Servidor_BD;
   TZConnection(Sender).Port     := StrToInt(Porta_BD);
   TZConnection(Sender).User     := Usuario_BD;
   TZConnection(Sender).Password := Senha_BD;
   TZConnection(Sender).LoginPrompt := FALSE;
End;

END.
