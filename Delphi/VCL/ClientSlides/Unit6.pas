unit Unit6;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.DBCtrls, Vcl.ExtDlgs, uRESTDWConsts, uRESTDWAbout,
  Vcl.Imaging.jpeg, uRESTDWBasicDB, uRESTDWIdBase,
  DateUtils, uRESTDWDataUtils, uRESTDWBasicTypes, uRESTDWMemoryDataset,
  Vcl.Buttons, Vcl.Grids, Vcl.DBGrids;

type
  TForm6 = class(TForm)
    DataSource1: TDataSource;
    RESTDWClientSQL1: TRESTDWClientSQL;
    DBImage1: TDBImage;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    DBNavigator1: TDBNavigator;
    OpenPictureDialog1: TOpenPictureDialog;
    RESTDWClientSQL1ID: TIntegerField;
    RESTDWClientSQL1BLOBIMAGE: TBlobField;
    RESTDWClientSQL1BLOBTEXT: TMemoField;
    DBMemo1: TDBMemo;
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
    Button3: TButton;
    rClientSQLCatalogImages: TRESTDWClientSQL;
    rClientSQLCatalogImagesID: TIntegerField;
    rClientSQLCatalogImagesFILENAME: TStringField;
    rClientSQLCatalogImagesFILEPATH: TStringField;
    rClientSQLCatalogImagesBLOBIMAGE: TBlobField;
    Button4: TButton;
    DBGrid1: TDBGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbAuthOptionsChange(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    procedure SetLoginOptions;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

Procedure TForm6.SetLoginOptions;
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

procedure TForm6.Button1Click(Sender: TObject);
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
  End;
 RESTDWClientSQL1.Active       := False;
 RESTDWClientSQL1.SQL.Clear;
 RESTDWClientSQL1.SQL.Add('select * from IMAGELIST');
 RESTDWClientSQL1.Active       := True;
end;

procedure TForm6.Button2Click(Sender: TObject);
Var
 vError : String;
begin
 If OpenPictureDialog1.Execute Then
  Begin
   RESTDWIdDatabase1.Active            := False;
   RESTDWIdDatabase1.PoolerService   := EHost.Text;
   RESTDWIdDatabase1.PoolerPort      := StrToInt(EPort.Text);
   SetLoginOptions;
   RESTDWIdDatabase1.Compression     := cbxCompressao.Checked;
   RESTDWIdDatabase1.AccessTag       := eAccesstag.Text;
   RESTDWIdDatabase1.WelcomeMessage  := eWelcomemessage.Text;
   RESTDWClientSQL1.Insert;
   TBlobField(RESTDWClientSQL1.FindField('BLOBIMAGE')).LoadFromFile(OpenPictureDialog1.FileName);
   RESTDWClientSQL1.FindField('BLOBTEXT').AsString := 'חחחבבבב';
   RESTDWClientSQL1.Post;
   If Not RESTDWClientSQL1.ApplyUpdates(vError) Then
    Showmessage(vError)
//   Else
//    Button1.OnClick(Self);
  End;
end;

procedure TForm6.Button4Click(Sender: TObject);
Var
 INICIO,
 FIM          : TDateTime;
 Path         : String;
 SR           : TSearchRec;
 vRecordcount : Integer;
Begin
 Path := 'c:\teste\';
 Try
  rClientSQLCatalogImages.Open;
  If FindFirst(Path + '*.bmp', faArchive, SR) = 0 Then
   Begin
    Repeat
     rClientSQLCatalogImages.Insert;
     rClientSQLCatalogImagesFILENAME.AsString := SR.Name;
     rClientSQLCatalogImagesFILEPATH.AsString := Path;
     rClientSQLCatalogImagesBLOBIMAGE.LoadFromFile(Path + SR.Name);
     rClientSQLCatalogImages.Post;
    Until FindNext(SR) <> 0;
    FindClose(SR);
   End;
 Finally
  vRecordcount := rClientSQLCatalogImages.MassiveCount;
  INICIO       := Now;
  If vRecordcount > 0 Then
   rClientSQLCatalogImages.ApplyUpdates;
  FIM := Now;
  rClientSQLCatalogImages.Close;
  If vRecordcount > 0 Then
   Showmessage(IntToStr(vRecordcount) + ' registro(s) enviados em ' + IntToStr(MilliSecondsBetween(FIM, INICIO)) + ' Milis.');
 End;
End;

procedure TForm6.cbAuthOptionsChange(Sender: TObject);
begin
 pTokenAuth.Visible := cbAuthOptions.ItemIndex > 1;
 pBasicAuth.Visible := cbAuthOptions.ItemIndex = 1;
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
 labVersao.Caption := RESTDWVersao;
end;

end.
