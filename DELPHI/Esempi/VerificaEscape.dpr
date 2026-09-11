program VerificaEscape;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function JsonStringa(const S: string): string;
var
  C: Char;
begin
  Result := '"';
  for C in S do
    case C of
      '"': Result := Result + '\"';
      '\': Result := Result + '\\';
      #8: Result := Result + '\b';
      #9: Result := Result + '\t';
      #10: Result := Result + '\n';
      #13: Result := Result + '\r';
      #0..#7, #11, #12, #14..#31:
        Result := Result + '\u' + IntToHex(Ord(C), 4);
    else
      Result := Result + C;
    end;
  Result := Result + '"';
end;

var
  S, R: string;
  I: Integer;
  Pulita: Boolean;
begin
  S := '';
  for I := 0 to 31 do
    S := S + Chr(I);
  R := JsonStringa(S);
  Pulita := True;
  for I := 1 to Length(R) do
    if Ord(R[I]) < 32 then
      Pulita := False;
  WriteLn(Pulita, ' ', Length(R));
  WriteLn(Copy(R, 1, 13));
end.
