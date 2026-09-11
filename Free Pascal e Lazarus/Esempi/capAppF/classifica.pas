{ Classifica - Manuale completo di Free Pascal e Lazarus }
program Classifica;
{$mode objfpc}{$H+}
var
  C: Char;
begin
  for C in 'aE7z!' do
    if C in ['a', 'e', 'i', 'o', 'u',
             'A', 'E', 'I', 'O', 'U'] then
      WriteLn(C, ': vocale')
    else
      case C of
        'a'..'z', 'A'..'Z': WriteLn(C, ': consonante');
        '0'..'9': WriteLn(C, ': cifra');
      else
        WriteLn(C, ': altro');
      end;
end.
