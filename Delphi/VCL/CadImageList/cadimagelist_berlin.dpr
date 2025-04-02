program cadimagelist_berlin;

uses
  Vcl.Forms,
  ucadimagelist in 'ucadimagelist.pas' {fcadimagelist};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfcadimagelist, fcadimagelist);
  Application.Run;
end.
