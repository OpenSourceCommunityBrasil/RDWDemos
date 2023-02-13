program RESTDWConsoleApp;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  // versão 2.0 ou 2.1 Indy
  uRESTDWIdBase,
  // versão 2.1 ICS Delphi VCL
  // uRESTDWIcsBase,

  uDM in 'src\uDM.pas' {DM: TDataModule};

var
  // versão 2.0 ou 2.1 Indy
  Server: TRESTDWIdServicePooler;

  // versão 2.1 ICS Delphi VCL
  // Server: TRESTDWIcsServicePooler;

begin
  // versão 2.0 ou 2.1 Indy
  Server := TRESTDWIdServicePooler.Create(nil);

  // versão 2.1 ICS Delphi VCL
  // Server := TRESTDWIcsServicePooler.Create(nil);
  try
    try
      // se não configurar nada, ele vai usar por padrão rdwAONone e porta 8082
      // você pode atribuir somente 1 datamodule através desse comando:
      Server.ServerMethodClass := TDM;
      // ou vários comentando a linha de cima e usando as linhas de baixo:
      {
        Server.AddDataRoute('nomedarota', DMRota1);
        Server.AddDataRoute('nomedarota', DMRota2);
        Server.AddDataRoute('nomedarota', DMRota3);
        Server.AddDataRoute('nomedarota', DMRota4);
        Server.AddDataRoute('nomedarota', DMRota5);
      }
      Server.Active := true;
      Writeln('Servidor REST DataWare rodando na porta: ' +
        IntToStr(Server.ServicePort));
      Writeln('');
      Writeln('Pressione alguma tecla pra fechar a aplicação...');
      ReadLn;
    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;
  finally
    Server.Free;
  end;

end.
