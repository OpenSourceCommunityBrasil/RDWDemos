unit formMain;

interface

uses
  Lcl, uDWJSON, uDWJSONObject, DateUtils, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, fpjson, DB, DBGrids, ExtCtrls, ComCtrls,
  ActnList, uRESTDWPoolerDB, uRESTDWServerEvents, uRESTDWBase, uDWDataset,
  IdComponent, uDWConstsData, LConvEncoding, ServerUtils, uDWConstsCharset;

type

  { TForm2 }

  TForm2 = class(TForm)
    ActionList1: TActionList;
    btnApply: TButton;
    btnExecute: TButton;
    btnGet: TButton;
    btnMassive: TButton;
    btnOpen: TButton;
    btnServerTime: TButton;
    cbBinaryRequest: TCheckBox;
    cbUseCripto: TCheckBox;
    cbxCompressao: TCheckBox;
    chkhttps: TCheckBox;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DWClientEvents1: TDWClientEvents;
    DWClientEvents2: TDWClientEvents;
    eAccesstag: TEdit;
    edPasswordDW: TEdit;
    edUserNameDW: TEdit;
    eHost: TEdit;
    ePort: TEdit;
    eWelcomemessage: TEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    labAcesso: TLabel;
    labConexao: TLabel;
    labExtras: TLabel;
    labHost: TLabel;
    labPorta: TLabel;
    labRepsonse: TLabel;
    labResult: TLabel;
    labSenha: TLabel;
    labSistema: TLabel;
    labSql: TLabel;
    labUsuario: TLabel;
    labVersao: TLabel;
    labWelcome: TLabel;
    mComando: TMemo;
    Memo1: TMemo;
    paEspanhol: TPanel;
    paIngles: TPanel;
    paPortugues: TPanel;
    paTopo: TPanel;
    ProgressBar1: TProgressBar;
    RESTClientPooler1: TRESTClientPooler;
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
    RESTDWDataBase1: TRESTDWDataBase;
    StatusBar1: TStatusBar;
    procedure btnApplyClick(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure btnGetClick(Sender: TObject);
    procedure btnMassiveClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnServerTimeClick(Sender: TObject);
    procedure cbUseCriptoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure mComandoChange(Sender: TObject);
    procedure RESTClientPooler1BeforeExecute(ASender: TObject);
    procedure RESTDWClientSQL1AfterInsert(DataSet: TDataSet);
    procedure RESTDWDataBase1BeforeConnect(Sender: TComponent);
    procedure RESTDWDataBase1Connection(Sucess: Boolean; const Error: String);
    procedure RESTDWDataBase1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);
    procedure RESTDWDataBase1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure RESTDWDataBase1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure RESTDWDataBase1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
  private
    { Private declarations }
   FBytesToTransfer : Int64;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$IFDEF LCL}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}


{ TForm2 }

procedure TForm2.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
 Form2 := Nil;
 Release;
end;

procedure TForm2.mComandoChange(Sender: TObject);
begin

end;

procedure TForm2.RESTClientPooler1BeforeExecute(ASender: TObject);
begin

end;

procedure TForm2.btnOpenClick(Sender: TObject);
Var
  INICIO: TdateTime;
  FIM: TdateTime;
