program server;

uses
  Vcl.Forms,
  uprincipal in 'uprincipal.pas' {Form2},
  udm_rest in 'udm_rest.pas' {dm_rest: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(Tdm_rest, dm_rest);
  Application.Run;
end.
