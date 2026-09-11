program SommaValidi;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  Riga: string;
  V, Somma: Double;
  Scartate: string;
begin
  { stdin: 1.5\nabc\n2.5\n\n }
  Somma := 0;
  Scartate := '';
  ReadLn(Riga);
  while Riga <> '' do
  begin
    if TryStrToFloat(Riga, V) then
      Somma := Somma + V
    else
      Scartate := Scartate + Riga + ' ';
    ReadLn(Riga);
  end;
  WriteLn('somma ', Somma:0:1);
  WriteLn('scartate: ', Scartate);
end.
