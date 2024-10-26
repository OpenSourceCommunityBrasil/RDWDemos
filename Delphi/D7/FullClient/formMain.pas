unit formMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, 
  DB, Grids, DBGrids, uRESTDWConsts, 
  ExtCtrls, DBClient, ComCtrls,
  uRESTDWServerEvents, DateUtils, uRESTDWParams,
  ActnList, jpeg, uRESTDWDataUtils, uRESTDWAbout, uRESTDWBasicDB, uRESTDWIdBase,
  uRESTDWBasicTypes, uRESTDWBasic,  uRESTDWMemoryDataset, uRESTDWPrototypes, DBCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    labResult: TLabel;
    labSql: TLabel;
    labRepsonse: TLabel;
    labConexao: TLabel;
    labVersao: TLabel;
    DBGrid1: TDBGrid;
    mComando: TMemo;
    btnOpen: TButton;
    btnExecute: TButton;
    ProgressBar1: TProgressBar;
    btnGet: TButton;
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    btnApply: TButton;
    btnMassive: TButton;
    btnServerTime: TButton;
    DataSource1: TDataSource;
    ActionList1: TActionList;
    paTopo: TPanel;
    Image1: TImage;
    labSistema: TLabel;
    paPortugues: TPanel;
    Image3: TImage;
    paEspanhol: TPanel;
    Image4: TImage;
    paIngles: TPanel;
    Image2: TImage;
    RESTDWClientSQL1: TRESTDWClientSQL;
    labHost: TLabel;
    labPorta: TLabel;
    labAcesso: TLabel;
    labWelcome: TLabel;
    labExtras: TLabel;
    Label11: TLabel;
    eHost: TEdit;
    ePort: TEdit;
    cbxCompressao: TCheckBox;
    chkhttps: TCheckBox;
    eAccesstag: TEdit;
    eWelcomemessage: TEdit;
    cbBinaryRequest: TCheckBox;
    cbUseCripto: TCheckBox;
    cbAuthOptions: TComboBox;
    pBasicAuth: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    edUserNameDW: TEdit;
    edPasswordDW: TEdit;
    pTokenAuth: TPanel;
    Label12: TLabel;
    Label13: TLabel;
    lTokenBegin: TLabel;
    lTokenEnd: TLabel;
    Label21: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    eTokenID: TEdit;
    EdPasswordAuth: TEdit;
    EdUserNameAuth: TEdit;
    Button2: TButton;
    eUpdateTableName: TEdit;
    Label1: TLabel;
    Button1: TButton;
    RESTDWClientEvents1: TRESTDWClientEvents;
    RESTDWIdClientPooler1: TRESTDWIdClientPooler;
    RESTDWIdDatabase1: TRESTDWIdDatabase;
    procedure btnOpenClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnServerTimeClick(Sender: TObject);
    procedure btnMassiveClick(Sender: TObject);
    procedure btnGetClick(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure cbUseCriptoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbAuthOptionsChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure RESTDWIdDatabase1Status(ASender: TObject;
      const AStatus: TConnStatus; const AStatusText: String);
    procedure RESTDWIdDatabase1Work(ASender: TObject; AWorkCount: Int64);
    procedure RESTDWIdDatabase1BeforeConnect(Sender: TComponent);
    procedure RESTDWIdDatabase1Connection(Sucess: Boolean;
      const Error: String);
    procedure RESTDWIdDatabase1WorkEnd(ASender: TObject);
    procedure RESTDWIdDatabase1WorkBegin(ASender: TObject;
      AWorkCount: Int64);
  private
    { Private declarations }
   vSecresString    : String;
   FBytesToTransfer : Int64;
   Procedure SetLoginOptions;
   Procedure GetLoginOptionsClientPooler;
   Function  GetSecret : String;
  public
    { Public declarations }
   Property SecresString : String Read vSecresString;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

Procedure TForm2.GetLoginOptionsClientPooler;
Begin
 If RESTDWIdClientPooler1.AuthenticationOptions.AuthorizationOption in [rdwAOBearer, rdwAOToken] Then
  Begin
   If RESTDWIdClientPooler1.AuthenticationOptions.AuthorizationOption = rdwAOBearer Then
    Begin
     eTokenID.Text       := TRESTDWAuthOptionBearerClient(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Token;
     lTokenBegin.Caption := FormatDateTime('dd/mm/yyyy hh:mm:ss', TRESTDWAuthOptionBearerClient(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).BeginTime);
     lTokenEnd.Caption   := FormatDateTime('dd/mm/yyyy hh:mm:ss', TRESTDWAuthOptionBearerClient(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).EndTime);
     vSecresString       := TRESTDWAuthOptionBearerClient(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Secrets;
    End
   Else
    Begin
     eTokenID.Text       := TRESTDWAuthOptionTokenClient(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Token;
     lTokenBegin.Caption := FormatDateTime('dd/mm/yyyy hh:mm:ss', TRESTDWAuthOptionTokenClient(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).BeginTime);
     lTokenEnd.Caption   := FormatDateTime('dd/mm/yyyy hh:mm:ss', TRESTDWAuthOptionTokenClient(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).EndTime);
     vSecresString       := TRESTDWAuthOptionTokenClient(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Secrets;
    End;
  End;
End;

Function  TForm2.GetSecret : String;
Begin
 Result := '';
 If RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption in [rdwAOBearer, rdwAOToken] Then
  Begin
   If RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption = rdwAOBearer Then
    Result := TRESTDWAuthOptionBearerClient(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Secrets
   Else
    Result := TRESTDWAuthOptionTokenClient(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Secrets;
  End;
End;

Procedure TForm2.SetLoginOptions;
Begin
  Case cbAuthOptions.ItemIndex Of
   0 : RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption := rdwAONone;
   1 : RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption := rdwAOBasic;
   2 : RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption := rdwAOBearer;
   3 : RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption := rdwAOToken;
  End;
 RESTDWIdClientPooler1.AuthenticationOptions.AuthorizationOption := RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption;
 If RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption in [rdwAOBearer, rdwAOToken] Then
  Begin
   If RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption = rdwAOBearer Then
    Begin
     TRESTDWAuthOptionBearerClient(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).TokenRequestType := rdwtRequest;
     TRESTDWAuthOptionBearerClient(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Token   := eTokenID.Text;
     TRESTDWAuthOptionBearerClient(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).TokenRequestType := TRESTDWAuthOptionBearerClient(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).TokenRequestType;
     TRESTDWAuthOptionBearerClient(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Token := TRESTDWAuthOptionBearerClient(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Token;
    End
   Else
    Begin
     TRESTDWAuthOptionTokenClient(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).TokenRequestType := rdwtRequest;
     TRESTDWAuthOptionTokenClient(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Token   := eTokenID.Text;
     TRESTDWAuthOptionTokenClient(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).TokenRequestType := TRESTDWAuthOptionTokenClient(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).TokenRequestType;
     TRESTDWAuthOptionTokenClient(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Token := TRESTDWAuthOptionTokenClient(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Token;
    End;
  End
 Else If RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption = rdwAOBasic Then
  Begin
   TRESTDWAuthOptionBasic(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Username := edUserNameDW.Text;
   TRESTDWAuthOptionBasic(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Password := edPasswordDW.Text;
   TRESTDWAuthOptionBasic(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Username := TRESTDWAuthOptionBasic(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Username;
   TRESTDWAuthOptionBasic(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Password := TRESTDWAuthOptionBasic(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Password;
  End;
End;

procedure TForm2.btnOpenClick(Sender: TObject);
Var
 INICIO,
 FIM        : TDateTime;
 I          : Integer;
 vKeyFields : TStringList;
Begin
 RESTDWIdDatabase1.Active            := False;
 If Not RESTDWIdDatabase1.Active Then
  Begin
   RESTDWIdDatabase1.PoolerService   := EHost.Text;
   RESTDWIdDatabase1.PoolerPort      := StrToInt(EPort.Text);
   SetLoginOptions;
   RESTDWIdDatabase1.Compression     := cbxCompressao.Checked;
   RESTDWIdDatabase1.AccessTag       := eAccesstag.Text;
   RESTDWIdDatabase1.WelcomeMessage  := eWelcomemessage.Text;
   If chkhttps.Checked Then
    RESTDWIdDatabase1.TypeRequest    := trHttps
   Else
    RESTDWIdDatabase1.TypeRequest    := trHttp;
  End;
 INICIO                            := Now;
 RESTDWClientSQL1.Close;
 DataSource1.DataSet               := RESTDWClientSQL1;
 RESTDWClientSQL1.BinaryRequest        := cbBinaryRequest.Checked;
 RESTDWClientSQL1.SQL.Clear;
 RESTDWClientSQL1.SQL.Add(MComando.Text);
 RESTDWClientSQL1.UpdateTableName  := Trim(eUpdateTableName.Text);
 Try
  RESTDWClientSQL1.Active          := True;
 Except
  On E: Exception Do
   Begin
    Raise Exception.Create('Erro ao executar a consulta: ' + sLineBreak + E.Message);
   End;
 End;
 FIM := Now;
 EHost.Text            := RESTDWIdDatabase1.PoolerService;
 EPort.Text            := IntToStr(RESTDWIdDatabase1.PoolerPort);
 cbxCompressao.Checked := RESTDWIdDatabase1.Compression;
 eAccesstag.Text       := RESTDWIdDatabase1.AccessTag;
 eWelcomemessage.Text  := RESTDWIdDatabase1.WelcomeMessage;
 If RESTDWClientSQL1.FindField('UF') <> Nil Then
  RESTDWClientSQL1.FindField('UF').ProviderFlags       := [];
 If RESTDWClientSQL1.Active Then
  Showmessage(IntToStr(RESTDWClientSQL1.Recordcount) + ' registro(s) recebido(s) em ' + IntToStr(MilliSecondsBetween(FIM, INICIO)) + ' Milis.');
End;

procedure TForm2.btnApplyClick(Sender: TObject);
Var
 vError : String;
begin
 If Not RESTDWClientSQL1.ApplyUpdates(vError) Then
  MessageDlg(vError, mtError, [mbOK], 0);
end;

procedure TForm2.btnServerTimeClick(Sender: TObject);
Var
 dwParams      : TRESTDWParams;
 vNativeResult,
 vErrorMessage : String;
Begin
 RESTDWIdClientPooler1.Host            := EHost.Text;
 RESTDWIdClientPooler1.Port            := StrToInt(EPort.Text);
 SetLoginOptions;
 RESTDWIdClientPooler1.DataCompression := cbxCompressao.Checked;
 RESTDWIdClientPooler1.AccessTag       := eAccesstag.Text;
 RESTDWIdClientPooler1.WelcomeMessage  := eWelcomemessage.Text;
 RESTDWIdClientPooler1.BinaryRequest   := cbBinaryRequest.Checked;
 If chkhttps.Checked then
  RESTDWIdClientPooler1.TypeRequest    := trHttps
 Else
  RESTDWIdClientPooler1.TypeRequest    := trHttp;
 RESTDWClientEvents1.CreateDWParams('servertime', dwParams);
 RESTDWClientEvents1.SendEvent('servertime', dwParams, vErrorMessage, vNativeResult);
 If vErrorMessage = '' Then
  Begin
   GetLoginOptionsClientPooler;
   If dwParams.ItemsString['result'] <> Nil Then
    Showmessage('Server Date/Time is : ' + dwParams.ItemsString['result'].Value)
   Else
    Begin
     If vNativeResult <> '' Then
      Begin
       If vNativeResult <> '' Then
        Showmessage(vNativeResult)
       Else
        Showmessage(vErrorMessage);
      End;
    End;
  End
 Else
  Showmessage(vErrorMessage);
 dwParams.Free;
End;

procedure TForm2.btnMassiveClick(Sender: TObject);
begin
 If RESTDWClientSQL1.MassiveCount > 0 Then
  Showmessage(RESTDWClientSQL1.MassiveToJSON);
end;

procedure TForm2.btnGetClick(Sender: TObject);
Var
 dwParams       : TRESTDWParams;
 vErrorMessage,
 vNativeResult  : String;
Begin
 RESTDWIdClientPooler1.Host            := EHost.Text;
 RESTDWIdClientPooler1.Port            := StrToInt(EPort.Text);
 SetLoginOptions;
 RESTDWIdClientPooler1.DataCompression := cbxCompressao.Checked;
 RESTDWIdClientPooler1.AccessTag       := eAccesstag.Text;
 RESTDWIdClientPooler1.WelcomeMessage  := eWelcomemessage.Text;
 If chkhttps.Checked then
  RESTDWIdClientPooler1.TypeRequest    := trHttps
 Else
  RESTDWIdClientPooler1.TypeRequest    := trHttp;
 RESTDWClientEvents1.CreateDWParams('getemployee', dwParams);
 RESTDWClientEvents1.SendEvent('getemployee', dwParams, vErrorMessage, vNativeResult);
 If RESTDWIdClientPooler1.BinaryRequest then
  Begin
   If vErrorMessage <> '' Then
    Showmessage(vErrorMessage)
   Else
    Begin
     GetLoginOptionsClientPooler;
     Showmessage(dwParams.ItemsString['result'].AsString);
    End;
  End
 Else
  Begin
   If vNativeResult <> '' Then
    Begin
     GetLoginOptionsClientPooler;
     Showmessage(vNativeResult);
    End
   Else
    Showmessage(vErrorMessage);
  End;
 dwParams.Free;
End;

procedure TForm2.btnExecuteClick(Sender: TObject);
VAR
  VError: STRING;
BEGIN
  RESTDWIdDatabase1.Close;
  SetLoginOptions;
  RESTDWIdDatabase1.PoolerService  := EHost.Text;
  RESTDWIdDatabase1.PoolerPort     := StrToInt(EPort.Text);
  TRESTDWAuthOptionBasic(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Username := EdUserNameDW.Text;
  TRESTDWAuthOptionBasic(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Password := EdPasswordDW.Text;
  RESTDWIdDatabase1.Compression    := cbxCompressao.Checked;
  RESTDWIdDatabase1.AccessTag      := eAccesstag.Text;
  RESTDWIdDatabase1.WelcomeMessage := eWelcomemessage.Text;
  If chkhttps.Checked Then
   RESTDWIdDatabase1.TypeRequest   := trHttps
  Else
   RESTDWIdDatabase1.TypeRequest   := trHttp;
  RESTDWIdDatabase1.Open;
  RESTDWClientSQL1.Close;
  RESTDWClientSQL1.SQL.Clear;
  RESTDWClientSQL1.SQL.Add(MComando.Text);
  IF NOT RESTDWClientSQL1.ExecSQL(VError) THEN
    Application.MessageBox(PChar('Erro executando o comando ' + RESTDWClientSQL1.SQL.Text), 'Erro...', Mb_iconerror + Mb_ok)
  ELSE
    Application.MessageBox('Comando executado com sucesso...', 'Informação !!!', Mb_iconinformation + Mb_ok);
END;

procedure TForm2.cbUseCriptoClick(Sender: TObject);
begin
 RESTDWIdDatabase1.CriptOptions.Use   := cbUseCripto.Checked;
 RESTDWIdClientPooler1.CriptOptions.Use := RESTDWIdDatabase1.CriptOptions.Use;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
 labVersao.Caption := RESTDWVERSAO;
end;

procedure TForm2.cbAuthOptionsChange(Sender: TObject);
begin
 pTokenAuth.Visible := cbAuthOptions.ItemIndex > 1;
 pBasicAuth.Visible := cbAuthOptions.ItemIndex = 1;
end;

procedure TForm2.Button1Click(Sender: TObject);
Var
 vErrorMessage : String;
 dwParams      : TRESTDWParams;
Begin
 dwParams      := Nil;
 RESTDWIdClientPooler1.Host            := EHost.Text;
 RESTDWIdClientPooler1.Port            := StrToInt(EPort.Text);
 SetLoginOptions;
 RESTDWIdClientPooler1.DataCompression := cbxCompressao.Checked;
 RESTDWIdClientPooler1.AccessTag       := eAccesstag.Text;
 RESTDWIdClientPooler1.WelcomeMessage  := eWelcomemessage.Text;
 If chkhttps.Checked then
  RESTDWIdClientPooler1.TypeRequest    := trHttps
 Else
  RESTDWIdClientPooler1.TypeRequest    := trHttp;
 RESTDWClientEvents1.SendEvent('assyncevent', dwParams, vErrorMessage, sePOST, True);
 If vErrorMessage = '' Then
  Begin
   GetLoginOptionsClientPooler;
   Showmessage('Assyncevent Executed...');
  End
 Else
  Showmessage(vErrorMessage);
End;

procedure TForm2.RESTDWIdDatabase1Status(ASender: TObject;
  const AStatus: TConnStatus; const AStatusText: String);
begin
 if Self = Nil then
  Exit;
  CASE AStatus OF
    hsResolving:
      BEGIN
        StatusBar1.Panels[0].Text := 'hsResolving...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    hsConnecting:
      BEGIN
        StatusBar1.Panels[0].Text := 'hsConnecting...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    hsConnected:
      BEGIN
        StatusBar1.Panels[0].Text := 'hsConnected...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    hsDisconnecting:
      BEGIN
        if StatusBar1.Panels.count > 0 then
         StatusBar1.Panels[0].Text := 'hsDisconnecting...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    hsDisconnected:
      BEGIN
        StatusBar1.Panels[0].Text := 'hsDisconnected...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    hsStatusText:
      BEGIN
        StatusBar1.Panels[0].Text := 'hsStatusText...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
  END;
end;

procedure TForm2.RESTDWIdDatabase1Work(ASender: TObject;
  AWorkCount: Int64);
begin
  If FBytesToTransfer = 0 Then // No Update File
   Exit;
  ProgressBar1.Position := AWorkCount;
end;

procedure TForm2.RESTDWIdDatabase1BeforeConnect(Sender: TComponent);
begin
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add('**********');
  Memo1.Lines.Add(' ');
end;

procedure TForm2.RESTDWIdDatabase1Connection(Sucess: Boolean;
  const Error: String);
begin
 If Sucess Then
  Memo1.Lines.Add(DateTimeToStr(Now) + ' - Database conectado com sucesso.')
 Else
  Memo1.Lines.Add(DateTimeToStr(Now) + ' - Falha de conexão ao Database: ' + Error);
end;

procedure TForm2.RESTDWIdDatabase1WorkEnd(ASender: TObject);
begin
 ProgressBar1.Position := FBytesToTransfer;
 FBytesToTransfer      := 0;
end;

procedure TForm2.RESTDWIdDatabase1WorkBegin(ASender: TObject;
  AWorkCount: Int64);
begin
 FBytesToTransfer      := AWorkCount;
 ProgressBar1.Max      := FBytesToTransfer;
 ProgressBar1.Position := 0;
end;

end.
