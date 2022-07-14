unit uDmService;

interface

uses
  SysUtils, Classes, IBConnection, sqldb, DB, mysql55conn, mysql50conn,
  mysql57conn, uDWDatamodule, uDWJSONObject, Dialogs, ZConnection, ZDataset,
  uRESTDWPoolerDB, uRESTDWServerEvents, uRESTDWServerContext, uRESTDWDriverZEOS,
  uConsts, uDWConsts, uSystemEvents;

Const
  WelcomeSample = True;

type

  { TServerMethodDM }

  TServerMethodDM = class(TServerMethodDataModule)
    DWEvents02: TDWServerEvents;
    DWEvents01: TDWServerEvents;
    RESTDWDriverZeos01: TRESTDWDriverZeos;
    RESTDWPoolerApp: TRESTDWPoolerDB;
    ZConnectionApp: TZConnection;
    ZQuery1nomclie: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleUserBasicAuth(Welcomemsg, AccessTag, Username,
      Password: String; var Params: TDWParams; var ErrorCode: Integer;
      var ErrorMessage: String; var Accept: Boolean);
    procedure DataModuleWelcomeMessage(Welcomemsg, AccessTag: String;
      var ConnectionDefs: TConnectionDefs; var Accept: Boolean;
      var ContentType, ErrorMessage: String);
    procedure DWEvents02EventsclientesReplyEventByType(var Params: TDWParams;
      var Result: String; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
    procedure ZConnectionAppBeforeConnect(Sender: TObject);
    procedure DWEvents01EventshoraReplyEvent(var Params: TDWParams;
      var Result: String);
  private
    procedure GetDados(var FDQuery: TZQuery; Params: TDWParams;
      dJsonMode: TJsonMode; var Result: String);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ServerMethodDM: TServerMethodDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.lfm}

{ TServerMethodDM }

// Procedure Get no banco de dados. ============================================
procedure TServerMethodDM.GetDados(var FDQuery: TZQuery; Params: TDWParams; dJsonMode: TJsonMode; Var Result: String);
var
 JSONValue : uDWJSONObject.TJSONValue;
begin
  JSONValue := uDWJSONObject.TJSONValue.Create;
  try
    FDQuery.Open;
    JSONValue.JsonMode := Params.JsonMode;
    JSONValue.Encoding := Encoding;
    try
      if Params.JsonMode in [jmPureJSON] Then
      begin
        JSONValue.LoadFromDataset('', FDQuery, False,  Params.JsonMode, 'dd/mm/yyyy');
        Result := JSONValue.ToJson;
      end
      else
      begin
        JSONValue.LoadFromDataset('tabela', FDQuery, False,  Params.JsonMode);
        Params.ItemsString['result'].AsObject := JSONValue.ToJSON;
      end;

    except on E:exception do
      Result := Format('{"Error":"%s"}', [E.Message]);
    end;
  finally
    JSONValue.Free;
    FDQuery.Free;
  end;
end;
// =============================================================================

procedure TServerMethodDM.DataModuleCreate(Sender: TObject);
begin
  RESTDWPoolerApp.Active := True;
end;

procedure TServerMethodDM.DataModuleUserBasicAuth(Welcomemsg, AccessTag,
  Username, Password: String; var Params: TDWParams; var ErrorCode: Integer;
  var ErrorMessage: String; var Accept: Boolean);
var
 cUsuario : String;
 cSenha   : String;
begin
  inherited;
  try
    if (Trim(Username) <> '') and (Trim(Password) <> '') then
    begin
      cUsuario := Trim(Username);
      cSenha   := Trim(Password);
    end
    else
    begin
      cUsuario := Trim(Params.ItemsString['usuario'].AsString);
      cSenha   := Trim(Params.ItemsString['senha'].AsString);
    end;

    if (cUsuario = 'teste') and (cSenha = 'teste') then
       Accept := True
    else
      ErrorMessage := 'Usuário ou senha inválida!';
  except
    ErrorMessage := 'Verifique os parametros informados!';
  end;
end;

procedure TServerMethodDM.DataModuleWelcomeMessage(Welcomemsg,
  AccessTag: String; var ConnectionDefs: TConnectionDefs; var Accept: Boolean;
  var ContentType, ErrorMessage: String);
begin
//  if Welcomemsg <> '' then
//     Database := Welcomemsg
//  else
//     Database := 'teste';

  Database := 'teste';
  Accept := True;
  try
    ZConnectionApp.Connected := False;
    ZConnectionApp.Connected := True;
  except on ex:exception do
    ErrorMessage := '{"status": 500, "message" : "Ao conectar o banco de dados!"}';
  end;
end;

procedure TServerMethodDM.ZConnectionAppBeforeConnect(Sender: TObject);
begin
  TZConnection(Sender).Database    := Database;
  TZConnection(Sender).HostName    := Servidor;
  TZConnection(Sender).Port        := Porta_BD;
  TZConnection(Sender).User        := Usuario_BD;
  TZConnection(Sender).Password    := Senha_BD;
  TZConnection(Sender).LoginPrompt := FALSE;
end;


// Execuções dos eventos. ======================================================
procedure TServerMethodDM.DWEvents01EventshoraReplyEvent(var Params: TDWParams;
  var Result: String);
begin
  Result := '{"data": "' + FormatDateTime('dd/mm/yyyyy', Date) + '", "hora": "' + FormatDateTime('hh:nn:ss', Now) + '"}';
end;

procedure TServerMethodDM.DWEvents02EventsclientesReplyEventByType(
  var Params: TDWParams; var Result: String; const RequestType: TRequestType;
  var StatusCode: Integer; RequestHeader: TStringList);
var
 TmpDataset : TZQuery;
begin
  case RequestType of
    // Get.
    rtGet:
      begin
        try
          // Cria uma query temporária.
          TmpDataset := TZQuery.Create(nil);
          TmpDataset.Connection := ZConnectionApp;
          TmpDataset.Close;
          TmpDataset.SQL.Clear;

          // Monta o SQL.
          TmpDataset.SQL.Add('Select nomclie ' +
                             'From clientes where codclie = 0');

          // Transforma a query em JSON e envia para o cliente.
          GetDados(TmpDataset, Params, Params.JsonMode, Result);
        except on ex:exception do
          begin
            Result := '{"status": 500, "message" : "Erro ao gerar as informações!"}';
          end;
        end;
      end;
  end;
end;
end.
