program CodePile;

{$APPTYPE CONSOLE}

uses
  SysUtils, Generics.Collections;

var
  Q: TQueue<string>;
  S: TStack<Integer>;
begin
  Q := TQueue<string>.Create;
  S := TStack<Integer>.Create;
  try
    Q.Enqueue('primo');
    Q.Enqueue('secondo');
    Q.Enqueue('terzo');
    WriteLn(Q.Dequeue, ' ', Q.Peek, ' ', Q.Count);
    S.Push(1);
    S.Push(2);
    S.Push(3);
    WriteLn(S.Pop, ' ', S.Peek, ' ', S.Count);
    while S.Count > 0 do
      Write(S.Pop, ' ');
    WriteLn;
  finally
    Q.Free;
    S.Free;
  end;
end.
