unit udm_rest;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  uRESTDWComponentBase, uRESTDWDriverBase, uRESTDWFireDACDriver, uRESTDWBasicDB,
  uRESTDWDatamodule, uRESTDWParams;

type
  Tdm_rest = class(TServerMethodDataModule)
    conexao: TFDConnection;
    fddriver: TRESTDWFireDACDriver;
    poolerdb: TRESTDWPoolerDB;
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

end.
