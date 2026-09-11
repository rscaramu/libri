program ListeStringhe;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;

var
  SL: TStringList;
  I: Integer;
begin
  SL := TStringList.Create;
  try
    SL.Add('pera');
    SL.Add('mela');
    SL.Add('uva');
    WriteLn(SL.Count, ' ', SL[1], ' ', SL.IndexOf('uva'));
    WriteLn(SL.CommaText);
    SL.Sort;
    Write(SL.Text);
    SL.Delimiter := ';';
    SL.DelimitedText := 'a;b;c;d';
    WriteLn(SL.Count, ' ', SL[3]);
    SL.Clear;
    SL.Values['host'] := 'localhost';
    SL.Values['porta'] := '8080';
    WriteLn(SL[0], ' | ', SL.Values['porta'], ' | ',
      SL.Names[1]);
    SL.Clear;
    SL.Sorted := True;
    SL.Duplicates := dupIgnore;
    SL.Add('b'); SL.Add('a'); SL.Add('b');
    WriteLn(SL.CommaText, ' ', SL.Find('b', I), ' ', I);
    SL.CaseSensitive := False;
    WriteLn(SL.IndexOf('A'));
  finally
    SL.Free;
  end;
end.
