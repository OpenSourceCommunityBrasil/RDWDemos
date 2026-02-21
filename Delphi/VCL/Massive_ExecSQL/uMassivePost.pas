unit uMassivePost;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uPrincipal, Data.DB,
  uRESTDWMemoryDataset, uRESTDWBasicTypes, uRESTDWBasicDB, Vcl.DBCtrls,
  Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls;

type
  TfMassivePost = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    DBTEMP_NO: TDBText;
    DBEFIRST_NAME: TDBEdit;
    DBELAST_NAME: TDBEdit;
    DBEPHONE_EXT: TDBEdit;
    DBTHIRE_DATE: TDBText;
    DBLCBDEPT_NO: TDBLookupComboBox;
    DBLCBJOB_CODE: TDBLookupComboBox;
    DBTJOB_GRADE: TDBText;
    DBTJOB_COUNTRY: TDBText;
    DBTSALARY: TDBText;
    DBTTIMEC: TDBText;
    bMassivePost: TButton;
    bMassiveCencel: TButton;
    procedure bMassiveCencelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bMassivePostClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMassivePost: TfMassivePost;

implementation

{$R *.dfm}

procedure TfMassivePost.bMassiveCencelClick(Sender: TObject);
begin
 ModalResult := mrCancel;
end;

procedure TfMassivePost.bMassivePostClick(Sender: TObject);
begin
 ModalResult := mrOk;
end;

procedure TfMassivePost.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := TCloseAction.caFree;
end;

end.
