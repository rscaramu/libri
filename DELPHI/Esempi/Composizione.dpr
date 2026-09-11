program Composizione;

{$APPTYPE CONSOLE}

type
  TFunzione = reference to function(X: Double): Double;

function Componi(F, G: TFunzione): TFunzione;
begin
  Result := function(X: Double): Double
    begin
      Result := G(F(X));
    end;
end;

var
  Doppio, PiuUno, H: TFunzione;
begin
  Doppio := function(X: Double): Double
    begin
      Result := X * 2;
    end;
  PiuUno := function(X: Double): Double
    begin
      Result := X + 1;
    end;
  H := Componi(Doppio, PiuUno);
  WriteLn(H(5):0:0);
  H := Componi(PiuUno, Doppio);
  WriteLn(H(5):0:0);
end.
