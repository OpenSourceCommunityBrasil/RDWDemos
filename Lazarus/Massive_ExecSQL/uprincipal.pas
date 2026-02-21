unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  DBGrids, uRESTDWIdBase, uRESTDWBasicDB, uRESTDWMemoryDataset, uRESTDWBasicTypes,
  uRESTDWProtoTypes;

type

  { TfPrincipal }

  TfPrincipal = class(TForm)
    bMassivePost: TButton;
    btnOpen: TButton;
    cbUseCripto: TCheckBox;
    cbxCompressao: TCheckBox;
    chkhttps: TCheckBox;
    DBGrid1: TDBGrid;
    dsClientSQLDep_No: TDataSource;
    dsClientSQLEmployee: TDataSource;
    dsClientSQLGrid: TDataSource;
    dsClientSQLJobs: TDataSource;
    eAccesstag: TEdit;
    eHost: TEdit;
    ePort: TEdit;
    eWelcomemessage: TEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    labAcesso: TLabel;
    labConexao: TLabel;
    labExtras: TLabel;
    labHost: TLabel;
    labPorta: TLabel;
    labResult: TLabel;
    labSistema: TLabel;
    labWelcome: TLabel;
    paEspanhol: TPanel;
    paIngles: TPanel;
    paPortugues: TPanel;
    paTopo: TPanel;
    rClientSQLDep_No: TRESTDWClientSQL;
    rClientSQLDep_NoDEPARTMENT: TStringFieldRESTDW;
    rClientSQLDep_NoDEPT_NO: TStringFieldRESTDW;
    rClientSQLEmployee: TRESTDWClientSQL;
    rClientSQLEmployeeDEPT_NO: TStringFieldRESTDW;
    rClientSQLEmployeeEMP_NO: TSmallintField;
    rClientSQLEmployeeFIRST_NAME: TStringFieldRESTDW;
    rClientSQLEmployeeFULL_NAME: TStringFieldRESTDW;
    rClientSQLEmployeeHIRE_DATE: TDateTimeField;
    rClientSQLEmployeeJOB_CODE: TStringFieldRESTDW;
    rClientSQLEmployeeJOB_COUNTRY: TStringFieldRESTDW;
    rClientSQLEmployeeJOB_GRADE: TSmallintField;
    rClientSQLEmployeeLAST_NAME: TStringFieldRESTDW;
    rClientSQLEmployeePHONE_EXT: TStringFieldRESTDW;
    rClientSQLEmployeeSALARY: TRESTDWNumericField;
    rClientSQLEmployeeTIMEC: TTimeField;
    rClientSQLExecSQL: TRESTDWClientSQL;
    rClientSQLGrid: TRESTDWClientSQL;
    rClientSQLJobs: TRESTDWClientSQL;
    rClientSQLJobsJOB_CODE: TStringFieldRESTDW;
    rClientSQLJobsJOB_COUNTRY: TStringFieldRESTDW;
    rClientSQLJobsJOB_GRADE: TSmallintField;
    rClientSQLJobsJOB_TITLE: TStringFieldRESTDW;
    rClientSQLJobsMAX_SALARY: TRESTDWNumericField;
    rClientSQLMaxEmployee: TRESTDWClientSQL;
    rClientSQLMaxEmployeeEMP_NO: TLargeintField;
    rDatabase: TRESTDWIdDatabase;
    procedure bMassivePostClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure rClientSQLEmployeeAfterInsert(DataSet: TDataSet);
    procedure rClientSQLJobsAfterScroll(DataSet: TDataSet);
    procedure rDatabaseBeforeConnect(Sender: TComponent);
  private
   Procedure SetConnect;
  public

  end;

var
  fPrincipal: TfPrincipal;

implementation

uses uMassivePost;

{$R *.lfm}

{ TfPrincipal }

procedure TfPrincipal.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  rClientSQLEmployee.Close;
  rClientSQLDep_No.Close;
  rClientSQLJobs.Close;
  rClientSQLGrid.Close;
  rClientSQLMaxEmployee.Close;
  CloseAction:= caFree;
end;

procedure TfPrincipal.rClientSQLEmployeeAfterInsert(DataSet: TDataSet);
Var
 vEmpNo : Integer;
begin
  rClientSQLEmployeeHIRE_DATE.AsDateTime := Now;
  rClientSQLEmployeeTIMEC.AsDateTime     := Time;
  rClientSQLMaxEmployee.Close;
  rClientSQLMaxEmployee.Open;
  rClientSQLEmployeeEMP_NO.AsInteger     := rClientSQLMaxEmployeeEMP_NO.AsInteger;
  rClientSQLMaxEmployee.Close;
end;

procedure TfPrincipal.rClientSQLJobsAfterScroll(DataSet: TDataSet);
Var
 vValue : DWLongDouble;
begin
  If rClientSQLEmployee.State in [dsEdit, dsInsert] Then
   Begin
    If Not rClientSQLJobsMAX_SALARY.IsNull Then
     Begin
      vValue                         := rClientSQLJobsMAX_SALARY.Value;
      rClientSQLEmployeeSALARY.Value := vValue;
     End
    Else
     rClientSQLEmployeeSALARY.Value        := 0;
    rClientSQLEmployeeJOB_GRADE.AsString   := rClientSQLJobsJOB_GRADE.AsString;
    rClientSQLEmployeeJOB_COUNTRY.AsString := rClientSQLJobsJOB_COUNTRY.AsString;
   End;
end;

procedure TfPrincipal.rDatabaseBeforeConnect(Sender: TComponent);
begin
 SetConnect;
end;

Procedure TfPrincipal.SetConnect;
Begin
 If Not rDatabase.Active Then
  Begin
   rDatabase.PoolerService   := EHost.Text;
   rDatabase.PoolerPort      := StrToInt(EPort.Text);
   rDatabase.Compression     := cbxCompressao.Checked;
   rDatabase.AccessTag       := eAccesstag.Text;
   rDatabase.WelcomeMessage  := eWelcomemessage.Text;
   If chkhttps.Checked Then
    rDatabase.TypeRequest    := TTyperequest.trHttps
   Else
    rDatabase.TypeRequest    := TTyperequest.trHttp;
  End;
End;

procedure TfPrincipal.btnOpenClick(Sender: TObject);
begin
  rClientSQLGrid.Close;
  rClientSQLGrid.Open;
end;

procedure TfPrincipal.bMassivePostClick(Sender: TObject);
begin
 rClientSQLEmployee.Close;
 rDatabase.OpenDatasets([rClientSQLJobs, rClientSQLDep_No, rClientSQLEmployee]);
 rClientSQLEmployee.Insert;
 fMassivePost := TfMassivePost.Create(Self);
 If fMassivePost.Showmodal = mrCancel Then
  rClientSQLEmployee.Cancel
 Else
  Begin
   rClientSQLEmployee.Post;
   rClientSQLEmployee.ApplyUpdates;
  End;
 rClientSQLEmployee.Close;
 rClientSQLDep_No.Close;
 rClientSQLJobs.Close;
end;

end.

