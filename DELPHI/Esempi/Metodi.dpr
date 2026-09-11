program Metodi;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  S: string;
  Parti: TArray<string>;
  P: string;
begin
  S := 'Delphi,Pascal,Lazarus';
  WriteLn(S.Length, ' ', S.ToUpper, ' ', S.ToLower);
  WriteLn(S.IndexOf('Pascal'), ' ', S.IndexOf('C#'));
  WriteLn(S.Substring(7, 6), '|', S.Substring(14));
  WriteLn(S.Contains('Laz'), ' ', S.StartsWith('Del'), ' ',
    S.EndsWith('rus'));
  WriteLn(S.Replace(',', ' | '));
  Parti := S.Split([',']);
  WriteLn(Length(Parti));
  for P in Parti do
    Write('[', P, ']');
  WriteLn;
  WriteLn(string.Join(' + ', Parti));
  WriteLn(S.Chars[0], ' ', S[1]);
  WriteLn('   x  '.Trim, '|', S.CountChar(','));
  WriteLn(S.IsEmpty, ' ', ''.IsEmpty);
end.
