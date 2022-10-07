object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'WebPascal Minimal'
  ClientHeight = 294
  ClientWidth = 491
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object ToggleSwitch1: TToggleSwitch
    Left = 8
    Top = 8
    Width = 73
    Height = 20
    TabOrder = 0
    OnClick = ToggleSwitch1Click
  end
  object RESTDWIdServicePooler1: TRESTDWIdServicePooler
    Active = False
    CORS = False
    CORS_CustomHeaders.Strings = (
      'Access-Control-Allow-Origin=*'
      
        'Access-Control-Allow-Methods=GET, POST, PATCH, PUT, DELETE, OPTI' +
        'ONS'
      
        'Access-Control-Allow-Headers=Content-Type, Origin, Accept, Autho' +
        'rization, X-CUSTOM-HEADER')
    DefaultUrl = '/index'
    PathTraversalRaiseError = True
    RequestTimeout = -1
    ServicePort = 8082
    ProxyOptions.ProxyPort = 0
    AuthenticationOptions.AuthorizationOption = rdwAONone
    Encoding = esUtf8
    RootPath = '..\..\src\html'
    ForceWelcomeAccess = False
    CriptOptions.Use = False
    CriptOptions.Key = 'RDWBASEKEY256'
    SSLVersions = []
    SSLVerifyMode = []
    SSLVerifyDepth = 0
    SSLMode = sslmUnassigned
    SSLMethod = sslvSSLv2
    Left = 168
    Top = 8
  end
end
