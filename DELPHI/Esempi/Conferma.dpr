program Conferma;

{$APPTYPE CONSOLE}

var
  Risposta: string;
begin
  { stdin: forse\nboh\ns\n }
  repeat
    Write('Continuare? (s/n) ');
    ReadLn(Risposta);
  until (Risposta = 's') or (Risposta = 'n');
  WriteLn;
  WriteLn('Risposta: ', Risposta);
end.
