program Somma;

{$APPTYPE CONSOLE}

var
  A, B: Integer;
begin
  { stdin: 3\n4\n }
  ReadLn(A);
  ReadLn(B);
  WriteLn(A, ' + ', B, ' = ', A + B);
end.
