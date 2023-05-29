unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.TabControl, System.Rtti, FMX.Grid, FMX.StdCtrls, FMX.Edit,
  FMX.Layouts, FMX.Controls.Presentation, FMX.ScrollBox,
  FMX.Memo.Types, FMX.Memo, FMX.ListBox,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Data.DB,

  uRESTDWBasicTypes, uRESTDWBasicDB, uRESTDWIdBase,
  uRESTDWBasic, uRESTDWParams, uRESTDWConsts, uRESTDWServerEvents,
  uRESTDWMemoryDataset, uRESTDWDataUtils,

  FMX.Grid.Style, Data.Bind.EngExt,
  FMX.Bind.DBEngExt, FMX.Bind.Grid, System.Bindings.Outputs, FMX.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, Data.Bind.Controls,
  FMX.Bind.Navigator, uRESTDWAbout, FMX.ComboEdit;

type
  TfPrincipal = class(TForm)
    TabControl1: TTabControl;
    Image1: TImage;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    RESTDWIdDatabase1: TRESTDWIdDatabase;
    RESTDWClientSQL1: TRESTDWClientSQL;
    lTitulo: TLabel;
    TabItem6: TTabItem;
    GroupBox1: TGroupBox;
    cbBinaryRequest: TCheckBox;
    Layout3: TLayout;
    eServidor: TEdit;
    Label1: TLabel;
    ePorta: TEdit;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Layout1: TLayout;
    Layout2: TLayout;
    Label4: TLabel;
    Memo1: TMemo;
    FlowLayout1: TFlowLayout;
    DBWare_BOpen: TButton;
    DBWare_BOpenDatasets: TButton;
    Layout4: TLayout;
    Edit1: TEdit;
    Label5: TLabel;
    FlowLayout2: TFlowLayout;
    Button1: TButton;
    RESTDWClientEvents1: TRESTDWClientEvents;
    RESTDWIdClientPooler1: TRESTDWIdClientPooler;
    TabControl2: TTabControl;
    TabItem4: TTabItem;
    TabItem5: TTabItem;
    Memo2: TMemo;
    Label6: TLabel;
    FlowLayout3: TFlowLayout;
    FlowLayoutBreak1: TFlowLayoutBreak;
    cbAuth: TComboBox;
    Label7: TLabel;
    eAuthUsuario: TEdit;
    Label8: TLabel;
    eAuthSenha: TEdit;
    Label9: TLabel;
    Layout5: TLayout;
    cbProtocol: TCheckBox;
    cbPoolerDB: TComboBox;
    Label3: TLabel;
    FlowLayout4: TFlowLayout;
    Layout6: TLayout;
    gDBWare: TGrid;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    BindNavigator1: TBindNavigator;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Splitter1: TSplitter;
    TabControl3: TTabControl;
    Request: TTabItem;
    Parameters: TTabItem;
    Authentication: TTabItem;
    Connection: TTabItem;
    Layout7: TLayout;
    ComboEdit2: TComboEdit;
    Label12: TLabel;
    Memo3: TMemo;
    Layout8: TLayout;
    ComboEdit1: TComboEdit;
    Label11: TLabel;
    ComboBox1: TComboBox;
    Label10: TLabel;
    Label13: TLabel;
    TabControl4: TTabControl;
    Label14: TLabel;
    TabItem7: TTabItem;
    TabItem8: TTabItem;
    TabItem9: TTabItem;
    Button3: TButton;
    Button2: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    ceTableName: TComboEdit;
    procedure RESTDWClientSQL1AfterOpen(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure cbPoolerDBEnter(Sender: TObject);
    procedure DBWare_BOpenClick(Sender: TObject);
    procedure DBWare_BOpenDatasetsClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure cbTableNameEnter(Sender: TObject);
    procedure cbAuthChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FBaseURL: string;
    FAuthType: TRESTDWClientAuthOptionParams;
    procedure ConfiguraComponentes;
    procedure ClearGrid;
    procedure ListarPoolers;
    procedure EnableButtons(aButtons: array of TButton);
    procedure DisableButtons(aButtons: array of TButton);
  public
    { Public declarations }
  end;

var
  fPrincipal: TfPrincipal;

implementation

{$R *.fmx}

procedure TfPrincipal.DBWare_BOpenClick(Sender: TObject);
begin
  ConfiguraComponentes;

  RESTDWClientSQL1.SQL.Text := Memo1.Text;
  if ceTableName.ItemIndex <> -1 then
    RESTDWClientSQL1.UpdateTableName := ceTableName.Text;
  RESTDWClientSQL1.Open;
end;

procedure TfPrincipal.DBWare_BOpenDatasetsClick(Sender: TObject);
var
  erro: boolean;
  mensagemerro: string;
begin
  ConfiguraComponentes;
  RESTDWClientSQL1.SQL.Text := Memo1.Text;
  RESTDWClientSQL1.UpdateTableName := ceTableName.Text;
  RESTDWIdDatabase1.OpenDatasets([RESTDWClientSQL1], erro, mensagemerro,
    RESTDWClientSQL1.BinaryRequest);
  if erro then
    raise Exception.Create(mensagemerro);
end;

procedure TfPrincipal.DisableButtons(aButtons: array of TButton);
var
  Button: TButton;
begin
  for Button in aButtons do
    Button.Enabled := false;
end;

procedure TfPrincipal.EnableButtons(aButtons: array of TButton);
var
  Button: TButton;
begin
  for Button in aButtons do
    Button.Enabled := true;
end;

procedure TfPrincipal.Button2Click(Sender: TObject);
var
  ClientREST: TRESTDWIdClientREST;
  teste: string;
  slistheader: TStringList;
  sstrBody: TStringStream;
begin
  ClientREST := TRESTDWIdClientREST.Create(nil);
  slistheader := TStringList.Create;
  sstrBody := TStringStream.Create('', TEncoding.UTF8);
  try
    try
      if ClientREST.Post('http://localhost:8082/testeerrounicode',slistheader,
         sstrBody) = 400 then
        teste := sstrBody.DataString;

      ShowMessage(teste);
    except
      on e: Exception do
        teste := e.Message;
    end;
  finally
    sstrBody.Free;
    slistheader.Free;
    ClientREST.Free;
  end;
end;

procedure TfPrincipal.Button3Click(Sender: TObject);
var
  ClientREST: TRESTDWIdClientREST;
  ssResponse: TStringStream;
  slHeaders: TStringList;
  msBody: TMemoryStream;
begin
  ClientREST := TRESTDWIdClientREST.Create(nil);
  ssResponse := TStringStream.Create;
  slHeaders := TStringList.Create;
  msBody := TMemoryStream.Create;
  try
    ClientREST.Put('URL', slHeaders, ssResponse, false);
    ClientREST.Put('URL', slHeaders, msBody, ssResponse, false);
  finally
    msBody.Free;
    ssResponse.Free;
    slHeaders.Free;
    ClientREST.Free;
  end;
end;

procedure TfPrincipal.cbPoolerDBEnter(Sender: TObject);
begin
  ListarPoolers;
end;

procedure TfPrincipal.ClearGrid;
begin
  gDBWare.ClearColumns;
  gDBWare.ClearContent;
  gDBWare.RowCount := 0;
end;

procedure TfPrincipal.cbTableNameEnter(Sender: TObject);
var
  ClientPooler: TRESTDWIdClientPooler;
  Params: TRESTDWParams;
  JSONParam: TJSONParam;
begin
  ConfiguraComponentes;

  ClientPooler := TRESTDWIdClientPooler.Create(nil);
  ClientPooler.AuthenticationOptions := FAuthType;

  Params := TRESTDWParams.Create;
  Params.Encoding := ClientPooler.Encoding;

  JSONParam := TJSONParam.Create(ClientPooler.Encoding);
  JSONParam.ParamName := 'Result';
  JSONParam.ObjectDirection := odOUT;
  JSONParam.ObjectValue := ovString;
  JSONParam.AsString := '';
  Params.Add(JSONParam);

  JSONParam := TJSONParam.Create(ClientPooler.Encoding);
  JSONParam.ParamName := 'Error';
  JSONParam.ObjectDirection := odINOUT;
  JSONParam.ObjectValue := ovBoolean;
  JSONParam.AsBoolean := false;
  Params.Add(JSONParam);

  JSONParam := TJSONParam.Create(ClientPooler.Encoding);
  JSONParam.ParamName := 'Pooler';
  JSONParam.ObjectDirection := odIN;
  JSONParam.ObjectValue := ovString;
  JSONParam.AsString := cbPoolerDB.Selected.Text;
  Params.Add(JSONParam);

  try
    ClientPooler.SendEvent('GetTableNames', Params);
    ceTableName.Items.Delimiter := '|';
    ceTableName.Items.DelimitedText := Params.ItemsString['Result'].AsString;
  finally
    Params.Free;
    ClientPooler.Free;
  end;
end;

procedure TfPrincipal.cbAuthChange(Sender: TObject);
begin
  Layout5.Visible := false;

  if cbAuth.ItemIndex = 1 then
    Layout5.Visible := true;
end;

procedure TfPrincipal.ConfiguraComponentes;
begin
  // configura servidor
  if (not eServidor.Text.IsEmpty) and (not ePorta.Text.IsEmpty) then
  begin
    if cbProtocol.IsChecked then
      FBaseURL := 'https://' + eServidor.Text + ':' + ePorta.Text
    else
      FBaseURL := 'http://' + eServidor.Text + ':' + ePorta.Text;

    if not assigned(FAuthType) then
      FAuthType := TRESTDWClientAuthOptionParams.Create(nil);
    FAuthType.AuthorizationOption := rdwAONone;

    case cbAuth.ItemIndex of
      0:
        FAuthType.AuthorizationOption := rdwAONone;
      1:
        begin
          FAuthType.AuthorizationOption := rdwAOBasic;
          TRESTDWAuthOptionBasic(FAuthType.OptionParams).Username :=
            eAuthUsuario.Text;
          TRESTDWAuthOptionBasic(FAuthType.OptionParams).Password :=
            eAuthSenha.Text;
        end;
    end;

    RESTDWIdDatabase1.AuthenticationOptions := FAuthType;
    RESTDWClientSQL1.DataBase := RESTDWIdDatabase1;

    if (cbPoolerDB.Items.Count > 0) and not(cbPoolerDB.Selected.Text.IsEmpty)
    then
    begin
      RESTDWIdDatabase1.PoolerPort := ePorta.Text.ToInteger;
      RESTDWIdDatabase1.PoolerService := eServidor.Text;
      RESTDWIdDatabase1.PoolerName := cbPoolerDB.Selected.Text;
      RESTDWIdDatabase1.UseSSL := cbProtocol.IsChecked;
    end;
    RESTDWClientSQL1.BinaryRequest := cbBinaryRequest.IsChecked;
  end
end;

procedure TfPrincipal.FormCreate(Sender: TObject);
begin
  ClearGrid;
  lTitulo.Text := 'Versão Componentes: ' + RESTDWVersao;
  FBaseURL := '';
end;

procedure TfPrincipal.FormDestroy(Sender: TObject);
begin
  if assigned(FAuthType) then
    FAuthType.Free;
end;

procedure TfPrincipal.ListarPoolers;
var
  DWParams: TRESTDWParams;
  DWClientPooler: TRESTDWIdClientPooler;
  JSONParam: TJSONParam;
  plist: TStringList;
begin
  ConfiguraComponentes;
  // verifica se os parâmetros de conexão foram informados corretamente
  if not(eServidor.Text.IsEmpty) and not(ePorta.Text.IsEmpty) then
  begin
    // configura o componente que vai puxar as informações de pooler
    DWClientPooler := TRESTDWIdClientPooler.Create(nil);
    DWClientPooler.AuthenticationOptions := FAuthType;
    DWClientPooler.Host := eServidor.Text;
    DWClientPooler.Port := ePorta.Text.ToInteger;

    // configura os parâmetros que serão usados
    plist := TStringList.Create;
    DWParams := TRESTDWParams.Create;
    try
      DWParams.Encoding := DWClientPooler.Encoding;
      JSONParam := TJSONParam.Create(DWClientPooler.Encoding);
      JSONParam.ParamName := 'Result';
      JSONParam.ObjectDirection := odOUT;
      JSONParam.ObjectValue := ovString;
      JSONParam.AsString := '';
      DWParams.Add(JSONParam);

      // executa a chamada pra buscar os poolers
      DWClientPooler.SendEvent('GetPoolerList', DWParams);

      // monta a lista de resultado
      cbPoolerDB.Items.Delimiter := '|';
      cbPoolerDB.Items.DelimitedText := DWParams.ItemsString['Result'].AsString;
    finally
      DWParams.Free;
      DWClientPooler.Free;
    end;
  end;
end;

procedure TfPrincipal.RESTDWClientSQL1AfterOpen(DataSet: TDataSet);
var
  I: Integer;
begin
  // famoso "DataSource" manual
  if not DataSet.IsEmpty then
  begin
    ClearGrid;
    for I := 0 to pred(DataSet.Fields.Count) do
    begin
      // monta as colunas da grid de resposta
      case DataSet.Fields.Fields[I].DataType of
        ftBlob:
          gDBWare.AddObject(TGlyphColumn.Create(gDBWare)); 
      else
        // ftString, ftWideString, ftFixedChar, ftMemo, ftFmtMemo:
        gDBWare.AddObject(TStringColumn.Create(gDBWare));
      end;

      gDBWare.Columns[pred(gDBWare.ColumnCount)].Header :=
        DataSet.Fields.Fields[I].FieldName;
    end;
    while not DataSet.Eof do
    begin
      // preenche a grid com o resultado do dataset
      gDBWare.RowCount := gDBWare.RowCount + 1;
      for I := 0 to pred(DataSet.Fields.Count) do
        case DataSet.Fields.Fields[I].DataType of
          ftBlob:
//            gDBWare.Cells[I, pred(gDBWare.RowCount)] :=
//              DataSet.Fields.Fields[I].Value;
        else
          // ftString, ftWideString, ftFixedChar, ftMemo, ftFmtMemo:
//          gDBWare.Cells[I, pred(gDBWare.RowCount)] := DataSet.Fields.Fields
//            [I].AsString;
        end;
      DataSet.Next;
    end;
  end;
end;

end.
