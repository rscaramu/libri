{ Coda95 - Manuale completo di Free Pascal e Lazarus }
program Coda95;
{$mode objfpc}{$H+}
type
  PNodo = ^TNodo;
  TNodo = record
    V: Integer;
    Prossimo: PNodo;
  end;
  TCoda = record
    Testa, Coda: PNodo;
  end;

procedure Accoda(var C: TCoda; V: Integer);
var
  N: PNodo;
begin
  New(N);
  N^.V := V;
  N^.Prossimo := nil;
  if C.Coda = nil then
    C.Testa := N
  else
    C.Coda^.Prossimo := N;
  C.Coda := N;
end;

function Estrai(var C: TCoda): Integer;
var
  N: PNodo;
begin
  N := C.Testa;
  Result := N^.V;
  C.Testa := N^.Prossimo;
  if C.Testa = nil then
    C.Coda := nil;
  Dispose(N);
end;

var
  C: TCoda;
  I: Integer;
begin
  C.Testa := nil;
  C.Coda := nil;
  for I := 1 to 4 do
    Accoda(C, I * 10);
  while C.Testa <> nil do
    Write(Estrai(C), ' ');
  WriteLn;
end.
