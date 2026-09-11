{ StringList - Manuale completo di Free Pascal e Lazarus }
program StringList;
{$mode objfpc}{$H+}
uses
  Classes, SysUtils;
var
  L: TStringList;
  I: Integer;
  S: String;
begin
  L := TStringList.Create;
  try
    L.Add('pera');
    L.Add('mela');
    L.Add('banana');
    L.Insert(0, 'kiwi');
    WriteLn(L.Count, ' frutti, il secondo e'' ', L[1]);
    L.Sort;
    WriteLn(L.CommaText);
    WriteLn('IndexOf(mela) = ', L.IndexOf('mela'));
    L.Delete(L.IndexOf('kiwi'));
    L.Sorted := True;             { mantiene l'ordine }
    L.Add('albicocca');
    WriteLn(L.Text);
    if L.Find('mela', I) then
      WriteLn('mela alla posizione ', I);

    L.Clear;
    L.Sorted := False;
    L.Delimiter := ';';
    L.StrictDelimiter := True;
    L.DelimitedText := 'a;b c;;d';
    WriteLn(L.Count, ' campi: ');
    for S in L do
      WriteLn('  [', S, ']');

    L.Clear;
    L.Add('nome=Anna');
    L.Add('eta=30');
    WriteLn(L.Values['nome'], ', ', L.Values['eta']);
    L.Values['eta'] := '31';
    WriteLn(L.Names[1], ' -> ', L.ValueFromIndex[1]);

    L.SaveToFile('elenco.txt');
    L.Clear;
    L.LoadFromFile('elenco.txt');
    WriteLn('Ricaricate ', L.Count, ' righe');
  finally
    L.Free;
  end;
end.
