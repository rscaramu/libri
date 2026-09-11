program Riferimenti;

{$APPTYPE CONSOLE}

type
  TContatore = class
  public
    Valore: Integer;
  end;

var
  A, B: TContatore;
begin
  A := TContatore.Create;
  try
    B := A;
    B.Valore := 42;
    WriteLn(A.Valore);
    WriteLn(A = B);
  finally
    A.Free;
  end;
end.
