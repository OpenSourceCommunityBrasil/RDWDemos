unit uprincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uRESTDWSelfSigned,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.Imaging.pngimage;

type
  Tfprincipal = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    bGerar: TButton;
    Label1: TLabel;
    eCountry: TEdit;
    Label2: TLabel;
    eState: TEdit;
    Label3: TLabel;
    eLocality: TEdit;
    eEmail: TEdit;
    eOrgUnit: TEdit;
    eOrganization: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    eCommonName: TEdit;
    Label8: TLabel;
    ePassword: TEdit;
    bVerSenha: TSpeedButton;
    Image1: TImage;
    Label9: TLabel;
    eSalvar: TEdit;
    Label10: TLabel;
    eExpires: TEdit;
    Label11: TLabel;
    procedure bGerarClick(Sender: TObject);
    procedure bVerSenhaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fprincipal: Tfprincipal;

implementation

{$R *.dfm}

procedure Tfprincipal.bGerarClick(Sender: TObject);
var
  vCert: TRESTDWSelfSigned;
  vPrivKeyType: TSslPrivKeyType;
  vCertDigest: TSslDigest;
  vExpireDays : integer;
  pkey, cert, msg : string;
begin
  vCert := TRESTDWSelfSigned.Create(nil);

  vExpireDays := StrToIntDef(eExpires.Text,365);
  vPrivKeyType := PrivKeyRsa4096;
  vCertDigest := Digest_sha512;

  vCert.Country := 'BR';
  if Trim(eCountry.Text) <> '' then
    vCert.Country := eCountry.Text;

  vCert.State := eState.Text;
  vCert.Locality := eLocality.Text;
  vCert.Organization := eOrganization.Text;
  vCert.OrgUnit := eOrgUnit.Text;
  vCert.Email := eEmail.Text;
  vCert.CommonName := eCommonName.Text;
  vCert.PrivateKeyType := vPrivKeyType;
  vCert.CertDigest := vCertDigest;
  vCert.ExpiresDays := vExpireDays;

  vCert.CreateSelfSignedCert;

  pkey := Trim(eSalvar.Text);
  if pkey = '' then
    pkey := ExtractFilePath(ParamStr(0));
  pkey := IncludeTrailingPathDelimiter(pkey);

  cert := pkey + 'cert.pem';
  pkey := pkey + 'pkey.pem';

  vCert.SavePrivateKeyToPemFile(pkey,ePassword.Text,PrivKeyEncTripleDES);
  vCert.SaveCertToPemFile(cert);
  vCert.Free;

  msg := 'Certificados salvos em:'+#13#10;
  msg := msg + 'Private: '+pkey+#13#10;
  msg := msg + 'Cert File: '+cert;
  MessageDlg(msg,mtInformation,[mbOK],0);
end;

procedure Tfprincipal.bVerSenhaClick(Sender: TObject);
begin
  if ePassword.PasswordChar = '*' then
    ePassword.PasswordChar := #0
  else
    ePassword.PasswordChar := '*';
end;

procedure Tfprincipal.FormCreate(Sender: TObject);
begin
  eSalvar.Text := ExtractFilePath(ParamStr(0));
end;

end.
