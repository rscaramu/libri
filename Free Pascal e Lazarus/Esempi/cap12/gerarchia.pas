{ Gerarchia - Manuale completo di Free Pascal e Lazarus }
program Gerarchia;
{$mode objfpc}{$H+}
uses
  SysUtils;

procedure Prova(Caso: Integer);
var
  A, B: Integer;
  D: Double;
  P: PInteger;
begin
  try
    case Caso of
      1: begin
           A := 10;
           B := 0;
           WriteLn(A div B);
         end;
      2: begin
           D := 0;
           WriteLn(1 / D);
         end;
      3: begin
           P := nil;
           WriteLn(P^);
         end;
      4: WriteLn(StrToFloat('x'));
    end;
  except
    on E: EDivByZero do
      WriteLn('Caso ', Caso, ': divisione intera per zero');
    on E: EZeroDivide do
      WriteLn('Caso ', Caso, ': divisione reale per zero');
    on E: EConvertError do
      WriteLn('Caso ', Caso, ': ', E.Message);
    on E: Exception do
      WriteLn('Caso ', Caso, ': ', E.ClassName);
  end;
end;

var
  I: Integer;
begin
  for I := 1 to 4 do
    Prova(I);
end.
