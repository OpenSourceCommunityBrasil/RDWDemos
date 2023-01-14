unit uPrincipal;

interface

uses
  Lcl, DateUtils, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, fpjson, DB, sqldb, DBGrids, ExtCtrls, ComCtrls, ActnList,
  DBCtrls, uRESTDWBasicDB, uRESTDWServerEvents, uRESTDWDataUtils, uRESTDWConsts,
  uRESTDWIdBase, LConvEncoding, uRESTDWComponentEvents, uRESTDWParams,
  uRESTDWBasicTypes, uRESTDWProtoTypes;

type

  { TfPrincipal }

  TfPrincipal = class(TForm)
    ActionList1: TActionList;
    btnApply: TButton;
    btnExecute: TButton;
    btnGet: TButton;
    btnMassive: TButton;
    btnOpen: TButton;
    btnServerTime: TButton;
    Button1: TButton;
    Button2: TButton;
    cbAuthOptions: TComboBox;
    cbBinaryRequest: TCheckBox;
    cbUseCripto: TCheckBox;
    cbxCompressao: TCheckBox;
    chkhttps: TCheckBox;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBImage1: TDBImage;
    eAccesstag: TEdit;
    EdPasswordAuth: TEdit;
    edPasswordDW: TEdit;
    EdUserNameAuth: TEdit;
    edUserNameDW: TEdit;
    eHost: TEdit;
    ePort: TEdit;
    eTokenID: TEdit;
    eUpdateTableName: TEdit;
    eWelcomemessage: TEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    labAcesso: TLabel;
    labConexao: TLabel;
    Label1: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    Label21: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    labExtras: TLabel;
    labHost: TLabel;
    labPorta: TLabel;
    labRepsonse: TLabel;
    labResult: TLabel;
    labSistema: TLabel;
    labSql: TLabel;
    labVersao: TLabel;
    labWelcome: TLabel;
    lTokenBegin: TLabel;
    lTokenEnd: TLabel;
    mComando: TMemo;
    Memo1: TMemo;
    paEspanhol: TPanel;
    paIngles: TPanel;
    paPortugues: TPanel;
    paTopo: TPanel;
    pBasicAuth: TPanel;
    ProgressBar1: TProgressBar;
    pTokenAuth: TPanel;
    RESTDWClientEvents1: TRESTDWClientEvents;
    RESTDWClientSQL1: TRESTDWClientSQL;
    RESTDWClientSQL1DEPT_NO1: TStringField;
    RESTDWClientSQL1EMP_NO1: TSmallintField;
    RESTDWClientSQL1FIRST_NAME1: TStringField;
    RESTDWClientSQL1FULL_NAME1: TStringField;
    RESTDWClientSQL1JOB_CODE1: TStringField;
    RESTDWClientSQL1JOB_COUNTRY1: TStringField;
    RESTDWClientSQL1JOB_GRADE1: TSmallintField;
    RESTDWClientSQL1LAST_NAME1: TStringField;
    RESTDWClientSQL1PHONE_EXT1: TStringField;
    RESTDWClientSQL1SALARY1: TFloatField;
    RESTDWIdClientPooler1: TRESTDWIdClientPooler;
    RESTDWIdDatabase1: TRESTDWIdDatabase;
    RESTDWUpdateSQL1: TRESTDWUpdateSQL;
    StatusBar1: TStatusBar;
    procedure btnApplyClick(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure btnGetClick(Sender: TObject);
    procedure btnMassiveClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnServerTimeClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cbAuthOptionsChange(Sender: TObject);
    procedure cbUseCriptoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure RESTDWIdDatabase1BeforeConnect(Sender: TComponent);
    procedure RESTDWIdDatabase1Status(ASender: TObject;
      const AStatus: TConnStatus; const AStatusText: string);
    procedure RESTDWIdDatabase1Work(ASender: TObject; AWorkCount: int64);
    procedure RESTDWIdDatabase1WorkBegin(ASender: TObject; AWorkCount: int64);
    procedure RESTDWIdDatabase1WorkEnd(ASender: TObject);
  private
    { Private declarations }
    FBytesToTransfer: int64;
    vSecresString: string;
    procedure SetLoginOptions;
    procedure GetLoginOptionsClientPooler;
    procedure GetLoginOptionsDatabase;
  public
    { Public declarations }
  end;

var
  fPrincipal: TfPrincipal;

implementation

{$IFDEF LCL}
{$R *.lfm}
{$ELSE}

{$R *.dfm}

{$ENDIF}


{ TfPrincipal }

procedure TfPrincipal.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  fPrincipal := nil;
  Release;
end;

procedure TfPrincipal.FormCreate(Sender: TObject);
begin
  vSecresString := '';
  labVersao.Caption := RESTDWVersao;
end;

procedure TfPrincipal.RESTDWIdDatabase1Status(ASender: TObject;
  const AStatus: TConnStatus; const AStatusText: string);
begin
  if Self = nil then
    Exit;
  case AStatus of
    hsResolving:
    begin
      StatusBar1.Panels[0].Text := 'hsResolving...';
      Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
    end;
    hsConnecting:
    begin
      StatusBar1.Panels[0].Text := 'hsConnecting...';
      Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
    end;
    hsConnected:
    begin
      StatusBar1.Panels[0].Text := 'hsConnected...';
      Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
    end;
    hsDisconnecting:
    begin
      if StatusBar1.Panels.Count > 0 then
        StatusBar1.Panels[0].Text := 'hsDisconnecting...';
      Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
    end;
    hsDisconnected:
    begin
      StatusBar1.Panels[0].Text := 'hsDisconnected...';
      Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
    end;
    hsStatusText:
    begin
      StatusBar1.Panels[0].Text := 'hsStatusText...';
      Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
    end;
  end;
end;

procedure TfPrincipal.RESTDWIdDatabase1Work(ASender: TObject; AWorkCount: int64);
begin
  if FBytesToTransfer = 0 then // No Update File
    Exit;
  ProgressBar1.Position := AWorkCount;
end;

procedure TfPrincipal.RESTDWIdDatabase1WorkBegin(ASender: TObject; AWorkCount: int64);
begin
  FBytesToTransfer := AWorkCount;
  ProgressBar1.Max := FBytesToTransfer;
  ProgressBar1.Position := 0;
end;

procedure TfPrincipal.RESTDWIdDatabase1WorkEnd(ASender: TObject);
begin
  ProgressBar1.Position := FBytesToTransfer;
  FBytesToTransfer := 0;
end;

procedure TfPrincipal.GetLoginOptionsDatabase;
begin
  if RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption in
    [rdwAOBearer, rdwAOToken] then
  begin
    if RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption = rdwAOBearer then
    begin
      eTokenID.Text := TRESTDWAuthOptionBearerClient(
        RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Token;
      lTokenBegin.Caption := FormatDateTime('dd/mm/yyyy hh:mm:ss',
        TRESTDWAuthOptionBearerClient(
        RESTDWIdDatabase1.AuthenticationOptions.OptionParams).BeginTime);
      lTokenEnd.Caption := FormatDateTime('dd/mm/yyyy hh:mm:ss',
        TRESTDWAuthOptionBearerClient(
        RESTDWIdDatabase1.AuthenticationOptions.OptionParams).EndTime);
      vSecresString := TRESTDWAuthOptionBearerClient(
        RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Secrets;
    end
    else
    begin
      eTokenID.Text := TRESTDWAuthOptionTokenClient(
        RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Token;
      lTokenBegin.Caption := FormatDateTime('dd/mm/yyyy hh:mm:ss',
        TRESTDWAuthOptionTokenClient(
        RESTDWIdDatabase1.AuthenticationOptions.OptionParams).BeginTime);
      lTokenEnd.Caption := FormatDateTime('dd/mm/yyyy hh:mm:ss',
        TRESTDWAuthOptionTokenClient(
        RESTDWIdDatabase1.AuthenticationOptions.OptionParams).EndTime);
      vSecresString := TRESTDWAuthOptionTokenClient(
        RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Secrets;
    end;
  end;
end;

procedure TfPrincipal.GetLoginOptionsClientPooler;
begin
  if RESTDWIdClientPooler1.AuthenticationOptions.AuthorizationOption in
    [rdwAOBearer, rdwAOToken] then
  begin
    if RESTDWIdClientPooler1.AuthenticationOptions.AuthorizationOption = rdwAOBearer then
    begin
      eTokenID.Text := TRESTDWAuthOptionBearerClient(
        RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Token;
      lTokenBegin.Caption := FormatDateTime('dd/mm/yyyy hh:mm:ss',
        TRESTDWAuthOptionBearerClient(
        RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).BeginTime);
      lTokenEnd.Caption := FormatDateTime('dd/mm/yyyy hh:mm:ss',
        TRESTDWAuthOptionBearerClient(
        RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).EndTime);
      vSecresString := TRESTDWAuthOptionBearerClient(
        RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Secrets;
    end
    else
    begin
      eTokenID.Text := TRESTDWAuthOptionTokenClient(
        RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Token;
      lTokenBegin.Caption := FormatDateTime('dd/mm/yyyy hh:mm:ss',
        TRESTDWAuthOptionTokenClient(
        RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).BeginTime);
      lTokenEnd.Caption := FormatDateTime('dd/mm/yyyy hh:mm:ss',
        TRESTDWAuthOptionTokenClient(
        RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).EndTime);
      vSecresString := TRESTDWAuthOptionTokenClient(
        RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Secrets;
    end;
  end;
end;

procedure TfPrincipal.btnOpenClick(Sender: TObject);
var
  INICIO, FIM: TDateTime;
  I: integer;
  vKeyFields: TStringList;
begin
  RESTDWIdDatabase1.Active := False;
  if not RESTDWIdDatabase1.Active then
  begin
    RESTDWIdDatabase1.PoolerService := EHost.Text;
    RESTDWIdDatabase1.PoolerPort := StrToInt(EPort.Text);
    SetLoginOptions;
    RESTDWIdDatabase1.Compression := cbxCompressao.Checked;
    RESTDWIdDatabase1.AccessTag := eAccesstag.Text;
    RESTDWIdDatabase1.WelcomeMessage := eWelcomemessage.Text;
    if chkhttps.Checked then
      RESTDWIdDatabase1.TypeRequest := TTyperequest.trHttps
    else
      RESTDWIdDatabase1.TypeRequest := TTyperequest.trHttp;
  end;
  INICIO := Now;
  // RESTDWIdDatabase1.PoolerList;
  RESTDWClientSQL1.BinaryRequest := cbBinaryRequest.Checked;
  RESTDWClientSQL1.Close;
  DBImage1.DataField := '';
  RESTDWClientSQL1.SQL.Clear;
  RESTDWClientSQL1.SQL.Add(MComando.Text);
  RESTDWClientSQL1.UpdateTableName := Trim(eUpdateTableName.Text);
  try
    RESTDWClientSQL1.Active := True;
    if RESTDWClientSQL1.FindField('IMAGEM') <> nil then
      DBImage1.DataField := 'IMAGEM';
  except
    On E: Exception do
    begin
      raise Exception.Create('Erro ao executar a consulta: ' + sLineBreak + E.Message);
    end;
  end;
  FIM := Now;
  EHost.Text := RESTDWIdDatabase1.PoolerService;
  EPort.Text := IntToStr(RESTDWIdDatabase1.PoolerPort);
  cbxCompressao.Checked := RESTDWIdDatabase1.Compression;
  eAccesstag.Text := RESTDWIdDatabase1.AccessTag;
  eWelcomemessage.Text := RESTDWIdDatabase1.WelcomeMessage;
  if RESTDWClientSQL1.FindField('FULL_NAME') <> nil then
    RESTDWClientSQL1.FindField('FULL_NAME').ProviderFlags := [];
  if RESTDWClientSQL1.FindField('UF') <> nil then
    RESTDWClientSQL1.FindField('UF').ProviderFlags := [];
  if RESTDWClientSQL1.Active then
    ShowMessage(IntToStr(RESTDWClientSQL1.RecordCount) +
      ' registro(s) recebido(s) em ' + IntToStr(MilliSecondsBetween(FIM, INICIO)) +
      ' Milis.');
end;

procedure TfPrincipal.btnServerTimeClick(Sender: TObject);
var
  dwParams: TRESTDWParams;
  vNativeResult, vErrorMessage: string;
begin
  RESTDWIdClientPooler1.Host := EHost.Text;
  RESTDWIdClientPooler1.Port := StrToInt(EPort.Text);
  SetLoginOptions;
  RESTDWIdClientPooler1.DataCompression := cbxCompressao.Checked;
  RESTDWIdClientPooler1.AccessTag := eAccesstag.Text;
  RESTDWIdClientPooler1.WelcomeMessage := eWelcomemessage.Text;
  RESTDWIdClientPooler1.BinaryRequest := cbBinaryRequest.Checked;
  if chkhttps.Checked then
    RESTDWIdClientPooler1.TypeRequest := TTyperequest.trHttps
  else
    RESTDWIdClientPooler1.TypeRequest := TTyperequest.trHttp;
  // RESTDWClientEvents1.GetEvents         := True;
  RESTDWClientEvents1.CreateDWParams('servertime', dwParams);
  RESTDWClientEvents1.SendEvent('servertime', dwParams, vErrorMessage, vNativeResult);
  if vErrorMessage = '' then
  begin
    GetLoginOptionsClientPooler;
    if dwParams.ItemsString['result'] <> nil then
      ShowMessage('Server Date/Time is : ' +
        DateTimeToStr(dwParams.ItemsString['result'].Value))
    else
    begin
      if vNativeResult <> '' then
      begin
        if vNativeResult <> '' then
          ShowMessage(vNativeResult)
        else
          ShowMessage(vErrorMessage);
      end;
    end;
  end
  else
    ShowMessage(vErrorMessage);
  dwParams.Free;
end;

procedure TfPrincipal.Button1Click(Sender: TObject);
var
  vErrorMessage: string;
  dwParams: TRESTDWParams;
begin
  dwParams := nil;
  RESTDWIdClientPooler1.Host := EHost.Text;
  RESTDWIdClientPooler1.Port := StrToInt(EPort.Text);
  SetLoginOptions;
  RESTDWIdClientPooler1.DataCompression := cbxCompressao.Checked;
  RESTDWIdClientPooler1.AccessTag := eAccesstag.Text;
  RESTDWIdClientPooler1.WelcomeMessage := eWelcomemessage.Text;
  if chkhttps.Checked then
    RESTDWIdClientPooler1.TypeRequest := TTyperequest.trHttps
  else
    RESTDWIdClientPooler1.TypeRequest := TTyperequest.trHttp;
  RESTDWClientEvents1.SendEvent('assyncevent', dwParams, vErrorMessage, sePOST, True);
  if vErrorMessage = '' then
  begin
    GetLoginOptionsClientPooler;
    ShowMessage('Assyncevent Executed...');
  end
  else
    ShowMessage(vErrorMessage);
end;

procedure TfPrincipal.cbAuthOptionsChange(Sender: TObject);
begin
  pTokenAuth.Visible := cbAuthOptions.ItemIndex > 1;
  pBasicAuth.Visible := cbAuthOptions.ItemIndex = 1;
end;

procedure TfPrincipal.cbUseCriptoClick(Sender: TObject);
begin
  RESTDWIdDatabase1.CriptOptions.Use := cbUseCripto.Checked;
  RESTDWIdClientPooler1.CriptOptions.Use := RESTDWIdDatabase1.CriptOptions.Use;
end;

procedure TfPrincipal.SetLoginOptions;
begin
  case cbAuthOptions.ItemIndex of
    0: RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption := rdwAONone;
    1: RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption := rdwAOBasic;
    2: RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption := rdwAOBearer;
    3: RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption := rdwAOToken;
  end;
  RESTDWIdClientPooler1.AuthenticationOptions.AuthorizationOption :=
    RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption;
  if RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption in
    [rdwAOBearer, rdwAOToken] then
  begin
    if RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption = rdwAOBearer then
    begin
      TRESTDWAuthOptionBearerClient(
        RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Token := eTokenID.Text;
      TRESTDWAuthOptionBearerClient(
        RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Token :=
        TRESTDWAuthOptionBearerClient(
        RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Token;
    end
    else
    begin
      TRESTDWAuthOptionTokenClient(
        RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Token := eTokenID.Text;
      TRESTDWAuthOptionTokenClient(
        RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Token :=
        TRESTDWAuthOptionTokenClient(
        RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Token;
    end;
  end
  else if RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption = rdwAOBasic then
  begin
    TRESTDWAuthOptionBasic(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Username
    :=
      edUserNameDW.Text;
    TRESTDWAuthOptionBasic(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Password
    :=
      edPasswordDW.Text;
    TRESTDWAuthOptionBasic(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Username := TRESTDWAuthOptionBasic(
      RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Username;
    TRESTDWAuthOptionBasic(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Password := TRESTDWAuthOptionBasic(
      RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Password;
  end;
end;

procedure TfPrincipal.btnGetClick(Sender: TObject);
var
  dwParams: TRESTDWParams;
  vErrorMessage, vNativeResult: string;
begin
  RESTDWIdClientPooler1.Host := EHost.Text;
  RESTDWIdClientPooler1.Port := StrToInt(EPort.Text);
  SetLoginOptions;
  RESTDWIdClientPooler1.DataCompression := cbxCompressao.Checked;
  RESTDWIdClientPooler1.AccessTag := eAccesstag.Text;
  RESTDWIdClientPooler1.WelcomeMessage := eWelcomemessage.Text;
  if chkhttps.Checked then
    RESTDWIdClientPooler1.TypeRequest := TTyperequest.trHttps
  else
    RESTDWIdClientPooler1.TypeRequest := TTyperequest.trHttp;
  RESTDWClientEvents1.CreateDWParams('getemployee', dwParams);
  RESTDWClientEvents1.SendEvent('getemployee', dwParams, vErrorMessage, vNativeResult);
  if RESTDWIdClientPooler1.BinaryRequest then
  begin
    if vErrorMessage <> '' then
      ShowMessage(vErrorMessage)
    else
    begin
      GetLoginOptionsClientPooler;
      ShowMessage(dwParams.ItemsString['result'].AsString);
    end;
  end
  else
  begin
    if vNativeResult <> '' then
    begin
      GetLoginOptionsClientPooler;
      ShowMessage(vNativeResult);
    end
    else
      ShowMessage(vErrorMessage);
  end;
  dwParams.Free;
end;

procedure TfPrincipal.btnMassiveClick(Sender: TObject);
begin
  if RESTDWClientSQL1.MassiveCount > 0 then
    ShowMessage(RESTDWClientSQL1.MassiveToJSON);
end;

procedure TfPrincipal.btnExecuteClick(Sender: TObject);
var
  VError: string;
begin
  RESTDWIdDatabase1.Close;
  RESTDWIdDatabase1.PoolerService := EHost.Text;
  RESTDWIdDatabase1.PoolerPort := StrToInt(EPort.Text);
  SetLoginOptions;
  RESTDWIdDatabase1.Compression := cbxCompressao.Checked;
  RESTDWIdDatabase1.AccessTag := eAccesstag.Text;
  RESTDWIdDatabase1.WelcomeMessage := eWelcomemessage.Text;
  if chkhttps.Checked then
    RESTDWIdDatabase1.TypeRequest := trHttps
  else
    RESTDWIdDatabase1.TypeRequest := trHttp;
  RESTDWIdDatabase1.Open;
  RESTDWClientSQL1.Close;
  RESTDWClientSQL1.SQL.Clear;
  RESTDWClientSQL1.SQL.Add(MComando.Text);
  if not RESTDWClientSQL1.ExecSQL(VError) then
    ShowMessage('Erro executando o comando ' + RESTDWClientSQL1.SQL.Text)
  else
    ShowMessage('Comando executado com sucesso...');
end;

procedure TfPrincipal.btnApplyClick(Sender: TObject);
var
  vError: string;
begin
  if not RESTDWClientSQL1.ApplyUpdates(vError) then
    MessageDlg(vError, mtError, [mbOK], 0);
end;

procedure TfPrincipal.RESTDWIdDatabase1BeforeConnect(Sender: TComponent);
begin
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add('**********');
  Memo1.Lines.Add(' ');
end;

end.
