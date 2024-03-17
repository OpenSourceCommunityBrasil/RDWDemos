unit fs.datamodules;

{$MODE Delphi}

interface

uses
  SysUtils,
  Classes,
  uRESTDWAbout,
  uRESTDWServerEvents,
  uRESTDWJSONObject,
  uRESTDWDatamodule,
  uRESTDWComponentBase,
  uRESTDWParams;

type
  TDMFS = class(TServerMethodDataModule)
    DWFileEvent: TRESTDWServerEvents;
    procedure FileListReplyEvent(var Params: TRESTDWParams; var Result: string);
    procedure SendReplicationFileReplyEvent(var Params: TRESTDWParams; var Result: string);
    procedure DownloadFileReplyEvent(var Params: TRESTDWParams; var Result: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMFS: TDMFS;  {DataModule File Server}

implementation

uses
  fs.mainform;

{$R *.lfm}

procedure TDMFS.SendReplicationFileReplyEvent(var Params: TRESTDWParams; var Result: string);
var
  vArquivo, vDiretorio: string;
  JSONValue: TJSONValue;
  vFileIn: {TStream}TStringStream;
  ///vFile: TStream;
  ///
  /// https://www.tweaking4all.com/software-development/lazarus-development/lazarus-crossplatform-trashcan/
  ///
  {
  procedure DelFilesFromDir(Directory, FileMask: string; const DelSubDirs: boolean = False);
  var
    SourceLst: string;
    FOS: TSHFileOpStruct;
  begin
    FillChar(FOS, SizeOf(FOS), 0);
    FOS.Wnd := 0;
    FOS.wFunc := FO_DELETE;
    SourceLst := IncludeTrailingPathDelimiter(Directory) + FileMask + #0;
    FOS.pFrom := PChar(SourceLst);
    if not DelSubDirs then
      FOS.fFlags := FOS.fFlags or FOF_FILESONLY;
    // Remove the next line if you want a confirmation dialog box
    FOS.fFlags := FOS.fFlags or FOF_NOCONFIRMATION;
    // Add the next line for a "silent operation" (no progress box)
    // FOS.fFlags := FOS.fFlags OR FOF_SILENT;
    SHFileOperation(FOS);
  end;

  }
begin
  if (Params.ItemsString['Arquivo'] <> nil) then
  begin
    vDiretorio := '';
    if (Params.ItemsString['Diretorio'] <> nil) then
    begin
      if Params.ItemsString['Diretorio'].AsString <> '' then
      begin
        vDiretorio := IncludeTrailingPathDelimiter(Params.ItemsString['Diretorio'].AsString);
        ForceDirectories(MainForm.DirName + vDiretorio);
      end;
    end;
    JSONValue := TJSONValue.Create;
    JSONValue.Encoding := Encoding;
    vArquivo := MainForm.DirName + vDiretorio + Trim(ExtractFileName(Params.ItemsString['Arquivo'].AsString));
    if FileExists(vArquivo) then
      DeleteFile(vArquivo);
    vFileIn := {TMemoryStream}TStringStream.Create;
    Params.ItemsString['FileSend'].SaveToStream(vFileIn);
    try
      vFileIn.Position := 0;
      TMemoryStream(vFileIn).SaveToFile(vArquivo);
      MainForm.LoadLocalFiles;
    finally
      if Params.ItemsString['Result'] <> nil then
        Params.ItemsString['Result'].AsBoolean := (vFileIn.Size > 0);
      vFileIn.Free;
      JSONValue.Free;
    end;
  end;
end;

procedure TDMFS.DownloadFileReplyEvent(var Params: TRESTDWParams; var Result: string);
var
  vFile: TMemoryStream;
  vArquivo: string;
  //vFileExport: TMemoryStream;
begin
  if (Params.ItemsString['Arquivo'] <> nil) then
  begin
    vArquivo := MainForm.DirName + Trim(Params.ItemsString['Arquivo'].AsString);
    if (vArquivo <> '') then
    begin
      try
        if FileExists(vArquivo) then
        begin
          vFile := TMemoryStream.Create;
          try
            vFile.LoadFromFile(vArquivo);
            vFile.Position := 0;
          except

          end;
          Params.ItemsString['result'].LoadFromStream(vFile);
        end;
      finally
        FreeAndNil(vFile);
      end;
    end;
  end;
end;

procedure TDMFS.FileListReplyEvent(var Params: TRESTDWParams; var Result: string);
var
  //vArquivo: string;
  vFileExport: TStringStream;
  List: TStringList;
begin
  List := TStringList.Create;
  GetFilesServer(List);
  try
    vFileExport := TStringStream.Create(List.Text);
    vFileExport.Position := 0;
    Params.ItemsString['result'].LoadFromStream(vFileExport);
  finally
    FreeAndNil(vFileExport);
    FreeAndNil(List);
  end;
end;

end.
