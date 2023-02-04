unit udm_rest;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  uRESTDWDriverBase, uRESTDWFireDACDriver, uRESTDWBasicDB, uRESTDWDataUtils,
  uRESTDWDatamodule, uRESTDWParams, uRESTDWAbout;

type
  Tdm_rest = class(TServerMethodDataModule)
    conexao: TFDConnection;
    fddriver: TRESTDWFireDACDriver;
    poolerdb: TRESTDWPoolerDB;
    procedure ServerMethodDataModuleGetToken(Welcomemsg, AccessTag: string;
      Params: TRESTDWParams; AuthOptions: TRESTDWAuthTokenParam;
      var ErrorCode: Integer; var ErrorMessage, TokenID: string;
      var Accept: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm_rest: Tdm_rest;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure Tdm_rest.ServerMethodDataModuleGetToken(Welcomemsg, AccessTag: string;
  Params: TRESTDWParams; AuthOptions: TRESTDWAuthTokenParam;
  var ErrorCode: Integer; var ErrorMessage, TokenID: string;
  var Accept: Boolean);
begin
  TokenID := AuthOptions.GetToken('fernando');
  Accept := True;
  ErrorCode := 200;
end;

end.
