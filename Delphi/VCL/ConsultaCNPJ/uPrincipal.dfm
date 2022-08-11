object fClientREST: TfClientREST
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Client REST'
  ClientHeight = 310
  ClientWidth = 698
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 25
    Height = 13
    Caption = 'CNPJ'
  end
  object Button1: TButton
    Left = 192
    Top = 19
    Width = 107
    Height = 25
    Caption = 'Consultar'
    TabOrder = 0
    OnClick = Button1Click
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 50
    Width = 698
    Height = 260
    Align = alBottom
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object edCNPJ: TEdit
    Left = 55
    Top = 21
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '00000000000191'
  end
  object RESTDWClientSQL1: TRESTDWClientSQL
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    BinaryCompatibleMode = False
    MasterCascadeDelete = True
    BinaryRequest = False
    Datapacks = -1
    DataCache = False
    MassiveType = mtMassiveCache
    Params = <>
    CacheUpdateRecords = True
    AutoCommitData = False
    AutoRefreshAfterCommit = False
    ThreadRequest = False
    RaiseErrors = True
    ReflectChanges = False
    Left = 144
    Top = 96
  end
  object DataSource1: TDataSource
    DataSet = RESTDWClientSQL1
    Left = 176
    Top = 96
  end
  object DWClientREST: TRESTDWIdClientREST
    UseSSL = True
    UserAgent = 
      'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, l' +
      'ike Gecko) Chrome/41.0.2227.0 Safari/537.36'
    Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Charset = 'utf8'
    ContentEncoding = 'multipart/form-data'
    MaxAuthRetries = 0
    ContentType = 'application/json'
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
    Left = 64
    Top = 216
  end
end
