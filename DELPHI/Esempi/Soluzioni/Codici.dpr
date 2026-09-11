program Codici;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  S: string;
  C: Char;
begin
  { stdin: Ab1\n }
  ReadLn(S);
  for C in S do
    WriteLn(Format('''%s'' = %d', [C, Ord(C)]));
end.
