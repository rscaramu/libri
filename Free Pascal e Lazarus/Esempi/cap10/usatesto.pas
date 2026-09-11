{ UsaTesto - Manuale completo di Free Pascal e Lazarus }
program UsaTesto;
{$mode objfpc}{$H+}
uses
  Testo;
begin
  WriteLn(Capitalizza('pASCAL'));
  WriteLn(ContaParole('  uno  due tre '));
  WriteLn(ContaParole(''));
end.
