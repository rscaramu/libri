{ Pila - Manuale completo di Free Pascal e Lazarus }
program Pila;
{$mode objfpc}{$H+}
type
  PNodo = ^TNodo;
  TNodo = record
    V: Integer;
    Sotto: PNodo;
  end;

procedure Push(var Cima: PNodo; V: Integer);
var
  N: PNodo;
begin
  New(N);
  N^.V := V;
  N^.Sotto := Cima;
  Cima := N;
end;

function Pop(var Cima: PNodo): Integer;
var
  N: PNodo;
begin
  N := Cima;
  Result := N^.V;
  Cima := N^.Sotto;
  Dispose(N);
end;

var
  S: PNodo = nil;
  I: Integer;
begin
  for I := 1 to 5 do
    Push(S, I * I);
  while S <> nil do
    Write(Pop(S), ' ');
  WriteLn;
end.
