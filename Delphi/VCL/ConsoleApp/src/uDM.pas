unit uDM;

interface

uses
  System.SysUtils, System.Classes,
  uRESTDWAbout, uRESTDWDatamodule, uRESTDWServerEvents, uRESTDWParams;

type
  TDM = class(TServerMethodDataModule)
    RESTDWServerEvents1: TRESTDWServerEvents;
    procedure RESTDWServerEvents1EventshelloReplyEvent(
      var Params: TRESTDWParams; var Result: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TDM.RESTDWServerEvents1EventshelloReplyEvent(
  var Params: TRESTDWParams; var Result: string);
begin
  Result := 'Hello world!';
end;

end.
