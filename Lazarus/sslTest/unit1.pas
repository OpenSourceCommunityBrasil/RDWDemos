unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  uRESTDWAuthenticators;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonRandomDigits: TButton;
    ButtonRandomDigits1: TButton;
    ButtonRandomDigits2: TButton;
    ButtonRandomDigits3: TButton;
    ButtonRandomDigits4: TButton;
    ButtonRandomString: TButton;
    ButtonRandomString1: TButton;
    ButtonRandomString2: TButton;
    ButtonRandomString3: TButton;
    EditServerName: TEdit;
    EditOrganization: TEdit;
    EditOrgUnit: TEdit;
    EditCommonName: TEdit;
    EditExpiresDays: TEdit;
    EditState: TEdit;
    EditRandomString: TEdit;
    EditRandomDigits: TEdit;
    EditCountry: TEdit;
    EditLocality: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LabelRandomString: TLabel;
    MemoHeader1: TMemo;
    MemoJWT1: TMemo;
    MemoPayload1: TMemo;
    MemoSignature1: TMemo;
    MemoX509Certificate: TMemo;
    MemoPublicKey: TMemo;
    MemoHeader2: TMemo;
    MemoPayload2: TMemo;
    MemoSignature2: TMemo;
    MemoX509PrivateKey: TMemo;
    MemoPrivateKey: TMemo;
    MemoJWT2: TMemo;
    PageControl1: TPageControl;
    TabItemDecodeJWT: TTabSheet;
    TabItemEncodeJWT: TTabSheet;
    TabItemJWTCertificate: TTabSheet;
    TabItemX509Cert: TTabSheet;
    TabItemRandom: TTabSheet;
    ToolBarLabel: TLabel;
    procedure ButtonRandomDigits1Click(Sender: TObject);
    procedure ButtonRandomDigits2Click(Sender: TObject);
    procedure ButtonRandomDigits3Click(Sender: TObject);
    procedure ButtonRandomDigits4Click(Sender: TObject);
    procedure ButtonRandomDigitsClick(Sender: TObject);
    procedure ButtonRandomString1Click(Sender: TObject);
    procedure ButtonRandomString2Click(Sender: TObject);
    procedure ButtonRandomString3Click(Sender: TObject);
    procedure ButtonRandomStringClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses uRESTDW.OpenSsl_11,
     uRESTDW.OAuth2,
     uRESTDWProtoTypes,
     uRESTDWTools;

{ TForm1 }

function BytesToHex(const ABuffer: TBytes): String;
begin
  SetLength(Result, Length(ABuffer) * 2);
  BinToHex(PAnsiChar(ABuffer), PChar(Result), Length(ABuffer));
end;

function HexToBytes(const ABuffer: String): TBytes;
begin
  SetLength(Result, Length(ABuffer) div 2);
  HexToBin(PChar(ABuffer), PAnsiChar(Result), Length(Result));
end;

procedure TForm1.ButtonRandomDigitsClick(Sender: TObject);
begin
 EditRandomDigits.Text := TRESTDWOpenSSLHelper.RandomDigits(32);
end;

procedure TForm1.ButtonRandomString1Click(Sender: TObject);
var
  JSONWebToken: String;
  PrivateKey: RawByteString;
  PrivateKeyBytes: TRESTDWBytes;
  JWT: TRESTDWJWT;
begin
  { Extract the Private Key from the memo }
  PrivateKey := RawByteString(MemoPrivateKey.Text);
  SetLength(PrivateKeyBytes, Length(PrivateKey));
  Move(PrivateKey[1], PrivateKeyBytes[0], Length(PrivateKey));

  { Initialize the JWT }
  JWT := TRESTDWJWT.Create;
  Try
   JWT.Initialize(MemoHeader2.Text, MemoPayload2.Text);
   { Sign the JWT }
   if JWT.Sign(PrivateKeyBytes, JSONWebToken) then
    begin
     MemoJWT2.Text := JSONWebToken;
     MemoSignature2.Text := BytesToHex(TBytes(JWT.Signature));
     ShowMessage('Encoded!');
    end
   else
    ShowMessage('Failed Encoded!');
  finally
   FreeAndnil(JWT);
  end;
end;

procedure TForm1.ButtonRandomString2Click(Sender: TObject);
var
  JWT: TRESTDWJWT;
begin
 JWT := TRESTDWJWT.Create;
 Try
  if JWT.Decode(MemoJWT1.Text) then
  begin
    MemoHeader1.Text := StringOf(TBytes(JWT.Header));
    MemoPayload1.Text := StringOf(TBytes(JWT.Payload));
    MemoSignature1.Text := BytesToHex(TBytes(JWT.Signature));
    ShowMessage('Decoded!');
  end
  else
    ShowMessage('Failed Decoded!');
 Finally
  FreeAndNil(JWT);
 End;
