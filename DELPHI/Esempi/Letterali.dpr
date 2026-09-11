program Letterali;

{$APPTYPE CONSOLE}

var
  S: string;
begin
  S := 'L''aquila';
  WriteLn(S);
  S := 'prima riga'#13#10'seconda riga';
  WriteLn(S);
  S := 'tab' + #9 + 'ulato';
  WriteLn(S);
  WriteLn('a' + 'b' + 'c', ' ', Length('abc'));
  WriteLn('');
  WriteLn(Length(''));
end.
