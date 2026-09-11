program Menu;

{$APPTYPE CONSOLE}

var
  C: Char;
begin
  { stdin: a\nx\nm\nq\n }
  repeat
    ReadLn(C);
    case C of
      'a': WriteLn('aggiungi');
      's': WriteLn('sottrai');
      'm': WriteLn('moltiplica');
      'q': WriteLn('esci');
    else
      WriteLn('comando ignoto');
    end;
  until C = 'q';
end.
