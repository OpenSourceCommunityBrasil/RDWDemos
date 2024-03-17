unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, OverbyteIcsWndControl,
  OverbyteIcsHttpSrv, Vcl.StdCtrls, OverbyteIcsHttpAppServer;

 Type
  TRESTDWHttpConnection = class(THttpConnection)
  protected
    FPostedRawData    : PAnsiChar; { Will hold dynamically allocated buffer }
    FPostedDataBuffer : PChar;     { Contains either Unicode or Ansi data   }
    FPostedDataSize   : Integer;   { Databuffer size                        }
    FDataLen          : Integer;   { Keep track of received byte count.     }
    FDataFile         : TextFile;  { Used for datafile display              }
    FFileIsUtf8       : Boolean;
//    FRespTimer        : TTimer;    { V7.22 send a delayed response }
  Public
   Destructor  Destroy; override;
//    procedure TimerRespTimer(Sender: TObject);
  End;

type
  TForm1 = class(TForm)
    HttpAppSrv1: THttpAppSrv;
    Button1: TButton;
    DisplayMemo: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure HttpAppSrv1GetDocument(Sender, Client: TObject;
      var Flags: THttpGetFlag);
  private
    procedure Display(const Msg: String);
    procedure CreateData(Sender: TObject; ClientCnx: TRESTDWHttpConnection;
      var Flags: THttpGetFlag);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Destructor TRESTDWHttpConnection.Destroy;
Begin
 If Assigned(FPostedRawData) Then
  Begin
   FreeMem(FPostedRawData, FPostedDataSize);
   FPostedRawData  := Nil;
   FPostedDataSize := 0;
  End;
 //FreeAndNil (FRespTimer);  { V7.21 }
 Inherited Destroy;
End;

procedure TForm1.CreateData(
    Sender    : TObject;
    ClientCnx : TRESTDWHttpConnection;
    var Flags : THttpGetFlag);
begin
 ClientCnx.AnswerStream(Flags,
                        '',           { Default Status '200 OK'         }
                        '',           { Default Content-Type: text/html }
                        '');           { Default header                  }
End;

procedure TForm1.Button1Click(Sender: TObject);
begin
 if Not HttpAppSrv1.ListenAllOK Then
  HttpAppSrv1.Start
 Else
  HttpAppSrv1.Stop;
end;

procedure TForm1.Display(const Msg : String);
var
    I : Integer;
begin
    if not Assigned(DisplayMemo) then
        Exit;
    DisplayMemo.Lines.BeginUpdate;
    try
        if DisplayMemo.Lines.Count > 200 then begin
            with TStringList.Create do
            try
                BeginUpdate;
                Assign(DisplayMemo.Lines);
                for I := 1 to 50 do
                    Delete(0);
                DisplayMemo.Lines.Text := Text;
            finally
                Free;
            end;
        end;
        DisplayMemo.Lines.Add(Msg);
    finally
        DisplayMemo.Lines.EndUpdate;
        SendMessage(DisplayMemo.Handle, EM_SCROLLCARET, 0, 0);
    end;
end;

procedure TForm1.HttpAppSrv1GetDocument(Sender, Client: TObject;
  var Flags: THttpGetFlag);
Var
 ClientCnx     : THttpAppSrvConnection;
 vStringStream : TStream;
 vReply        : String;
begin
 ClientCnx := Client as THttpAppSrvConnection;
 If ClientCnx.Params = '' Then
  Display(ClientCnx.PeerAddr + ':' + ClientCnx.PeerPort + ' ' + ClientCnx.Path)
 Else
  Display(ClientCnx.PeerAddr + ':' + ClientCnx.PeerPort + ' ' + ClientCnx.Path + '?' + ClientCnx.Params);
 vReply :=
        '<HTML>' +
          '<HEAD>' +
            '<TITLE>ICS WebServer Demo</TITLE>' +
          '</HEAD>' + #13#10 +
          '<BODY>' +
            '<H2>This page was deliberately returned slowly</H2>' + #13#10 +
            '<H2>Time at server side:</H2>' + #13#10 +
            '<P>' + DateTimeToStr(Now) +'</P>' + #13#10 +
            '<A HREF="/demo.html">Demo menu</A>' + #13#10 +
          '</BODY>' +
        '</HTML>';
 vStringStream       := TStringStream.Create(vReply);
 ClientCnx.DocStream := vStringStream;
 ClientCnx.AnswerStream(Flags,
                        '', { Default Status '200 OK'            }
                        ''  { Default Content-Type: text/html    },
                        ''  {Header});
end;

end.
