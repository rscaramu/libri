program TestSenzaFramework;

{$APPTYPE CONSOLE}

uses
  SysUtils, Math;

function Rata(Capitale, TassoAnnuo: Double;
  Mesi: Integer): Double;
var
  I: Double;
begin
  if Mesi <= 0 then
    raise EArgumentException.Create('mesi non validi');
  if TassoAnnuo = 0 then
    Exit(Capitale / Mesi);
  I := TassoAnnuo / 12;
  Result := Capitale * I / (1 - Power(1 + I, -Mesi));
end;

var
  Superati, Falliti: Integer;

procedure Verifica(const Nome: string; Atteso, Reale: Double);
begin
  if SameValue(Atteso, Reale, 0.005) then
  begin
    Inc(Superati);
    WriteLn('ok   ', Nome);
  end
  else
  begin
    Inc(Falliti);
    WriteLn('FAIL ', Nome, ': atteso ', Atteso:0:2,
      ', ottenuto ', Reale:0:2);
  end;
end;

procedure VerificaEccezione(const Nome: string;
  Capitale, Tasso: Double; Mesi: Integer);
begin
  try
    Rata(Capitale, Tasso, Mesi);
    Inc(Falliti);
    WriteLn('FAIL ', Nome, ': nessuna eccezione');
  except
    on EArgumentException do
    begin
      Inc(Superati);
      WriteLn('ok   ', Nome);
    end;
  end;
end;

begin
  Superati := 0;
  Falliti := 0;
  Verifica('tasso zero', 100, Rata(1200, 0, 12));
  Verifica('un anno al 6%', 86.07, Rata(1000, 0.06, 12));
  Verifica('dieci anni al 4%', 101.25,
    Rata(10000, 0.04, 120));
  Verifica('una rata', 1050, Rata(1000, 0.6, 1));
  VerificaEccezione('mesi zero', 1000, 0.05, 0);
  VerificaEccezione('mesi negativi', 1000, 0.05, -3);
  WriteLn(Superati, ' superati, ', Falliti, ' falliti');
  if Falliti > 0 then
    Halt(1);
end.
