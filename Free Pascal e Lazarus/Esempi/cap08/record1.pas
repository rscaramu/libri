{ Record1 - Manuale completo di Free Pascal e Lazarus }
program Record1;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  TData = record
    Giorno, Mese, Anno: Word;
  end;
  TPersona = record
    Nome, Cognome: String;
    Nascita: TData;
    Altezza: Double;
  end;

function DescriviData(const D: TData): String;
begin
  Result := Format('%.2d/%.2d/%d',
                   [D.Giorno, D.Mese, D.Anno]);
end;

procedure Stampa(const P: TPersona);
begin
  WriteLn(P.Cognome, ' ', P.Nome, ', nato il ',
          DescriviData(P.Nascita), ', alto ', P.Altezza:0:2);
end;

var
  A, B: TPersona;
begin
  A.Nome := 'Ada';
  A.Cognome := 'Lovelace';
  A.Nascita.Giorno := 10;
  A.Nascita.Mese := 12;
  A.Nascita.Anno := 1815;
  A.Altezza := 1.65;
  Stampa(A);
  B := A;                   { copia di tutti i campi }
  B.Nome := 'Anna';
  Stampa(B);
  Stampa(A);
  WriteLn('SizeOf(TData) = ', SizeOf(TData));
  WriteLn('SizeOf(TPersona) = ', SizeOf(TPersona));
end.
