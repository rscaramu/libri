program Chiusure;

{$APPTYPE CONSOLE}

type
  TContatore = reference to function: Integer;
  TMoltiplica = reference to function(X: Integer): Integer;

function NuovoContatore: TContatore;
var
  N: Integer;
begin
  N := 0;
  Result := function: Integer
    begin
      Inc(N);
      Result := N;
    end;
end;

function Moltiplicatore(K: Integer): TMoltiplica;
begin
  Result := function(X: Integer): Integer
    begin
      Result := X * K;
    end;
end;

var
  A, B: TContatore;
  PerTre, PerDieci: TMoltiplica;
  V: Integer;
begin
  A := NuovoContatore;
  B := NuovoContatore;
  V := A(); WriteLn(V);
  V := A(); WriteLn(V);
  V := A(); WriteLn(V);
  V := B(); WriteLn(V);
  PerTre := Moltiplicatore(3);
  PerDieci := Moltiplicatore(10);
  WriteLn(PerTre(7), ' ', PerDieci(7));
end.