Begin
  RESTDWDataBase1.Active := False;
  RESTDWDataBase1.Close;
  RESTDWDataBase1.PoolerService  := EHost.Text;
  RESTDWDataBase1.PoolerPort     := StrToInt(EPort.Text);

  RESTDWDataBase1.AuthenticationOptions.AuthorizationOption := rdwAOBasic;
  TRDWAuthOptionBasic(RESTDWDataBase1.AuthenticationOptions.OptionParams).Username := EdUserNameDW.Text;
  TRDWAuthOptionBasic(RESTDWDataBase1.AuthenticationOptions.OptionParams).Password := EdPasswordDW.Text;

  RESTClientPooler1.AuthenticationOptions.AuthorizationOption := RESTDWDataBase1.AuthenticationOptions.AuthorizationOption;
  TRDWAuthOptionBasic(RESTClientPooler1.AuthenticationOptions.OptionParams).Username := TRDWAuthOptionBasic(RESTDWDataBase1.AuthenticationOptions.OptionParams).Username;
  TRDWAuthOptionBasic(RESTClientPooler1.AuthenticationOptions.OptionParams).Password := TRDWAuthOptionBasic(RESTDWDataBase1.AuthenticationOptions.OptionParams).Password;

  RESTDWDataBase1.AccessTag      := eAccesstag.Text;
  RESTDWDataBase1.Compression    := cbxCompressao.Checked;
  RESTDWDataBase1.WelcomeMessage := eWelcomemessage.Text;

  If chkhttps.Checked Then
   RESTDWDataBase1.TypeRequest   := TTyperequest.trHttps
  Else
   RESTDWDataBase1.TypeRequest   := TTyperequest.trHttp;

  DataSource1.DataSet                   := RESTDWClientSQL1;
  RESTDWClientSQL1.BinaryRequest        := cbBinaryRequest.Checked;
  RESTDWClientSQL1.BinaryCompatibleMode := False;
  RESTDWClientSQL1.DatabaseCharSet      := csUTF8;
  RESTDWClientSQL1.Encoding             := esUTF8;

  INICIO  := Now;

  RESTDWClientSQL1.Close;
  RESTDWClientSQL1.SQL.Clear;
  RESTDWClientSQL1.SQL.Add(MComando.Text);
//  RESTDWClientSQL1.UpdateTableName  := Trim('clientes');
  Try
    RESTDWClientSQL1.Active := True;
  Except
    On E: Exception Do
    Begin
      Raise Exception.Create(E.Message);
    End;
  End;
  FIM := Now;
  Showmessage(IntToStr(RESTDWClientSQL1.Recordcount)+ ' registro(s) recebido(s) em ' + IntToStr(MilliSecondsBetween(FIM, INICIO)) + ' Milis.');
End;

procedure TForm2.btnServerTimeClick(Sender: TObject);
Var
 dwParams      : TDWParams;
 vErrorMessage : String;
begin
 RESTClientPooler1.Host            := EHost.Text;
 RESTClientPooler1.Port            := StrToInt(EPort.Text);
 //RESTClientPooler1.UserName        := EdUserNameDW.Text;
 //RESTClientPooler1.Password        := EdPasswordDW.Text;
 RESTClientPooler1.DataCompression := cbxCompressao.Checked;
 RESTClientPooler1.AccessTag       := eAccesstag.Text;
 RESTClientPooler1.WelcomeMessage  := eWelcomemessage.Text;
 //If chkhttps.Checked then
 // RESTClientPooler1.TypeRequest := trHttps
 //Else
 // RESTClientPooler1.TypeRequest := trHttp;
 DWClientEvents1.CreateDWParams('servertime', dwParams);
 dwParams.ItemsString['inputdata'].AsString := 'teste de string';
 DWClientEvents1.SendEvent('servertime', dwParams, vErrorMessage);
 If vErrorMessage = '' Then
  Begin
   If dwParams.ItemsString['result'].AsString <> '' Then
    Showmessage('Server Date/Time is : ' + DateTimeToStr(dwParams.ItemsString['result'].Value))
   Else
    Showmessage('Invalid result data...');
   dwParams.ItemsString['result'].SaveToFile('json.d7');
  End
 Else
  Showmessage(vErrorMessage);
 dwParams.Free;
end;

procedure TForm2.cbUseCriptoClick(Sender: TObject);
begin
 RESTDWDataBase1.CriptOptions.Use   := cbUseCripto.Checked;
 RESTClientPooler1.CriptOptions.Use := RESTDWDataBase1.CriptOptions.Use;
end;

procedure TForm2.btnGetClick(Sender: TObject);
Var
 dwParams      : TDWParams;
 vErrorMessage,
 vNativeResult : String;
