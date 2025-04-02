unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.ComCtrls, Vcl.DBCtrls, IdComponent, Vcl.Mask, Vcl.Buttons, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uRESTDWConsts, uRESTDWBasicTypes, uRESTDWBasic, uRESTDWBasicDB,
  uRESTDWProtoTypes, uRESTDWIdBase, uRESTDWDataUtils, Vcl.Imaging.jpeg,
  uRESTDWAbout, uRESTDWMemoryDataset;

type
  TForm5 = class(TForm)
    RESTDWClientSQL1: TRESTDWClientSQL;
    Label1: TLabel;
    Bevel2: TBevel;
    DataSource1: TDataSource;
    ProgressBar1: TProgressBar;
    Button1: TButton;
    DBNavigator1: TDBNavigator;
    Label2: TLabel;
    Label3: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBImage1: TDBImage;
    BitBtn1: TBitBtn;
    Label11: TLabel;
    DBText1: TDBText;
    RESTDWClientSQL1ID_PESSOA: TIntegerField;
    RESTDWClientSQL1NM_LOGIN: TStringField;
    RESTDWClientSQL1DS_SENHA: TStringField;
    RESTDWClientSQL1DS_FOTO: TBlobField;
    RESTDWClientSQL1ID_USUARIO: TIntegerField;
    RESTDWClientSQL1FL_ATIVO: TStringField;
    RESTDWClientSQL1DT_INCLUSAO: TSQLTimeStampField;
    RESTDWClientSQL1DT_ALTERACAO: TSQLTimeStampField;
    RESTDWClientSQL1CALCFIELD: TIntegerField;
    RESTDWIdDatabase1: TRESTDWIdDatabase;
    labHost: TLabel;
    labPorta: TLabel;
    labAcesso: TLabel;
    labWelcome: TLabel;
    labExtras: TLabel;
    labConexao: TLabel;
    labVersao: TLabel;
    Label4: TLabel;
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
    cbBinaryCompatible: TCheckBox;
    cbAuthOptions: TComboBox;
    pBasicAuth: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    edUserNameDW: TEdit;
    edPasswordDW: TEdit;
    pTokenAuth: TPanel;
    Label12: TLabel;
    Label13: TLabel;
    lTokenBegin: TLabel;
    lTokenEnd: TLabel;
    Label21: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    eTokenID: TEdit;
    EdPasswordAuth: TEdit;
    EdUserNameAuth: TEdit;
    Button2: TButton;
    procedure RESTDWDataBase1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure RESTDWDataBase1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure RESTDWDataBase1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure BitBtn1Click(Sender: TObject);
    procedure RESTDWClientSQL1CalcFields(DataSet: TDataSet);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbAuthOptionsChange(Sender: TObject);
  private
    { Private declarations }
   FBytesToTransfer : Int64;
   procedure SetLoginOptions;
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.BitBtn1Click(Sender: TObject);
begin
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
 RESTDWClientSQL1.Close;
 RESTDWClientSQL1.SQL.Clear;
 RESTDWClientSQL1.SQL.Add('SELECT * FROM TB_USUARIO WHERE ID_PESSOA = :ID_PESSOA or NM_LOGIN like upper(:NM_LOGIN)');
 RESTDWClientSQL1.ParamByName('ID_PESSOA').AsInteger := 0;
 RESTDWClientSQL1.ParamByName('NM_LOGIN').AsString := '%' + Inputbox('Pesquisa de dados', 'Digite o valor', '') + '%';
 RESTDWClientSQL1.Open;
end;

Procedure TForm5.SetLoginOptions;
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

procedure TForm5.Button1Click(Sender: TObject);
begin
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
 RESTDWClientSQL1.Close;
 RESTDWClientSQL1.Open;
end;

procedure TForm5.cbAuthOptionsChange(Sender: TObject);
begin
 pTokenAuth.Visible := cbAuthOptions.ItemIndex > 1;
 pBasicAuth.Visible := cbAuthOptions.ItemIndex = 1;
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
 labVersao.Caption := RESTDWVersao;
end;

procedure TForm5.RESTDWClientSQL1CalcFields(DataSet: TDataSet);
begin
 If RESTDWClientSQL1.Active Then
  RESTDWClientSQL1CALCFIELD.AsInteger := RESTDWClientSQL1.RecNo;
end;

procedure TForm5.RESTDWDataBase1Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  If FBytesToTransfer = 0 Then // No Update File
   Exit;
  ProgressBar1.Position := AWorkCount;
end;

procedure TForm5.RESTDWDataBase1WorkBegin(ASender: TObject;
  AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
 FBytesToTransfer      := AWorkCountMax;
 ProgressBar1.Max      := FBytesToTransfer;
 ProgressBar1.Position := 0;
end;

procedure TForm5.RESTDWDataBase1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
 ProgressBar1.Position := FBytesToTransfer;
 FBytesToTransfer      := 0;
end;

end.
