unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uRESTDWAbout,
  uRESTDWBasicDB, uRESTDWIdBase, FMX.Objects, System.Rtti, FMX.Grid.Style,
  FMX.Memo, FMX.StdCtrls, FMX.Edit, FMX.ListBox, FMX.Layouts,
  System.Diagnostics, System.TimeSpan, FMX.Controls.Presentation, FMX.ScrollBox,
  FMX.Grid,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.Bind.EngExt, FMX.Bind.DBEngExt, FMX.Bind.Grid, System.Bindings.Outputs,
  FMX.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, uRESTDWBasicTypes,
  uRESTDWServerEvents, uRESTDWParams, uRESTDWBasic, FMX.Memo.Types,
  uRESTDWComponentBase;

type
  TForm1 = class(TForm)
    rTitle: TRectangle;
    Rectangle1: TRectangle;
    Layout2: TLayout;
    Layout3: TLayout;
    StringGrid1: TStringGrid;
    Layout4: TLayout;
    lst1: TListBox;
    ListBoxItem1: TListBoxItem;
    edtip: TEdit;
    ListBoxItem2: TListBoxItem;
    edtporta: TEdit;
    ListBoxItem3: TListBoxItem;
    bServerTime: TButton;
    Layout5: TLayout;
    mmo1: TMemo;
    btn1: TButton;
    RESTDWClientSQL1: TRESTDWClientSQL;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    RESTDWClientEvents: TRESTDWClientEvents;
    RESTDWIdDatabase1: TRESTDWIdDatabase;
    RESTDWIdClientPooler1: TRESTDWIdClientPooler;
    procedure btn1Click(Sender: TObject);
    procedure bServerTimeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.bServerTimeClick(Sender: TObject);
Var
  dwParams: TRESTDWParams;
  vNativeResult, vErrorMessage: String;
  vResult: Boolean;
begin
  RESTDWIdClientPooler1.Host := edtip.Text;
  RESTDWIdClientPooler1.Port := StrToInt(edtporta.Text);
  RESTDWIdClientPooler1.DataCompression := True;
  // RESTDWClientEvents.GetEvents := True;
  vResult := RESTDWClientEvents.GetEvents;
  RESTDWClientEvents.CreateDWParams('helloworld', dwParams);
  dwParams.ItemsString['temp'].AsString := 'teste de string';
  RESTDWClientEvents.SendEvent('helloworld', dwParams, vErrorMessage,
    vNativeResult);
  If vErrorMessage = '' Then
  Begin
    If vNativeResult <> '' Then
      Showmessage(vNativeResult)
    Else
      Showmessage(vErrorMessage);
  End
  Else
    Showmessage(vErrorMessage);
  dwParams.Free;
end;

procedure TForm1.btn1Click(Sender: TObject);
Var
  Stopwatch: TStopwatch;
  Elapsed: TTimeSpan;
Begin
  Stopwatch := TStopwatch.StartNew;
  If Not RESTDWIdDatabase1.Connected Then
  Begin
    RESTDWIdDatabase1.active := false;
    RESTDWIdDatabase1.PoolerService := edtip.Text;
    RESTDWIdDatabase1.PoolerPort := StrToInt(edtporta.Text);
    RESTDWIdDatabase1.active := True;
  End;
  RESTDWClientSQL1.Close;
  RESTDWClientSQL1.SQL.Clear;
  RESTDWClientSQL1.SQL.Text := mmo1.Lines.Text;
  RESTDWClientSQL1.Open;
  Elapsed := Stopwatch.Elapsed;
  ListBoxItem3.Text := 'Tempo de Resposta: ' + inttostr(Elapsed.Milliseconds) +
    ' milisegundos.';
end;

end.
