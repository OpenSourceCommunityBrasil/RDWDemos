object DM: TDM
  Encoding = esUtf8
  QueuedRequest = False
  Height = 156
  Width = 230
  object RESTDWServerEvents1: TRESTDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
        Params = <>
        JsonMode = jmPureJSON
        Name = 'teste'
        EventName = 'teste'
        BaseURL = '/'
        OnlyPreDefinedParams = False
        OnReplyEventByType = RESTDWServerEvents1EventstesteReplyEventByType
      end>
    Left = 64
    Top = 32
  end
end
