{ Potenze - Manuale completo di Free Pascal e Lazarus }
program Potenze;
{$mode objfpc}{$H+}

function PotenzaIter(Base: Integer; Esp: Integer): Int64;
var
  I: Integer;
begin
  Result := 1;
  for I := 1 to Esp do
    Result := Result * Base;
end;

function PotenzaRic(Base: Integer; Esp: Integer): Int64;
begin
  if Esp = 0 then
    Result := 1
  else
    Result := Base * PotenzaRic(Base, Esp - 1);
end;

begin
  WriteLn('2^10 = ', PotenzaIter(2, 10), ' = ',
          PotenzaRic(2, 10));
  WriteLn('3^0  = ', PotenzaIter(3, 0), ' = ',
          PotenzaRic(3, 0));
  WriteLn('7^12 = ', PotenzaIter(7, 12));
end.
