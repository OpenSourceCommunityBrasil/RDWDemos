UNIT uRDWDataModule;

INTERFACE

USES
  SysUtils, Classes, System.JSON, Dialogs, Data.DB,

  FireDAC.Dapt, FireDAC.Phys.FBDef, FireDAC.UI.Intf, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Comp.Client, FireDAC.Comp.UI, FireDAC.Phys.IBBase,
  FireDAC.Stan.StorageJSON, FireDAC.Phys.MSSQLDef, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSSQL, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.Dapt.Intf, FireDAC.Comp.DataSet,

  uRESTDWServerContext, uRESTDWAbout, uRESTDWBasic, uRESTDWParams,
  uRESTDWComponentBase, uRESTDWDatamodule, uRESTDWMassiveBuffer,
  uRESTDWDataUtils, uRESTDWBasicDB, URestDWDriverFD, uRESTDWConsts,
  uRESTDWServerEvents;

Const
  Const404Page = 'www\404.html';

TYPE
  TRDWDataModule = CLASS(TServerMethodDataModule)
    RESTDWPoolerDB1: TRESTDWPoolerDB;
    RESTDWDriverFD1: TRESTDWDriverFD;
    Server_FDConnection: TFDConnection;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    FDTransaction1: TFDTransaction;
    FDQuery1: TFDQuery;
    FDQLogin: TFDQuery;
    RESTDWServerEvents1: TRESTDWServerEvents;
    RESTDWServerContext1: TRESTDWServerContext;
    PROCEDURE Server_FDConnectionBeforeConnect(Sender: TObject);
    procedure ServerMethodDataModuleMassiveProcess(var MassiveDataset
      : TMassiveDatasetBuffer; var Ignore: Boolean);
    procedure ServerMethodDataModuleGetToken(Welcomemsg, AccessTag: string;
      Params: TRESTDWParams; AuthOptions: TRESTDWAuthTokenParam;
      var ErrorCode: Integer; var ErrorMessage, TokenID: string;
      var Accept: Boolean);
    procedure RESTDWServerEvents1Eventsdwevent1ReplyEvent
      (var Params: TRESTDWParams; var Result: string);
    procedure RESTDWServerEvents1EventshelloworldReplyEvent
      (var Params: TRESTDWParams; var Result: string);
    procedure ServerMethodDataModuleUserTokenAuth(Welcomemsg, AccessTag: string;
      Params: TRESTDWParams; AuthOptions: TRESTDWAuthTokenParam;
      var ErrorCode: Integer; var ErrorMessage, TokenID: string;
      var Accept: Boolean);
  PRIVATE
    { Private declarations }
    vIDVenda: Integer;
    function GetGenID(GenName: String): Integer;
  PUBLIC
    { Public declarations }
  END;

VAR
  RDWDataModule: TRDWDataModule;

