{ Vocali - Manuale completo di Free Pascal e Lazarus }
program Vocali;
{$mode objfpc}{$H+}
uses
  SysUtils;
var
  Frase: String;
  Conta: array['a'..'z'] of Integer;
  C: Char;
begin
  Frase := LowerCase('Il Pascal e un linguaggio elegante');
  for C := 'a' to 'z' do
    Conta[C] := 0;
  for C in Frase do
    if C in ['a'..'z'] then
      Inc(Conta[C]);
  for C in ['a', 'e', 'i', 'o', 'u'] do
    WriteLn(C, ': ', Conta[C]);
end.
