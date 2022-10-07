object DM: TDM
  Encoding = esUtf8
  QueuedRequest = False
  Height = 238
  Width = 370
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
  object RESTDWPoolerDB1: TRESTDWPoolerDB
    RESTDriver = RESTDWDriverFD1
    Compression = True
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    Active = True
    PoolerOffMessage = 'RESTPooler not active.'
    ParamCreate = True
    Left = 288
    Top = 16
  end
  object RESTDWDriverFD1: TRESTDWDriverFD
    CommitRecords = 100
    Connection = FDConnection1
    Left = 288
    Top = 72
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Server=OCSServer'
      'User_Name=postgres'
      'Password=admin'
      'Database=testedbware'
      'DriverID=PG')
    LoginPrompt = False
    Left = 288
    Top = 128
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
end
