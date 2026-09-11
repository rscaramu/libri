program CoppiaScambia;

{$APPTYPE CONSOLE}

type
  TCoppia<T> = record
    Primo, Secondo: T;
    constructor Create(A, B: T);
    function Scambia: TCoppia<T>;
  end;

constructor TCoppia<T>.Create(A, B: T);
begin
  Primo := A;
  Secondo := B;
end;

function TCoppia<T>.Scambia: TCoppia<T>;
begin
  Result.Primo := Secondo;
  Result.Secondo := Primo;
end;

var
  I: TCoppia<Integer>;
  S: TCoppia<string>;
begin
  I := TCoppia<Integer>.Create(1, 2).Scambia;
  S := TCoppia<string>.Create('a', 'b').Scambia;
  WriteLn(I.Primo, I.Secondo, ' ', S.Primo, S.Secondo);
end.
