object DM: TDM
  Encoding = esUtf8
  QueuedRequest = False
  Height = 169
  Width = 280
  object DWServerEvents1: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'hello'
        EventName = 'hello'
        OnlyPreDefinedParams = False
        OnReplyEvent = DWServerEvents1EventshelloReplyEvent
      end>
    Left = 48
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
    Left = 192
    Top = 104
  end
  object RESTDWDriverFD1: TRESTDWDriverFD
    CommitRecords = 100
    Connection = FDConnection1
    Left = 192
    Top = 56
  end
  object FDConnection1: TFDConnection
    Left = 192
    Top = 8
  end
end
