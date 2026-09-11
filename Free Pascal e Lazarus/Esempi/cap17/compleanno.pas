{ Compleanno - Manuale completo di Free Pascal e Lazarus }
program Compleanno;
{$mode objfpc}{$H+}
uses
  SysUtils, DateUtils;
var
  Nascita, Oggi, Prossimo: TDateTime;
  A, M, G: Word;
begin
  Oggi := EncodeDate(2026, 9, 11);
  Nascita := EncodeDate(1990, 12, 25);
  WriteLn('Eta'': ', YearsBetween(Oggi, Nascita), ' anni');
  DecodeDate(Nascita, A, M, G);
  DecodeDate(Oggi, A, A, A);        { A = anno corrente }
  Prossimo := EncodeDate(YearOf(Oggi), M, G);
  if Prossimo < Oggi then
    Prossimo := IncYear(Prossimo);
  WriteLn('Prossimo compleanno: ',
          FormatDateTime('dd"/"mm"/"yyyy', Prossimo),
          ', tra ', DaysBetween(Oggi, Prossimo), ' giorni');
end.