end;

procedure TForm1.ButtonRandomString3Click(Sender: TObject);
var
  JWT: TRESTDWJWT;
  JSONWebToken: String;
  PublicKey: RawByteString;
  JSONWebTokenBytes, PublicKeyBytes: TRESTDWBytes;
begin
 JWT := TRESTDWJWT.Create;
 Try
  if JWT.Decode(MemoJWT1.Text) then
  begin
    { Extract the JWT from the memo }
    JSONWebToken := MemoJWT1.Text;
    SetLength(JSONWebTokenBytes, Length(JSONWebToken));
    Move(JSONWebToken[1], JSONWebTokenBytes[0], Length(JSONWebToken));

    { Extract the Public Key from the memo }
    PublicKey := RawByteString(MemoPublicKey.Text);
    SetLength(PublicKeyBytes, Length(PublicKey));
    Move(PublicKey[1], PublicKeyBytes[0], Length(PublicKey));

    { Verify the JWT was signed using the Public Key }
    if JWT.VerifyWithPublicKey(JSONWebToken, PublicKeyBytes) then
      ShowMessage('Verified!')
    else
      ShowMessage('Failed Verify!');
  end;
 Finally
  FreeAndnil(JWT);
 End;
end;


procedure TForm1.ButtonRandomDigits1Click(Sender: TObject);
var
  Certificate,
  PrivateKey     : TRESTDWBytes;
//  CertificateCA,
//  PrivateKeyCA   : TRESTDWBytes;
begin
  if TRESTDWOpenSSLHelper.CreateSelfSignedCert_X509(EditCountry.Text,
                                                    EditState.Text,
                                                    EditLocality.Text,
                                                    EditOrganization.Text,
                                                    EditOrgUnit.Text,
                                                    EditCommonName.Text,
                                                    EditServerName.Text,
                                                    StrToInt(EditExpiresDays.Text),
                                                    Certificate, PrivateKey) then
  begin
    MemoX509Certificate.Text := StringOf(TBytes(Certificate));
    MemoX509PrivateKey.Text := StringOf(TBytes(PrivateKey));
//    if TRESTDWOpenSSLHelper.CreateSelfSignedCert_X509CA(Certificate,
//                                                        PrivateKey,
//                                                        '',//Password
//                                                        EditCountry.Text,
//                                                        EditState.Text,
//                                                        EditLocality.Text,
//                                                        EditOrganization.Text,
//                                                        EditOrgUnit.Text,
//                                                        EditCommonName.Text,
//                                                        EditServerName.Text,
//                                                        EditExpiresDays.Text.ToInteger,
//                                                        CertificateCA, PrivateKeyCA) Then
//    Begin
//     MemoX509Certificate.Text := StringOf(TBytes(CertificateCA));
//     MemoX509PrivateKey.Text := StringOf(TBytes(PrivateKeyCA));
     ShowMessage('Created!');
//    End;
  end
  else
    ShowMessage('Failed Created!');
end;

procedure TForm1.ButtonRandomDigits2Click(Sender: TObject);
begin
   MemoJWT2.Text := '';
   MemoSignature2.Text := '';
end;

procedure TForm1.ButtonRandomDigits3Click(Sender: TObject);
begin
  MemoHeader1.Text := '';
  MemoPayload1.Text := '';
  MemoSignature1.Text := '';
end;

procedure TForm1.ButtonRandomDigits4Click(Sender: TObject);
var
  JWT: TRESTDWJWT;
  JSONWebToken: String;
  JSONWebTokenBytes,
  PrivateKeyBytes: TRESTDWBytes;
begin
 JWT := TRESTDWJWT.Create;
 Try
  if JWT.Decode(MemoJWT1.Text) then
  begin
    { Extract the JWT from the memo }
    JSONWebToken := MemoJWT1.Text;
    SetLength(JSONWebTokenBytes, Length(JSONWebToken));
    Move(JSONWebToken[1], JSONWebTokenBytes[0], Length(JSONWebToken));

    { Extract the Public Key from the memo }
    PrivateKeyBytes := StringToBytes(MemoPrivateKey.Text);

    { Verify the JWT was signed using the Public Key }
    if JWT.VerifyWithPrivateKey(JSONWebToken, PrivateKeyBytes) then
      ShowMessage('Verified!')
    else
      ShowMessage('Failed Verify!');
  end;
 Finally
  FreeAndNil(JWT);
 End;
end;

procedure TForm1.ButtonRandomStringClick(Sender: TObject);
begin
 EditRandomString.Text := TRESTDWOpenSSLHelper.RandomString(32);
end;

end.

