program Romani;

{$APPTYPE CONSOLE}

function Romano(N: Integer): string;

  procedure Applica(Valore: Integer; const Simbolo: string);
  begin
    while N >= Valore do
    begin
      Result := Result + Simbolo;
      N := N - Valore;
    end;
  end;

begin
  Result := '';
  Applica(1000, 'M'); Applica(900, 'CM');
  Applica(500, 'D'); Applica(400, 'CD');
  Applica(100, 'C'); Applica(90, 'XC');
  Applica(50, 'L'); Applica(40, 'XL');
  Applica(10, 'X'); Applica(9, 'IX');
  Applica(5, 'V'); Applica(4, 'IV');
  Applica(1, 'I');
end;

begin
  WriteLn(Romano(1994), ' ', Romano(2026), ' ', Romano(3999));
end.
