{ CodaCircolareGen - Manuale completo di Free Pascal e Lazarus }
program CodaCircolareGen;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  generic TCodaCircolare<T> = class
  private
    FDati: array of T;
    FInizio, FConta: Integer;
  public
    constructor Create(Capacita: Integer);
    procedure Accoda(const V: T);
    function Estrai: T;
    function Piena: Boolean;
    function Vuota: Boolean;
  end;
  TCodaChar = specialize TCodaCircolare<Char>;
  TCodaDouble = specialize TCodaCircolare<Double>;

constructor TCodaCircolare.Create(Capacita: Integer);
begin
  SetLength(FDati, Capacita);
end;

function TCodaCircolare.Piena: Boolean;
begin
  Result := FConta = Length(FDati);
end;

function TCodaCircolare.Vuota: Boolean;
begin
  Result := FConta = 0;
end;

procedure TCodaCircolare.Accoda(const V: T);
begin
  if Piena then
    raise Exception.Create('Piena');
  FDati[(FInizio + FConta) mod Length(FDati)] := V;
  Inc(FConta);
end;

function TCodaCircolare.Estrai: T;
begin
  if Vuota then
    raise Exception.Create('Vuota');
  Result := FDati[FInizio];
  FInizio := (FInizio + 1) mod Length(FDati);
  Dec(FConta);
end;

var
  C: TCodaChar;
  D: TCodaDouble;
begin
  C := TCodaChar.Create(2);
  D := TCodaDouble.Create(2);
  try
    C.Accoda('x'); C.Accoda('y');
    D.Accoda(1.5); D.Accoda(2.5);
    WriteLn(C.Estrai, C.Estrai, ' ', D.Estrai + D.Estrai:0:1);
  finally
    D.Free;
    C.Free;
  end;
end.
