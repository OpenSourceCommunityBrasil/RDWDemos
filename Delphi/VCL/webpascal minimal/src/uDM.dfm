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
        BaseURL = '/'
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
        BaseURL = '/'
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
end
