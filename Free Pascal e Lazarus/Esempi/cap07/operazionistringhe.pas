{ OperazioniStringhe - Manuale completo di Free Pascal e Lazarus }
program OperazioniStringhe;
{$mode objfpc}{$H+}
uses
  SysUtils, StrUtils;
var
  S, T: String;
  P: Integer;
begin
  S := '  Free Pascal e Lazarus  ';
  WriteLn('[', Trim(S), ']');
  S := Trim(S);
  WriteLn(UpperCase(S));
  WriteLn(LowerCase(S));
  WriteLn('Lunghezza: ', Length(S));
  WriteLn('Primo: ', S[1], '  Ultimo: ', S[Length(S)]);
  P := Pos('Pascal', S);
  WriteLn('Pascal in posizione ', P);
  WriteLn('Copy: ', Copy(S, P, 6));
  T := S;
  Insert('Object ', T, P);
  WriteLn(T);
  Delete(T, 1, 5);
  WriteLn(T);
  WriteLn(StringReplace(S, 'e', 'E', [rfReplaceAll]));
  WriteLn(ReverseString('anna'), ' ', DupeString('ab', 3));
  WriteLn(StringOfChar('-', 10));
  WriteLn(SameText('PASCAL', 'pascal'), ' ',
          'PASCAL' = 'pascal');
  WriteLn(IfThen(Length(S) > 10, 'lunga', 'corta'));
end.
