{ ArrayAperti - Manuale completo di Free Pascal e Lazarus }
program ArrayAperti;
{$mode objfpc}{$H+}

function Somma(const A: array of Integer): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to High(A) do
    Result := Result + A[I];
end;

procedure Mostra(const Valori: array of const);
var
  I: Integer;
begin
  for I := 0 to High(Valori) do
    case Valori[I].VType of
      vtInteger:    Write(Valori[I].VInteger, ' ');
      vtBoolean:    Write(Valori[I].VBoolean, ' ');
      vtChar:       Write(Valori[I].VChar, ' ');
      vtAnsiString:
        Write(AnsiString(Valori[I].VAnsiString), ' ');
    else
      Write('? ');
    end;
  WriteLn;
end;

var
  S: array[1..4] of Integer = (10, 20, 30, 40);
  D: array of Integer;
begin
  D := [1, 2, 3];
  WriteLn(Somma(S), ' ', Somma(D), ' ', Somma([5, 5]));
  Mostra([42, True, 'x', 'ciao']);
end.
