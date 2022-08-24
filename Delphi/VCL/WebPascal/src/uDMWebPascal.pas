Unit uDMWebPascal;

Interface

{$DEFINE APPWIN}
{ .$DEFINE SYNOPSE }

Uses
  SysUtils, Classes, System.IOUtils, System.JSON, Data.DB,

  FireDAC.Dapt, FireDAC.Phys.FBDef, FireDAC.UI.Intf, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Comp.Client, FireDAC.Comp.UI, FireDAC.Phys.IBBase,
  FireDAC.Stan.StorageJSON, FireDAC.Phys.MSSQLDef, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSSQL, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.Dapt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL,
  FireDAC.Phys.PGDef, FireDAC.Phys.PG,

  uRESTDWDatamodule, uRESTDWMassiveBuffer, uRESTDWJSONObject, uRESTDWDataUtils,
  uRESTDWDriverFD, uRESTDWConsts, uRESTDWServerEvents, uRESTDWAbout,
  uRESTDWServerContext, uRESTDWBasicTypes, uRESTDWBasicDB, uRESTDWBasic,
  uRESTDWComponentBase, uRESTDWParams, uRESTDWTools

    ;

Const
  WelcomeSample = False;
  Const404Page = 'www\404.html';
  bl = #10#13;
  cInvalidChar = #65533;

Type
  TDMWebPascal = Class(TServerMethodDataModule)
    RESTDWPoolerDB1: TRESTDWPoolerDB;
    RESTDWDriverFD1: TRESTDWDriverFD;
    Server_FDConnection: TFDConnection;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    FDTransaction1: TFDTransaction;
    FDQuery1: TFDQuery;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    dwsCrudServer: TRESTDWServerContext;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    dwcrIndex: TRESTDWContextRules;
    dwcrLogin: TRESTDWContextRules;
    rOpenSecrets: TRESTDWClientSQL;
    Procedure ServerMethodDataModuleCreate(Sender: TObject);
    Procedure Server_FDConnectionBeforeConnect(Sender: TObject);
    procedure dwcrIndexItemsdatatableRequestExecute(const Params: TRESTDWParams;
      var ContentType, Result: string);
    procedure dwcrIndexItemseditModalRequestExecute(const Params: TRESTDWParams;
      var ContentType, Result: string);
    procedure dwcrIndexItemsdeleteModalRequestExecute
      (const Params: TRESTDWParams; var ContentType, Result: string);
    procedure dwcrIndexItemsoperationRequestExecute(const Params: TRESTDWParams;
      var ContentType, Result: string);
    procedure dwcrIndexItemsdwcbPaisesBeforeRendererContextItem
      (var ContextItemTag: string);
    procedure dwcrIndexItemsdwsidemenuBeforeRendererContextItem
      (var ContextItemTag: string);
    procedure dwcrIndexBeforeRenderer(aSelf: TComponent);
    procedure dwcrLoginBeforeRenderer(aSelf: TComponent);
    procedure dwcrIndexItemscadModalBeforeRendererContextItem
      (var ContextItemTag: string);
    procedure dwsCrudServerBeforeRenderer(aSelf: TComponent);
    procedure dwcrLoginItemsmeuloginnameBeforeRendererContextItem
      (var ContextItemTag: string);
    procedure dwcrIndexItemsmeuloginnameBeforeRendererContextItem
      (var ContextItemTag: string);
    procedure dwcrIndexItemsLabelMenuBeforeRendererContextItem
      (var ContextItemTag: string);
    procedure dwcrIndexItemsdwmyhtmlRequestExecute(const Params: TRESTDWParams;
      var ContentType, Result: string);
    procedure dwcrIndexItemsdwframeBeforeRendererContextItem
      (var ContextItemTag: string);
    procedure dwcrIndexItemsdwcbPaisesRequestExecute(const Params
      : TRESTDWParams; var ContentType, Result: string);
    procedure dwcrIndexItemsdwcbCargosRequestExecute(const Params
      : TRESTDWParams; var ContentType, Result: string);
    procedure ServerMethodDataModuleGetToken(Welcomemsg, AccessTag: string;
      Params: TRESTDWParams; AuthOptions: TRESTDWAuthTokenParam;
      var ErrorCode: Integer; var ErrorMessage, TokenID: string;
      var Accept: Boolean);
    procedure ServerMethodDataModuleUserTokenAuth(Welcomemsg, AccessTag: string;
      Params: TRESTDWParams; AuthOptions: TRESTDWAuthTokenParam;
      var ErrorCode: Integer; var ErrorMessage, TokenID: string;
      var Accept: Boolean);
    procedure dwsCrudServerContextListindex2BeforeRenderer(const BaseHeader
      : string; var ContentType, ContentRenderer: string;
      const RequestType: TRequestType);
  Private
    { Private declarations }
    IDUser: Integer;
    IDUserName: String;
    Function MyMenu: String;
  Public
    { Public declarations }
  End;

