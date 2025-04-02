unit ucadimagelist;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, uRESTDWBasicDB, uRESTDWIdBase, Data.DB, uRESTDWDataUtils,
  uRESTDWMemoryDataset, uRESTDWBasicTypes, uRESTDWProtoTypes, Vcl.DBCtrls, Vcl.Buttons,
  Vcl.Grids, Vcl.DBGrids, System.DateUtils, Vcl.ExtDlgs, uRESTDWAbout;

type
  Tfcadimagelist = class(TForm)
    labHost: TLabel;
    labPorta: TLabel;
    labAcesso: TLabel;
    labWelcome: TLabel;
    labExtras: TLabel;
    labConexao: TLabel;
    labVersao: TLabel;
    Label11: TLabel;
    eHost: TEdit;
    ePort: TEdit;
    cbxCompressao: TCheckBox;
    chkhttps: TCheckBox;
    eAccesstag: TEdit;
    eWelcomemessage: TEdit;
    paTopo: TPanel;
    Image1: TImage;
    labSistema: TLabel;
    paPortugues: TPanel;
    Image3: TImage;
    paEspanhol: TPanel;
    Image4: TImage;
    paIngles: TPanel;
    Image2: TImage;
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
    rcDados: TRESTDWClientSQL;
    DataSource1: TDataSource;
    RESTDWIdDatabase1: TRESTDWIdDatabase;
    DBNavigator1: TDBNavigator;
    SpeedButton1: TSpeedButton;
    sbnew: TSpeedButton;
    sbedit: TSpeedButton;
    sbdelete: TSpeedButton;
    sbcancel: TSpeedButton;
    sbapply: TSpeedButton;
    sbpost: TSpeedButton;
    pCad: TPanel;
    DBImage2: TDBImage;
    DBMemo2: TDBMemo;
    Label1: TLabel;
    DBText1: TDBText;
    OpenPictureDialog1: TOpenPictureDialog;
    SpeedButton2: TSpeedButton;
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rcDadosAfterCancel(DataSet: TDataSet);
    procedure sbnewClick(Sender: TObject);
    procedure sbeditClick(Sender: TObject);
    procedure sbdeleteClick(Sender: TObject);
    procedure sbcancelClick(Sender: TObject);
    procedure sbpostClick(Sender: TObject);
    procedure sbapplyClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
   vSecresString    : String;
   Procedure SetLoginOptions;
   Procedure DatasetState(State: TDatasetState);
  public
    { Public declarations }
   Procedure Locale_Portugues(pLocale : String);
   Property SecresString : String Read vSecresString;
  end;

var
  fcadimagelist: Tfcadimagelist;

implementation

{$R *.dfm}

Uses URESTDWConsts;

procedure Tfcadimagelist.DatasetState(State : TDatasetState);
Begin
// pgrid.Visible    := Not(State in [dsEdit, dsInsert]);
 pcad.Visible     := True;
 sbnew.Enabled    := State in [dsBrowse];
 sbedit.Enabled   := sbnew.Enabled;
 sbdelete.Enabled := (sbnew.Enabled)  And
                     (rcDados.Active) And
                     (rcDados.RecordCount > 0);
 sbcancel.Enabled := State in [dsEdit, dsInsert];
 sbpost.Enabled   := sbcancel.Enabled;
 sbapply.Enabled  := (rcDados.Active) And (sbnew.Enabled) And (rcDados.MassiveCount > 0)
End;

procedure Tfcadimagelist.Button2Click(Sender: TObject);
begin
 Showmessage(SecresString);
end;

procedure Tfcadimagelist.FormCreate(Sender: TObject);
begin
 labVersao.Caption := RESTDWVersao;
 DatasetState(rcDados.state);
end;

