program Puntatori;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  PNodo = ^TNodo;
  TNodo = record
    Valore: Integer;
    Successivo: PNodo;
  end;

var
  Testa, N: PNodo;
  Buffer: PByte;
  I: Integer;
begin
  Testa := nil;
  for I := 3 downto 1 do
  begin
    New(N);
    N^.Valore := I;
    N^.Successivo := Testa;
    Testa := N;
  end;
  N := Testa;
  while N <> nil do
  begin
    Write(N^.Valore, ' ');
    N := N^.Successivo;
  end;
  WriteLn;
  while Testa <> nil do
  begin
    N := Testa;
    Testa := Testa^.Successivo;
    Dispose(N);
  end;
  GetMem(Buffer, 1024);
  try
    FillChar(Buffer^, 1024, 0);
    Buffer[10] := 42;
    WriteLn(Buffer[10], ' ', Buffer[11]);
  finally
    FreeMem(Buffer);
  end;
  WriteLn(SizeOf(TNodo), ' ', SizeOf(PNodo));
end.
