object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'SimpleServer'
  ClientHeight = 185
  ClientWidth = 411
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
    Top = 16
    Width = 73
    Height = 20
    TabOrder = 0
    OnClick = ToggleSwitch1Click
  end
  object RESTDWServiceSynPooler1: TRESTDWServiceSynPooler
    Active = False
    ServerThreadPoolCount = 32
    PathTraversalRaiseError = True
    CORS = False
    CORS_CustomHeaders.Strings = (
      'Access-Control-Allow-Origin=*'
      
        'Access-Control-Allow-Methods=GET, POST, PATCH, PUT, DELETE, OPTI' +
        'ONS'
      
        'Access-Control-Allow-Headers=Content-Type, Origin, Accept, Autho' +
        'rization, X-CUSTOM-HEADER')
    UseSSL = False
    RequestTimeout = -1
    ServicePort = 8082
    ProxyOptions.Port = 8888
    AuthenticationOptions.AuthorizationOption = rdwAONone
    Encoding = esUtf8
    RootPath = '/'
    RootUser = 'root'
    ForceWelcomeAccess = False
    CriptOptions.Use = False
    CriptOptions.Key = 'RDWBASEKEY256'
    Left = 232
    Top = 24
  end
end
