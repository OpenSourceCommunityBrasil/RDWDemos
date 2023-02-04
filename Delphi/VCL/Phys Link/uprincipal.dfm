object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 517
  ClientWidth = 1009
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 128
    Top = 280
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Button1: TButton
    Left = 128
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Query'
    TabOrder = 0
    OnClick = Button1Click
  end
  object DBGrid1: TDBGrid
    Left = 328
    Top = 48
    Width = 633
    Height = 377
    DataSource = ds
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Button2: TButton
    Left = 128
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Table'
    TabOrder = 2
    OnClick = Button2Click
  end
  object conn: TFDConnection
    Params.Strings = (
      'DriverID=RESTDW')
    Connected = True
    LoginPrompt = False
    Left = 104
    Top = 80
  end
  object rdw_database: TRESTDWIdDatabase
    Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    ContentType = 'application/x-www-form-urlencoded'
    Charset = 'utf8'
    ContentEncoding = 'gzip, identity'
    Active = True
    Compression = True
    CriptOptions.Use = False
    CriptOptions.Key = 'RDWBASEKEY256'
    MyIP = '127.0.0.1'
    IgnoreEchoPooler = False
    AuthenticationOptions.AuthorizationOption = rdwAOBearer
    AuthenticationOptions.OptionParams.AuthDialog = True
    AuthenticationOptions.OptionParams.CustomDialogAuthMessage = 'Protected Space...'
    AuthenticationOptions.OptionParams.Custom404TitleMessage = '(404) The address you are looking for does not exist'
    AuthenticationOptions.OptionParams.Custom404BodyMessage = '404'
    AuthenticationOptions.OptionParams.Custom404FooterMessage = 'Take me back to <a href="./">Home REST Dataware'
    AuthenticationOptions.OptionParams.TokenType = rdwTS
    AuthenticationOptions.OptionParams.TokenRequestType = rdwtHeader
    AuthenticationOptions.OptionParams.GetTokenEvent = 'GetToken'
    AuthenticationOptions.OptionParams.Key = 'token'
    AuthenticationOptions.OptionParams.AutoGetToken = True
    AuthenticationOptions.OptionParams.AutoRenewToken = False
    Proxy = False
    ProxyOptions.Port = 8888
    PoolerService = '127.0.0.1'
    PoolerPort = 8082
    PoolerName = 'Tdm_rest.poolerdb'
    StateConnection.AutoCheck = False
    StateConnection.InTime = 1000
    RequestTimeOut = 10000
    ConnectTimeOut = 3000
    EncodedStrings = True
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    PoolerNotFoundMessage = 'Pooler not found'
    HandleRedirects = False
    RedirectMaximum = 0
    ParamCreate = True
    FailOver = False
    FailOverConnections = <>
    FailOverReplaceDefaults = False
    ClientConnectionDefs.Active = False
    UseSSL = False
    SSLVersions = []
    UserAgent = 
      'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, l' +
      'ike Gecko) Chrome/41.0.2227.0 Safari/537.36'
    SSLMode = sslmUnassigned
    Left = 256
    Top = 80
  end
  object q1: TFDQuery
    Connection = conn
    SQL.Strings = (
      'select * from banco')
    Left = 256
    Top = 176
  end
  object ds: TDataSource
    DataSet = tb
    Left = 248
    Top = 256
  end
  object tb: TFDTable
    AfterPost = tbAfterPost
    CachedUpdates = True
    IndexFieldNames = 'COD_SETOR'
    Connection = conn
    UpdateOptions.UpdateTableName = 'SETOR'
    TableName = 'SETOR'
    Left = 248
    Top = 328
  end
  object RESTDWFireDACPhysLink1: TRESTDWFireDACPhysLink
    Database = rdw_database
    RDBMS = 9
    Left = 96
    Top = 328
  end
end
