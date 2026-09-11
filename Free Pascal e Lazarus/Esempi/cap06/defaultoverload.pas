{ DefaultOverload - Manuale completo di Free Pascal e Lazarus }
program DefaultOverload;
{$mode objfpc}{$H+}
uses
  SysUtils;

function Saluta(const Nome: String;
                const Formula: String = 'Ciao'): String;
begin
  Result := Formula + ', ' + Nome + '!';
end;

function Area(Lato: Double): Double; overload;
begin
  Result := Lato * Lato;
end;

function Area(Base, Altezza: Double): Double; overload;
begin
  Result := Base * Altezza;
end;

function Descrivi(N: Integer): String; overload;
begin
  Result := 'intero ' + IntToStr(N);
end;

function Descrivi(const S: String): String; overload;
begin
  Result := 'stringa "' + S + '"';
end;

begin
  WriteLn(Saluta('Anna'));
  WriteLn(Saluta('Anna', 'Buongiorno'));
  WriteLn('Quadrato: ', Area(3):0:1);
  WriteLn('Rettangolo: ', Area(3, 4):0:1);
  WriteLn(Descrivi(42));
  WriteLn(Descrivi('42'));
end.
