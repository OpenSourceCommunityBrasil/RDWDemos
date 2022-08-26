program fileclient;

{$Mode objfpc}
{$H+}

uses
 {$IFDEF UNIX}
  cthreads,
   {$ENDIF} {$IFDEF HASAMIGA}
  athreads,
   {$ENDIF}
  Forms,
  Interfaces,
  fc.mainform;

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
