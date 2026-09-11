{ Compila - Manuale completo di Free Pascal e Lazarus }
program Compila;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, Process;
var
  F: TStringList;
  Output, Riga: String;
  Errori: Integer;
begin
  F := TStringList.Create;
  try
    F.Add('program errato;');
    F.Add('begin');
    F.Add('  WriteLn(x);');
    F.Add('end.');
    F.SaveToFile('errato.pas');
  finally
    F.Free;
  end;
  RunCommand('fpc', ['-v0e', 'errato.pas'], Output);
  Errori := 0;
  for Riga in Output.Split(LineEnding) do
    if Pos('Error', Riga) > 0 then
    begin
      Inc(Errori);
      WriteLn(Riga);
    end;
  WriteLn(Errori, ' errori');
end.
