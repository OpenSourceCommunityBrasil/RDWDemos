unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Data.DB, uRESTDWMemoryDataset, uRESTDWBasicTypes, uRESTDWBasicDB,
  Vcl.Grids, Vcl.DBGrids, uRESTDWAbout, uRESTDWIdBase, uRESTDWProtoTypes;

type
  TfPrincipal = class(TForm)
    paTopo: TPanel;
    Image1: TImage;
    labSistema: TLabel;
    paPortugues: TPanel;
    Image3: TImage;
    paEspanhol: TPanel;
    Image4: TImage;
    paIngles: TPanel;
    Image2: TImage;
    labConexao: TLabel;
    ePort: TEdit;
    eHost: TEdit;
    labHost: TLabel;
    labPorta: TLabel;
    eAccesstag: TEdit;
    labAcesso: TLabel;
    eWelcomemessage: TEdit;
    labWelcome: TLabel;
    labExtras: TLabel;
    chkhttps: TCheckBox;
    cbUseCripto: TCheckBox;
    cbxCompressao: TCheckBox;
    rClientSQLEmployee: TRESTDWClientSQL;
    rClientSQLExecSQL: TRESTDWClientSQL;
    labResult: TLabel;
    DBGrid1: TDBGrid;
    rClientSQLGrid: TRESTDWClientSQL;
    rDatabase: TRESTDWIdDatabase;
    dsClientSQLGrid: TDataSource;
    dsClientSQLEmployee: TDataSource;
    btnOpen: TButton;
    bMassivePost: TButton;
    rClientSQLMaxEmployee: TRESTDWClientSQL;
    rClientSQLMaxEmployeeEMP_NO: TLargeintField;
    rClientSQLDep_No: TRESTDWClientSQL;
    dsClientSQLDep_No: TDataSource;
    dsClientSQLJobs: TDataSource;
    rClientSQLJobs: TRESTDWClientSQL;
    rClientSQLEmployeeEMP_NO: TSmallintField;
    rClientSQLEmployeeFIRST_NAME: TStringFieldRESTDW;
    rClientSQLEmployeeLAST_NAME: TStringFieldRESTDW;
    rClientSQLEmployeePHONE_EXT: TStringFieldRESTDW;
    rClientSQLEmployeeHIRE_DATE: TSQLTimeStampField;
    rClientSQLEmployeeDEPT_NO: TStringFieldRESTDW;
    rClientSQLEmployeeJOB_CODE: TStringFieldRESTDW;
    rClientSQLEmployeeJOB_GRADE: TSmallintField;
    rClientSQLEmployeeJOB_COUNTRY: TStringFieldRESTDW;
    rClientSQLEmployeeSALARY: TRESTDWNumericField;
    rClientSQLEmployeeFULL_NAME: TStringFieldRESTDW;
    rClientSQLEmployeeTIMEC: TTimeField;
    rClientSQLDep_NoDEPT_NO: TStringFieldRESTDW;
    rClientSQLDep_NoDEPARTMENT: TStringFieldRESTDW;
    rClientSQLJobsJOB_CODE: TStringFieldRESTDW;
    rClientSQLJobsJOB_GRADE: TSmallintField;
    rClientSQLJobsJOB_COUNTRY: TStringFieldRESTDW;
    rClientSQLJobsJOB_TITLE: TStringFieldRESTDW;
    rClientSQLJobsMAX_SALARY: TRESTDWNumericField;
    procedure btnOpenClick(Sender: TObject);
    procedure bMassivePostClick(Sender: TObject);
    procedure rClientSQLEmployeeAfterInsert(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rClientSQLJobsAfterScroll(DataSet: TDataSet);
    procedure rDatabaseBeforeConnect(Sender: TComponent);
  private
    { Private declarations }
   Procedure SetConnect;
  public
    { Public declarations }
  end;

var
  fPrincipal: TfPrincipal;

implementation

Uses uMassivePost;

{$R *.dfm}


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

procedure TfPrincipal.btnOpenClick(Sender: TObject);
begin
 rClientSQLGrid.Close;
 rClientSQLGrid.Open;
end;

procedure TfPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 rClientSQLEmployee.Close;
 rClientSQLDep_No.Close;
 rClientSQLJobs.Close;
 rClientSQLGrid.Close;
 rClientSQLMaxEmployee.Close;
 Action := caFree;
end;

procedure TfPrincipal.rClientSQLEmployeeAfterInsert(DataSet: TDataSet);
begin
 rClientSQLEmployeeHIRE_DATE.AsDateTime := Now;
 rClientSQLEmployeeTIMEC.AsDateTime     := Time;
 rClientSQLMaxEmployee.Close;
 rClientSQLMaxEmployee.Open;
 rClientSQLEmployeeEMP_NO.AsInteger := rClientSQLMaxEmployeeEMP_NO.AsInteger;
 rClientSQLMaxEmployee.Close;
end;

procedure TfPrincipal.rClientSQLJobsAfterScroll(DataSet: TDataSet);
begin
 If rClientSQLEmployee.State in [dsEdit, dsInsert] Then
  Begin
   If Not rClientSQLJobsMAX_SALARY.IsNull Then
    rClientSQLEmployeeSALARY.Value        := rClientSQLJobsMAX_SALARY.Value
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

end.
