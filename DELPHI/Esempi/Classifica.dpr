program Classifica;

{$APPTYPE CONSOLE}

var
  C: Char;
begin
  for C in 'a1 Z?' do
    case C of
      'a'..'z': WriteLn(C, ' minuscola');
      'A'..'Z': WriteLn(C, ' maiuscola');
      '0'..'9': WriteLn(C, ' cifra');
      ' ': WriteLn('spazio');
    else
      WriteLn(C, ' altro');
    end;
end.
