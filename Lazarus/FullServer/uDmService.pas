unit uDmService;

interface

uses
  SysUtils, Classes, IBConnection, sqldb, db, uRESTDWDatamodule, Dialogs,
  ZConnection, ZDataset, uRESTDWDataUtils, uRESTDWConsts, RestDWServerFormU,
  uRESTDWServerEvents, uRESTDWServerContext, uRESTDWBasicDB, uRESTDWZeosDriver,
  uRESTDWParams, uRESTDWLazarusDriver;

type

  { TServerMethodDM }

  TServerMethodDM = class(TServerMethodDataModule)
    DataSource1: TDataSource;
    IBConnection1: TIBConnection;
    RESTDWLazarusDriver1: TRESTDWLazarusDriver;
    RESTDWPoolerZEOS: TRESTDWPoolerDB;
    RESTDWPoolerSQLDB: TRESTDWPoolerDB;
    RESTDWServerEvents: TRESTDWServerEvents;
    RESTDWZeosDriver1: TRESTDWZeosDriver;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    procedure DataModuleGetToken(Welcomemsg, AccessTag: String;
      Params: TRESTDWParams; AuthOptions: TRESTDWAuthTokenParam;
      var ErrorCode: Integer; var ErrorMessage: String; var TokenID: String;
      var Accept: Boolean);
    procedure IBConnection1BeforeConnect(Sender: TObject);
    procedure RESTDWServerEventsEventsservertimeReplyEvent(
      var Params: TRESTDWParams; var Result: String);
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
 RESTDWPoolerZEOS.Active := RestDWForm.cbPoolerState.Checked;
end;

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
   database:= RestDWForm.EdBD.Text;
   Driver_BD := RestDWForm.CbDriver.Text;
   If RestDWForm.CkUsaURL.Checked Then
    Servidor_BD := RestDWForm.EdURL.Text
   Else
    Servidor_BD := RestDWForm.DatabaseIP;
   Case RestDWForm.CbDriver.ItemIndex Of
    0 : Begin
         Pasta_BD := IncludeTrailingPathDelimiter(RestDWForm.EdPasta.Text);
         Database := RestDWForm.edBD.Text;
         Database := Pasta_BD + Database;
        End;
    1 : Database := RestDWForm.EdBD.Text;
   End;
   Porta_BD   := RestDWForm.EdPortaBD.Text;
   Usuario_BD := RestDWForm.EdUserNameBD.Text;
   Senha_BD   := RestDWForm.EdPasswordBD.Text;
   TZConnection(Sender).Database := Database;
   TZConnection(Sender).HostName := Servidor_BD;
   TZConnection(Sender).Port     := StrToInt(Porta_BD);
   TZConnection(Sender).User     := Usuario_BD;
   TZConnection(Sender).Password := Senha_BD;
   TZConnection(Sender).LoginPrompt := FALSE;
End;

procedure TServerMethodDM.IBConnection1BeforeConnect(Sender: TObject);
VAR
  Driver_BD: STRING;
  Porta_BD: STRING;
  Servidor_BD: STRING;
  DataBase: STRING;
  Pasta_BD: STRING;
  Usuario_BD: STRING;
  Senha_BD: STRING;
BEGIN
   database:= RestDWForm.EdBD.Text;
   Driver_BD := RestDWForm.CbDriver.Text;
   If RestDWForm.CkUsaURL.Checked Then
    Servidor_BD := RestDWForm.EdURL.Text
   Else
    Servidor_BD := RestDWForm.DatabaseIP;
   Case RestDWForm.CbDriver.ItemIndex Of
    0 : Begin
         Pasta_BD := IncludeTrailingPathDelimiter(RestDWForm.EdPasta.Text);
         Database := RestDWForm.edBD.Text;
         Database := Pasta_BD + Database;
        End;
    1 : Database := RestDWForm.EdBD.Text;
   End;
   Porta_BD   := RestDWForm.EdPortaBD.Text;
   Usuario_BD := RestDWForm.EdUserNameBD.Text;
   Senha_BD   := RestDWForm.EdPasswordBD.Text;
   TIBConnection(Sender).DatabaseName := Database;
   TIBConnection(Sender).HostName    := Servidor_BD;
//   TIBConnection(Sender).Port        := StrToInt(Porta_BD);
   TIBConnection(Sender).Username    := Usuario_BD;
   TIBConnection(Sender).Password    := Senha_BD;
   TIBConnection(Sender).LoginPrompt := FALSE;
End;

procedure TServerMethodDM.RESTDWServerEventsEventsservertimeReplyEvent(
  var Params: TRESTDWParams; var Result: String);
begin
 Params.ItemsString['result'].AsDateTime := Now;
end;

procedure TServerMethodDM.DataModuleGetToken(Welcomemsg, AccessTag: String;
  Params: TRESTDWParams; AuthOptions: TRESTDWAuthTokenParam;
  var ErrorCode: Integer; var ErrorMessage: String; var TokenID: String;
  var Accept: Boolean);
Var
 vMyClient,
 vMyPass    : String;
begin
 vMyClient  := '';
 vMyPass    := vMyClient;
 If (Params.ItemsString['username'] <> Nil) And
    (Params.ItemsString['password'] <> Nil) Then
  Begin
   vMyClient  := Params.ItemsString['username'].AsString;
   vMyPass    := Params.ItemsString['password'].AsString;
  End
 Else
  Begin
   vMyClient  := Copy(Welcomemsg, InitStrPos, Pos('|', Welcomemsg) -1);
   Delete(Welcomemsg, InitStrPos, Pos('|', Welcomemsg));
   vMyPass    := Trim(Welcomemsg);
  End;
 Accept     := Not ((vMyClient = '') Or
                    (vMyPass   = ''));
 If Accept Then
  Begin
   ZQuery1.Close;
   ZQuery1.SQL.Clear;
   ZQuery1.SQL.Add('select * from TB_USUARIO where Upper(NM_LOGIN) = Upper(:NM_LOGIN) and Upper(DS_SENHA) = Upper(:DS_SENHA)');
   Try
    ZQuery1.ParamByName('NM_LOGIN').AsString := vMyClient;
    ZQuery1.ParamByName('DS_SENHA').AsString := vMyPass;
    ZQuery1.Open;
   Finally
    Accept     := Not(ZQuery1.EOF);
    If Not Accept Then
     Begin
      ErrorMessage := cInvalidAuth;
      ErrorCode  := 401;
     End
    Else
     TokenID := AuthOptions.GetToken(Format('{"id":"%s", "login":"%s"}', [ZQuery1.FindField('ID_PESSOA').AsString,
                                                                          ZQuery1.FindField('NM_LOGIN').AsString]));
    ZQuery1.Close;
   End;
  End
 Else
  Begin
   ErrorMessage := cInvalidAuth;
   ErrorCode  := 401;
  End;
end;


end.