begin
 RESTClientPooler1.Host            := EHost.Text;
 RESTClientPooler1.Port            := StrToInt(EPort.Text);
 //RESTClientPooler1.UserName        := EdUserNameDW.Text;
 //RESTClientPooler1.Password        := EdPasswordDW.Text;
 RESTClientPooler1.DataCompression := cbxCompressao.Checked;
 RESTClientPooler1.AccessTag       := eAccesstag.Text;
 RESTClientPooler1.WelcomeMessage  := eWelcomemessage.Text;
 //If chkhttps.Checked then
 // RESTClientPooler1.TypeRequest := trHttps
 //Else
 // RESTClientPooler1.TypeRequest := trHttp;
 DWClientEvents1.CreateDWParams('getemployee', dwParams);
 DWClientEvents1.SendEvent('getemployee', dwParams, vErrorMessage, vNativeResult);
 dwParams.Free;
 If vErrorMessage = '' Then
  Showmessage(CP1252ToUTF8(vNativeResult))
 Else
  Showmessage(vErrorMessage);
end;

procedure TForm2.btnMassiveClick(Sender: TObject);
begin
 If RESTDWClientSQL1.MassiveCount > 0 Then
  Showmessage(RESTDWClientSQL1.MassiveToJSON);
end;

procedure TForm2.btnExecuteClick(Sender: TObject);
VAR
  VError: STRING;
BEGIN
  RESTDWDataBase1.Close;
  RESTDWDataBase1.PoolerService  := EHost.Text;
  RESTDWDataBase1.PoolerPort     := StrToInt(EPort.Text);
  //RESTDWDataBase1.Login          := EdUserNameDW.Text;
  //RESTDWDataBase1.Password       := EdPasswordDW.Text;
  RESTDWDataBase1.Compression    := cbxCompressao.Checked;
  RESTDWDataBase1.AccessTag      := eAccesstag.Text;
  RESTDWDataBase1.WelcomeMessage := eWelcomemessage.Text;
  //If chkhttps.Checked Then
  // RESTDWDataBase1.TypeRequest   := trHttps
  //Else
  // RESTDWDataBase1.TypeRequest   := trHttp;
  RESTDWDataBase1.Open;
  RESTDWClientSQL1.Close;
  RESTDWClientSQL1.SQL.Clear;
  RESTDWClientSQL1.SQL.Add(MComando.Text);
  IF NOT RESTDWClientSQL1.ExecSQL(VError) THEN
    ShowMessage('Erro executando o comando ' + RESTDWClientSQL1.SQL.Text)
  ELSE
    ShowMessage('Comando executado com sucesso...');
END;

procedure TForm2.btnApplyClick(Sender: TObject);
Var
 vError : String;
begin
 If Not RESTDWClientSQL1.ApplyUpdates(vError) Then
  MessageDlg(vError, mtError, [mbOK], 0);
end;

procedure TForm2.RESTDWClientSQL1AfterInsert(DataSet: TDataSet);
begin

end;

procedure TForm2.RESTDWDataBase1BeforeConnect(Sender: TComponent);
begin
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add('**********');
  Memo1.Lines.Add(' ');
end;

procedure TForm2.RESTDWDataBase1Connection(Sucess: Boolean; const Error: String
  );
begin
 IF Sucess THEN
 BEGIN
   Memo1.Lines.Add(DateTimeToStr(Now) + ' - Database conectado com sucesso.');
 END
 ELSE
 BEGIN
   Memo1.Lines.Add(DateTimeToStr(Now) + ' - Falha de conexão ao Database: ' + Error);
 END;
end;

procedure TForm2.RESTDWDataBase1Status(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
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
    // These are to eliminate the TIdFTPStatus and the coresponding event These can be use din the other protocols to.
    ftpTransfer:
      BEGIN
        StatusBar1.Panels[0].Text := 'ftpTransfer...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    ftpReady:
      BEGIN
        StatusBar1.Panels[0].Text := 'ftpReady...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    ftpAborted:
      BEGIN
        StatusBar1.Panels[0].Text := 'ftpAborted...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
  END;
end;

procedure TForm2.RESTDWDataBase1Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
 If FBytesToTransfer = 0 Then // No Update File
  Exit;
 ProgressBar1.Position := AWorkCount;
end;

procedure TForm2.RESTDWDataBase1WorkBegin(ASender: TObject;
  AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
 FBytesToTransfer      := AWorkCountMax;
 ProgressBar1.Max      := FBytesToTransfer;
 ProgressBar1.Position := 0;
end;

procedure TForm2.RESTDWDataBase1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
 ProgressBar1.Position := FBytesToTransfer;
 FBytesToTransfer      := 0;
end;

end.
