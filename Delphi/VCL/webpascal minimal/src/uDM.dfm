object DM: TDM
  Encoding = esUtf8
  QueuedRequest = False
  Height = 180
  Width = 282
  object RESTDWServerContext1: TRESTDWServerContext
    IgnoreInvalidParams = False
    ContextList = <
      item
        Params = <>
        ContentType = 'text/html'
        Name = 'index'
        BaseURL = '/pages/'
        ContextName = 'index'
        Routes = [crAll]
        OnlyPreDefinedParams = False
        IgnoreBaseHeader = False
        NeedAuthorization = True
        OnReplyRequestStream = index
      end
      item
        Params = <>
        ContentType = 'text/html'
        Name = 'produto'
        BaseURL = '/pages/'
        ContextName = 'produto'
        Routes = [crAll]
        OnlyPreDefinedParams = False
        IgnoreBaseHeader = False
        NeedAuthorization = True
        OnReplyRequestStream = produto
      end>
    DefaultContext = '/'
    Left = 80
    Top = 24
  end
  object RESTDWServerEvents1: TRESTDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
        Params = <>
        DataMode = dmRAW
        Name = 'index'
        EventName = 'index'
        BaseURL = '/api/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
        OnReplyEvent = RESTDWServerEvents1EventsindexReplyEvent
      end>
    Left = 80
    Top = 104
  end
end
