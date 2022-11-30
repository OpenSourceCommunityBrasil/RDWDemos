unit udatamodule;

interface

uses
  SysUtils, Classes, IBConnection, sqldb, DB, Dialogs,

  uRESTDWDatamodule, uRESTDWDataUtils, uRESTDWConsts, uRESTDWServerContext,
  uRESTDWDriverZEOS, uRESTDWServerEvents, uRestDWLazDriver, uRESTDWParams,
  uRESTDWBasicDB,

  ZConnection, ZDataset,
  uprincipal;

type

  { TServerMethodDM }

  TServerMethodDM = class(TServerMethodDataModule)
    DataSource1: TDataSource;
    IBConnection1: TIBConnection;
    RESTDWDriverZeos1: TRESTDWDriverZeos;
    RESTDWLazDriver1: TRESTDWLazDriver;
    RESTDWPoolerZEOS: TRESTDWPoolerDB;
    RESTDWPoolerSQLDB: TRESTDWPoolerDB;
    RESTDWServerEvents: TRESTDWServerEvents;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    procedure DataModuleGetToken(Welcomemsg, AccessTag: string;
      Params: TRESTDWParams; AuthOptions: TRESTDWAuthTokenParam;
      var ErrorCode: integer; var ErrorMessage: string; var TokenID: string;
      var Accept: boolean);
    procedure IBConnection1BeforeConnect(Sender: TObject);
    procedure RESTDWServerEventsEventsservertimeReplyEvent(
      var Params: TRESTDWParams;
      var Result: string);
    procedure ServerMethodDataModuleCreate(Sender: TObject);
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

procedure TServerMethodDM.ServerMethodDataModuleCreate(Sender: TObject);
begin
  RESTDWPoolerZEOS.Active := fPrincipal.cbPoolerState.Checked;
end;

procedure TServerMethodDM.ZConnection1BeforeConnect(Sender: TObject);
var
  Driver_BD: string;
  Porta_BD: string;
  Servidor_BD: string;
  DataBase: string;
  Pasta_BD: string;
  Usuario_BD: string;
  Senha_BD: string;
begin
  database := fPrincipal.EdBD.Text;
  Driver_BD := fPrincipal.CbDriver.Text;
  if fPrincipal.CkUsaURL.Checked then
    Servidor_BD := fPrincipal.EdURL.Text
  else
    Servidor_BD := fPrincipal.DatabaseIP;
  case fPrincipal.CbDriver.ItemIndex of
    0: begin
      Pasta_BD := IncludeTrailingPathDelimiter(fPrincipal.EdPasta.Text);
      Database := fPrincipal.edBD.Text;
      Database := Pasta_BD + Database;
    end;
    1: Database := fPrincipal.EdBD.Text;
  end;
  Porta_BD := fPrincipal.EdPortaBD.Text;
  Usuario_BD := fPrincipal.EdUserNameBD.Text;
  Senha_BD := fPrincipal.EdPasswordBD.Text;
  TZConnection(Sender).Database := Database;
  TZConnection(Sender).HostName := Servidor_BD;
  TZConnection(Sender).Port := StrToInt(Porta_BD);
  TZConnection(Sender).User := Usuario_BD;
  TZConnection(Sender).Password := Senha_BD;
  TZConnection(Sender).LoginPrompt := False;
end;

procedure TServerMethodDM.IBConnection1BeforeConnect(Sender: TObject);
var
  Driver_BD: string;
  Porta_BD: string;
  Servidor_BD: string;
  DataBase: string;
  Pasta_BD: string;
  Usuario_BD: string;
  Senha_BD: string;
begin
  database := fPrincipal.EdBD.Text;
  Driver_BD := fPrincipal.CbDriver.Text;
  if fPrincipal.CkUsaURL.Checked then
    Servidor_BD := fPrincipal.EdURL.Text
  else
    Servidor_BD := fPrincipal.DatabaseIP;
  case fPrincipal.CbDriver.ItemIndex of
    0: begin
      Pasta_BD := IncludeTrailingPathDelimiter(fPrincipal.EdPasta.Text);
      Database := fPrincipal.edBD.Text;
      Database := Pasta_BD + Database;
    end;
    1: Database := fPrincipal.EdBD.Text;
  end;
  Porta_BD := fPrincipal.EdPortaBD.Text;
  Usuario_BD := fPrincipal.EdUserNameBD.Text;
  Senha_BD := fPrincipal.EdPasswordBD.Text;
  TIBConnection(Sender).DatabaseName := Database;
  TIBConnection(Sender).HostName := Servidor_BD;
  //   TIBConnection(Sender).Port        := StrToInt(Porta_BD);
  TIBConnection(Sender).Username := Usuario_BD;
  TIBConnection(Sender).Password := Senha_BD;
  TIBConnection(Sender).LoginPrompt := False;
end;

procedure TServerMethodDM.RESTDWServerEventsEventsservertimeReplyEvent(
  var Params: TRESTDWParams; var Result: string);
begin
  Params.ItemsString['result'].AsDateTime := Now;
end;

procedure TServerMethodDM.DataModuleGetToken(Welcomemsg, AccessTag: string;
  Params: TRESTDWParams; AuthOptions: TRESTDWAuthTokenParam;
  var ErrorCode: integer; var ErrorMessage: string; var TokenID: string;
  var Accept: boolean);
var
  vMyClient, vMyPass: string;
begin
  vMyClient := '';
  vMyPass := vMyClient;
  if (Params.ItemsString['username'] <> nil) and
    (Params.ItemsString['password'] <> nil) then
  begin
    vMyClient := Params.ItemsString['username'].AsString;
    vMyPass := Params.ItemsString['password'].AsString;
  end
  else
  begin
    vMyClient := Copy(Welcomemsg, InitStrPos, Pos('|', Welcomemsg) - 1);
    Delete(Welcomemsg, InitStrPos, Pos('|', Welcomemsg));
    vMyPass := Trim(Welcomemsg);
  end;
  Accept := not ((vMyClient = '') or (vMyPass = ''));
  if Accept then
  begin
    ZQuery1.Close;
    ZQuery1.SQL.Clear;
    ZQuery1.SQL.Add(
      'select * from TB_USUARIO where Upper(NM_LOGIN) = Upper(:NM_LOGIN) and Upper(DS_SENHA) = Upper(:DS_SENHA)');
    try
      ZQuery1.ParamByName('NM_LOGIN').AsString := vMyClient;
      ZQuery1.ParamByName('DS_SENHA').AsString := vMyPass;
      ZQuery1.Open;
    finally
      Accept := not (ZQuery1.EOF);
      if not Accept then
      begin
        ErrorMessage := cInvalidAuth;
        ErrorCode := 401;
      end
      else
        TokenID := AuthOptions.GetToken(Format('{"id":"%s", "login":"%s"}',
          [ZQuery1.FindField('ID_PESSOA').AsString,
          ZQuery1.FindField('NM_LOGIN').AsString]));
      ZQuery1.Close;
    end;
  end
  else
  begin
    ErrorMessage := cInvalidAuth;
    ErrorCode := 401;
  end;
end;


end.
