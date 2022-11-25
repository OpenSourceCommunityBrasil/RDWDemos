unit uFileClient;

{$MODE Delphi}

interface

uses
  SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls,
  uRESTDWParams, uRESTDWConsts, uRESTDWDataUtils, uRESTDWServerEvents,
  uRESTDWBasic, uRESTDWIdBase;

type

  { TForm4 }

  TForm4 = class(TForm)
    Label4: TLabel;
    Label5: TLabel;
    Image1: TImage;
    Bevel1: TBevel;
    Label7: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    eHost: TEdit;
    ePort: TEdit;
    edPasswordDW: TEdit;
    edUserNameDW: TEdit;
    Label1: TLabel;
    bListar: TButton;
    Bevel2: TBevel;
    lbLocalFiles: TListBox;
    bDownload: TButton;
    bUpload: TButton;
    cmb_tmp: TComboBox;
    Label2: TLabel;
    ProgressBar1: TProgressBar;
    DWClientEvents1: TRESTDWClientEvents;
    RESTClientPooler1: TRESTDWIdClientPooler;
    procedure bListarClick(Sender: TObject);
    procedure bDownloadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bUploadClick(Sender: TObject);
    procedure RESTClientPooler1Work(ASender: TObject; AWorkCount: int64);
    procedure RESTClientPooler1WorkEnd(ASender: TObject);
    procedure RESTClientPooler1WorkBegin(ASender: TObject; AWorkCount: int64);
  private
    { Private declarations }
    FBytesToTransfer: int64;
  public
    { Public declarations }
    LocalDirName: string;
  end;

var
  Form4: TForm4;

implementation

{$R *.lfm}

procedure TForm4.bListarClick(Sender: TObject);
var
  dwParams: TRESTDWParams;
  vErrorMessage: string;
  vFileList: TStringStream;
begin
  lbLocalFiles.Clear;
  RESTClientPooler1.Host := eHost.Text;
  RESTClientPooler1.Port := StrToInt(ePort.Text);
  RESTClientPooler1.AuthenticationOptions.AuthorizationOption := rdwAOBasic;
  TRESTDWAuthOptionBasic(RESTClientPooler1.AuthenticationOptions.OptionParams).Username :=
    edUserNameDW.Text;
  TRESTDWAuthOptionBasic(RESTClientPooler1.AuthenticationOptions.OptionParams).Password :=
    edPasswordDW.Text;
  try
    try
      DWClientEvents1.CreateDWParams('FileList', dwParams);
      DWClientEvents1.SendEvent('FileList', dwParams, vErrorMessage);
      if vErrorMessage = '' then
      begin
        if not dwParams.ItemsString['result'].isNull then
        begin
          vFileList := TStringStream.Create('');
          try
            dwParams.ItemsString['result'].SaveToStream(vFileList);
            lbLocalFiles.Items.Text := vFileList.DataString;
          finally
            vFileList.Free;
          end;
        end;
      end
      else
        ShowMessage(vErrorMessage);
    except
    end;
  finally
    FreeAndNil(dwParams);
  end;
end;

procedure TForm4.bDownloadClick(Sender: TObject);
var
  DWParams: TRESTDWParams;
  vErrorMessage, RemoteFilePath: string;
  //arquivo: TFileStream;
  //StringStream : TStringStream;
begin
  if lbLocalFiles.ItemIndex > -1 then
  begin
    RESTClientPooler1.Host := eHost.Text;
    RESTClientPooler1.Port := StrToInt(ePort.Text);
    RESTClientPooler1.AuthenticationOptions.AuthorizationOption := rdwAOBasic;
    TRESTDWAuthOptionBasic(RESTClientPooler1.AuthenticationOptions.OptionParams).Username
    :=
      edUserNameDW.Text;
    TRESTDWAuthOptionBasic(RESTClientPooler1.AuthenticationOptions.OptionParams).Password
    :=
      edPasswordDW.Text;
    DWClientEvents1.CreateDWParams('DownloadFile', dwParams);
    RemoteFilePath := lbLocalFiles.GetSelectedText;
    dwParams.ItemsString['Arquivo'].AsString := RemoteFilePath;
    try
      try
        DWClientEvents1.SendEvent('DownloadFile', dwParams, vErrorMessage);
        if vErrorMessage = '' then
        begin
          try
            ForceDirectories(ExtractFileDir(LocalDirName + RemoteFilePath));
            if FileExists(LocalDirName + RemoteFilePath) then
              DeleteFile(LocalDirName + RemoteFilePath);
            dwParams.ItemsString['result'].SaveToFile(LocalDirName + RemoteFilePath);

            ShowMessage('Download concluído...');
          finally

          end;
        end;
      except
      end;
    finally
      FreeAndNil(DWParams);
    end;
  end
  else
    ShowMessage('Escolha um arquivo para Download...');
end;

procedure TForm4.bUploadClick(Sender: TObject);
var
  DWParams: TRESTDWParams;
  vErrorMessage: string;
  MemoryStream: TStringStream;
  OpenDialog: TOpenDialog;
begin
  RESTClientPooler1.RequestTimeOut := StrToInt(Copy(cmb_tmp.Text, 1, 1)) * 60000;
  RESTClientPooler1.AuthenticationOptions.AuthorizationOption := rdwAOBasic;
  TRESTDWAuthOptionBasic(RESTClientPooler1.AuthenticationOptions.OptionParams).Username :=
    edUserNameDW.Text;
  TRESTDWAuthOptionBasic(RESTClientPooler1.AuthenticationOptions.OptionParams).Password :=
    edPasswordDW.Text;
  OpenDialog := TOpenDialog.Create(nil);
  try
    if OpenDialog.Execute then
    begin
      DWClientEvents1.CreateDWParams('SendReplicationFile', dwParams);
      dwParams.ItemsString['Arquivo'].AsString := OpenDialog.FileName;
      MemoryStream := TStringStream.Create;
      MemoryStream.LoadFromFile(OpenDialog.FileName);
      dwParams.ItemsString['FileSend'].LoadFromStream(MemoryStream);
      MemoryStream.Free;
      DWClientEvents1.SendEvent('SendReplicationFile', DWParams, vErrorMessage);
      if vErrorMessage = '' then
      begin
        try
          if DWParams.ItemsString['Result'].AsBoolean then
            ShowMessage('Upload concluído...');
        finally
        end;
      end;
      DWParams.Free;
    end;
  finally
    OpenDialog.Free;
  end;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  LocalDirName := IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)) +
    '\localfiles');
  ForceDirectories(LocalDirName);
end;

procedure TForm4.RESTClientPooler1Work(ASender: TObject; AWorkCount: int64);
begin
  if FBytesToTransfer = 0 then // No Update File
    Exit;
  ProgressBar1.Position := AWorkCount;
end;

procedure TForm4.RESTClientPooler1WorkBegin(ASender: TObject; AWorkCount: int64);
begin
  FBytesToTransfer := AWorkCount;
  ProgressBar1.Max := FBytesToTransfer;
  ProgressBar1.Position := 0;
end;

procedure TForm4.RESTClientPooler1WorkEnd(ASender: TObject);
begin
  ProgressBar1.Position := FBytesToTransfer;
  FBytesToTransfer := 0;
end;

end.
