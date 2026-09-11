program SommaMedia;

{$APPTYPE CONSOLE}

var
  N, Somma, Conteggio: Integer;
begin
  { stdin: 4\n7\n9\n0\n }
  Somma := 0;
  Conteggio := 0;
  ReadLn(N);
  while N <> 0 do
  begin
    Somma := Somma + N;
    Inc(Conteggio);
    ReadLn(N);
  end;
  if Conteggio = 0 then
    WriteLn('nessun valore')
  else
    WriteLn('somma ', Somma, ' media ',
      Somma / Conteggio:0:2);
end.
