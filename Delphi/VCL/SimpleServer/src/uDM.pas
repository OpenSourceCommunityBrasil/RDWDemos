unit uDM;

interface

uses
  System.SysUtils, System.Classes, uRESTDWAbout, uRESTDWServerEvents,
  uRESTDWDatamodule,
  uRESTDWParams, uRESTDWConsts;

type
  TDM = class(TServerMethodDataModule)
    RESTDWServerEvents1: TRESTDWServerEvents;
    procedure RESTDWServerEvents1EventstesteReplyEventByType
      (var Params: TRESTDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TDM.RESTDWServerEvents1EventstesteReplyEventByType
  (var Params: TRESTDWParams; var Result: string;
  const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
begin
  case RequestType of
    rtGet, rtDelete:
      StatusCode := 200;
    rtPost, rtPut, rtPatch:
      StatusCode := 201;
  end;
end;

end.
