{ Grep - Manuale completo di Free Pascal e Lazarus }
{ Input di prova (una voce per riga):  Free Pascal | Lazarus | Object Pascal | Fine }
program Grep;
{$mode objfpc}{$H+}
uses
  SysUtils;
var
  Parola, Riga: String;
  N: Integer;
begin
  if ParamCount >= 1 then
    Parola := ParamStr(1)
  else
    Parola := 'pascal';
  N := 0;
  while not EOF(Input) do
  begin
    ReadLn(Riga);
    Inc(N);
    if Pos(LowerCase(Parola), LowerCase(Riga)) > 0 then
      WriteLn(N, ': ', Riga);
  end;
end.
