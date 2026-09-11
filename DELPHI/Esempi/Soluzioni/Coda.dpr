program Coda;

{$APPTYPE CONSOLE}

type
  TCoda = class
  private
    FDati: array of Integer;
  public
    procedure Accoda(V: Integer);
    function Estrai: Integer;
    function Count: Integer;
  end;

procedure TCoda.Accoda(V: Integer);
begin
  FDati := FDati + [V];
end;

function TCoda.Estrai: Integer;
begin
  Result := FDati[0];
  Delete(FDati, 0, 1);
end;

function TCoda.Count: Integer;
begin
  Result := Length(FDati);
end;

var
  C: TCoda;
begin
  C := TCoda.Create;
  try
    C.Accoda(1); C.Accoda(2); C.Accoda(3);
    WriteLn(C.Estrai, ' ', C.Estrai, ' ', C.Count);
  finally
    C.Free;
  end;
end.
