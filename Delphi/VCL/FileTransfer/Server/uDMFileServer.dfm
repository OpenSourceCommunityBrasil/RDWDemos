object dmFileServer: TdmFileServer
  OldCreateOrder = False
  Encoding = esUtf8
  QueuedRequest = False
  Height = 239
  Width = 351
  object dwSEArquivos: TRESTDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
        Params = <
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovBlob
            ParamName = 'result'
            Encoded = True
          end>
        DataMode = dmDataware
        Name = 'FileList'
        EventName = 'FileList'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
        OnReplyEvent = dwSEArquivosEventsFileListReplyEvent
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        Params = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'Arquivo'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'Diretorio'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovBlob
            ParamName = 'FileSend'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovBoolean
            ParamName = 'Result'
            Encoded = True
          end>
        DataMode = dmDataware
        Name = 'SendReplicationFile'
        EventName = 'SendReplicationFile'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
        OnReplyEvent = dwSEArquivosEventsSendReplicationFileReplyEvent
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        Params = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'Arquivo'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovBlob
            ParamName = 'Result'
            Encoded = True
          end>
        DataMode = dmDataware
        Name = 'DownloadFile'
        EventName = 'DownloadFile'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
        OnReplyEvent = dwSEArquivosEventsDownloadFileReplyEvent
      end>
    Left = 80
    Top = 103
  end
end
