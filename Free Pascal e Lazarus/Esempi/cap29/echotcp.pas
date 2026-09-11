{ EchoTcp - Manuale completo di Free Pascal e Lazarus }
program EchoTcp;
{$mode objfpc}{$H+}
uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  SysUtils, Classes, ssockets;
type
  TServerThread = class(TThread)
  private
    FServer: TInetServer;
    procedure Connessione(Sender: TObject;
                          Data: TSocketStream);
  protected
    procedure Execute; override;
  public
    constructor Create;
    procedure Ferma;
  end;

function LeggiRiga(S: TSocketStream): String;
var
  C: Char;
begin
  Result := '';
  while S.Read(C, 1) = 1 do
  begin
    if C = #10 then
      Break;
    Result := Result + C;
  end;
end;

procedure ScriviRiga(S: TSocketStream; const R: String);
var
  T: String;
begin
  T := R + #10;
  S.WriteBuffer(T[1], Length(T));
end;

constructor TServerThread.Create;
begin
  inherited Create(True);
  FServer := TInetServer.Create('127.0.0.1', 9099);
  FServer.OnConnect := @Connessione;
  FreeOnTerminate := False;
end;

procedure TServerThread.Connessione(Sender: TObject;
                                     Data: TSocketStream);
var
  R: String;
begin
  R := LeggiRiga(Data);
  ScriviRiga(Data, 'ECO: ' + UpperCase(R));
end;

procedure TServerThread.Execute;
begin
  FServer.StartAccepting;
end;

procedure TServerThread.Ferma;
begin
  FServer.StopAccepting(True);
end;

var
  Server: TServerThread;
  Client: TInetSocket;
  I: Integer;
begin
  Server := TServerThread.Create;
  Server.Start;
  Sleep(200);                { il server si mette in ascolto }
  for I := 1 to 3 do
  begin
    Client := TInetSocket.Create('127.0.0.1', 9099);
    try
      ScriviRiga(Client, 'messaggio ' + IntToStr(I));
      WriteLn(LeggiRiga(Client));
    finally
      Client.Free;
    end;
  end;
  Server.Ferma;
  Server.WaitFor;
  Server.Free;
end.
