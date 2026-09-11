program Caratteri;

{$APPTYPE CONSOLE}

var
  C: Char;
begin
  C := 'A';
  WriteLn(Ord(C));
  WriteLn(Chr(Ord(C) + 1));
  WriteLn(Succ(C), Pred(C));
  WriteLn(SizeOf(WideChar), ' ', SizeOf(AnsiChar));
end.
