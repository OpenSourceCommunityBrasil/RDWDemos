object ServerMethodDM: TServerMethodDM
  OldCreateOrder = False
  OnCreate = ServerMethodDataModuleCreate
  Encoding = esUtf8
  QueuedRequest = False
  Left = 531
  Top = 234
  Height = 288
  Width = 390
  object RESTDWPoolerDB1: TRESTDWPoolerDB
    RESTDriver = RESTDWDriverZeos1
    Compression = True
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    Active = True
    PoolerOffMessage = 'RESTPooler not active.'
    ParamCreate = True
    Left = 52
    Top = 111
  end
  object ZConnection1: TZConnection
    ControlsCodePage = cGET_ACP
    AutoEncodeStrings = False
    ClientCodepage = 'ISO8859_1'
    Properties.Strings = (
      'codepage=ISO8859_1')
    BeforeConnect = ZConnection1BeforeConnect
    Port = 3050
    Protocol = 'firebird-2.5'
    Left = 56
    Top = 16
  end
  object RESTDWDriverZeos1: TRESTDWDriverZeos
    CommitRecords = 100
    Connection = ZConnection1
    Left = 56
    Top = 64
  end
  object ZQuery1: TZQuery
    Connection = ZConnection1
    Params = <>
    Left = 120
    Top = 16
  end
  object RESTDWServerEvents1: TRESTDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
        Params = <>
        DataMode = dmDataware
        Name = 'dwevent1'
        EventName = 'dwevent1'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
      end>
    Left = 88
    Top = 176
  end
end
