program QuozienteResto;

{$APPTYPE CONSOLE}

var
  A, B: Integer;
begin
  { stdin: 17\n5\n }
  ReadLn(A);
  ReadLn(B);
  WriteLn('quoziente ', A div B, ' resto ', A mod B);
  WriteLn((A div B) * B + A mod B = A);
end.
