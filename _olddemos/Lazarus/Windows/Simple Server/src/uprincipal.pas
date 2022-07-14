unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  uRESTDWBase, uRESTDWSynBase;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Server: TRESTServicePooler;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

uses
  udm;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Server.ServerMethodClass := TDM;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  server.Active := not Server.Active;
  if Server.Active then
    Button1.Caption := 'Online'
  else
    Button1.Caption := 'Offline';
end;

end.
