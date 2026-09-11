{ Albero - Manuale completo di Free Pascal e Lazarus }
program Albero;
{$mode objfpc}{$H+}
type
  PNodo = ^TNodo;
  TNodo = record
    V: Integer;
    Sx, Dx: PNodo;
  end;

procedure Inserisci(var R: PNodo; V: Integer);
begin
  if R = nil then
  begin
    New(R);
    R^.V := V;
    R^.Sx := nil;
    R^.Dx := nil;
  end
  else if V < R^.V then
    Inserisci(R^.Sx, V)
  else
    Inserisci(R^.Dx, V);
end;

procedure InOrdine(R: PNodo);
begin
  if R = nil then
    Exit;
  InOrdine(R^.Sx);
  Write(R^.V, ' ');
  InOrdine(R^.Dx);
end;

procedure Libera(var R: PNodo);
begin
  if R = nil then
    Exit;
  Libera(R^.Sx);
  Libera(R^.Dx);
  Dispose(R);
  R := nil;
end;

function Altezza(R: PNodo): Integer;
begin
  if R = nil then
    Exit(0);
  Result := 1 + Altezza(R^.Sx);
  if 1 + Altezza(R^.Dx) > Result then
    Result := 1 + Altezza(R^.Dx);
end;

const
  Valori: array[0..6] of Integer =
    (50, 30, 70, 20, 40, 60, 80);
var
  Radice: PNodo = nil;
  V: Integer;
begin
  for V in Valori do
    Inserisci(Radice, V);
  InOrdine(Radice);
  WriteLn;
  WriteLn('Altezza: ', Altezza(Radice));
  Libera(Radice);
end.