IMPLEMENTATION

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TRDWDataModule.ServerMethodDataModuleGetToken(Welcomemsg,
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
      v404Error.LoadFromFile(RestDWForm.RESTServicePooler1.RootPath +
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
        ErrorCode := 404;
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
    ErrorCode := 404;
  End;
end;

Function TRDWDataModule.GetGenID(GenName: String): Integer;
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

procedure TRDWDataModule.RESTDWServerEvents1Eventsdwevent1ReplyEvent
  (var Params: TRESTDWParams; var Result: string);
begin
  If Params.ItemsString['inputdata'].AsString <> '' Then // servertime
    Params.ItemsString['result'].AsDateTime := Now
  Else
    Params.ItemsString['result'].AsDateTime := Now - 1;
  Params.ItemsString['resultstring'].AsString := 'testservice';
  Params.RequestHeaders.Output.Add('meutesteheader=testado');
  Params.Url_Redirect := 'servertime?redirect=testerdw';
end;

procedure TRDWDataModule.RESTDWServerEvents1EventshelloworldReplyEvent
  (var Params: TRESTDWParams; var Result: string);
begin
  Result := Format('{"Message":"%s"}',
    [Params.ItemsString['entrada'].AsString]);
end;

procedure TRDWDataModule.ServerMethodDataModuleMassiveProcess(var MassiveDataset
  : TMassiveDatasetBuffer; var Ignore: Boolean);
begin
  { //Esse código é para manipular o evento nao permitindo que sejam alteradas por massive outras
    //tabelas diferentes de employee e se você alterar o campo last_name no client ele substitui o valor
    //pelo valor setado abaixo
    Ignore := (MassiveDataset.MassiveMode in [mmInsert, mmUpdate, mmDelete]) and
    (lowercase(MassiveDataset.TableName) <> 'employee');
  }
  If lowercase(MassiveDataset.TableName) = 'vendas' Then
  Begin
    If MassiveDataset.Fields.FieldByName('ID_VENDA') <> Nil Then
      If (Trim(MassiveDataset.Fields.FieldByName('ID_VENDA').Value) = '') or
        (Trim(MassiveDataset.Fields.FieldByName('ID_VENDA').Value) = '-1') then
      Begin
        vIDVenda := GetGenID('GEN_' + lowercase(MassiveDataset.TableName));
        MassiveDataset.Fields.FieldByName('ID_VENDA').Value :=
          IntToStr(vIDVenda);
      End
      Else
        vIDVenda := StrToInt(MassiveDataset.Fields.FieldByName
          ('ID_VENDA').Value)
  End
  Else If lowercase(MassiveDataset.TableName) = 'vendas_items' Then
  Begin
    If MassiveDataset.Fields.FieldByName('ID_VENDA') <> Nil Then
      If (Trim(MassiveDataset.Fields.FieldByName('ID_VENDA').Value) = '') or
        (Trim(MassiveDataset.Fields.FieldByName('ID_VENDA').Value) = '-1') then
        MassiveDataset.Fields.FieldByName('ID_VENDA').Value :=
          IntToStr(vIDVenda);
    If MassiveDataset.Fields.FieldByName('ID_ITEMS') <> Nil Then
      If (Trim(MassiveDataset.Fields.FieldByName('ID_ITEMS').Value) = '') or
        (Trim(MassiveDataset.Fields.FieldByName('ID_ITEMS').Value) = '-1') then
        MassiveDataset.Fields.FieldByName('ID_ITEMS').Value :=
          IntToStr(GetGenID('GEN_' + lowercase(MassiveDataset.TableName)));
  End;
end;

procedure TRDWDataModule.ServerMethodDataModuleUserTokenAuth(Welcomemsg,
  AccessTag: string; Params: TRESTDWParams; AuthOptions: TRESTDWAuthTokenParam;
  var ErrorCode: Integer; var ErrorMessage, TokenID: string;
  var Accept: Boolean);
begin
  // Novo código para validação
  Accept := True;
  // AuthOptions.BeginTime
  // AuthOptions.EndTime
  // AuthOptions.Secrets
end;

PROCEDURE TRDWDataModule.Server_FDConnectionBeforeConnect(Sender: TObject);
VAR
  Driver_BD: STRING;
  Porta_BD: STRING;
  Servidor_BD: STRING;
  DataBaseB: STRING;
  Pasta_BD: STRING;
BEGIN
  // Servidor_BD := servidor;
  // Pasta_BD := IncludeTrailingPathDelimiter(pasta);
  // DataBaseB := Pasta_BD + Database;
  // TFDConnection(Sender).Params.Clear;
  // TFDConnection(Sender).Params.Add('DriverID=FB');
  // TFDConnection(Sender).Params.Add('Server=' + Servidor_BD);
  // TFDConnection(Sender).Params.Add('Port=' + Porta_BD);
  // TFDConnection(Sender).Params.Add('Database=' + DataBaseB);
  // TFDConnection(Sender).Params.Add('User_Name=' + Usuario_BD);
  // TFDConnection(Sender).Params.Add('Password=' + Senha_BD);
  // TFDConnection(Sender).Params.Add('Protocol=TCPIP');
  // TFDConnection(Sender).DriverName  := 'FB';
  // TFDConnection(Sender).LoginPrompt := FALSE;
  // TFDConnection(Sender).UpdateOptions.CountUpdatedRecords := False;
END;

END.
