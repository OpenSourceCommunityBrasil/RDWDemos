unit uprincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uRESTDWBasic,
  uRESTDWIdBase, uRESTDWAbout;

type
  TForm2 = class(TForm)
    pooler: TRESTDWIdServicePooler;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses
  udm_rest;

procedure TForm2.FormCreate(Sender: TObject);
begin
  pooler.Active := False;
  pooler.ServerMethodClass := Tdm_rest;
  pooler.Active := True;
end;

end.
