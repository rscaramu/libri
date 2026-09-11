{ LetturaRobusta - Manuale completo di Free Pascal e Lazarus }
{ Input di prova (una voce per riga):  abc | 200 | 15 }
program LetturaRobusta;
{$mode objfpc}{$H+}
uses
  SysUtils;

function LeggiIntero(const Prompt: String;
                     Min, Max: Integer): Integer;
var
  S: String;
  Ok: Boolean;
begin
  repeat
    Write(Prompt);
    ReadLn(S);
    Ok := TryStrToInt(Trim(S), Result);
    if not Ok then
      WriteLn('Non e'' un numero.')
    else if (Result < Min) or (Result > Max) then
    begin
      WriteLn('Deve essere tra ', Min, ' e ', Max, '.');
      Ok := False;
    end;
  until Ok;
end;

var
  N: Integer;
begin
  N := LeggiIntero('Eta'': ', 0, 120);
  WriteLn('Registrato: ', N);
end.
