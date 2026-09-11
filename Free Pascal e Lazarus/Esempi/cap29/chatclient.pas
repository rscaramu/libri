{ ChatClient - Manuale completo di Free Pascal e Lazarus }
program ChatClient;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, ssockets;

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

var
  S: TInetSocket;
  Riga, T: String;
begin
  S := TInetSocket.Create('127.0.0.1', 9099);
  try
    repeat
      Write('> ');
      ReadLn(Riga);
      T := Riga + #10;
      S.WriteBuffer(T[1], Length(T));
      if Riga <> 'quit' then
        WriteLn(LeggiRiga(S));
    until Riga = 'quit';
  finally
    S.Free;
  end;
end.
