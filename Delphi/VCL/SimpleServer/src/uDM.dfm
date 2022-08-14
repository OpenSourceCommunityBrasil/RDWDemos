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
        DataMode = dmDataware
        Name = 'teste'
        EventName = 'teste'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
        OnReplyEventByType = RESTDWServerEvents1EventstesteReplyEventByType
      end>
    Left = 64
    Top = 32
  end
end
