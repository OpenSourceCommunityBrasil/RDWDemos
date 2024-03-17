program fileserver;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
    Forms, indylaz,
    Interfaces,
    fs.mainform,
    fs.datamodules;

  {$R *.res}

  begin
  Application.Scaled:=True;
    Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
    Application.Run;
  end.

