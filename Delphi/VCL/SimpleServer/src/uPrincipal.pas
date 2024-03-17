unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uRESTDWAbout, uRESTDWBasic,
  uRESTDWIdBase, Vcl.WinXCtrls, uRESTDWComponentBase;

type
  TForm1 = class(TForm)
    ToggleSwitch1: TToggleSwitch;
    RESTDWIdServicePooler1: TRESTDWIdServicePooler;
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
  RESTDWIdServicePooler1.ServerMethodClass := TDM;
end;

procedure TForm1.ToggleSwitch1Click(Sender: TObject);
begin
  RESTDWIdServicePooler1.Active := ToggleSwitch1.State = tssOn;
end;

end.
