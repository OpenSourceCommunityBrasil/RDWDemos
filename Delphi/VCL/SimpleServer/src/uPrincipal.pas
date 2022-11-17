unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.WinXCtrls,
  Vcl.StdCtrls,

  uRESTDWAbout, uRESTDWBasic, uRESTDWComponentBase, uRESTDWIdBase,
  uRESTDWConsts

    ;

type
  TForm1 = class(TForm)
    ToggleSwitch1: TToggleSwitch;
    Label1: TLabel;
    Pooler: TRESTDWIdServicePooler;
    procedure FormCreate(Sender: TObject);
    procedure ToggleSwitch1Click(Sender: TObject);
  private
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
  Pooler.ServerMethodClass := TDM;
  self.Caption := 'Test Server: ' + RESTDWVersao;
end;

procedure TForm1.ToggleSwitch1Click(Sender: TObject);
begin
  Pooler.Active := ToggleSwitch1.State = tssOn;
  if Pooler.Active then
    Label1.Caption := 'https://localhost:' + Pooler.ServicePort.ToString
  else
    Label1.Caption := 'label1';
end;

end.
