unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.TabControl, System.Rtti, FMX.Grid.Style, FMX.StdCtrls, FMX.Edit,
  FMX.Layouts, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid,
  FMX.Memo.Types, FMX.Memo, FMX.ListBox,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Data.DB,

  uRESTDWBasicTypes, uRESTDWBasicDB, uRESTDWComponentBase, uRESTDWIdBase,
  uRESTDWBasic, uRESTDWParams, uRESTDWConsts;

type
  TfPrincipal = class(TForm)
    TabControl1: TTabControl;
    Image1: TImage;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    sgDBWare: TStringGrid;
    Layout1: TLayout;
    eServidor: TEdit;
    Label1: TLabel;
    ePorta: TEdit;
    Label2: TLabel;
    cbPoolerDB: TComboBox;
    Label3: TLabel;
    RESTDWIdDatabase1: TRESTDWIdDatabase;
    RESTDWClientSQL1: TRESTDWClientSQL;
    Memo1: TMemo;
    Label4: TLabel;
    Layout2: TLayout;
    FlowLayout1: TFlowLayout;
    Button1: TButton;
    TabControl2: TTabControl;
    TabItem4: TTabItem;
    TabItem5: TTabItem;
    cbBinaryRequest: TCheckBox;
    GroupBox1: TGroupBox;
    cbBinaryCompatibleMode: TCheckBox;
    lTitulo: TLabel;
    procedure RESTDWClientSQL1AfterOpen(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure cbPoolerDBEnter(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure ConfiguraComponentes;
    procedure ClearGrid;
    procedure ListarPoolers;
  public
    { Public declarations }
  end;

var
  fPrincipal: TfPrincipal;

implementation

{$R *.fmx}

procedure TfPrincipal.Button1Click(Sender: TObject);
begin
  ConfiguraComponentes;

  RESTDWClientSQL1.SQL.Text := Memo1.Text;
  RESTDWClientSQL1.Open;
end;

procedure TfPrincipal.cbPoolerDBEnter(Sender: TObject);
begin
  ListarPoolers;
end;

procedure TfPrincipal.ClearGrid;
begin
  sgDBWare.ClearColumns;
  sgDBWare.ClearContent;
end;

procedure TfPrincipal.ConfiguraComponentes;
begin
  if (cbPoolerDB.Items.Count > 0) and not(cbPoolerDB.Selected.Text.IsEmpty) then
  begin
    RESTDWIdDatabase1.PoolerPort := ePorta.Text.ToInteger;
    RESTDWIdDatabase1.PoolerService := eServidor.Text;
    RESTDWIdDatabase1.PoolerName := cbPoolerDB.Selected.Text;
  end;
  RESTDWClientSQL1.BinaryRequest := cbBinaryRequest.IsChecked;
  RESTDWClientSQL1.BinaryCompatibleMode := cbBinaryCompatibleMode.IsChecked;
end;

procedure TfPrincipal.FormCreate(Sender: TObject);
begin
  ClearGrid;
  lTitulo.Text := 'Vers�o Componentes: ' + RESTDWVersao;
end;

procedure TfPrincipal.ListarPoolers;
var
  DWParams: TRESTDWParams;
  DWClientPooler: TRESTDWIdClientPooler;
  JSONParam: TJSONParam;
  teste, teste2: string;
  plist: TStringList;
begin
  if not(eServidor.Text.IsEmpty) and not(ePorta.Text.IsEmpty) then
  begin
    DWClientPooler := TRESTDWIdClientPooler.Create(nil);
    DWClientPooler.Host := eServidor.Text;
    DWClientPooler.Port := ePorta.Text.ToInteger;

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

      teste := DWClientPooler.SendEvent('GetPoolerList', DWParams);
      cbPoolerDB.Items.delimiter := '|';
      cbPoolerDB.Items.delimitedText := DWParams.ItemsString['Result'].AsString;
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
      sgDBWare.AddObject(TStringColumn.Create(sgDBWare));
      sgDBWare.Columns[pred(sgDBWare.ColumnCount)].Header :=
        DataSet.Fields.Fields[I].FieldName;
    end;
    while not DataSet.Eof do
    begin
      sgDBWare.RowCount := sgDBWare.RowCount + 1;
      for I := 0 to pred(DataSet.Fields.Count) do
        sgDBWare.Cells[I, pred(sgDBWare.RowCount)] := DataSet.Fields.Fields
          [I].AsString;
      DataSet.Next;
    end;
  end;
end;

end.