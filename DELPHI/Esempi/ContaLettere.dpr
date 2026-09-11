program ContaLettere;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  Frase: string;
  Conteggio: array['a'..'z'] of Integer;
  C: Char;
  I: Integer;
begin
  Frase := 'la programmazione e una forma di scrittura';
  for C := 'a' to 'z' do
    Conteggio[C] := 0;
  for I := 1 to Length(Frase) do
  begin
    C := Frase[I];
    if (C >= 'a') and (C <= 'z') then
      Inc(Conteggio[C]);
  end;
  for C := 'a' to 'z' do
    if Conteggio[C] > 0 then
      WriteLn(C, ': ', Conteggio[C]);
end.
