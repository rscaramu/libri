{ Denaro - Manuale completo di Free Pascal e Lazarus }
program Denaro;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  TDenaro = record
    Centesimi: Int64;
    Valuta: String[3];
  end;

function Soldi(Euro: Double; const V: String): TDenaro;
begin
  Result.Centesimi := Round(Euro * 100);
  Result.Valuta := V;
end;

procedure Verifica(const A, B: TDenaro);
begin
  if A.Valuta <> B.Valuta then
    raise Exception.Create('Valute diverse');
end;

operator + (const A, B: TDenaro) R: TDenaro;
begin
  Verifica(A, B);
  R.Centesimi := A.Centesimi + B.Centesimi;
  R.Valuta := A.Valuta;
end;

operator - (const A, B: TDenaro) R: TDenaro;
begin
  Verifica(A, B);
  R.Centesimi := A.Centesimi - B.Centesimi;
  R.Valuta := A.Valuta;
end;

operator < (const A, B: TDenaro) R: Boolean;
begin
  Verifica(A, B);
  R := A.Centesimi < B.Centesimi;
end;

var
  A, B: TDenaro;
begin
  A := Soldi(10.10, 'EUR');
  B := Soldi(0.20, 'EUR');
  WriteLn((A + B).Centesimi, ' ', (A - B).Centesimi, ' ',
          B < A);
  try
    A := A + Soldi(1, 'USD');
  except
    on E: Exception do
      WriteLn(E.Message);
  end;
end.
