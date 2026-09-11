program Letterali;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  A: array of Integer;
  S: TArray<string>;
  X: Integer;
begin
  A := [10, 20, 30];
  A := A + [40];
  for X in A do
    Write(X, ' ');
  WriteLn;
  S := ['a', 'b'];
  Insert('c', S, 1);
  WriteLn(string.Join('', S));
  Delete(S, 0, 1);
  WriteLn(string.Join('', S), ' ', Length(S));
end.
