{ Rubrica17 - Manuale completo di Free Pascal e Lazarus }
program Rubrica17;
{$mode objfpc}{$H+}
uses
  Classes, SysUtils;
var
  R: TStringList;
  I: Integer;
begin
  R := TStringList.Create;
  try
    R.Values['Rossi'] := '333 111';
    R.Values['Bianchi'] := '02 222';
    R.Values['Verdi'] := '06 333';
    WriteLn('Bianchi: ', R.Values['Bianchi']);
    I := R.IndexOfName('Verdi');
    if I >= 0 then
      R.Delete(I);
    R.Sort;
    R.SaveToFile('rubrica.txt');
    R.Clear;
    R.LoadFromFile('rubrica.txt');
    for I := 0 to R.Count - 1 do
      WriteLn(R.Names[I]:10, ': ', R.ValueFromIndex[I]);
    WriteLn('Sconosciuto: [', R.Values['Neri'], ']');
  finally
    R.Free;
  end;
end.
