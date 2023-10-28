object RDWDataModule: TRDWDataModule
  OldCreateOrder = True
  Encoding = esUtf8
  OnMassiveProcess = ServerMethodDataModuleMassiveProcess
  OnUserTokenAuth = ServerMethodDataModuleUserTokenAuth
  OnGetToken = ServerMethodDataModuleGetToken
  QueuedRequest = False
  Height = 213
  Width = 361
  object RESTDWPoolerDB1: TRESTDWPoolerDB
    RESTDriver = RESTDWFireDACDriver1
    Compression = True
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    Active = True
    PoolerOffMessage = 'RESTPooler not active.'
    ParamCreate = True
    Left = 52
    Top = 103
  end
  object Server_FDConnection: TFDConnection
    Params.Strings = (
      
        'Database=D:\Meus Dados\Projetos\SUGV\Componentes\XyberPower\REST' +
        '_Controls\DEMO\EMPLOYEE.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Server=localhost'
      'Port=3050'
      'CharacterSet='
      'DriverID=FB')
    FetchOptions.AssignedValues = [evCursorKind]
    FetchOptions.CursorKind = ckDefault
    UpdateOptions.AssignedValues = [uvCountUpdatedRecords]
    ConnectedStoredUsage = []
    LoginPrompt = False
    Transaction = FDTransaction1
    BeforeConnect = Server_FDConnectionBeforeConnect
    Left = 53
    Top = 15
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 109
    Top = 59
  end
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 81
    Top = 59
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 109
    Top = 15
  end
  object FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink
    Left = 137
    Top = 59
  end
  object FDTransaction1: TFDTransaction
    Options.AutoStop = False
    Options.DisconnectAction = xdRollback
    Connection = Server_FDConnection
    Left = 81
    Top = 15
  end
  object FDQuery1: TFDQuery
    Connection = Server_FDConnection
    SQL.Strings = (
      '')
    Left = 137
    Top = 15
  end
  object FDQLogin: TFDQuery
    Connection = Server_FDConnection
    Left = 304
    Top = 16
  end
  object RESTDWServerEvents1: TRESTDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
        Params = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'inputdata'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovDateTime
            ParamName = 'result'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovString
            ParamName = 'resultstring'
            Encoded = True
          end>
        DataMode = dmDataware
        Name = 'servertime'
        EventName = 'servertime'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
        OnReplyEvent = RESTDWServerEvents1Eventsdwevent1ReplyEvent
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        Params = <>
        DataMode = dmDataware
        Name = 'helloworld'
        EventName = 'helloworld'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
        OnReplyEvent = RESTDWServerEvents1EventshelloworldReplyEvent
      end>
    Left = 152
    Top = 120
  end
  object RESTDWServerContext1: TRESTDWServerContext
    IgnoreInvalidParams = False
    ContextList = <>
    Left = 264
    Top = 120
  end
  object RESTDWFireDACDriver1: TRESTDWFireDACDriver
    Connection = Server_FDConnection
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = False
    Compression = False
    EncodeStringsJSON = False
    Encoding = esUtf8
    ParamCreate = True
    CommitRecords = 100
    Left = 64
    Top = 160
  end
end
