{ Lista - Manuale completo di Free Pascal e Lazarus }
program Lista;
{$mode objfpc}{$H+}
type
  PNodo = ^TNodo;
  TNodo = record
    Valore: Integer;
    Prossimo: PNodo;
  end;

procedure InserisciInTesta(var Testa: PNodo; V: Integer);
var
  N: PNodo;
begin
  New(N);
  N^.Valore := V;
  N^.Prossimo := Testa;
  Testa := N;
end;

procedure InserisciInCoda(var Testa: PNodo; V: Integer);
var
  N, Cur: PNodo;
begin
  New(N);
  N^.Valore := V;
  N^.Prossimo := nil;
  if Testa = nil then
    Testa := N
  else
  begin
    Cur := Testa;
    while Cur^.Prossimo <> nil do
      Cur := Cur^.Prossimo;
    Cur^.Prossimo := N;
  end;
end;

procedure Stampa(Testa: PNodo);
begin
  while Testa <> nil do
  begin
    Write(Testa^.Valore, ' ');
    Testa := Testa^.Prossimo;
  end;
  WriteLn;
end;

function Conta(Testa: PNodo): Integer;
begin
  Result := 0;
  while Testa <> nil do
  begin
    Inc(Result);
    Testa := Testa^.Prossimo;
  end;
end;

procedure Libera(var Testa: PNodo);
var
  Tmp: PNodo;
begin
  while Testa <> nil do
  begin
    Tmp := Testa;
    Testa := Testa^.Prossimo;
    Dispose(Tmp);
  end;
end;

var
  L: PNodo = nil;
  I: Integer;
begin
  for I := 1 to 3 do
    InserisciInTesta(L, I);
  for I := 10 to 12 do
    InserisciInCoda(L, I);
  Stampa(L);
  WriteLn('Nodi: ', Conta(L));
  Libera(L);
  WriteLn('Dopo Libera: ', Conta(L));
end.
