unit fs.mainform;

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
  uRESTDWAbout,
  uRESTDWComponentBase,
  uRESTDWBasic,
  uRESTDWIdBase,
  uRESTDWDataUtils;

type

  { TMainForm }

  TMainForm = class(TForm)
    lbLocalFiles: TListBox;
    Image1: TImage;
    cbEncode: TCheckBox;
    edPasswordDW: TEdit;
    Label3: TLabel;
    Bevel1: TBevel;
    Label7: TLabel;
    edUserNameDW: TEdit;
    Label2: TLabel;
    edPortaDW: TEdit;
    Label4: TLabel;
    ButtonStart: TButton;
    Label13: TLabel;
    Bevel2: TBevel;
    cbPoolerState: TCheckBox;
    fsServicePooler: TRESTDWIdServicePooler;
    procedure FormCreate(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DirName: string;
    procedure LoadLocalFiles;
  end;

function GetFilesServer(const List: TStrings): boolean;

var
  MainForm: TMainForm;
  StartDir: string;

implementation

{$R *.lfm}

uses
  fs.datamodules;

function GetFilesServer(const List: TStrings): boolean;

  procedure ScanFolder(const Path: string; List: TStrings);
  var
    sPath: string;
    rec: TSearchRec;
  begin
    sPath := IncludeTrailingPathDelimiter(Path);
    if FindFirst(sPath + '*.*', faAnyFile, rec) = 0 then
    begin
      repeat
        if (rec.Attr and faDirectory) <> 0 then
        begin
          if (rec.Name <> '.') and (rec.Name <> '..') then
            ScanFolder(IncludeTrailingPathDelimiter(sPath + rec.Name), List);
        end
        else
        begin
          if pos(StartDir, Path) > 0 then
            List.Add(copy(Path, length(StartDir) + 1, length(path)) + rec.Name)
          else
            List.Add(Path + rec.Name);
        end;
      until FindNext(rec) <> 0;
      FindClose(rec);
    end;
  end;

begin
  if not Assigned(List) then
  begin
    Result := False;
    Exit;
  end;
  ScanFolder(StartDir, List);
  Result := (List.Count > 0);
end;

procedure TMainForm.LoadLocalFiles;
var
  List: TStringList;
  I: integer;
begin
  lbLocalFiles.Clear;
  List := TStringList.Create;
  DirName := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + IncludeTrailingPathDelimiter('filelist');
  StartDir := DirName;
  lbLocalFiles.Items.Add(DirName);
  if not DirectoryExists(DirName) then
    ForceDirectories(DirName);
  if GetFilesServer(List) then
  begin
    for I := 0 to List.Count - 1 do
      //lbLocalFiles.AddItem (List[I], nil)
      lbLocalFiles.Items.Add(List[I]);
  end;
  List.Free;
end;

procedure TMainForm.ButtonStartClick(Sender: TObject);
begin
  if not fsServicePooler.Active then
  begin
    ///fsServicePooler.AuthenticationOptions.AuthorizationOption := rdwAOBasic;
    ///TRESTDWAuthOptionBasic(fsServicePooler.AuthenticationOptions.OptionParams).Username := edUserNameDW.Text;
    ///TRESTDWAuthOptionBasic(fsServicePooler.AuthenticationOptions.OptionParams).Password := edPasswordDW.Text;

    fsServicePooler.AuthenticationOptions.AuthorizationOption := rdwAONone;

    fsServicePooler.ServicePort := StrToInt(edPortaDW.Text);
    fsServicePooler.Active := True;
    if not fsServicePooler.Active then
      Exit;
    ButtonStart.Caption := 'Desativar';
    LoadLocalFiles;
  end
  else
  begin
    fsServicePooler.Active := False;
    ButtonStart.Caption := 'Ativar';
    lbLocalFiles.Clear;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  fsServicePooler.ServerMethodClass := TDMFS {DataModule File Server};
end;

end.
