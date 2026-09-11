{ NewDispose - Manuale completo di Free Pascal e Lazarus }
program NewDispose;
{$mode objfpc}{$H+}
type
  TPersona = record
    Nome: String;
    Eta: Integer;
  end;
  PPersona = ^TPersona;

function CreaPersona(const N: String; E: Integer): PPersona;
begin
  New(Result);
  Result^.Nome := N;
  Result^.Eta := E;
end;

var
  P: PPersona;
begin
  P := CreaPersona('Grace', 45);
  WriteLn(P^.Nome, ', ', P^.Eta);
  P^.Eta := P^.Eta + 1;
  WriteLn(P^.Nome, ', ', P^.Eta);
  Dispose(P);
  P := nil;
end.