Procedure Tfcadimagelist.Locale_Portugues( pLocale : String );
Begin
 If pLocale = 'portugues'     Then
  Begin
   paPortugues.Color     := clWhite;
   paEspanhol.Color      := $002a2a2a;
   paIngles.Color        := $002a2a2a;
   labConexao.Caption    := ' .: CONFIGURAÇÃO DO SERVIDOR';
   cbxCompressao.Caption := 'Compressão';
  End
 Else If pLocale = 'ingles'   Then
  Begin
   paPortugues.Color     := $002a2a2a;
   paEspanhol.Color      := $002a2a2a;
   paIngles.Color        := clWhite;
   labConexao.Caption    := ' .: SQL COMMAND';
   cbxCompressao.Caption := 'Compresión';
  End
 Else If pLocale = 'espanhol' Then
  Begin
   paPortugues.Color     := $002a2a2a;
   paEspanhol.Color      := clWhite;
   paIngles.Color        := $002a2a2a;
   labConexao.Caption    := ' .: CONFIGURATIÓN DEL SERVIDOR';
   cbxCompressao.Caption := 'Compressão';
  End;
End;

procedure Tfcadimagelist.rcDadosAfterCancel(DataSet: TDataSet);
begin
 DatasetState(DataSet.State);
end;

procedure Tfcadimagelist.sbapplyClick(Sender: TObject);
Var
 vError : String;
begin
 If Not rcDados.ApplyUpdates(vError) Then
  Showmessage(vError)
 Else
  DatasetState(rcDados.State);
end;

procedure Tfcadimagelist.sbcancelClick(Sender: TObject);
begin
 rcDados.Cancel;
end;

procedure Tfcadimagelist.sbdeleteClick(Sender: TObject);
begin
 rcDados.Delete;
end;

procedure Tfcadimagelist.sbeditClick(Sender: TObject);
begin
 rcDados.Edit;
end;

procedure Tfcadimagelist.sbnewClick(Sender: TObject);
begin
 rcDados.Insert;
end;

procedure Tfcadimagelist.sbpostClick(Sender: TObject);
begin
 rcDados.Post;
end;

Procedure Tfcadimagelist.SetLoginOptions;
Begin
  Case cbAuthOptions.ItemIndex Of
   0 : RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption := rdwAONone;
   1 : RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption := rdwAOBasic;
   2 : RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption := rdwAOBearer;
   3 : RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption := rdwAOToken;
  End;
 If RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption in [rdwAOBearer, rdwAOToken] Then
  Begin
   If RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption = rdwAOBearer Then
    Begin
     TRESTDWAuthOptionBearerClient(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).TokenRequestType := rdwtRequest;
     TRESTDWAuthOptionBearerClient(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Token   := eTokenID.Text;
    End
   Else
    Begin
     TRESTDWAuthOptionTokenClient(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).TokenRequestType := rdwtRequest;
     TRESTDWAuthOptionTokenClient(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Token   := eTokenID.Text;
    End;
  End
 Else If RESTDWIdDatabase1.AuthenticationOptions.AuthorizationOption = rdwAOBasic Then
  Begin
   TRESTDWAuthOptionBasic(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Username := edUserNameDW.Text;
   TRESTDWAuthOptionBasic(RESTDWIdDatabase1.AuthenticationOptions.OptionParams).Password := edPasswordDW.Text;
  End;
End;

procedure Tfcadimagelist.SpeedButton1Click(Sender: TObject);
Var
 INICIO,
 FIM        : TDateTime;
 I          : Integer;
Begin
 If rcDados.Active Then
  rcDados.Active := False;
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
    RESTDWIdDatabase1.TypeRequest    := TTyperequest.trHttps
   Else
    RESTDWIdDatabase1.TypeRequest    := TTyperequest.trHttp;
  End;
 INICIO                            := Now;
 Try
  rcDados.BinaryRequest   := cbBinaryRequest.Checked;
  rcDados.Active          := True;
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
 If rcDados.Active Then
  Showmessage(IntToStr(rcDados.Recordcount) + ' registro(s) recebido(s) em ' + IntToStr(MilliSecondsBetween(FIM, INICIO)) + ' Milis.');
End;

procedure Tfcadimagelist.SpeedButton2Click(Sender: TObject);
Var
 FileStream : TStream;
begin
 FileStream := TMemoryStream.Create;
 Try
  If OpenPictureDialog1.Execute Then
   Begin
    TMemoryStream(FileStream).LoadFromFile(OpenPictureDialog1.FileName);
    FileStream.Position := 0;
   End;
//  rcDadosBLOBIMAGE.LoadFromStream(FileStream);
 Finally
  FreeAndNil(FileStream);
 End;
end;

end.
