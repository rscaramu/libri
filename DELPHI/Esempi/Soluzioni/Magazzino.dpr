program Magazzino;

{$APPTYPE CONSOLE}

type
  TProdotto = record
    Codice: string;
    Prezzo: Currency;
    Quantita: Integer;
  end;

function Valore(const P: array of TProdotto): Currency;
var
  X: TProdotto;
begin
  Result := 0;
  for X in P do
    Result := Result + X.Prezzo * X.Quantita;
end;

function Prod(const C: string; P: Currency;
  Q: Integer): TProdotto;
begin
  Result.Codice := C;
  Result.Prezzo := P;
  Result.Quantita := Q;
end;

begin
  WriteLn(Valore([Prod('A', 2.5, 10),
    Prod('B', 0.75, 100)]):0:2);
end.
