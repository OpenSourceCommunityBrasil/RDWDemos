unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  uRESTDWBasicTypes, uRESTDWBasicDB, uRESTDWComponentBase, uRESTDWBasicClass,
  uRESTDWIdBase;

type
  TfClientREST = class(TForm)
    Button1: TButton;
    RESTDWClientSQL1: TRESTDWClientSQL;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    edCNPJ: TEdit;
    Label1: TLabel;
    DWClientREST: TRESTDWIdClientREST;
    procedure Button1Click(Sender: TObject);
    procedure DWClientRESTBeforeGet(var AUrl: string;
      var AHeaders: TStringList);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fClientREST: TfClientREST;

implementation

{$R *.dfm}

procedure TfClientREST.Button1Click(Sender: TObject);
Var
 url,
 Str        : String;
 Response   : TStringStream;
 RetornoGet : Integer;
Begin
 Try
  If Trim(edCNPJ.Text) = '' then
   Begin
    showmessage('Informe o CNPJ');
    edCNPJ.SetFocus;
    Exit;
   End;
  Response   := TStringStream.Create;
  Str        := edCNPJ.Text;
  Str        := StringReplace(Str, '/', '',[rfReplaceAll]);
  Str        := StringReplace(Str, '-', '',[rfReplaceAll]);
  Str        := StringReplace(Str, '.', '',[rfReplaceAll]);
  Str        := StringReplace(Str, ' ', '',[rfReplaceAll]);
  url        := Format('http://www.receitaws.com.br/v1/cnpj/%s', [Str]);
  RetornoGet := DWClientREST.Get(url, Nil, Response);
  If RetornoGet = 200 then
   If (Trim(Response.DataString) <> '') Then
    RESTDWClientSQL1.OpenJson(Response.DataString);
 Finally
  Response.DisposeOf;
 End;
end;

procedure TfClientREST.DWClientRESTBeforeGet(var AUrl: string;
  var AHeaders: TStringList);
begin
 AUrl := 'https://www.receitaws.com.br/v1/cnpj/' + edCNPJ.Text;
end;

end.
