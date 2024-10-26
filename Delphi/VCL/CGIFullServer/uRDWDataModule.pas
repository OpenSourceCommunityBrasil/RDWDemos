UNIT uRDWDataModule;

INTERFACE

USES
  SysUtils, Classes, System.JSON, Dialogs, Data.DB,

  FireDAC.Dapt, FireDAC.Phys.FBDef, FireDAC.UI.Intf, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Comp.Client, FireDAC.Comp.UI, FireDAC.Phys.IBBase,
  FireDAC.Stan.StorageJSON, FireDAC.Phys.MSSQLDef, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSSQL, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.Dapt.Intf, FireDAC.Comp.DataSet,

  uRESTDWServerContext, uRESTDWAbout, uRESTDWBasic, uRESTDWParams,
  uRESTDWDatamodule, uRESTDWMassiveBuffer,
  uRESTDWDataUtils, uRESTDWBasicDB, uRESTDWConsts,
  uRESTDWServerEvents, uRESTDWDriverBase, uRESTDWFireDACDriver;

Const
  Const404Page = 'www\404.html';

TYPE
  TRDWDataModule = CLASS(TServerMethodDataModule)
    RESTDWPoolerDB1: TRESTDWPoolerDB;
    Server_FDConnection: TFDConnection;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    FDTransaction1: TFDTransaction;
    FDQuery1: TFDQuery;
    FDQLogin: TFDQuery;
    RESTDWServerEvents1: TRESTDWServerEvents;
    RESTDWServerContext1: TRESTDWServerContext;
    RESTDWFireDACDriver1: TRESTDWFireDACDriver;
    PROCEDURE Server_FDConnectionBeforeConnect(Sender: TObject);
    procedure ServerMethodDataModuleMassiveProcess(var MassiveDataset
      : TMassiveDatasetBuffer; var Ignore: Boolean);
  PRIVATE
    { Private declarations }
    vIDVenda: Integer;
    function GetGenID(GenName: String): Integer;
  PUBLIC
    { Public declarations }
  END;

VAR
  RDWDataModule: TRDWDataModule;

IMPLEMENTATION

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

Function TRDWDataModule.GetGenID(GenName: String): Integer;
Var
  vTempClient: TFDQuery;
Begin
  vTempClient := TFDQuery.Create(Nil);
  Result := -1;
  Try
    vTempClient.Connection := Server_FDConnection;
    vTempClient.SQL.Add(Format('select gen_id(%s, 1)GenID From rdb$database',
      [GenName]));
    vTempClient.Active := True;
    Result := vTempClient.FindField('GenID').AsInteger;
  Except

  End;
  vTempClient.Free;
End;

procedure TRDWDataModule.ServerMethodDataModuleMassiveProcess(var MassiveDataset
  : TMassiveDatasetBuffer; var Ignore: Boolean);
begin
  { //Esse código é para manipular o evento nao permitindo que sejam alteradas por massive outras
    //tabelas diferentes de employee e se você alterar o campo last_name no client ele substitui o valor
    //pelo valor setado abaixo
    Ignore := (MassiveDataset.MassiveMode in [mmInsert, mmUpdate, mmDelete]) and
    (lowercase(MassiveDataset.TableName) <> 'employee');
  }
  If lowercase(MassiveDataset.TableName) = 'vendas' Then
  Begin
    If MassiveDataset.Fields.FieldByName('ID_VENDA') <> Nil Then
      If (Trim(MassiveDataset.Fields.FieldByName('ID_VENDA').Value) = '') or
        (Trim(MassiveDataset.Fields.FieldByName('ID_VENDA').Value) = '-1') then
      Begin
        vIDVenda := GetGenID('GEN_' + lowercase(MassiveDataset.TableName));
        MassiveDataset.Fields.FieldByName('ID_VENDA').Value :=
          IntToStr(vIDVenda);
      End
      Else
        vIDVenda := StrToInt(MassiveDataset.Fields.FieldByName
          ('ID_VENDA').Value)
  End
  Else If lowercase(MassiveDataset.TableName) = 'vendas_items' Then
  Begin
    If MassiveDataset.Fields.FieldByName('ID_VENDA') <> Nil Then
      If (Trim(MassiveDataset.Fields.FieldByName('ID_VENDA').Value) = '') or
        (Trim(MassiveDataset.Fields.FieldByName('ID_VENDA').Value) = '-1') then
        MassiveDataset.Fields.FieldByName('ID_VENDA').Value :=
          IntToStr(vIDVenda);
    If MassiveDataset.Fields.FieldByName('ID_ITEMS') <> Nil Then
      If (Trim(MassiveDataset.Fields.FieldByName('ID_ITEMS').Value) = '') or
        (Trim(MassiveDataset.Fields.FieldByName('ID_ITEMS').Value) = '-1') then
        MassiveDataset.Fields.FieldByName('ID_ITEMS').Value :=
          IntToStr(GetGenID('GEN_' + lowercase(MassiveDataset.TableName)));
  End;
end;

PROCEDURE TRDWDataModule.Server_FDConnectionBeforeConnect(Sender: TObject);
VAR
  Driver_BD: STRING;
  Porta_BD: STRING;
  Servidor_BD: STRING;
  DataBaseB: STRING;
  Pasta_BD: STRING;
BEGIN
  // Servidor_BD := servidor;
  // Pasta_BD := IncludeTrailingPathDelimiter(pasta);
  // DataBaseB := Pasta_BD + Database;
  // TFDConnection(Sender).Params.Clear;
  // TFDConnection(Sender).Params.Add('DriverID=FB');
  // TFDConnection(Sender).Params.Add('Server=' + Servidor_BD);
  // TFDConnection(Sender).Params.Add('Port=' + Porta_BD);
  // TFDConnection(Sender).Params.Add('Database=' + DataBaseB);
  // TFDConnection(Sender).Params.Add('User_Name=' + Usuario_BD);
  // TFDConnection(Sender).Params.Add('Password=' + Senha_BD);
  // TFDConnection(Sender).Params.Add('Protocol=TCPIP');
  // TFDConnection(Sender).DriverName  := 'FB';
  // TFDConnection(Sender).LoginPrompt := FALSE;
  // TFDConnection(Sender).UpdateOptions.CountUpdatedRecords := False;
END;

END.
