{ Riferimenti - Manuale completo di Free Pascal e Lazarus }
program Riferimenti;
{$mode objfpc}{$H+}
type
  TScatola = class
  public
    Contenuto: Integer;
  end;
var
  A, B: TScatola;
begin
  A := TScatola.Create;
  A.Contenuto := 1;
  B := A;                  { stesso oggetto }
  B.Contenuto := 2;
  WriteLn('A.Contenuto = ', A.Contenuto);
  WriteLn('A = B? ', A = B);
  WriteLn('SizeOf(A) = ', SizeOf(A));
  WriteLn('InstanceSize = ', A.InstanceSize);
  A.Free;                  { distrugge l'oggetto }
  A := nil;
  { B ora e' un riferimento pendente: non usarlo }
  WriteLn('Assigned(A) = ', Assigned(A));
end.
