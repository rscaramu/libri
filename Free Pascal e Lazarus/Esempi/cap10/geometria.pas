{ Geometria - Manuale completo di Free Pascal e Lazarus }
unit Geometria;
{$mode objfpc}{$H+}

interface

const
  PiGreco = 3.141592653589793;

type
  TPunto = record
    X, Y: Double;
  end;

function Punto(X, Y: Double): TPunto;
function Distanza(const A, B: TPunto): Double;
function AreaCerchio(Raggio: Double): Double;
function Chiamate: Integer;

implementation

var
  Contatore: Integer = 0;   { privata della unit }

procedure Registra;
begin
  Inc(Contatore);
end;

function Punto(X, Y: Double): TPunto;
begin
  Registra;
  Result.X := X;
  Result.Y := Y;
end;

function Distanza(const A, B: TPunto): Double;
begin
  Registra;
  Result := Sqrt(Sqr(A.X - B.X) + Sqr(A.Y - B.Y));
end;

function AreaCerchio(Raggio: Double): Double;
begin
  Registra;
  Result := PiGreco * Sqr(Raggio);
end;

function Chiamate: Integer;
begin
  Result := Contatore;
end;

end.
