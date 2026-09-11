{ HelperDate - Manuale completo di Free Pascal e Lazarus }
program HelperDate;
{$mode objfpc}{$H+}
{$modeswitch typehelpers}
uses
  SysUtils, DateUtils;
type
  TDateHelper = type helper for TDateTime
    function EFestivo: Boolean;
    function Formatta: String;
  end;

  TStrHelper = type helper(TStringHelper) for String
    function Capitalizza: String;
  end;

function TDateHelper.EFestivo: Boolean;
begin
  Result := DayOfTheWeek(Self) >= 6;
end;

function TDateHelper.Formatta: String;
begin
  Result := FormatDateTime('dd"/"mm"/"yyyy', Self);
end;

function TStrHelper.Capitalizza: String;
begin
  if Self = '' then
    Exit('');
  Result := UpperCase(Self[1]) + Self.Substring(1).ToLower;
end;

var
  D: TDateTime;
  S: String;
begin
  D := EncodeDate(2026, 9, 12);
  WriteLn(D.Formatta, ' festivo? ', D.EFestivo);
  D := D + 2;
  WriteLn(D.Formatta, ' festivo? ', D.EFestivo);
  S := 'pASCAL';
  WriteLn(S.Capitalizza, ' ', S.Trim.Length);
end.
