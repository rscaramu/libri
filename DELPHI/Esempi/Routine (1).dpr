program Routine;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  S: string;
begin
  S := '  Delphi e Pascal  ';
  WriteLn('[', Trim(S), ']');
  WriteLn('[', TrimLeft(S), ']');
  S := Trim(S);
  WriteLn(UpperCase(S), ' ', LowerCase(S));
  WriteLn(Pos('Pascal', S));
  WriteLn(Copy(S, 1, 6));
  WriteLn(Copy(S, 10, MaxInt));
  Delete(S, 7, 2);
  WriteLn(S);
  Insert(' e', S, 7);
  WriteLn(S);
  WriteLn(StringReplace(S, 'a', 'A', [rfReplaceAll]));
  WriteLn(StringReplace(S, 'a', 'A', []));
  WriteLn(SameText('DELPHI', 'delphi'), ' ',
    'DELPHI' = 'delphi');
  WriteLn(CompareStr('abc', 'abd'), ' ',
    CompareText('ABC', 'abc'));
  WriteLn(QuotedStr('l''aquila'));
  WriteLn(StringOfChar('=', 10));
end.
