object dm_rest: Tdm_rest
  OldCreateOrder = False
  Encoding = esUtf8
  QueuedRequest = False
  Height = 437
  Width = 591
  object conexao: TFDConnection
    Params.Strings = (
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Protocol=TCPIP'
      'Server=localhost'
      'DriverID=FB')
    LoginPrompt = False
    Left = 56
    Top = 56
  end
  object fddriver: TRESTDWFireDACDriver
    Connection = conexao
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = False
    Compression = False
    EncodeStringsJSON = False
    Encoding = esASCII
    ParamCreate = True
    CommitRecords = 100
    Left = 144
    Top = 56
  end
  object poolerdb: TRESTDWPoolerDB
    RESTDriver = fddriver
    Compression = True
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    Active = False
    PoolerOffMessage = 'RESTPooler not active.'
    ParamCreate = True
    Left = 144
    Top = 136
  end
end
