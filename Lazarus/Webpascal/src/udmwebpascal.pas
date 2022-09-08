unit udmwebpascal;

interface

{$DEFINE APPWIN}

uses
  SysUtils, Classes, IBConnection, sqldb,
  Dialogs, ZConnection, ZDataset, uRESTDWCharSet,
  uRESTDWIdBase, uRESTDWTools, encddecd,
  uRESTDWDatamodule, uRESTDWJSONObject,
  uRESTDWDataUtils, uRESTDWConsts,
  uRESTDWServerEvents, uRESTDWParams,
  uRESTDWAbout, uRESTDWServerContext,
  uRESTDWBasicDB, uRESTDWDriverZEOS,
  uPrincipal;

Const
 WelcomeSample = False;
 Const404Page  = 'www\404.html';
 bl            = #10#13;
 cInvalidChar  = #65533;


type

  { TServerMethodDM }

  TServerMethodDM = class(TServerMethodDataModule)
    dwcrIndex: TRESTDWContextRules;
    dwcrLogin: TRESTDWContextRules;
    dwsCrudServer: TRESTDWServerContext;
    RESTDWDriverZeos1: TRESTDWDriverZeos;
    RESTDWPoolerDB1: TRESTDWPoolerDB;
    rOpenSecrets: TRESTDWClientSQL;
    Server_FDConnection: TZConnection;
    ZQuery1: TZQuery;
    procedure DataModuleGetToken(Welcomemsg, AccessTag: String;
      Params: TRESTDWParams; AuthOptions: TRESTDWAuthTokenParam;
      var ErrorCode: Integer; var ErrorMessage: String; var TokenID: String;
      var Accept: Boolean);
    procedure DataModuleUserTokenAuth(Welcomemsg, AccessTag: String;
      Params: TRESTDWParams; AuthOptions: TRESTDWAuthTokenParam;
      var ErrorCode: Integer; var ErrorMessage: String; var TokenID: String;
      var Accept: Boolean);
    procedure dwcrIndexBeforeRenderer(aSelf: TComponent);
    procedure dwcrIndexItemscadModalBeforeRendererContextItem(
      var ContextItemTag: String);
    procedure dwcrIndexItemsdatatableRequestExecute(const Params: TRESTDWParams;
      var ContentType, Result: String);
    procedure dwcrIndexItemsdeleteModalRequestExecute(const Params: TRESTDWParams;
      var ContentType, Result: String);
    procedure dwcrIndexItemsdwcbCargosRequestExecute(const Params: TRESTDWParams;
      var ContentType, Result: String);
    procedure dwcrIndexItemsdwcbpaisesBeforeRendererContextItem(
      var ContextItemTag: String);
    procedure dwcrIndexItemsdwcbpaisesRequestExecute(const Params: TRESTDWParams;
      var ContentType, Result: String);
    procedure dwcrIndexItemsdwframeBeforeRendererContextItem(
      var ContextItemTag: String);
    procedure dwcrIndexItemsdwmyhtmlRequestExecute(const Params: TRESTDWParams;
      var ContentType, Result: String);
    procedure dwcrIndexItemsdwsidemenuBeforeRendererContextItem(
      var ContextItemTag: String);
    procedure dwcrIndexItemseditModalRequestExecute(const Params: TRESTDWParams;
      var ContentType, Result: String);
    procedure dwcrIndexItemsLabelMenuBeforeRendererContextItem(
      var ContextItemTag: String);
    procedure dwcrIndexItemsmeuloginnameBeforeRendererContextItem(
      var ContextItemTag: String);
    procedure dwcrIndexItemsoperationRequestExecute(const Params: TRESTDWParams;
      var ContentType, Result: String);
    procedure dwcrLoginBeforeRenderer(aSelf: TComponent);
    procedure dwcrLoginItemsmeuloginnameBeforeRendererContextItem(
      var ContextItemTag: String);
    procedure dwsCrudServerBeforeRenderer(aSelf: TComponent);
    procedure Server_FDConnectionBeforeConnect(Sender: TObject);
  private
    { Private declarations }
    IDUser     : Integer;
    IDUserName,
    vTokenID   : String;
    Function MyMenu: String;
  public
    { Public declarations }
  end;

