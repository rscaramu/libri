program Eta;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  Nome: string;
  AnnoNascita, AnnoCorrente: Integer;
begin
  { stdin: Anna\n1998\n }
  Write('Come ti chiami? ');
  ReadLn(Nome);
  Write('In che anno sei nata o nato? ');
  ReadLn(AnnoNascita);
  AnnoCorrente := 2026;
  WriteLn;
  WriteLn('Ciao ', Nome, ', quest''anno compi ',
    AnnoCorrente - AnnoNascita, ' anni.');
end.
