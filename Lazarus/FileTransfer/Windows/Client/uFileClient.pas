unit uFileClient;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  uRESTDWJSONObject, uRESTDWConsts, ComCtrls,
  uRESTDWDataUtils, uRESTDWServerEvents, uRESTDWAbout, uRESTDWBasic, uRESTDWIdBase,
  uRESTDWComponentEvents, uRESTDWParams;

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
    Button1: TButton;
    Bevel2: TBevel;
    lbLocalFiles: TListBox;
    Button2: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    cmb_tmp: TComboBox;
    Label2: TLabel;
    ProgressBar1: TProgressBar;
    RESTDWClientEvents1: TRESTDWClientEvents;
    RESTDWIdClientPooler1: TRESTDWIdClientPooler;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure RESTClientPooler1Work(ASender: TObject; AWorkCount: Int64);
    procedure RESTClientPooler1WorkEnd(ASender: TObject);
    procedure RESTClientPooler1WorkBegin(ASender: TObject; AWorkCount: Int64);
  private
    { Private declarations }
   FBytesToTransfer : Int64;
  public
    { Public declarations }
   DirName : String;
  end;

var
  Form4: TForm4;

implementation

{$R *.lfm}

procedure TForm4.Button1Click(Sender: TObject);
Var
 dwParams      : TRESTDWParams;
 vErrorMessage : String;
 vFileList     : TStringStream;
Begin
 lbLocalFiles.Clear;
 RESTDWIdClientPooler1.Host     := eHost.Text;
 RESTDWIdClientPooler1.Port     := StrToInt(ePort.Text);
 RESTDWIdClientPooler1.AuthenticationOptions.AuthorizationOption := rdwAOBasic;
 TRESTDWAuthOptionBasic(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Username := edUserNameDW.Text;
 TRESTDWAuthOptionBasic(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Password := edPasswordDW.Text;
 Try
  Try
   RESTDWClientEvents1.CreateDWParams('FileList', dwParams);
   RESTDWClientEvents1.SendEvent('FileList', dwParams, vErrorMessage);
   If vErrorMessage = '' Then
    Begin
     If Not dwParams.ItemsString['result'].isNull Then
      Begin
       vFileList := TStringStream.Create('');
       Try
        dwParams.ItemsString['result'].SaveToStream(vFileList);
        lbLocalFiles.Items.Text := vFileList.DataString;
       Finally
        vFileList.Free;
       End;
      End;
    End
   Else
    Showmessage(vErrorMessage);
  Except
  End;
 Finally
  FreeAndNil(dwParams);
 End;
End;

procedure TForm4.Button2Click(Sender: TObject);
Var
 DWParams     : TRESTDWParams;
 vErrorMessage : String;
 StringStream : TStringStream;
Begin
 If lbLocalFiles.ItemIndex > -1 Then
  Begin
   RESTDWIdClientPooler1.Host     := eHost.Text;
   RESTDWIdClientPooler1.Port     := StrToInt(ePort.Text);
   RESTDWIdClientPooler1.AuthenticationOptions.AuthorizationOption := rdwAOBasic;
   TRESTDWAuthOptionBasic(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Username := edUserNameDW.Text;
   TRESTDWAuthOptionBasic(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Password := edPasswordDW.Text;
   RESTDWClientEvents1.CreateDWParams('DownloadFile', dwParams);
   dwParams.ItemsString['Arquivo'].AsString := lbLocalFiles.Items[lbLocalFiles.ItemIndex];
   Try
    Try
     RESTDWIdClientPooler1.Host := eHost.Text;
     RESTDWIdClientPooler1.Port := StrToInt(ePort.Text);
     RESTDWClientEvents1.SendEvent('DownloadFile', dwParams, vErrorMessage);
     If vErrorMessage = '' Then
      Begin
       StringStream          := TStringStream.Create('');
       dwParams.ItemsString['result'].SaveToStream(StringStream);
       Try
        ForceDirectories(ExtractFilePath(DirName + lbLocalFiles.Items[lbLocalFiles.ItemIndex]));
        If FileExists(DirName + lbLocalFiles.Items[lbLocalFiles.ItemIndex]) Then
         DeleteFile(DirName + lbLocalFiles.Items[lbLocalFiles.ItemIndex]);
        StringStream.SaveToFile(DirName + lbLocalFiles.Items[lbLocalFiles.ItemIndex]);
        StringStream.SetSize(0);
        Showmessage('Download concluído...');
       Finally
        FreeAndNil(StringStream);
       End;
      End;
    Except
    End;
   Finally
    FreeAndNil(DWParams);
   End;
  End
 Else
  Showmessage('Escolha um arquivo para Download...');
End;

procedure TForm4.Button3Click(Sender: TObject);
Var
 DWParams      : TRESTDWParams;
 vErrorMessage : String;
 MemoryStream  : TMemoryStream;
Begin
 RESTDWIdClientPooler1.RequestTimeOut:= StrToInt(Copy(cmb_tmp.Text, 1,1)) * 60000;
 RESTDWIdClientPooler1.AuthenticationOptions.AuthorizationOption := rdwAOBasic;
 TRESTDWAuthOptionBasic(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Username := edUserNameDW.Text;
 TRESTDWAuthOptionBasic(RESTDWIdClientPooler1.AuthenticationOptions.OptionParams).Password := edPasswordDW.Text;
 If OpenDialog1.Execute Then
  Begin
   RESTDWClientEvents1.CreateDWParams('SendReplicationFile', dwParams);
   dwParams.ItemsString['Arquivo'].AsString := OpenDialog1.FileName;
   MemoryStream                 := TMemoryStream.Create;
   MemoryStream.LoadFromFile(OpenDialog1.FileName);
   MemoryStream.position := 0;
   dwParams.ItemsString['FileSend'].LoadFromStream(MemoryStream);
   MemoryStream.Free;
   RESTDWClientEvents1.SendEvent('SendReplicationFile', DWParams, vErrorMessage);
   If vErrorMessage = '' Then
    Begin
      Try
       If DWParams.ItemsString['Result'].AsBoolean Then
        Showmessage('Upload concluído...');
      Finally
      End;
    End;
   DWParams.Free;
  End;
end;

procedure TForm4.Image1Click(Sender: TObject);
begin

end;

procedure TForm4.FormCreate(Sender: TObject);
begin
 DirName  := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) +
             IncludeTrailingPathDelimiter('filelist');
 If Not DirectoryExists(DirName) Then
  ForceDirectories(DirName);
end;

procedure TForm4.RESTClientPooler1Work(ASender: TObject; AWorkCount: Int64);
begin
  If FBytesToTransfer = 0 Then // No Update File
   Exit;
  ProgressBar1.Position := AWorkCount;
end;

procedure TForm4.RESTClientPooler1WorkBegin(ASender: TObject;
  AWorkCount: Int64);
begin
 FBytesToTransfer := AWorkCount;
 ProgressBar1.Max := FBytesToTransfer;
 ProgressBar1.Position := 0;
end;

procedure TForm4.RESTClientPooler1WorkEnd(ASender: TObject);
begin
 ProgressBar1.Position := FBytesToTransfer;
 FBytesToTransfer      := 0;
end;

end.
