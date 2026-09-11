program RadiceDigitale;

{$APPTYPE CONSOLE}

function SommaCifre(N: Integer): Integer;
begin
  if N < 10 then
    Result := N
  else
    Result := N mod 10 + SommaCifre(N div 10);
end;

function RadiceDigitale(N: Integer): Integer;
begin
  Result := N;
  while Result >= 10 do
    Result := SommaCifre(Result);
end;

begin
  WriteLn(SommaCifre(987), ' ', RadiceDigitale(987));
  WriteLn(SommaCifre(123456789), ' ',
    RadiceDigitale(123456789));
end.
