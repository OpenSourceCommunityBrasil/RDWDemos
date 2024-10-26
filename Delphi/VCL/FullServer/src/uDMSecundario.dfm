object DMSecundario: TDMSecundario
  OnCreate = ServerMethodDataModuleCreate
  Encoding = esUtf8
  OnMassiveProcess = ServerMethodDataModuleMassiveProcess
  QueuedRequest = False
  Height = 252
  Width = 328
  object RESTDWPoolerFD: TRESTDWPoolerDB
    Compression = True
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    Active = True
    PoolerOffMessage = 'RESTPooler not active.'
    ParamCreate = True
    Left = 54
    Top = 163
  end
  object Server_FDConnection: TFDConnection
    Params.Strings = (
      
        'Database=D:\Meus Dados\Projetos\SUGV\Componentes\XyberPower\REST' +
        '_Controls\CORE\Demos\EMPLOYEE.FDB'
      'User_Name=sysdba'
      'Password=masterkey'
      'DriverID=FB')
    FetchOptions.AssignedValues = [evCursorKind]
    FetchOptions.CursorKind = ckDefault
    UpdateOptions.AssignedValues = [uvCountUpdatedRecords]
    ConnectedStoredUsage = []
    LoginPrompt = False
    Transaction = FDTransaction1
    OnError = Server_FDConnectionError
    BeforeConnect = Server_FDConnectionBeforeConnect
    Left = 53
    Top = 62
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 54
    Top = 17
  end
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 193
    Top = 63
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 109
    Top = 62
  end
  object FDTransaction1: TFDTransaction
    Options.AutoStop = False
    Options.DisconnectAction = xdRollback
    Connection = Server_FDConnection
    Left = 81
    Top = 62
  end
  object FDQuery1: TFDQuery
    AfterScroll = FDQuery1AfterScroll
    Connection = Server_FDConnection
    Left = 137
    Top = 62
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    Left = 138
    Top = 17
  end
  object FDMoniRemoteClientLink1: TFDMoniRemoteClientLink
    Left = 166
    Top = 17
  end
  object FDQuery2: TFDQuery
    Connection = Server_FDConnection
    SQL.Strings = (
      'select * from SALARY_HISTORY'
      'where emp_no = :emp_no')
    Left = 165
    Top = 62
    ParamData = <
      item
        Name = 'EMP_NO'
        ParamType = ptInput
      end>
  end
  object FDQLogin: TFDQuery
    Connection = Server_FDConnection
    Left = 221
    Top = 63
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 110
    Top = 17
  end
  object RDWSEDados2: TRESTDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes.All.Active = True
        Routes.All.NeedAuthorization = False
        Routes.Get.Active = False
        Routes.Get.NeedAuthorization = False
        Routes.Post.Active = False
        Routes.Post.NeedAuthorization = False
        Routes.Put.Active = False
        Routes.Put.NeedAuthorization = False
        Routes.Patch.Active = False
        Routes.Patch.NeedAuthorization = False
        Routes.Delete.Active = False
        Routes.Delete.NeedAuthorization = False
        Routes.Option.Active = False
        Routes.Option.NeedAuthorization = False
        Params = <>
        DataMode = dmDataware
        Name = 'helloworld'
        EventName = 'helloworld'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
      end>
    Left = 160
    Top = 168
  end
  object RESTDWServerContext1: TRESTDWServerContext
    IgnoreInvalidParams = False
    ContextList = <>
    Left = 152
    Top = 120
  end
  object RESTDWFireDACDriver1: TRESTDWFireDACDriver
    ConectionType = dbtUndefined
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = False
    Compression = False
    EncodeStringsJSON = False
    Encoding = esUtf8
    ParamCreate = False
    CommitRecords = 0
    Left = 64
    Top = 128
  end
end