Var
  DMWebPascal: TDMWebPascal;

Implementation

uses
{$IFDEF APPWIN}
  uPrincipal;
{$ELSE}
  uConsts;
{$ENDIF}
{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

Function LoadHTMLFile(FileName: String): String;
Var
  vStringCad: TStringList;
begin
  vStringCad := TStringList.Create;
  Try
    vStringCad.LoadFromFile(FileName);
    Result := UTF8ToString(vStringCad.Text);
  Finally
    vStringCad.Free;
  End;
end;

Function SwapHTMLDateToDelphiDate(Value: String): String;
Begin
  Result := Value;
  If Pos('-', Value) > 0 Then
  Begin
    Result := Copy(Value, 1, Pos('-', Value) - 1);
    Delete(Value, 1, Pos('-', Value));
    Result := Copy(Value, 1, Pos('-', Value) - 1) + '/' + Result;
    Delete(Value, 1, Pos('-', Value));
    Result := Copy(Value, 1, Length(Value)) + '/' + Result;
  End;
End;

procedure TDMWebPascal.dwcrIndexBeforeRenderer(aSelf: TComponent);
begin
  TRESTDWContextRules(aSelf).MasterHtml.LoadFromFile
    ('.\www\templates\index.html');
end;

procedure TDMWebPascal.dwcrIndexItemscadModalBeforeRendererContextItem
  (var ContextItemTag: string);
begin
  ContextItemTag := LoadHTMLFile('.\www\templates\cademployee.html');
end;

procedure TDMWebPascal.dwcrIndexItemsdatatableRequestExecute
  (const Params: TRESTDWParams; var ContentType, Result: string);
Var
  JSONValue: TJSONValue;
begin
  JSONValue := TJSONValue.Create;
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

procedure TDMWebPascal.dwcrIndexItemsdeleteModalRequestExecute
  (const Params: TRESTDWParams; var ContentType, Result: string);
begin
  Result := 'true';
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('delete from employee where emp_no = ' + Params.ItemsString
    ['id'].AsString);
  Try
    FDQuery1.ExecSQL;
    Server_FDConnection.CommitRetaining;
  Except
    Server_FDConnection.Rollback;
    Result := 'false';
  End;
end;

procedure TDMWebPascal.dwcrIndexItemsdwcbCargosRequestExecute
  (const Params: TRESTDWParams; var ContentType, Result: string);
Var
  JSONValue: TJSONValue;
begin
  JSONValue := TJSONValue.Create;
  Try
    FDQuery1.Close;
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add
      ('select JOB_GRADE, (JOB_COUNTRY ||''/''|| JOB_TITLE)JOB_TITLE from JOB');
    Try
      FDQuery1.Open;
      JSONValue.DataMode := dmRAW;
      JSONValue.Encoding := Encoding;
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

procedure TDMWebPascal.dwcrIndexItemsdwcbPaisesBeforeRendererContextItem
  (var ContextItemTag: string);
begin
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from COUNTRY');
  FDQuery1.Open;
  ContextItemTag := ContextItemTag +
    '<option value="" >Selecione seu país</option>';
  While Not FDQuery1.EOF Do
  Begin
    ContextItemTag := ContextItemTag + Format('<option value="%s">%s</option>',
      [FDQuery1.FindField('UF').AsString, FDQuery1.FindField('COUNTRY')
      .AsString]);
    FDQuery1.Next;
  End;
  ContextItemTag := ContextItemTag + '</select>';
  FDQuery1.Close;
end;

procedure TDMWebPascal.dwcrIndexItemsdwcbPaisesRequestExecute
  (const Params: TRESTDWParams; var ContentType, Result: string);
Var
  JSONValue: TJSONValue;
begin
  JSONValue := TJSONValue.Create;
  Try
    FDQuery1.Close;
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('select UF, COUNTRY from COUNTRY');
    Try
      FDQuery1.Open;
      JSONValue.DataMode := dmRAW;
      JSONValue.Encoding := Encoding;
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

procedure TDMWebPascal.dwcrIndexItemsdwframeBeforeRendererContextItem
  (var ContextItemTag: string);
begin
  ContextItemTag := LoadHTMLFile
    (System.IOUtils.TPath.Combine(ExtractFilePath(ParamSTR(0)),
    'www\templates\dataFrame.html'));
end;

procedure TDMWebPascal.dwcrIndexItemsdwmyhtmlRequestExecute
  (const Params: TRESTDWParams; var ContentType, Result: string);
begin
  ContentType := 'text/html';
  If Params.ItemsString['myhtml'] <> Nil Then
    Result := LoadHTMLFile('www\templates\' + Params.ItemsString['myhtml']
      .AsString + '.html');
end;

procedure TDMWebPascal.dwcrIndexItemsdwsidemenuBeforeRendererContextItem
  (var ContextItemTag: string);
begin
  ContextItemTag := ContextItemTag + MyMenu;
end;

procedure TDMWebPascal.dwcrIndexItemseditModalRequestExecute
  (const Params: TRESTDWParams; var ContentType, Result: string);
Var
  JSONValue: TJSONValue;
begin
  JSONValue := TJSONValue.Create;
  Try
    FDQuery1.Close;
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('select * from employee where emp_no = ' +
      Params.ItemsString['id'].AsString);
    Try
      FDQuery1.Open;
      JSONValue.DataMode := dmRAW;
      JSONValue.Encoding := Encoding;
      JSONValue.LoadFromDataset('', FDQuery1, False, JSONValue.DataMode,
        'dd/mm/yyyy', ',');
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

Function TDMWebPascal.MyMenu: String;
Begin
  If (IDUser > 0) Then
    Result := '<li class="nav-item menu-open"><a href="#" class="nav-link" onClick="newEmployee()"><i class="nav-icon far fa-image"></i><p>Novo Empregado</p></a></li>'
      + '<li class="nav-item menu-open"><a href="#" class="nav-link" onClick="reloadDatatable(true)"><i class="nav-icon far fa-image"></i><p>Lista de Empregados</p></a></li>'
      + '<li class="nav-item menu-open"><a href="#" class="nav-link" onClick="logout()"><i class="nav-icon far fa-image"></i><p>Logout<i class="right fas fa-angle-left"></i></p></a></li>'
  Else
    Result := '';
End;

procedure TDMWebPascal.dwcrIndexItemsLabelMenuBeforeRendererContextItem
  (var ContextItemTag: string);
begin
  If IDUser > 0 then
    ContextItemTag := MyMenu;
end;

procedure TDMWebPascal.dwcrIndexItemsmeuloginnameBeforeRendererContextItem
  (var ContextItemTag: string);
begin
  ContextItemTag :=
    Format('<a id="mynamepan" idd="%d" href="#" class="d-block">%s</a>',
    [IDUser, IDUserName]);
end;

procedure TDMWebPascal.dwcrIndexItemsoperationRequestExecute
  (const Params: TRESTDWParams; var ContentType, Result: string);
Var
  vSalary: String;
  Function LimpaLixo(Value: String): String;
  Begin
    Result := Value;
    Result := StringReplace(Result, 'R', '', [rfReplaceAll]);
    Result := StringReplace(Result, '$', '', [rfReplaceAll]);
    Result := StringReplace(Result, ' ', '', [rfReplaceAll]);
    Result := StringReplace(Result, '.', '', [rfReplaceAll]);
  End;

begin
  Result := 'true';
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  If Params.ItemsString['operation'].AsString = 'edit' Then
    FDQuery1.SQL.Add
      ('update employee set FIRST_NAME = :FIRST_NAME, LAST_NAME = :LAST_NAME, '
      + 'PHONE_EXT = :PHONE_EXT, HIRE_DATE = :HIRE_DATE, DEPT_NO = :DEPT_NO, ' +
      'JOB_CODE  = :JOB_CODE, JOB_GRADE = :JOB_GRADE, JOB_COUNTRY = :JOB_COUNTRY, '
      + 'SALARY = :SALARY ' + 'Where EMP_NO = ' + Params.ItemsString
      ['id'].AsString)
  Else If Params.ItemsString['operation'].AsString = 'insert' Then
    FDQuery1.SQL.Add('insert into employee (EMP_NO, FIRST_NAME, LAST_NAME, ' +
      'PHONE_EXT, HIRE_DATE, DEPT_NO, ' +
      'JOB_CODE, JOB_GRADE, JOB_COUNTRY, SALARY) ' +
      'VALUES (gen_id(emp_no_gen, 1), :FIRST_NAME, :LAST_NAME, :PHONE_EXT, :HIRE_DATE, :DEPT_NO, :JOB_CODE, '
      + ':JOB_GRADE, :JOB_COUNTRY, :SALARY)')
  Else If Params.ItemsString['operation'].AsString = 'delete' Then
    FDQuery1.SQL.Add('delete from employee Where EMP_NO = ' + Params.ItemsString
      ['id'].AsString);
  Try
    If Params.ItemsString['operation'].AsString <> 'delete' Then
    Begin
      FDQuery1.ParamByName('FIRST_NAME').AsString := Params.ItemsString
        ['FIRST_NAME'].AsString;
      FDQuery1.ParamByName('LAST_NAME').AsString := Params.ItemsString
        ['LAST_NAME'].AsString;
      FDQuery1.ParamByName('PHONE_EXT').AsString :=
        StringReplace(StringReplace(Params.ItemsString['PHONE_EXT'].AsString,
        '(', '', [rfReplaceAll]), ')', '', [rfReplaceAll]);
      FDQuery1.ParamByName('DEPT_NO').AsString := '600';
      FDQuery1.ParamByName('JOB_CODE').AsString := 'Vp';
      FDQuery1.ParamByName('HIRE_DATE').AsDateTime :=
        StrToDate(SwapHTMLDateToDelphiDate(Params.ItemsString['HIRE_DATE']
        .AsString));
      FDQuery1.ParamByName('JOB_GRADE').AsString := Params.ItemsString
        ['JOB_GRADE'].AsString;
      FDQuery1.ParamByName('JOB_COUNTRY').AsString := Params.ItemsString
        ['JOB_COUNTRY'].AsString;
      vSalary := LimpaLixo(Params.ItemsString['SALARY'].AsString);
      FDQuery1.ParamByName('SALARY').AsFloat := StrToFloat(vSalary);
    End;
    FDQuery1.ExecSQL;
    Server_FDConnection.CommitRetaining;
  Except
    On E: Exception Do
    Begin
      Server_FDConnection.Rollback;
      Result := 'false';
    End;
  End;
end;

procedure TDMWebPascal.dwcrLoginBeforeRenderer(aSelf: TComponent);
begin
  TRESTDWContextRules(aSelf).MasterHtml.LoadFromFile
    ('.\www\templates\login.html');
end;

procedure TDMWebPascal.dwcrLoginItemsmeuloginnameBeforeRendererContextItem
  (var ContextItemTag: string);
begin
  ContextItemTag :=
    Format('<a id="mynamepan" idd="%d" href="#" class="d-block">%s</a>',
    [IDUser, IDUserName]);
end;

procedure TDMWebPascal.dwsCrudServerBeforeRenderer(aSelf: TComponent);
begin
  TRESTDWServerContext(aSelf).BaseHeader.LoadFromFile
    ('.\www\templates\master.html');
  TRESTDWServerContext(aSelf).BaseHeader.Text :=
    UTF8ToString(TRESTDWServerContext(aSelf).BaseHeader.Text);
end;

procedure TDMWebPascal.dwsCrudServerContextListindex2BeforeRenderer
  (const BaseHeader: string; var ContentType, ContentRenderer: string;
  const RequestType: TRequestType);
Var
  vIndexPage: TStringStream;
begin
  vIndexPage := TStringStream.Create;
  Try
    vIndexPage.LoadFromFile('.\www\index.html');
    ContentRenderer := vIndexPage.DataString;
  Finally
    FreeAndNil(vIndexPage);
  End;
end;

Procedure TDMWebPascal.ServerMethodDataModuleCreate(Sender: TObject);
Begin
{$IFDEF APPWIN}
  RESTDWPoolerDB1.Active := fPrincipal.CbPoolerState.Checked;
{$ENDIF}
End;

procedure TDMWebPascal.ServerMethodDataModuleGetToken(Welcomemsg,
  AccessTag: string; Params: TRESTDWParams; AuthOptions: TRESTDWAuthTokenParam;
  var ErrorCode: Integer; var ErrorMessage, TokenID: string;
  var Accept: Boolean);
Var
  vMyClient, vTokenID, vMyPass: String;
  Function RejectURL: String;
  Var
    v404Error: TStringList;
  Begin
    v404Error := TStringList.Create;
    Try
{$IFDEF APPWIN}
{$IFDEF SYNOPSE}
      v404Error.LoadFromFile(fPrincipal.RESTDWServiceSynPooler1.RootPath +
        Const404Page);
{$ELSE}
      v404Error.LoadFromFile(fPrincipal.RESTServicePooler1.RootPath +
        Const404Page);
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
  vTokenID := TokenID;
  If Pos('bearer', lowercase(vTokenID)) > 0 Then
    vTokenID := StringReplace
      (DecodeStrings(Trim(Copy(vTokenID, Pos('bearer', lowercase(vTokenID)) + 6,
      Length(vTokenID)))), cInvalidChar, '', [rfReplaceAll])
  Else
    vTokenID := StringReplace
      (DecodeStrings(Trim(Copy(vTokenID, Pos('basic', lowercase(vTokenID)) + 5,
      Length(vTokenID)))), cInvalidChar, '', [rfReplaceAll]);
  vMyClient := Copy(vTokenID, InitStrPos, Pos(':', vTokenID) - 1);
  Delete(vTokenID, InitStrPos, Pos(':', vTokenID));
  vMyPass := Trim(vTokenID);
  Accept := Not((vMyClient = '') Or (vMyPass = ''));
  If Accept Then
  Begin
    FDQuery1.Close;
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add
      ('select * from TB_USUARIO where Upper(NM_LOGIN) = Upper(:NM_LOGIN) and Upper(DS_SENHA) = Upper(:DS_SENHA)');
    Try
      FDQuery1.ParamByName('NM_LOGIN').AsString := vMyClient;
      FDQuery1.ParamByName('DS_SENHA').AsString := vMyPass;
      FDQuery1.Open;
    Finally
      Accept := Not(FDQuery1.EOF);
      If Not Accept Then
      Begin
        ErrorMessage := cInvalidAuth;
        ErrorCode := 401;
      End
      Else
        TokenID := AuthOptions.GetToken(Format('{"id":"%s", "login":"%s"}',
          [FDQuery1.FindField('ID_PESSOA').AsString,
          FDQuery1.FindField('NM_LOGIN').AsString]));
      FDQuery1.Close;
    End;
  End
  Else
  Begin
    ErrorMessage := cInvalidAuth;
    ErrorCode := 401;
  End;
end;

procedure TDMWebPascal.ServerMethodDataModuleUserTokenAuth(Welcomemsg,
  AccessTag: string; Params: TRESTDWParams; AuthOptions: TRESTDWAuthTokenParam;
  var ErrorCode: Integer; var ErrorMessage, TokenID: string;
  var Accept: Boolean);
Var
  vSecrets: String;
  vUserID: Integer;
  Function RejectURL: String;
  Var
    v404Error: TStringList;
  Begin
    v404Error := TStringList.Create;
    Try
{$IFDEF APPWIN}
{$IFDEF SYNOPSE}
      v404Error.LoadFromFile(fPrincipal.RESTDWServiceSynPooler1.RootPath +
        Const404Page);
{$ELSE}
      v404Error.LoadFromFile(fPrincipal.RESTServicePooler1.RootPath +
        Const404Page);
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
  Accept := TokenID <> '';
  If Accept Then
  Begin
    rOpenSecrets.OpenJson(AuthOptions.Secrets);
    vSecrets := rOpenSecrets.FindField('secrets').AsString;
    rOpenSecrets.Close;
    rOpenSecrets.OpenJson(DecodeStrings(vSecrets));
    vUserID := rOpenSecrets.FindField('ID').AsInteger;
    rOpenSecrets.Close;
    FDQuery1.Close;
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('select * from TB_USUARIO where ID_PESSOA = :ID');
    Try
      FDQuery1.ParamByName('ID').AsInteger := vUserID;
      FDQuery1.Open;
      IDUser := FDQuery1.FindField('ID_PESSOA').AsInteger;
      IDUserName := FDQuery1.FindField('NM_LOGIN').AsString;
    Finally
      Accept := Not FDQuery1.EOF;
      If Not Accept Then
      Begin
        ErrorMessage := RejectURL;
        ErrorCode := 404;
      End;
      FDQuery1.Close;
    End;
  End
  Else
  Begin
    ErrorMessage := RejectURL;
    ErrorCode := 404;
  End;
end;

Procedure TDMWebPascal.Server_FDConnectionBeforeConnect(Sender: TObject);
Var
  Driver_BD, Porta_BD, Servidor_BD, DataBase, Pasta_BD, Usuario_BD,
    Senha_BD: String;
Begin
{$IFDEF APPWIN}
  DataBase := fPrincipal.EdBD.Text;
  Driver_BD := fPrincipal.CbDriver.Text;
  If fPrincipal.CkUsaURL.Checked Then
    Servidor_BD := fPrincipal.EdURL.Text
  Else
    Servidor_BD := fPrincipal.DatabaseIP;
  Case fPrincipal.CbDriver.ItemIndex Of
    0:
      Begin
        Pasta_BD := IncludeTrailingPathDelimiter(fPrincipal.EdPasta.Text);
        DataBase := fPrincipal.EdBD.Text;
        DataBase := Pasta_BD + DataBase;
      End;
    1:
      DataBase := fPrincipal.EdBD.Text;
    3:
      Driver_BD := 'PG';
  End;
  Porta_BD := fPrincipal.EdPortaBD.Text;
  Usuario_BD := fPrincipal.EdUserNameBD.Text;
  Senha_BD := fPrincipal.EdPasswordBD.Text;
{$ELSE}
  Servidor_BD := servidor;
  Porta_BD := IntToStr(portaBD);
  DataBase := pasta + databaseC;
  Usuario_BD := usuarioBD;
  Senha_BD := senhaBD;
  Driver_BD := DriverBD;
{$ENDIF}
  TFDConnection(Sender).Params.Clear;
  TFDConnection(Sender).Params.Add('DriverID=' + Driver_BD);
  TFDConnection(Sender).Params.Add('Server=' + Servidor_BD);
  TFDConnection(Sender).Params.Add('Port=' + Porta_BD);
  TFDConnection(Sender).Params.Add('Database=' + DataBase);
  TFDConnection(Sender).Params.Add('User_Name=' + Usuario_BD);
  TFDConnection(Sender).Params.Add('Password=' + Senha_BD);
  TFDConnection(Sender).Params.Add('Protocol=TCPIP');
  TFDConnection(Sender).DriverName := Driver_BD;
  TFDConnection(Sender).LoginPrompt := False;
  TFDConnection(Sender).UpdateOptions.CountUpdatedRecords := False;
End;

End.
