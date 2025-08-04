unit uDmServiceBase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uRESTDWIdBase;

type

  { TrdwDaemonDM }

  TrdwDaemonDM = class(TDatamodule)
    RESTDWServicePooler: TRESTDWIdServicePooler;
    procedure DataModuleCreate(Sender: TObject);
  private

  public
   Procedure StartServer;
   Procedure StopServer;
  end;

var
  rdwDaemonDM: TrdwDaemonDM;

implementation

uses uDmService;

{$R *.lfm}

{ TrdwDaemonDM }

procedure TrdwDaemonDM.DataModuleCreate(Sender: TObject);
begin
 RESTDWServicePooler.ServerMethodClass := TServerMethodDM;
end;

procedure TrdwDaemonDM.StartServer;
begin
 RESTDWServicePooler.Active := True;
end;

procedure TrdwDaemonDM.StopServer;
begin
 RESTDWServicePooler.Active := False;
end;

end.

