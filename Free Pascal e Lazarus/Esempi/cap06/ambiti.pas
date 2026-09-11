{ Ambiti - Manuale completo di Free Pascal e Lazarus }
program Ambiti;
{$mode objfpc}{$H+}
var
  Globale: Integer = 100;

procedure Esterna(P: Integer);
var
  Locale: Integer;

  procedure Interna;
  begin
    { vede P, Locale e Globale }
    WriteLn('    Interna: P=', P, ' Locale=', Locale,
            ' Globale=', Globale);
    Locale := Locale + 1;
  end;

begin
  Locale := P * 2;
  Interna;
  Interna;
  WriteLn('  Esterna: Locale=', Locale);
end;

procedure Ombra;
var
  Globale: Integer;   { nasconde la globale }
begin
  Globale := -1;
  WriteLn('  Ombra vede Globale=', Globale);
end;

begin
  Esterna(5);
  Ombra;
  WriteLn('Programma: Globale=', Globale);
end.
