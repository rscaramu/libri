{ TipiStringa - Manuale completo di Free Pascal e Lazarus }
program TipiStringa;
{$mode objfpc}{$H+}
var
  A: String;
  S: ShortString;
  W: UnicodeString;
begin
  A := 'Caff' + #$C3#$A8;   { 'Caffe'' accentata in UTF-8 }
  S := A;
  W := UTF8Decode(A);
  WriteLn('AnsiString  : ', Length(A), ' byte');
  WriteLn('ShortString : ', Length(S), ' byte, max 255');
  WriteLn('Unicode     : ', Length(W), ' code unit');
  WriteLn('SizeOf(S)   : ', SizeOf(S));
  WriteLn('SizeOf(A)   : ', SizeOf(A), ' (e'' un puntatore)');
end.
