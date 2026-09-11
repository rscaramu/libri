{ Coppie - Manuale completo di Free Pascal e Lazarus }
program Coppie;
{$mode objfpc}{$H+}
type
  generic TCoppia<A, B> = record
    Primo: A;
    Secondo: B;
  end;
  TIntInt = specialize TCoppia<Integer, Integer>;
  TStrDouble = specialize TCoppia<String, Double>;

function DivMod(N, D: Integer): TIntInt;
begin
  Result.Primo := N div D;
  Result.Secondo := N mod D;
end;

var
  R: TIntInt;
  P: TStrDouble;
begin
  R := DivMod(17, 5);
  WriteLn(R.Primo, ' resto ', R.Secondo);
  P.Primo := 'pi greco';
  P.Secondo := 3.14;
  WriteLn(P.Primo, ' = ', P.Secondo:0:2);
end.
