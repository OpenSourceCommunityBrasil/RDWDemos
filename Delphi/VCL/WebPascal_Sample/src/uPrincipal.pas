unit uPrincipal;

Interface

Uses
  Winapi.Windows, Winapi.Messages, Winsock, Winapi.Iphlpapi, Winapi.IpTypes,
  Winapi.ShellApi,
  System.SysUtils, System.Variants, System.Classes, System.IniFiles,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.AppEvnts, Vcl.Mask,
  Vcl.Menus, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Imaging.Jpeg,
  Vcl.Imaging.Pngimage,
  Data.DB, Web.HTTPApp,

  FireDAC.Phys.FBDef, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Comp.Client, FireDAC.Comp.UI, FireDAC.Phys.IBBase,
  FireDAC.Stan.StorageJSON,
  uSock,
  uRESTDWBasic, uRESTDWIdBase, uRESTDWDataUtils,
  uRESTDWConsts, uDMWebPascal, uRESTDWAbout, uRESTDWAuthenticators;

type
  TfPrincipal = class(TForm)
    Label8: TLabel;
    Bevel3: TBevel;
    PageControl1: TPageControl;
    TsConfigs: TTabSheet;
    TsLogs: TTabSheet;
    ApplicationEvents1: TApplicationEvents;
    CtiPrincipal: TTrayIcon;
    PmMenu: TPopupMenu;
    RestaurarAplicao1: TMenuItem;
    N5: TMenuItem;
    SairdaAplicao1: TMenuItem;
    MemoReq: TMemo;
    MemoResp: TMemo;
    Label19: TLabel;
    Label18: TLabel;
    Tupdatelogs: TTimer;
    paTopo: TPanel;
    Image2: TImage;
    paPortugues: TPanel;
    Image3: TImage;
    paEspanhol: TPanel;
    Image4: TImage;
    paIngles: TPanel;
    Image5: TImage;
    Panel1: TPanel;
    Panel3: TPanel;
    Image7: TImage;
    Panel4: TPanel;
    Image8: TImage;
    Label1: TLabel;
    edPortaDW: TEdit;
    cbForceWelcome: TCheckBox;
    labPorta: TLabel;
    labUsuario: TLabel;
    labSenha: TLabel;
    lbPasta: TLabel;
    labNomeBD: TLabel;
    Label14: TLabel;
    edURL: TEdit;
    cbAdaptadores: TComboBox;
    edPortaBD: TEdit;
    edUserNameBD: TEdit;
    edPasswordBD: TEdit;
    edPasta: TEdit;
    edBD: TEdit;
    cbDriver: TComboBox;
    ckUsaURL: TCheckBox;
    Label5: TLabel;
    Label6: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    ePrivKeyFile: TEdit;
    eCertFile: TEdit;
    ePrivKeyPass: TMaskEdit;
    labConexao: TLabel;
    Label7: TLabel;
    labDBConfig: TLabel;
    labSSL: TLabel;
    Panel2: TPanel;
    lSeguro: TLabel;
    ButtonStart: TButton;
    ButtonStop: TButton;
    cbPoolerState: TCheckBox;
    labSistema: TLabel;
    labVersao: TLabel;
    Label4: TLabel;
    EdDataSource: TEdit;
    Label9: TLabel;
    EdMonitor: TEdit;
    cbOsAuthent: TCheckBox;
    cbUpdateLog: TCheckBox;
    eHostCertFile: TEdit;
    Label10: TLabel;
    pBasicAuth: TPanel;
    edUserNameDW: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edPasswordDW: TEdit;
    Label11: TLabel;
    cbAuthOptions: TComboBox;
    pTokenAuth: TPanel;
    Label12: TLabel;
    Label13: TLabel;
    Label21: TLabel;
    Label20: TLabel;
    Label22: TLabel;
    cbTokenType: TComboBox;
    eTokenEvent: TEdit;
    eLifeCycle: TEdit;
    eServerSignature: TEdit;
    eTokenHash: TEdit;
    RESTDWIdServicePooler1: TRESTDWIdServicePooler;
    RESTDWAuthToken1: TRESTDWAuthToken;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CbAdaptadoresChange(Sender: TObject);
    procedure CtiPrincipalDblClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SairdaAplicao1Click(Sender: TObject);
    procedure RestaurarAplicao1Click(Sender: TObject);
    procedure RESTServicePooler1LastRequest(Value: string);
    procedure RESTServicePooler1LastResponse(Value: string);
    procedure TupdatelogsTimer(Sender: TObject);
    procedure CbDriverCloseUp(Sender: TObject);
    procedure CkUsaURLClick(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure cbAuthOptionsChange(Sender: TObject);
  Private
    { Private declarations }
    VLastRequest, VLastRequestB, VDatabaseName, FCfgName, VDatabaseIP,
      VUsername, VPassword: string;
    procedure StartServer;
    Function GetHandleOnTaskBar: THandle;
    procedure ChangeStatusWindow;
    procedure HideApplication;
  Public
    { Public declarations }
    procedure ShowBalloonTips(IconMessage: Integer = 0;
      MessageValue: string = '');
    procedure ShowApplication;
    Property Username: String Read VUsername Write VUsername;
    Property Password: String Read VPassword Write VPassword;
    Property DatabaseIP: String Read VDatabaseIP Write VDatabaseIP;
    Property DatabaseName: String Read VDatabaseName Write VDatabaseName;
    procedure Locale_Portugues(pLocale: String);
  End;

var
  fPrincipal: TfPrincipal;

implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

Function ServerIpIndex(Items: TStrings; ChooseIP: string): Integer;
Var
  I: Integer;
Begin
  Result := -1;
  For I := 0 To Items.Count - 1 Do
  Begin
    If Pos(ChooseIP, Items[I]) > 0 Then
    Begin
      Result := I;
      Break;
    End;
  End;
End;

Function TfPrincipal.GetHandleOnTaskBar: THandle;
Begin
{$IFDEF COMPILER11_UP}
  If Application.MainFormOnTaskBar And Assigned(Application.MainForm) Then
    Result := Application.MainForm.Handle
  Else
{$ENDIF COMPILER11_UP}
    Result := Application.Handle;
End;

procedure TfPrincipal.ChangeStatusWindow;
Begin
  If Self.Visible Then
    SairdaAplicao1.Caption := 'Minimizar para a bandeja'
  Else
    SairdaAplicao1.Caption := 'Sair da Aplica��o';
  Application.ProcessMessages;
End;

procedure TfPrincipal.CkUsaURLClick(Sender: TObject);
Begin
  If ckUsaURL.Checked Then
  Begin
    cbAdaptadores.Visible := False;

    edURL.Visible := True;
  End
  Else
  Begin
    edURL.Visible := False;
    cbAdaptadores.Visible := True;
  End;
End;

procedure TfPrincipal.CbDriverCloseUp(Sender: TObject);
Var
  Ini: TIniFile;
Begin
  Ini := TIniFile.Create(FCfgName);
  Try
    cbAdaptadores.ItemIndex := ServerIpIndex(cbAdaptadores.Items,
      Ini.ReadString('BancoDados', 'Servidor', '127.0.0.1'));
    edBD.Text := Ini.ReadString('BancoDados', 'BD', 'EMPLOYEE.FDB');
    edPasta.Text := Ini.ReadString('BancoDados', 'Pasta',
      ExtractFilePath(ParamSTR(0)) + '..\');
    edPortaBD.Text := Ini.ReadString('BancoDados', 'PortaBD', '3050');
    edUserNameBD.Text := Ini.ReadString('BancoDados', 'UsuarioBD', 'SYSDBA');
    edPasswordBD.Text := Ini.ReadString('BancoDados', 'SenhaBD', 'masterkey');
    edPortaDW.Text := Ini.ReadString('BancoDados', 'PortaDW', '8082');
    edUserNameDW.Text := Ini.ReadString('BancoDados', 'UsuarioDW',
      'testserver');
    edPasswordDW.Text := Ini.ReadString('BancoDados', 'SenhaDW', 'testserver');
    Case cbDriver.ItemIndex of
      0: // FireBird
        Begin
          lbPasta.Visible := True;
          edPasta.Visible := True;
          DatabaseName := edPasta.Text + edBD.Text;
        End;
      1: // MSSQL
        Begin
          edBD.Text := 'seubanco';
          lbPasta.Visible := False;
          edPasta.Visible := False;
          edPasta.Text := EmptyStr;
          edPortaBD.Text := '1433';
          edUserNameBD.Text := 'sa';
          edPasswordBD.Text := EmptyStr;
          DatabaseName := edBD.Text;
        End;
      2: // MySQL
        Begin

        end;
      3: // PG
        Begin

        end;
      4: // ODBC
        Begin

        End;
    End;
  Finally
    Ini.Free;
  End;
End;

procedure TfPrincipal.CtiPrincipalDblClick(Sender: TObject);
Begin
  ShowApplication;
End;

procedure TfPrincipal.HideApplication;
Begin
  CtiPrincipal.Visible := True;
  Application.ShowMainForm := False;
  If Self <> Nil Then
    Self.Visible := False;
  Application.Minimize;
  ShowWindow(GetHandleOnTaskBar, SW_HIDE);
  ChangeStatusWindow;
End;

procedure TfPrincipal.Image3Click(Sender: TObject);
begin
  Locale_Portugues('portugues');
end;

procedure TfPrincipal.Image4Click(Sender: TObject);
begin
  Locale_Portugues('espanhol');
end;

procedure TfPrincipal.Image5Click(Sender: TObject);
begin
  Locale_Portugues('ingles');
end;

procedure TfPrincipal.Locale_Portugues(pLocale: String);
begin

  if pLocale = 'portugues' then
  begin
    paPortugues.Color := clWhite;
    paEspanhol.Color := $002A2A2A;
    paIngles.Color := $002A2A2A;

    labConexao.Caption := ' .: CONFIGURA��O DO SERVIDOR';
    labDBConfig.Caption := ' .: CONFIGURA��O DO BANCO DE DADOS';
    labSSL.Caption := ' .: CONFIGURA��O DO SSL';
    // cbxCompressao.Caption := 'Compress�o';
  end
  else if pLocale = 'ingles' then
  begin
    paPortugues.Color := $002A2A2A;
    paEspanhol.Color := $002A2A2A;
    paIngles.Color := clWhite;
    labConexao.Caption := ' .: SQL COMMAND';
    labDBConfig.Caption := ' .: SERVER CONFIGURATION';
    labSSL.Caption := ' .: SSL CONFIGURATION';
    // cbxCompressao.Caption := 'Compresi�n';
  end
  else if pLocale = 'espanhol' then
  begin
    paPortugues.Color := $002A2A2A;
    paEspanhol.Color := clWhite;
    paIngles.Color := $002A2A2A;

    labConexao.Caption := ' .: CONFIGURATI�N DEL SERVIDOR';
    labDBConfig.Caption := ' .: CONFIGURATI�N DEL BANCO DE DADOS';
    labSSL.Caption := ' .: CONFIGURATI�N DEL SSL';

    // cbxCompressao.Caption := 'Compress�o';
  end;

end;

procedure TfPrincipal.RestaurarAplicao1Click(Sender: TObject);
Begin
  ShowApplication;
End;

procedure TfPrincipal.RESTServicePooler1LastRequest(Value: string);
Begin
  VLastRequest := Value;
End;

procedure TfPrincipal.RESTServicePooler1LastResponse(Value: string);
Begin
  VLastRequestB := Value;
End;

procedure TfPrincipal.SairdaAplicao1Click(Sender: TObject);
Begin
  Close;
End;

procedure TfPrincipal.ShowApplication;
Begin
  CtiPrincipal.Visible := False;
  Application.ShowMainForm := True;
  If Self <> Nil Then
  Begin
    Self.Visible := True;
    Self.WindowState := WsNormal;
  End;
  ShowWindow(GetHandleOnTaskBar, SW_SHOW);
  ChangeStatusWindow;
End;

procedure TfPrincipal.ShowBalloonTips(IconMessage: Integer = 0;
  MessageValue: string = '');
Begin
  case IconMessage of
    0:
      CtiPrincipal.BalloonFlags := BfInfo;
    1:
      CtiPrincipal.BalloonFlags := BfWarning;
    2:
      CtiPrincipal.BalloonFlags := BfError;
  Else
    CtiPrincipal.BalloonFlags := BfInfo;
  End;
  CtiPrincipal.BalloonTitle := Self.Caption;
  CtiPrincipal.BalloonHint := MessageValue;
  CtiPrincipal.ShowBalloonHint;
  Application.ProcessMessages;
End;

procedure TfPrincipal.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
Begin
  ButtonStart.Enabled := Not RESTDWIdServicePooler1.Active;
  ButtonStop.Enabled := RESTDWIdServicePooler1.Active;
  edPortaDW.Enabled := ButtonStart.Enabled;
  edUserNameDW.Enabled := ButtonStart.Enabled;
  edPasswordDW.Enabled := ButtonStart.Enabled;
  cbAdaptadores.Enabled := ButtonStart.Enabled;
  edPortaBD.Enabled := ButtonStart.Enabled;
  edPasta.Enabled := ButtonStart.Enabled;
  edBD.Enabled := ButtonStart.Enabled;
  edUserNameBD.Enabled := ButtonStart.Enabled;
  edPasswordBD.Enabled := ButtonStart.Enabled;
  EdMonitor.Enabled := ButtonStart.Enabled;
  EdDataSource.Enabled := ButtonStart.Enabled;
  cbOsAuthent.Enabled := ButtonStart.Enabled;
  ePrivKeyFile.Enabled := ButtonStart.Enabled;
  ePrivKeyPass.Enabled := ButtonStart.Enabled;
  eCertFile.Enabled := ButtonStart.Enabled;
End;

procedure TfPrincipal.ButtonStartClick(Sender: TObject);
var
  Ini: TIniFile;
Begin
  // DWCGIRunner1.BaseFiles  := ExtractFilePath(ParamSTR(0));
  // DWCGIRunner1.PHPIniPath := ExtractFilePath(ParamSTR(0)) + 'php5\';
  If FileExists(FCfgName) Then
    DeleteFile(FCfgName);
  Ini := TIniFile.Create(FCfgName);
  If ckUsaURL.Checked Then
  Begin
    Ini.WriteString('BancoDados', 'Servidor', edURL.Text);
  End
  Else
  Begin
    Ini.WriteString('BancoDados', 'Servidor', cbAdaptadores.Text);
    cbAdaptadores.onChange(cbAdaptadores);
  End;
  Ini.WriteInteger('BancoDados', 'DRIVER', cbDriver.ItemIndex);
  If ckUsaURL.Checked Then
    Ini.WriteInteger('BancoDados', 'USEDNS', 1)
  Else
    Ini.WriteInteger('BancoDados', 'USEDNS', 0);
  If cbUpdateLog.Checked Then
    Ini.WriteInteger('Configs', 'UPDLOG', 1)
  Else
    Ini.WriteInteger('Configs', 'UPDLOG', 0);
  Ini.WriteString('BancoDados', 'BD', edBD.Text);
  Ini.WriteString('BancoDados', 'Pasta', edPasta.Text);
  Ini.WriteString('BancoDados', 'PortaBD', edPortaBD.Text);
  Ini.WriteString('BancoDados', 'PortaDW', edPortaDW.Text);
  Ini.WriteString('BancoDados', 'UsuarioBD', edUserNameBD.Text);
  Ini.WriteString('BancoDados', 'SenhaBD', edPasswordBD.Text);
  Ini.WriteString('BancoDados', 'UsuarioDW', edUserNameDW.Text);
  Ini.WriteString('BancoDados', 'SenhaDW', edPasswordDW.Text);
  Ini.WriteString('BancoDados', 'DataSource', EdDataSource.Text); // ODBC
  Ini.WriteInteger('BancoDados', 'OsAuthent', cbOsAuthent.Checked.ToInteger);
  Ini.WriteString('BancoDados', 'MonitorBy', EdMonitor.Text);
  Ini.WriteString('SSL', 'PKF', ePrivKeyFile.Text);
  Ini.WriteString('SSL', 'PKP', ePrivKeyPass.Text);
  Ini.WriteString('SSL', 'CF', eCertFile.Text);
  Ini.WriteString('SSL', 'HostCF', eHostCertFile.Text);
  If cbForceWelcome.Checked Then
    Ini.WriteInteger('Configs', 'ForceWelcomeAccess', 1)
  Else
    Ini.WriteInteger('Configs', 'ForceWelcomeAccess', 0);
  Ini.Free;
  VUsername := edUserNameDW.Text;
  VPassword := edPasswordDW.Text;
  StartServer;
End;

procedure TfPrincipal.ButtonStopClick(Sender: TObject);
Begin
  Tupdatelogs.Enabled := False;
  RESTDWIdServicePooler1.Active := False;
  PageControl1.ActivePage := TsConfigs;
  ShowApplication;
End;

procedure TfPrincipal.CbAdaptadoresChange(Sender: TObject);
Begin
  VDatabaseIP := Trim(Copy(cbAdaptadores.Text, Pos('-', cbAdaptadores.Text)
    + 1, 100));
End;

procedure TfPrincipal.cbAuthOptionsChange(Sender: TObject);
begin
  pTokenAuth.Visible := cbAuthOptions.ItemIndex > 1;
  pBasicAuth.Visible := cbAuthOptions.ItemIndex = 1;
end;

procedure TfPrincipal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
Begin
  CanClose := Not RESTDWIdServicePooler1.Active;
  If Not CanClose Then
  Begin
    CanClose := Not Self.Visible;
    If CanClose Then
      CanClose := Application.MessageBox
        ('Voc� deseja realmente sair do programa ?', 'Pergunta ?',
        Mb_IconQuestion + Mb_YesNo) = MrYes
    Else
      HideApplication;
  End;
End;

procedure TfPrincipal.FormCreate(Sender: TObject);
Begin
  labVersao.Caption := uRESTDWConsts.RESTDWVersao;
  // define o nome do .ini de acordo c o EXE
  // dessa forma se quiser testar v�rias inst�ncias do servidor em
  // portas diferentes os arquivos n�o ir�o conflitar
  FCfgName := StringReplace(ExtractFileName(ParamSTR(0)), '.exe', '',
    [RfReplaceAll]);
  FCfgName := ExtractFilePath(ParamSTR(0)) + 'Config_' + FCfgName + '.ini';
  RESTDWIdServicePooler1.ServerMethodClass := TDMWebPascal;
  RESTDWIdServicePooler1.RootPath := IncludeTrailingPathDelimiter
    (ExtractFilePath(Application.ExeName) + 'www');
  PageControl1.ActivePage := TsConfigs;
End;

procedure TfPrincipal.FormShow(Sender: TObject);
var
  Ini: TIniFile;
  VTag, I: Integer;
  ANetInterfaceList: TNetworkInterfaceList;
Begin
  VTag := 0;
  If (GetNetworkInterfaces(ANetInterfaceList)) Then
  Begin
    cbAdaptadores.Items.Clear;
    For I := 0 To High(ANetInterfaceList) Do
    Begin
      cbAdaptadores.Items.Add('Placa #' + IntToStr(I) + ' - ' +
        ANetInterfaceList[I].AddrIP);
      If (I <= 1) or (Pos('127.0.0.1', ANetInterfaceList[I].AddrIP) > 0) Then
      Begin
        VDatabaseIP := ANetInterfaceList[I].AddrIP;
        VTag := 1;
      End;
    End;
    cbAdaptadores.ItemIndex := VTag;
  End;
  Ini := TIniFile.Create(FCfgName);
  cbDriver.ItemIndex := Ini.ReadInteger('BancoDados', 'DRIVER', 0);
  ckUsaURL.Checked := Ini.ReadInteger('BancoDados', 'USEDNS', 0) = 1;
  If ServerIpIndex(cbAdaptadores.Items, Ini.ReadString('BancoDados', 'Servidor',
    '')) > -1 Then
    cbAdaptadores.ItemIndex := ServerIpIndex(cbAdaptadores.Items,
      Ini.ReadString('BancoDados', 'Servidor', ''))
  Else
  Begin
    If Ini.ReadString('BancoDados', 'Servidor', '') <> '' Then
    Begin
      cbAdaptadores.Items.Add(Ini.ReadString('BancoDados', 'Servidor', ''));
      cbAdaptadores.ItemIndex := cbAdaptadores.Items.Count - 1;
    End;
  End;
  edBD.Text := Ini.ReadString('BancoDados', 'BD', 'EMPLOYEE.FDB');
  edPasta.Text := Ini.ReadString('BancoDados', 'Pasta',
    ExtractFilePath(ParamSTR(0)) + '..\');
  edPortaBD.Text := Ini.ReadString('BancoDados', 'PortaBD', '3050');
  edPortaDW.Text := Ini.ReadString('BancoDados', 'PortaDW', '8082');
  edUserNameBD.Text := Ini.ReadString('BancoDados', 'UsuarioBD', 'SYSDBA');
  edPasswordBD.Text := Ini.ReadString('BancoDados', 'SenhaBD', 'masterkey');
  edUserNameDW.Text := Ini.ReadString('BancoDados', 'UsuarioDW', 'testserver');
  edPasswordDW.Text := Ini.ReadString('BancoDados', 'SenhaDW', 'testserver');
  EdMonitor.Text := Ini.ReadString('BancoDados', 'MonitorBy', 'Remote');
  // ICO Menezes
  EdDataSource.Text := Ini.ReadString('BancoDados', 'DataSource', 'SQL');
  cbOsAuthent.Checked := Ini.ReadInteger('BancoDados', 'OsAuthent', 0) = 1;
  cbUpdateLog.Checked := Ini.ReadInteger('Configs', 'UPDLOG', 1) = 1;
  ePrivKeyFile.Text := Ini.ReadString('SSL', 'PKF', '');
  ePrivKeyPass.Text := Ini.ReadString('SSL', 'PKP', '');
  eCertFile.Text := Ini.ReadString('SSL', 'CF', '');
  eHostCertFile.Text := Ini.ReadString('SSL', 'HostCF', '');
  cbForceWelcome.Checked := Ini.ReadInteger('Configs',
    'ForceWelcomeAccess', 0) = 1;
  Ini.Free;
End;

procedure TfPrincipal.StartServer;
  Function GetAuthOption: TRESTDWAuthOption;
  Begin
    Case cbAuthOptions.ItemIndex Of
      0:
        Result := rdwAONone;
      1:
        Result := rdwAOBasic;
      2:
        Result := rdwAOBearer;
      3:
        Result := rdwAOToken;
    else
      Result := rdwAONone;
    End;
  End;
  Function GetTokenType: TRESTDWTokenType;
  Begin
    Case cbTokenType.ItemIndex Of
      0:
        Result := rdwTS;
      1:
        Result := rdwJWT;
    else
      Result := rdwJWT;
    End;
  End;

Begin
  If Not RESTDWIdServicePooler1.Active Then
  Begin
  {
    RESTDWIdServicePooler1.AuthenticationOptions.AuthorizationOption :=
      GetAuthOption;
    Case RESTDWIdServicePooler1.AuthenticationOptions.AuthorizationOption Of
      rdwAOBasic:
        Begin
          TRESTDWAuthOptionBasic
            (RESTDWIdServicePooler1.AuthenticationOptions.OptionParams).Username :=
            edUserNameDW.Text;
          TRESTDWAuthOptionBasic
            (RESTDWIdServicePooler1.AuthenticationOptions.OptionParams).Password :=
            edPasswordDW.Text;
        End;
      rdwAOBearer, rdwAOToken:
        Begin
          If RESTDWIdServicePooler1.AuthenticationOptions.AuthorizationOption =
            rdwAOBearer Then
          Begin
            TRESTDWAuthOptionBearerServer
              (RESTDWIdServicePooler1.AuthenticationOptions.OptionParams).TokenType
              := GetTokenType;
            TRESTDWAuthOptionBearerServer
              (RESTDWIdServicePooler1.AuthenticationOptions.OptionParams)
              .GetTokenEvent := eTokenEvent.Text;
            TRESTDWAuthOptionBearerServer
              (RESTDWIdServicePooler1.AuthenticationOptions.OptionParams).TokenHash
              := eTokenHash.Text;
            TRESTDWAuthOptionBearerServer
              (RESTDWIdServicePooler1.AuthenticationOptions.OptionParams)
              .ServerSignature := eServerSignature.Text;
            TRESTDWAuthOptionBearerServer
              (RESTDWIdServicePooler1.AuthenticationOptions.OptionParams).LifeCycle
              := StrToInt(eLifeCycle.Text);
          End
          Else
          Begin
            TRESTDWAuthOptionTokenServer
              (RESTDWIdServicePooler1.AuthenticationOptions.OptionParams).TokenType
              := GetTokenType;
            TRESTDWAuthOptionTokenServer
              (RESTDWIdServicePooler1.AuthenticationOptions.OptionParams)
              .GetTokenEvent := eTokenEvent.Text;
            TRESTDWAuthOptionTokenServer
              (RESTDWIdServicePooler1.AuthenticationOptions.OptionParams).TokenHash
              := eTokenHash.Text;
            TRESTDWAuthOptionTokenServer
              (RESTDWIdServicePooler1.AuthenticationOptions.OptionParams)
              .ServerSignature := eServerSignature.Text;
            TRESTDWAuthOptionTokenServer
              (RESTDWIdServicePooler1.AuthenticationOptions.OptionParams).LifeCycle
              := StrToInt(eLifeCycle.Text);
          End;
        End;
    Else
      RESTDWIdServicePooler1.AuthenticationOptions.AuthorizationOption := rdwAONone;
      }
  End;
    RESTDWIdServicePooler1.ServicePort := StrToInt(edPortaDW.Text);
    RESTDWIdServicePooler1.SSLPrivateKeyFile := ePrivKeyFile.Text;
    RESTDWIdServicePooler1.SSLPrivateKeyPassword := ePrivKeyPass.Text;
    RESTDWIdServicePooler1.SSLCertFile := eCertFile.Text;
    RESTDWIdServicePooler1.SSLRootCertFile := eHostCertFile.Text;
    RESTDWIdServicePooler1.ForceWelcomeAccess := cbForceWelcome.Checked;
    RESTDWIdServicePooler1.Active := True;
    If Not RESTDWIdServicePooler1.Active Then
      Exit;
    PageControl1.ActivePage := TsLogs;
    HideApplication;
    Tupdatelogs.Enabled := cbUpdateLog.Checked;
//  End;
{
  If RESTDWIdServicePooler1.SSLCertFile <> '' Then
  Begin
    lSeguro.Font.Color := ClBlue;
    lSeguro.Caption := 'Seguro : Sim';
  End
  Else
  Begin
    lSeguro.Font.Color := ClRed;
    lSeguro.Caption := 'Seguro : N�o';
  End;
  }
End;

procedure TfPrincipal.TupdatelogsTimer(Sender: TObject);
var
  VTempLastRequest, VTempLastRequestB: string;
Begin
  Tupdatelogs.Enabled := False;
  Try
    VTempLastRequest := VLastRequest;
    VTempLastRequestB := VLastRequestB;
    If (VTempLastRequest <> '') Then
    Begin
      If MemoReq.Lines.Count > 0 Then
        If MemoReq.Lines[MemoReq.Lines.Count - 1] = VTempLastRequest Then
          Exit;
      If MemoReq.Lines.Count = 0 Then
        MemoReq.Lines.Add(Copy(VTempLastRequest, 1, 100))
      Else
        MemoReq.Lines[MemoReq.Lines.Count - 1] :=
          Copy(VTempLastRequest, 1, 100);
      If Length(VTempLastRequest) > 1000 Then
        MemoReq.Lines[MemoReq.Lines.Count - 1] :=
          MemoReq.Lines[MemoReq.Lines.Count - 1] + '...';
      If MemoResp.Lines.Count > 0 Then
        If MemoResp.Lines[MemoResp.Lines.Count - 1] = VTempLastRequestB Then
          Exit;
      If MemoResp.Lines.Count = 0 Then
        MemoResp.Lines.Add(Copy(VTempLastRequestB, 1, 100))
      Else
        MemoResp.Lines[MemoResp.Lines.Count - 1] :=
          Copy(VTempLastRequestB, 1, 100);
      If Length(VTempLastRequest) > 1000 Then
        MemoResp.Lines[MemoResp.Lines.Count - 1] :=
          MemoResp.Lines[MemoResp.Lines.Count - 1] + '...';
    End;
  Finally
    Tupdatelogs.Enabled := True;
  End;
End;

End.
