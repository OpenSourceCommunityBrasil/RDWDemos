object DM: TDM
  OnCreate = ServerMethodDataModuleCreate
  Encoding = esUtf8
  QueuedRequest = False
  Height = 238
  Width = 409
  object RESTDWServerEvents1: TRESTDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
        Params = <>
        DataMode = dmDataware
        Name = 'teste'
        EventName = 'teste'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
        OnReplyEventByType = teste
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        Params = <>
        DataMode = dmRAW
        Name = 'testebody'
        EventName = 'testebody'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
        OnReplyEventByType = testebody
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        Params = <>
        DataMode = dmRAW
        Name = 'testeheader'
        EventName = 'testeheader'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
        OnReplyEventByType = testeheader
      end>
    Left = 64
    Top = 32
  end
  object PoolerDBFireDAC: TRESTDWPoolerDB
    RESTDriver = RDWDriverFD
    Compression = True
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    Active = True
    PoolerOffMessage = 'RESTPooler not active.'
    ParamCreate = True
    Left = 320
    Top = 24
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=testedbware'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 320
    Top = 160
  end
  object RESTDWServerContext1: TRESTDWServerContext
    IgnoreInvalidParams = False
    ContextList = <
      item
        Params = <>
        ContentType = 'application/pdf'
        Name = 'relatorio'
        BaseURL = '/'
        ContextName = 'relatorio'
        Routes = [crAll]
        OnlyPreDefinedParams = False
        IgnoreBaseHeader = False
        NeedAuthorization = True
        OnReplyRequestStream = relatorio
      end>
    Left = 64
    Top = 96
  end
  object PoolerDBZeos: TRESTDWPoolerDB
    RESTDriver = RDWDriverZeos
    Compression = True
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    Active = True
    PoolerOffMessage = 'RESTPooler not active.'
    ParamCreate = True
    Left = 192
    Top = 24
  end
  object RDWDriverFD: TRESTDWDriverFD
    CommitRecords = 100
    Connection = FDConnection1
    Left = 320
    Top = 88
  end
  object RDWDriverZeos: TRESTDWDriverZeos
    CommitRecords = 100
    Connection = ZConnection1
    Left = 192
    Top = 88
  end
  object ZConnection1: TZConnection
    ControlsCodePage = cCP_UTF16
    Catalog = ''
    HostName = ''
    Port = 0
    Database = 'testedbware'
    User = ''
    Password = ''
    Protocol = 'sqlite-3'
    Left = 192
    Top = 160
  end
end
