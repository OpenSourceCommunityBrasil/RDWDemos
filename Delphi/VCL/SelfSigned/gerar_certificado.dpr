program gerar_certificado;

uses
  Vcl.Forms,
  uprincipal in 'fontes\uprincipal.pas' {fprincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Gerador de Certificados';
  Application.CreateForm(Tfprincipal, fprincipal);
  Application.Run;
end.
