{ Builder - Manuale completo di Free Pascal e Lazarus }
program Builder;
{$mode objfpc}{$H+}
uses
  SysUtils;
var
  SB: TStringBuilder;
  I: Integer;
  T: QWord;
  S: String;
begin
  SB := TStringBuilder.Create;
  try
    SB.Append('Quadrati: ');
    for I := 1 to 5 do
      SB.Append(I * I).Append(' ');
    SB.AppendLine;
    SB.AppendFormat('Totale %d numeri', [5]);
    WriteLn(SB.ToString);
    WriteLn('Lunghezza: ', SB.Length);
  finally
    SB.Free;
  end;

  T := GetTickCount64;
  S := '';
  for I := 1 to 200000 do
    S := S + 'x';
  WriteLn('Concatenazione: ', Length(S), ' caratteri');
  SB := TStringBuilder.Create;
  try
    for I := 1 to 200000 do
      SB.Append('x');
    WriteLn('Builder: ', SB.Length, ' caratteri');
  finally
    SB.Free;
  end;
  WriteLn('Entrambi in meno di un secondo? ',
          GetTickCount64 - T < 1000);
end.
