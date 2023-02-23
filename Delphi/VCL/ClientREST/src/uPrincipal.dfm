object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Demo ClientREST'
  ClientHeight = 291
  ClientWidth = 281
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 269
    Height = 23
    TabOrder = 0
    Text = 'https://www.receitaws.com.br/v1/cnpj/'
  end
  object Button1: TButton
    Left = 8
    Top = 37
    Width = 75
    Height = 25
    Caption = 'GET'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 72
    Width = 269
    Height = 211
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
  object RESTDWIdClientREST1: TRESTDWIdClientREST
    UseSSL = True
    UserAgent = 
      'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, l' +
      'ike Gecko) Chrome/41.0.2227.0 Safari/537.36'
    Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Charset = 'utf8'
    ContentEncoding = 'gzip, identity'
    MaxAuthRetries = 0
    ContentType = 'application/x-www-form-urlencoded'
    RequestCharset = esUtf8
    RequestTimeOut = 5000
    ConnectTimeOut = 5000
    RedirectMaximum = 1
    AllowCookies = False
    HandleRedirects = False
    AuthenticationOptions.AuthorizationOption = rdwAONone
    AccessControlAllowOrigin = '*'
    ProxyOptions.ProxyPort = 0
    VerifyCert = False
    SSLVersions = [sslvTLSv1_2]
    CertMode = sslmUnassigned
    PortCert = 0
    Left = 80
    Top = 168
  end
end
