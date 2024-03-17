unit fc.mainform;

{$MODE Delphi}

interface

uses
  LCLIntf,
  LCLType,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  uRESTDWParams,
  uRESTDWJSONObject,
  uRESTDWConsts,
  ComCtrls,
  uRESTDWDataUtils,
  uRESTDWServerEvents,
  uRESTDWAbout,
  uRESTDWBasic,
  uRESTDWIdBase,
  uRESTDWComponentBase;

type
  TMainForm = class(TForm)
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
    btnFileList: TButton;
    Bevel2: TBevel;
    lbLocalFiles: TListBox;
    btnDownloadFile: TButton;
    btnUploadFile: TButton;
    OD: TOpenDialog;
    cmb_tmp: TComboBox;
    Label2: TLabel;
    ProgressBar1: TProgressBar;
    fscEvents: TRESTDWClientEvents;
    fscPooler: TRESTDWIdClientPooler;
    procedure btnFileListClick(Sender: TObject);
    procedure btnDownloadFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnUploadFileClick(Sender: TObject);
    procedure fscPoolerWork(ASender: TObject; AWorkCount: int64);
    procedure fscPoolerWorkEnd(ASender: TObject);
    procedure fscPoolerWorkBegin(ASender: TObject; AWorkCount: int64);
  private
    { Private declarations }
    FBytesToTransfer: int64;
  public
    { Public declarations }
    DirName: string;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

procedure TMainForm.btnFileListClick(Sender: TObject);
var
  DWParams: TRESTDWParams;
  vErrorMessage: string;
  vFileList: TStringStream;
begin
  lbLocalFiles.Clear;
  fscPooler.Host := eHost.Text;
  fscPooler.Port := StrToInt(ePort.Text);
  fscPooler.AuthenticationOptions.AuthorizationOption := rdwAOBasic;
  TRESTDWAuthOptionBasic(fscPooler.AuthenticationOptions.OptionParams).Username := edUserNameDW.Text;
  TRESTDWAuthOptionBasic(fscPooler.AuthenticationOptions.OptionParams).Password := edPasswordDW.Text;
  try
    try
      fscEvents.CreateDWParams('FileList', DWParams);
      fscEvents.SendEvent('FileList', DWParams, vErrorMessage);
      if vErrorMessage = '' then
      begin
        if not DWParams.ItemsString['result'].isNull then
        begin
          vFileList := TStringStream.Create('');
          try
            DWParams.ItemsString['result'].SaveToStream(vFileList);
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
    FreeAndNil(DWParams);
  end;
end;

procedure TMainForm.btnDownloadFileClick(Sender: TObject);
var
  DWParams: TRESTDWParams;
  vErrorMessage: string;
  StringStream: TStringStream;
begin
  if lbLocalFiles.ItemIndex > -1 then
  begin
    fscPooler.Host := eHost.Text;
    fscPooler.Port := StrToInt(ePort.Text);
    fscPooler.AuthenticationOptions.AuthorizationOption := rdwAOBasic;
    TRESTDWAuthOptionBasic(fscPooler.AuthenticationOptions.OptionParams).Username := edUserNameDW.Text;
    TRESTDWAuthOptionBasic(fscPooler.AuthenticationOptions.OptionParams).Password := edPasswordDW.Text;
    fscEvents.CreateDWParams('DownloadFile', DWParams);
    dwParams.ItemsString['Arquivo'].AsString := lbLocalFiles.Items[lbLocalFiles.ItemIndex];
    try
      try
        fscPooler.Host := eHost.Text;
        fscPooler.Port := StrToInt(ePort.Text);
        fscEvents.SendEvent('DownloadFile', DWParams, vErrorMessage);
        if vErrorMessage = '' then
        begin
          ///*
          DirName := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + IncludeTrailingPathDelimiter('filelist');
          StringStream := TStringStream.Create('');
          dwParams.ItemsString['result'].SaveToStream(StringStream);
          try
            ForceDirectories(ExtractFilePath(DirName + lbLocalFiles.Items[lbLocalFiles.ItemIndex]));
            if FileExists(DirName + lbLocalFiles.Items[lbLocalFiles.ItemIndex]) then
              DeleteFile(DirName + lbLocalFiles.Items[lbLocalFiles.ItemIndex]);
            StringStream.SaveToFile(DirName + lbLocalFiles.Items[lbLocalFiles.ItemIndex]);
            StringStream.SetSize(0);
            ShowMessage('Download concluído...');
          finally
            FreeAndNil(StringStream);
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

procedure TMainForm.btnUploadFileClick(Sender: TObject);
var
  DWParams: TRESTDWParams;
  vErrorMessage: string;
  MemoryStream: {TStream}TMemoryStream;
begin
  fscPooler.RequestTimeOut := StrToInt(Copy(cmb_tmp.Text, 1, 1)) * 60000;
  fscPooler.AuthenticationOptions.AuthorizationOption := rdwAOBasic;
  TRESTDWAuthOptionBasic(fscPooler.AuthenticationOptions.OptionParams).Username := edUserNameDW.Text;
  TRESTDWAuthOptionBasic(fscPooler.AuthenticationOptions.OptionParams).Password := edPasswordDW.Text;
  if OD.Execute then
  begin
    fscEvents.CreateDWParams('SendReplicationFile', dwParams);
    dwParams.ItemsString['Arquivo'].AsString := OD.FileName;
    ///MemoryStream := TFileStream.Create(OD.FileName, fmOpenRead);

    MemoryStream := TMemoryStream.Create;
    MemoryStream.LoadFromFile( OD.FileName);


    dwParams.ItemsString['FileSend'].LoadFromStream(MemoryStream);
    MemoryStream.Free;
    fscEvents.SendEvent('SendReplicationFile', DWParams, vErrorMessage);
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
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DirName := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + IncludeTrailingPathDelimiter('filelist');
  if not DirectoryExists(DirName) then
    ForceDirectories(DirName);
end;

procedure TMainForm.fscPoolerWork(ASender: TObject; AWorkCount: int64);
begin
  if FBytesToTransfer = 0 then // No Update File
    Exit;
  ProgressBar1.Position := AWorkCount;
end;

procedure TMainForm.fscPoolerWorkBegin(ASender: TObject; AWorkCount: int64);
begin
  FBytesToTransfer := AWorkCount;
  ProgressBar1.Max := FBytesToTransfer;
  ProgressBar1.Position := 0;
end;

procedure TMainForm.fscPoolerWorkEnd(ASender: TObject);
begin
  ProgressBar1.Position := FBytesToTransfer;
  FBytesToTransfer := 0;
end;

end.
