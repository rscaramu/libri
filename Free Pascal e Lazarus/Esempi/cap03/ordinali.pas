{ Ordinali - Manuale completo di Free Pascal e Lazarus }
program Ordinali;
{$mode objfpc}{$H+}
var
  C: Char;
  B: Boolean;
  N: Integer;
begin
  C := 'A';
  WriteLn('Ord(''A'') = ', Ord(C), ', Succ = ', Succ(C));
  WriteLn('Chr(97) = ', Chr(97));
  B := True;
  WriteLn('Ord(True) = ', Ord(B), ', Pred = ', Pred(B));
  N := 10;
  Inc(N);
  Inc(N, 5);
  Dec(N);
  WriteLn('N = ', N);
  WriteLn('High(Char) = ', Ord(High(Char)));
end.
