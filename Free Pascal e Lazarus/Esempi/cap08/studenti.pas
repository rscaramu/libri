{ Studenti - Manuale completo di Free Pascal e Lazarus }
program Studenti;
{$mode objfpc}{$H+}
type
  TStudente = record
    Nome: String;
    Voti: array[1..3] of Integer;
  end;

function Media(const S: TStudente): Double;
var
  I, Somma: Integer;
begin
  Somma := 0;
  for I := 1 to 3 do
    Somma := Somma + S.Voti[I];
  Result := Somma / 3;
end;

const
  Classe: array[1..3] of TStudente = (
    (Nome: 'Bianchi'; Voti: (7, 8, 6)),
    (Nome: 'Rossi';   Voti: (5, 4, 6)),
    (Nome: 'Verdi';   Voti: (9, 10, 8)));
var
  I: Integer;
  M: Double;
begin
  for I := 1 to 3 do
  begin
    M := Media(Classe[I]);
    Write(Classe[I].Nome:10, M:6:2);
    if M < 6 then
      Write('  insufficiente');
    WriteLn;
  end;
end.
