{ Date - Manuale completo di Free Pascal e Lazarus }
program Date;
{$mode objfpc}{$H+}
uses
  SysUtils, DateUtils;
var
  D, E: TDateTime;
  A, M, G: Word;
begin
  D := EncodeDate(2026, 9, 11);
  WriteLn(FormatDateTime('dd/mm/yyyy', D));
  WriteLn(FormatDateTime('yyyy-mm-dd hh:nn:ss', D + 0.5));
  WriteLn('Giorno della settimana: ', DayOfTheWeek(D));
  E := IncMonth(D, 3);
  WriteLn(FormatDateTime('dd/mm/yyyy', E), ', tra ',
          DaysBetween(D, E), ' giorni');
  DecodeDate(EndOfTheMonth(D), A, M, G);
  WriteLn('Settembre ha ', G, ' giorni');
  WriteLn('2024 bisestile? ', IsLeapYear(2024));
  WriteLn('ISO: ', DateToISO8601(D, True));
  WriteLn('Unix: ', DateTimeToUnix(D));
  D := D + EncodeTime(14, 30, 0, 0);
  WriteLn(FormatDateTime('"Alle" hh:nn "del" d mmmm', D));
  WriteLn('Valida? ', TryEncodeDate(2026, 2, 30, E));
end.
