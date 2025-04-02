program ServerRdwConsole;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  uEmployeeController in '..\Source\Controller\uEmployeeController.pas',
  uServerController in '..\Source\Controller\uServerController.pas'

  , uRESTDWIdBase

  ;

var
  ServicePooler: TRESTDWIdServicePooler;

begin
  try
    ServicePooler := TRESTDWIdServicePooler.Create(nil);
    try
      ServicePooler.ServerMethodClass := TServerController;
      ServicePooler.Active := True;
      WriteLn('Server Online...');
      ReadLn;
    finally
      ServicePooler.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
