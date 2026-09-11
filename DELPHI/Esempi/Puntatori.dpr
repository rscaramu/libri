program Puntatori;

{$APPTYPE CONSOLE}

type
  TOperazione = function(A, B: Integer): Integer;

function Somma(A, B: Integer): Integer;
begin
  Result := A + B;
end;

function Prodotto(A, B: Integer): Integer;
begin
  Result := A * B;
end;

procedure Applica(Op: TOperazione; const Nome: string);
begin
  WriteLn(Nome, ': ', Op(6, 7));
end;

begin
  Applica(Somma, 'somma');
  Applica(Prodotto, 'prodotto');
end.
