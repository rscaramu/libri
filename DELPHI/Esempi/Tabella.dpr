program Tabella;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  FS: TFormatSettings;
  Totale: Currency;

procedure Riga(const Nome: string; Importo: Currency);
begin
  WriteLn(Format('%-12s%14s', [Nome,
    FormatCurr('#,##0.00', Importo, FS)]));
  Totale := Totale + Importo;
end;

begin
  FS := FormatSettings;
  FS.DecimalSeparator := ',';
  FS.ThousandSeparator := '.';
  Totale := 0;
  Riga('Materiali', 12500.5);
  Riga('Manodopera', 8300);
  Riga('Trasporto', 450.75);
  WriteLn(StringOfChar('-', 26));
  Riga('Totale', Totale);
end.
