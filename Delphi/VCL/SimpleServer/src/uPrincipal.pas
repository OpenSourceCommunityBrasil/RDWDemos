unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.WinXCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask,

  uRESTDWAbout, uRESTDWBasic, uRESTDWIdBase,
  uRESTDWConsts, uRESTDWAuthenticators, uRESTDWIcsBase

    ;

type
  TForm1 = class(TForm)
    ToggleSwitch1: TToggleSwitch;
    Label1: TLabel;
    Memo1: TMemo;
    RESTDWAuthBasic1: TRESTDWAuthBasic;
    Label2: TLabel;
    LabeledEdit1: TLabeledEdit;
    RadioGroup1: TRadioGroup;
    RESTDWIdServicePooler1: TRESTDWIdServicePooler;
    RESTDWIcsServicePooler1: TRESTDWIcsServicePooler;
    procedure FormCreate(Sender: TObject);
    procedure ToggleSwitch1Click(Sender: TObject);
    procedure PoolerLastRequest(Value: string);
  private
    Pooler: TRESTServicePoolerBase;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  uDM;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Pooler := nil;
  self.Caption := 'Test Server: ' + RESTDWVersao;
end;

procedure TForm1.PoolerLastRequest(Value: string);
begin
  Memo1.Lines.Add(Value);
end;

procedure TForm1.ToggleSwitch1Click(Sender: TObject);
begin
  if not Assigned(Pooler) then
  begin
    case RadioGroup1.ItemIndex of
      0: // Indy
        TRESTDWIdServicePooler(Pooler) := RESTDWIdServicePooler1;
      1: // ICS
        TRESTDWIcsServicePooler(Pooler) := RESTDWIcsServicePooler1;
    else
      raise Exception.Create('Precisa escolher o motor');
    end;

    Pooler.ServicePort := StrToIntDef(LabeledEdit1.Text, 8082);
    Pooler.ServerMethodClass := TDM;
    Pooler.OnLastRequest := PoolerLastRequest;

    Pooler.Active := ToggleSwitch1.State = tssOn;
  end;

  if ToggleSwitch1.State = tssOn then
  begin
    Label1.Caption := 'https://localhost:' + Pooler.ServicePort.ToString
  end
  else
  begin
    Pooler.Active := false;
    Label1.Caption := 'label1';
    Pooler := nil;
  end;
end;

end.
