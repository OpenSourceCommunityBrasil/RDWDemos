unit uMassivePost;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBCtrls, uPrincipal, StdCtrls;

type

  { TfMassivePost }

  TfMassivePost = class(TForm)
    bMassiveCencel: TButton;
    bMassivePost: TButton;
    DBEFIRST_NAME: TDBEdit;
    DBELAST_NAME: TDBEdit;
    DBEPHONE_EXT: TDBEdit;
    DBLCBDEPT_NO: TDBLookupComboBox;
    DBLCBJOB_CODE: TDBLookupComboBox;
    DBTEMP_NO: TDBText;
    DBTHIRE_DATE: TDBText;
    DBTJOB_COUNTRY: TDBText;
    DBTJOB_GRADE: TDBText;
    DBTSALARY: TDBText;
    DBTTIMEC: TDBText;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure bMassiveCencelClick(Sender: TObject);
    procedure bMassivePostClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private

  public

  end;

var
  fMassivePost: TfMassivePost;

implementation

{$R *.lfm}

{ TfMassivePost }

procedure TfMassivePost.bMassivePostClick(Sender: TObject);
begin
 ModalResult := mrOk;
end;

procedure TfMassivePost.bMassiveCencelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfMassivePost.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
 CloseAction:= caFree;
end;

end.

