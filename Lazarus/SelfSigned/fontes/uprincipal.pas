unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, uRESTDWSelfSigned;

type

  { TfPrincipal }

  TfPrincipal = class(TForm)
    bGerar: TButton;
    bVerSenha: TSpeedButton;
    eCommonName: TEdit;
    eCountry: TEdit;
    eEmail: TEdit;
    eExpires: TEdit;
    eLocality: TEdit;
    eOrganization: TEdit;
    eOrgUnit: TEdit;
    ePassword: TEdit;
    eSalvar: TEdit;
    eState: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure bGerarClick(Sender: TObject);
    procedure bVerSenhaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  fPrincipal: TfPrincipal;

implementation

{$R *.lfm}

{ TfPrincipal }

procedure TfPrincipal.bVerSenhaClick(Sender: TObject);
begin
  if ePassword.PasswordChar = '*' then
    ePassword.PasswordChar := #0
  else
    ePassword.PasswordChar := '*';
end;

procedure TfPrincipal.bGerarClick(Sender: TObject);
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

procedure TfPrincipal.FormCreate(Sender: TObject);
begin
  eSalvar.Text := ExtractFilePath(ParamStr(0));
end;

end.

