program Filtra;

{$APPTYPE CONSOLE}

type
  TPredicato<T> = function(const V: T): Boolean;
  TArr = class
    class function Filtra<T>(const A: array of T;
      Pred: TPredicato<T>): TArray<T>; static;
  end;

class function TArr.Filtra<T>(const A: array of T;
  Pred: TPredicato<T>): TArray<T>;
var
  X: T;
begin
  Result := nil;
  for X in A do
    if Pred(X) then
      Result := Result + [X];
end;

function Pari(const V: Integer): Boolean;
begin
  Result := V mod 2 = 0;
end;

var
  R: TArray<Integer>;
  X: Integer;
begin
  R := TArr.Filtra<Integer>([1, 2, 3, 4, 5, 6], Pari);
  for X in R do
    Write(X, ' ');
  WriteLn;
end.
