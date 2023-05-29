object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'ICS Test Server'
  ClientHeight = 328
  ClientWidth = 452
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 272
    Top = 27
    Width = 34
    Height = 15
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 8
    Top = 71
    Width = 20
    Height = 15
    Caption = 'Log'
  end
  object ToggleSwitch1: TToggleSwitch
    Left = 176
    Top = 27
    Width = 73
    Height = 20
    TabOrder = 0
    OnClick = ToggleSwitch1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 92
    Width = 436
    Height = 157
    TabOrder = 1
  end
  object LabeledEdit1: TLabeledEdit
    Left = 92
    Top = 27
    Width = 65
    Height = 23
    EditLabel.Width = 28
    EditLabel.Height = 15
    EditLabel.Caption = 'Porta'
    TabOrder = 2
    Text = ''
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 0
    Width = 78
    Height = 65
    Caption = 'Pooler'
    Items.Strings = (
      'Indy'
      'ICS')
    TabOrder = 3
  end
  object RESTDWAuthBasic1: TRESTDWAuthBasic
    AuthDialog = True
    UserName = 'testserver'
    Password = 'testserver'
    Left = 360
    Top = 264
  end
  object RESTDWIdServicePooler1: TRESTDWIdServicePooler
    Active = False
    Authenticator = RESTDWAuthBasic1
    CORS = False
    CORS_CustomHeaders.Strings = (
      'Access-Control-Allow-Origin=*'
      
        'Access-Control-Allow-Headers=Content-Type, Origin, Accept, Autho' +
        'rization, X-CUSTOM-HEADER')
    PathTraversalRaiseError = True
    RequestTimeout = -1
    ServicePort = 8082
    ProxyOptions.ProxyPort = 0
    Encoding = esUtf8
    RootPath = '/'
    ForceWelcomeAccess = False
    CriptOptions.Use = False
    CriptOptions.Key = 'RDWBASEKEY256'
    EncodeErrors = False
    ServerIPVersionConfig.IPv4Address = '0.0.0.0'
    ServerIPVersionConfig.IPv6Address = '::'
    SSLVerifyMode = []
    SSLVerifyDepth = 0
    SSLMode = sslmUnassigned
    SSLMethod = sslvSSLv2
    SSLVersions = []
    Left = 56
    Top = 256
  end
  object RESTDWIcsServicePooler1: TRESTDWIcsServicePooler
    Active = False
    Authenticator = RESTDWAuthBasic1
    CORS = False
    CORS_CustomHeaders.Strings = (
      'Access-Control-Allow-Origin=*'
      
        'Access-Control-Allow-Headers=Content-Type, Origin, Accept, Autho' +
        'rization, X-CUSTOM-HEADER')
    PathTraversalRaiseError = True
    ServicePort = 8082
    ProxyOptions.ProxyPort = 0
    Encoding = esUtf8
    RootPath = '/'
    ForceWelcomeAccess = False
    CriptOptions.Use = False
    CriptOptions.Key = 'RDWBASEKEY256'
    EncodeErrors = False
    ServerIPVersionConfig.IPv4Address = '0.0.0.0'
    ServerIPVersionConfig.IPv6Address = '::'
    SSLVerifyMode = []
    SSLCacheModes = []
    SSLCliCertMethod = sslCliCertNone
    Left = 208
    Top = 256
  end
end