var
  ServerMethodDM: TServerMethodDM;

implementation

//uses uRESTDWConstsCharset;
{$R *.lfm}

Function LoadHTMLFile(FileName : String) : String;
Var
 vStringCad : TStringList;
begin
 vStringCad := TStringList.Create;
 Try
  vStringCad.LoadFromFile(FileName);
  Result := utf8decode(vStringCad.Text);
 Finally
  vStringCad.Free;
 End;
end;

Function SwapHTMLDateToDelphiDate(Value : String) : String;
Begin
 Result := Value;
 If Pos('-', Value) > 0 Then
  Begin
   Result := Copy(Value, 1, Pos('-', Value) -1);
   Delete(Value, 1, Pos('-', Value));
   Result := Copy(Value, 1, Pos('-', Value) -1) + '/' + Result;
   Delete(Value, 1, Pos('-', Value));
   Result := Copy(Value, 1, Length(Value)) + '/' + Result;
  End;
End;

procedure TServerMethodDM.Server_FDConnectionBeforeConnect(Sender: TObject);
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
   TZConnection(Sender).LibraryLocation := IncludeTrailingPathDelimiter(ExtractFilePath(ParamSTR(0))) + '\DataBase\fbclient.dll';
End;

procedure TServerMethodDM.DataModuleGetToken(Welcomemsg, AccessTag: String;
  Params: TRESTDWParams; AuthOptions: TRESTDWAuthTokenParam; var ErrorCode: Integer;
  var ErrorMessage: String; var TokenID: String; var Accept: Boolean);
