unit udm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, SQLite3Conn, uRESTDWDataModule,
  uRESTDWServerEvents, uRESTDWParams, uRESTDWServerContext, uRESTDWBasicDB,
  uRESTDWConsts, uRESTDWMIMETypes, uRESTDWLazarusDriver, uRESTDWZeosDriver,

  uPrincipal;

type

  { TDM }

  TDM = class(TServerMethodDataModule)
    RESTDWLazarusDriver1: TRESTDWLazarusDriver;
    RESTDWPoolerDB1: TRESTDWPoolerDB;
    RESTDWPoolerDB2: TRESTDWPoolerDB;
    RESTDWServerContext1: TRESTDWServerContext;
    RESTDWServerEvents1: TRESTDWServerEvents;
    RESTDWZeosDriver1: TRESTDWZeosDriver;
    SQLite3Connection1: TSQLite3Connection;
    ZConnection1: TZConnection;
    procedure teste(var Params: TRESTDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
    procedure testebody(var Params: TRESTDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
    procedure testeheader(var Params: TRESTDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
    procedure relatorio(const Params: TRESTDWParams; var ContentType: string;
      const Result: TMemoryStream; const RequestType: TRequestType;
      var StatusCode: Integer);
    procedure ServerMethodDataModuleCreate(Sender: TObject);
    procedure testecripto(var Params: TRESTDWParams; var Result: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{$R *.lfm}

{ TDM }

procedure TDM.testebody(var Params: TRESTDWParams; var Result: string;
  const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
var
  textos: TStringList;
begin
  textos := TStringList.Create;
  textos.Add('seus params: ' + Params.ToJSON);
  textos.Add('o body: ' + Params.RawBody.AsObject);

  Result := textos.Text;
  textos.Free;
end;

procedure TDM.testeheader(var Params: TRESTDWParams; var Result: string;
  const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
var
  textos: TStringList;
  I: Integer;
begin
  textos := TStringList.Create;
  textos.Add('seus params: ' + Params.ToJSON);
  for I := 0 to pred(Params.Count) do
    textos.AddPair(Params.Items[I].ParamName, Params.Items[I].AsString);

  Result := textos.Text;

end;

procedure TDM.relatorio(const Params: TRESTDWParams; var ContentType: string;
  const Result: TMemoryStream; const RequestType: TRequestType;
  var StatusCode: Integer);
begin
  ContentType := TRESTDWMIMEType.GetMIMEType('.\relatorio.pdf');
  Result.LoadFromFile('.\relatorio.pdf');
end;

procedure TDM.testecripto(var Params: TRESTDWParams; var Result: string);
begin
  Form1.Memo1.lines.add('senha: ' + Params.ItemsString['senha'].AsString);
end;

procedure TDM.ServerMethodDataModuleCreate(Sender: TObject);
begin
  // configurando Lazarus Connection
  SQLite3Connection1.Params.Clear;
  SQLite3Connection1.Params.Add('Database=' + ExtractFilePath(ParamStr(0)) +
    'employee.db');
  SQLite3Connection1.Params.Add('LockingMode=normal');

  // configurando Zeos Connection
  ZConnection1.Properties.Clear;
  ZConnection1.Protocol := 'sqlite-3';
  ZConnection1.Database := ExtractFilePath(ParamStr(0)) + 'employee.db';
  ZConnection1.LibraryLocation := ExtractFilePath(ParamStr(0)) + 'sqlite3.dll';
  ZConnection1.Properties.Add('LockingMode=normal');
end;

procedure TDM.teste(var Params: TRESTDWParams; var Result: string;
  const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
begin
  case RequestType of
    rtGet, rtDelete:
      StatusCode := 200;
    rtPost, rtPut, rtPatch:
      StatusCode := 201;
  end;
end;

end.
