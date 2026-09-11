program CodaStampa;

{$APPTYPE CONSOLE}

uses
  Generics.Collections;

var
  Q: TQueue<string>;
  I: Integer;
begin
  Q := TQueue<string>.Create;
  try
    for I := 1 to 5 do
      Q.Enqueue('doc' + Chr(Ord('0') + I));
    for I := 1 to 3 do
      WriteLn('stampo ', Q.Dequeue);
    Q.Enqueue('doc6');
    Q.Enqueue('doc7');
    WriteLn('in coda: ', Q.Count);
    while Q.Count > 0 do
      Write(Q.Dequeue, ' ');
    WriteLn;
  finally
    Q.Free;
  end;
end.
