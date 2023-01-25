unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, uRESTDWIdBase;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    RESTDWIdServicePooler1: TRESTDWIdServicePooler;
    ToggleBox1: TToggleBox;
    procedure FormCreate(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
    procedure ToggleBox1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

uses
  uDM;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  RESTDWIdServicePooler1.ServerMethodClass := TDM;
end;

procedure TForm1.ToggleBox1Change(Sender: TObject);
begin
  RESTDWIdServicePooler1.Active := ToggleBox1.Checked;
end;

procedure TForm1.ToggleBox1Click(Sender: TObject);
begin
  if ToggleBox1.Checked then
    ToggleBox1.Caption := 'http://localhost:' +
      RESTDWIdServicePooler1.ServicePort.ToString
  else
    ToggleBox1.Caption := 'inativo';
end;

end.