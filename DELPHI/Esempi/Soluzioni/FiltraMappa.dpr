program FiltraMappa;

{$APPTYPE CONSOLE}

type
  TPredicato = reference to function(X: Integer): Boolean;
  TTrasforma = reference to function(X: Integer): Integer;

function Filtra(const A: array of Integer;
  Pred: TPredicato): TArray<Integer>;
var
  X: Integer;
begin
  Result := nil;
  for X in A do
    if Pred(X) then
      Result := Result + [X];
end;

function Mappa(const A: array of Integer;
  F: TTrasforma): TArray<Integer>;
var
  I: Integer;
begin
  SetLength(Result, Length(A));
  for I := 0 to High(A) do
    Result[I] := F(A[I]);
end;

var
  X: Integer;
begin
  for X in Mappa(Filtra([1, 2, 3, 4, 5, 6],
      function(X: Integer): Boolean
      begin
        Result := X mod 2 = 0;
      end),
      function(X: Integer): Integer
      begin
        Result := X * X;
      end) do
    Write(X, ' ');
  WriteLn;
end.
