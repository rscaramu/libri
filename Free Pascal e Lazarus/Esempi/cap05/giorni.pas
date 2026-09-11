{ Giorni - Manuale completo di Free Pascal e Lazarus }
program Giorni;
{$mode objfpc}{$H+}
var
  G: Integer;
  C: Char;
begin
  for G := 1 to 7 do
  begin
    Write(G, ' -> ');
    case G of
      1..5: WriteLn('feriale');
      6, 7: WriteLn('fine settimana');
    end;
  end;
  for C in 'a1 Z?' do
    case C of
      'a'..'z': WriteLn(C, ': minuscola');
      'A'..'Z': WriteLn(C, ': maiuscola');
      '0'..'9': WriteLn(C, ': cifra');
      ' ':      WriteLn('spazio');
    else
      WriteLn(C, ': altro');
    end;
end.
