UNIT uDmService;

INTERFACE

USES
  SysUtils,
  Classes,
  URESTDWDatamodule,
  Dialogs,
  RestDWServerFormU,
  DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection,
  uRESTDWDriverZEOS, uRESTDWBasic, uRESTDWAbout, uRESTDWBasicDB,
  uRESTDWServerEvents, uRESTDWServerContext, uRESTDWComponentBase;

Const
 WelcomeSample = False;

TYPE
  TServerMethodDM = CLASS(TServerMethodDataModule)
    RESTDWPoolerDB1: TRESTDWPoolerDB;
    ZConnection1: TZConnection;
    RESTDWDriverZeos1: TRESTDWDriverZeos;
    ZQuery1: TZQuery;
    RESTDWServerEvents1: TRESTDWServerEvents;
    PROCEDURE ServerMethodDataModuleCreate(Sender: TObject);
    procedure ZConnection1BeforeConnect(Sender: TObject);
  PRIVATE
    { Private declarations }
    vIDVenda : Integer;
    vConnectFromClient : Boolean;
    function GetGenID(GenName: String): Integer;
  PUBLIC
    { Public declarations }
  END;

VAR
  ServerMethodDM: TServerMethodDM;

IMPLEMENTATION

{$R *.dfm}

PROCEDURE TServerMethodDM.ServerMethodDataModuleCreate(Sender: TObject);
BEGIN
 vConnectFromClient := False;
 RESTDWPoolerDB1.Active := RestDWForm.CbPoolerState.Checked;
END;

Function TServerMethodDM.GetGenID(GenName  : String): Integer;
Var
 vTempClient : TZQuery;
Begin
 vTempClient := TZQuery.Create(Nil);
 Result      := -1;
 Try
  vTempClient.Connection := ZConnection1;
  vTempClient.SQL.Add(Format('select gen_id(%s, 1)GenID From rdb$database', [GenName]));
  vTempClient.Active := True;
  Result := vTempClient.FindField('GenID').AsInteger;
 Except

 End;
 vTempClient.Free;
End;

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
 If Not vConnectFromClient Then
  Begin
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
End;

END.
