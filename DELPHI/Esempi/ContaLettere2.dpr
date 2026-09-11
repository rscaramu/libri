program ContaLettere2;

{$APPTYPE CONSOLE}

uses
  ContaCaratteri;

var
  Risultato: TConteggio;
begin
  Conta('delphi', Risultato);
  Stampa(Risultato);
end.
