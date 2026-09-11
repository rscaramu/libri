{ ArrayDinamici - Manuale completo di Free Pascal e Lazarus }
program ArrayDinamici;
{$mode objfpc}{$H+}
type
  TInteri = array of Integer;

function Quadrati(N: Integer): TInteri;
var
  I: Integer;
begin
  SetLength(Result, N);
  for I := 0 to N - 1 do
    Result[I] := (I + 1) * (I + 1);
end;

procedure Stampa(const A: TInteri);
var
  V: Integer;
begin
  for V in A do
    Write(V, ' ');
  WriteLn('(', Length(A), ' elementi)');
end;

var
  A, B: TInteri;
begin
  A := Quadrati(5);
  Stampa(A);
  SetLength(A, 7);        { allunga: i nuovi valgono 0 }
  Stampa(A);
  SetLength(A, 3);        { accorcia }
  Stampa(A);
  B := A;                 { B punta agli STESSI dati }
  B[0] := 99;
  Stampa(A);
  B := Copy(A);           { copia indipendente }
  B[0] := 1;
  Stampa(A);
  Stampa(B);
  A := nil;
  Stampa(A);
end.
