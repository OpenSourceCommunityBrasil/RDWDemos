unit uprincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, uRESTDWBasicDB, uRESTDWIdBase, Vcl.StdCtrls,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, Vcl.Grids, Vcl.DBGrids, FireDAC.Phys.IBBase,
  uRESTDWMemoryDataset, uRESTDWBasicTypes, FireDAC.Phys.RESTDWDef,
  FireDAC.Phys.RESTDWBase, FireDAC.Phys.RESTDW, uRESTDWAbout;

type
  TForm1 = class(TForm)
    conn: TFDConnection;
    rdw_database: TRESTDWIdDatabase;
    Button1: TButton;
    q1: TFDQuery;
    DBGrid1: TDBGrid;
    ds: TDataSource;
    tb: TFDTable;
    Button2: TButton;
    Label1: TLabel;
    RESTDWFireDACPhysLink1: TRESTDWFireDACPhysLink;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure tbAfterPost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  dt1, dt2 : TDateTime;
begin
  conn.Open;
  ds.DataSet := q1;
  q1.Close;
  dt1 := Now;
  q1.Open;
  dt2 := Now;
  Label1.Caption := FormatDateTime('HH:nn:ss:zzz',dt2-dt1);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  dt1, dt2 : TDateTime;
begin
  conn.Open;
  ds.DataSet := tb;
  dt1 := Now;
  tb.Close;
  tb.Open;
  dt2 := Now;
  Label1.Caption := FormatDateTime('HH:nn:ss:zzz',dt2-dt1);
end;

procedure TForm1.tbAfterPost(DataSet: TDataSet);
var
  s : string;
  oErr: EFDException;
begin
  if tb.ApplyUpdates > 0 then begin
    tb.FilterChanges := [rtModified, rtInserted, rtDeleted, rtHasErrors];
    try
      tb.First;
      s := '';
      while not tb.Eof do begin
        oErr := tb.RowError;
        if oErr <> nil then begin
          if s <> '' then
            s := s + #13#10;
          s := s + oErr.Message;
        end;
        tb.Next;
      end;
    finally
      tb.FilterChanges := [rtUnmodified, rtModified, rtInserted];
    end;
    ShowMessage(s);
    tb.RevertRecord;
  end
  else begin
    ShowMessage('Gravado com sucesso!');
  end;
end;

end.