Var
 vMyClient,
 vTokenID,
 vMyPass,
 vIddToken    : String;
 Function RejectURL : String;
 Var
  v404Error  : TStringList;
 Begin
  v404Error  := TStringList.Create;
  Try
   {$IFDEF APPWIN}
    {$IFDEF SYNOPSE}
     v404Error.LoadFromFile(RestDWForm.RESTDWServiceSynPooler1.RootPath + Const404Page);
    {$ELSE}
     v404Error.LoadFromFile(RestDWForm.RESTDWIdServicePooler1.RootPath + Const404Page);
    {$ENDIF}
   {$ELSE}
   v404Error.LoadFromFile('.\www\' + Const404Page);
   {$ENDIF}
   Result := v404Error.Text;
  Finally
   v404Error.Free;
  End;
 End;
begin
 vTokenID   := TokenID;
 If Pos('bearer', lowercase(vTokenID)) > 0 Then
 begin
  vTokenID  := Trim(Copy(vTokenID, Pos('bearer', lowercase(vTokenID)) + 6, Length(vTokenID)));
  vTokenID  := encddecd.DecodeString(vTokenID);
 end Else
   vTokenID  := StringReplace(encddecd.DecodeString(Trim(Copy(vTokenID, Pos('basic', lowercase(vTokenID)) + 5, Length(vTokenID)))), cInvalidChar, '', [rfReplaceAll]);
 vMyClient  := Copy(vTokenID, InitStrPos, Pos(':', vTokenID) -1);
 Delete(vTokenID, InitStrPos, Pos(':', vTokenID));
 vMyPass    := Trim(vTokenID);
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

procedure TServerMethodDM.DataModuleUserTokenAuth(Welcomemsg,
  AccessTag: String; Params: TRESTDWParams; AuthOptions: TRESTDWAuthTokenParam;
  var ErrorCode: Integer; var ErrorMessage: String; var TokenID: String;
  var Accept: Boolean);
Var
 vSecrets : String;
 vUserID : Integer;
 Function RejectURL : String;
 Var
  v404Error  : TStringList;
 Begin
  v404Error  := TStringList.Create;
  Try
   {$IFDEF APPWIN}
    {$IFDEF SYNOPSE}
     v404Error.LoadFromFile(RestDWForm.RESTDWServiceSynPooler1.RootPath + Const404Page);
    {$ELSE}
     v404Error.LoadFromFile(RestDWForm.RESTDWIdServicePooler1.RootPath + Const404Page);
    {$ENDIF}
   {$ELSE}
   v404Error.LoadFromFile('.\www\' + Const404Page);
   {$ENDIF}
   Result := v404Error.Text;
  Finally
   v404Error.Free;
  End;
 End;
begin
 Accept  := TokenID <> '';
 If Accept Then
  Begin
   rOpenSecrets.OpenJson(AuthOptions.Secrets);
   vSecrets := rOpenSecrets.FindField('secrets').AsString;
   rOpenSecrets.Close;
   rOpenSecrets.OpenJson(encddecd.DecodeString(vSecrets));
   vUserID := rOpenSecrets.FindField('ID').AsInteger;
   rOpenSecrets.Close;
   ZQuery1.Close;
   ZQuery1.SQL.Clear;
   ZQuery1.SQL.Add('select * from TB_USUARIO where ID_PESSOA = :ID');
   Try
    ZQuery1.ParamByName('ID').AsInteger := vUserID;
    ZQuery1.Open;
    IDUser     := ZQuery1.FindField('ID_PESSOA').AsInteger;
    IDUserName := ZQuery1.FindField('NM_LOGIN').AsString;
   Finally
    Accept  := Not ZQuery1.EOF;
    If Not Accept Then
     Begin
      ErrorMessage := RejectURL;
      ErrorCode  := 404;
     End;
    ZQuery1.Close;
   End;
  End
 Else
  Begin
   ErrorMessage := RejectURL;
   ErrorCode  := 404;
  End;
end;

procedure TServerMethodDM.dwcrIndexBeforeRenderer(aSelf: TComponent);
begin
 TRESTDWContextRules(aSelf).MasterHtml.LoadFromFile('.\www\templates\index.html');
end;

procedure TServerMethodDM.dwcrIndexItemscadModalBeforeRendererContextItem(
  var ContextItemTag: String);
begin
 ContextItemTag := LoadHTMLFile('.\www\templates\cademployee.html');
end;

procedure TServerMethodDM.dwcrIndexItemsdatatableRequestExecute(
  const Params: TRESTDWParams; var ContentType, Result: String);
Var
 JSONValue :  TJSONValue;
begin
 JSONValue := TJSONValue.Create;
 Try
  ZQuery1.Close;
  ZQuery1.SQL.Clear;
  ZQuery1.SQL.Add('select * from employee');
  Try
   ZQuery1.Open;
   JSONValue.DataMode := dmRAW;
   JSONValue.Encoding := Encoding;
   JSONValue.LoadFromDataset('', ZQuery1, False,  JSONValue.DataMode, 'dd/mm/yyyy', '.');
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

procedure TServerMethodDM.dwcrIndexItemsdeleteModalRequestExecute(
  const Params: TRESTDWParams; var ContentType, Result: String);
begin
 result := 'true';
 ZQuery1.Close;
 ZQuery1.SQL.Clear;
 ZQuery1.SQL.Add('delete from employee where emp_no = ' + Params.ItemsString['id'].AsString);
 Server_FDConnection.StartTransaction;
 Try
  ZQuery1.ExecSQL;
  Server_FDConnection.Commit;
 Except
  Server_FDConnection.Rollback;
  result := 'false';
 End;
end;

procedure TServerMethodDM.dwcrIndexItemsdwcbCargosRequestExecute(
  const Params: TRESTDWParams; var ContentType, Result: String);
Var
 JSONValue :  TJSONValue;
begin
 JSONValue            := TJSONValue.Create;
 Try
  ZQuery1.Close;
  ZQuery1.SQL.Clear;
  ZQuery1.SQL.Add('select JOB_GRADE, (JOB_COUNTRY ||''/''|| JOB_TITLE)JOB_TITLE from JOB');
  Try
   ZQuery1.Open;
   JSONValue.DataMode := dmRAW;
   JSONValue.Encoding := Encoding;
   JSONValue.LoadFromDataset('', ZQuery1, False,  JSONValue.DataMode, 'dd/mm/yyyy', '.');
   Result             := JSONValue.ToJson;
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

procedure TServerMethodDM.dwcrIndexItemsdwcbpaisesBeforeRendererContextItem(
  var ContextItemTag: String);
begin
 ZQuery1.Close;
 ZQuery1.SQL.Clear;
 ZQuery1.SQL.Add('select * from COUNTRY');
 ZQuery1.Open;
 ContextItemTag := ContextItemTag + '<option value="" >Selecione seu país</option>';
 While Not ZQuery1.EOF Do
  Begin
   ContextItemTag := ContextItemTag + Format('<option value="%s">%s</option>', [ZQuery1.FindField('UF').AsString,
                                                                                ZQuery1.FindField('COUNTRY').AsString]);
   ZQuery1.Next;
  End;
 ContextItemTag := ContextItemTag + '</select>';
 ZQuery1.Close;
end;

procedure TServerMethodDM.dwcrIndexItemsdwcbpaisesRequestExecute(
  const Params: TRESTDWParams; var ContentType, Result: String);
Var
 JSONValue :  TJSONValue;
begin
 JSONValue            := TJSONValue.Create;
 Try
  ZQuery1.Close;
  ZQuery1.SQL.Clear;
  ZQuery1.SQL.Add('select UF, COUNTRY from COUNTRY');
  Try
   ZQuery1.Open;
   JSONValue.DataMode := dmRAW;
   JSONValue.Encoding := Encoding;
   JSONValue.LoadFromDataset('', ZQuery1, False,  JSONValue.DataMode, 'dd/mm/yyyy', '.');
   Result             := JSONValue.ToJson;
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

procedure TServerMethodDM.dwcrIndexItemsdwframeBeforeRendererContextItem(
  var ContextItemTag: String);
begin
 ContextItemTag := LoadHTMLFile(IncludeTrailingPathDelimiter(ExtractFilePath(ParamSTR(0))) + 'www\templates\dataFrame.html');
end;

procedure TServerMethodDM.dwcrIndexItemsdwmyhtmlRequestExecute(
  const Params: TRESTDWParams; var ContentType, Result: String);
begin
 ContentType := 'text/html';
 If Params.ItemsString['myhtml'] <> Nil Then
  Result := LoadHTMLFile('www\templates\' + Params.ItemsString['myhtml'].AsString + '.html');
end;

procedure TServerMethodDM.dwcrIndexItemsdwsidemenuBeforeRendererContextItem(
  var ContextItemTag: String);
begin
 ContextItemTag := ContextItemTag + MyMenu;
end;

procedure TServerMethodDM.dwcrIndexItemseditModalRequestExecute(
  const Params: TRESTDWParams; var ContentType, Result: String);
Var
 JSONValue :  TJSONValue;
begin
 JSONValue            := TJSONValue.Create;
 Try
  ZQuery1.Close;
  ZQuery1.SQL.Clear;
  ZQuery1.SQL.Add('select * from employee where emp_no = '+params.ItemsString['id'].AsString);

  Try
   ZQuery1.Open;
   JSONValue.DataMode := dmRAW;
   JSONValue.Encoding := Encoding;
   JSONValue.LoadFromDataset('', ZQuery1, False,  JSONValue.DataMode, 'dd/mm/yyyy', '.');
   Result             := JSONValue.ToJson;
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

procedure TServerMethodDM.dwcrIndexItemsLabelMenuBeforeRendererContextItem(
  var ContextItemTag: String);
begin
 If IDUser > 0 then
  ContextItemTag := MyMenu;
end;

procedure TServerMethodDM.dwcrIndexItemsmeuloginnameBeforeRendererContextItem(
  var ContextItemTag: String);
begin
 ContextItemTag := Format('<p id="mynamepan" idd="%d">%s</p>', [IDUser, IDUserName]);
end;

procedure TServerMethodDM.dwcrIndexItemsoperationRequestExecute(
  const Params: TRESTDWParams; var ContentType, Result: String);
begin
 Result := 'true';
 Server_FDConnection.StartTransaction;
 ZQuery1.Close;
 ZQuery1.SQL.Clear;
 If Params.ItemsString['operation'].AsString = 'edit' Then
  ZQuery1.SQL.Add('update employee set FIRST_NAME = :FIRST_NAME, LAST_NAME = :LAST_NAME, ' +
                   'PHONE_EXT = :PHONE_EXT, HIRE_DATE = :HIRE_DATE, DEPT_NO = :DEPT_NO, ' +
                   'JOB_CODE  = :JOB_CODE, JOB_GRADE = :JOB_GRADE, JOB_COUNTRY = :JOB_COUNTRY, ' +
                   'SALARY = :SALARY ' +
                   'Where EMP_NO = ' + Params.ItemsString['id'].AsString)
 Else If Params.ItemsString['operation'].AsString = 'insert' Then
  ZQuery1.SQL.Add('insert into employee (EMP_NO, FIRST_NAME, LAST_NAME, ' +
                                          'PHONE_EXT, HIRE_DATE, DEPT_NO, ' +
                                          'JOB_CODE, JOB_GRADE, JOB_COUNTRY, SALARY) ' +
                   'VALUES (gen_id(emp_no_gen, 1), :FIRST_NAME, :LAST_NAME, :PHONE_EXT, :HIRE_DATE, :DEPT_NO, :JOB_CODE, ' +
                           ':JOB_GRADE, :JOB_COUNTRY, :SALARY)')
 Else If Params.ItemsString['operation'].AsString = 'delete' Then
  ZQuery1.SQL.Add('delete from employee Where EMP_NO = ' + Params.ItemsString['id'].AsString);
 Try
  If Params.ItemsString['operation'].AsString <> 'delete' Then
   Begin
    ZQuery1.ParamByName('FIRST_NAME').AsString  := Params.ItemsString['FIRST_NAME'].AsString;
    ZQuery1.ParamByName('LAST_NAME').AsString   := Params.ItemsString['LAST_NAME'].AsString;
    ZQuery1.ParamByName('PHONE_EXT').AsString   := StringReplace(StringReplace(Params.ItemsString['PHONE_EXT'].AsString, '(', '', [rfReplaceAll]), ')', '', [rfReplaceAll]);
    ZQuery1.ParamByName('DEPT_NO').AsString     := '600';
    ZQuery1.ParamByName('JOB_CODE').AsString    := 'Vp';
    ZQuery1.ParamByName('HIRE_DATE').AsDateTime := StrToDate(SwapHTMLDateToDelphiDate(Params.ItemsString['HIRE_DATE'].asstring));
    ZQuery1.ParamByName('JOB_GRADE').AsString   := Params.ItemsString['JOB_GRADE'].AsString;
    ZQuery1.ParamByName('JOB_COUNTRY').AsString := Params.ItemsString['JOB_COUNTRY'].AsString;
    ZQuery1.ParamByName('SALARY').AsFloat       := Params.ItemsString['SALARY'].AsFloat;
   End;
  ZQuery1.ExecSQL;
  Server_FDConnection.Commit;
 Except
  On E : Exception Do
    Begin
     Server_FDConnection.Rollback;
     Result := 'false';
    End;
 End;
end;

procedure TServerMethodDM.dwcrLoginBeforeRenderer(aSelf: TComponent);
begin
 TRESTDWContextRules(aSelf).MasterHtml.LoadFromFile('.\www\templates\login.html');
end;

procedure TServerMethodDM.dwcrLoginItemsmeuloginnameBeforeRendererContextItem(
  var ContextItemTag: String);
begin
 ContextItemTag := Format('<p id="mynamepan" idd="%d">%s</p>', [IDUser, IDUserName]);
end;

procedure TServerMethodDM.dwsCrudServerBeforeRenderer(aSelf: TComponent);
begin
 TRESTDWServerContext(aSelf).BaseHeader.LoadFromFile('.\www\templates\master.html');
 TRESTDWServerContext(aSelf).BaseHeader.text := utf8decode(TRESTDWServerContext(aSelf).BaseHeader.text);
end;

Function TServerMethodDM.MyMenu: String;
Begin
 If (IDUser > 0) Then
  Result := Format('<li class="active"><a href=# onClick="newEmployee()"><i class="fa fa-address-book"></i> <span>Novo Empregado</span></a></li>'    + bl +
                   '<li class="active"><a href=# onClick="reloadDatatable(true)"><i class="fa fa-users"></i> <span>Lista de Empregados</span></a></li>' + bl +
                   '<li class="active"><a href="./login"><i class="fa fa-sign-out"></i> <span>Logout</span></a></li>', [Uppercase(IDUserName)])
 Else
  Result := '';
End;

end.
