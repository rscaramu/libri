program Scoped;

{$APPTYPE CONSOLE}

{$SCOPEDENUMS ON}

type
  TColore = (Rosso, Verde, Blu);
  TSemaforo = (Rosso, Giallo, Verde);

var
  C: TColore;
  S: TSemaforo;
begin
  C := TColore.Verde;
  S := TSemaforo.Verde;
  WriteLn(Ord(C), ' ', Ord(S));
end.
