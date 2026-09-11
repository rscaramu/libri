{ CodaCircolare - Manuale completo di Free Pascal e Lazarus }
program CodaCircolare;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  TCoda = class
  private
    FDati: array of Integer;
    FInizio, FConta: Integer;
  public
    constructor Create(Capacita: Integer);
    procedure Accoda(V: Integer);
    function Estrai: Integer;
    function Vuota: Boolean;
    function Piena: Boolean;
  end;

constructor TCoda.Create(Capacita: Integer);
begin
  SetLength(FDati, Capacita);
end;

function TCoda.Vuota: Boolean;
begin
  Result := FConta = 0;
end;

function TCoda.Piena: Boolean;
begin
  Result := FConta = Length(FDati);
end;

procedure TCoda.Accoda(V: Integer);
begin
  if Piena then
    raise Exception.Create('Coda piena');
  FDati[(FInizio + FConta) mod Length(FDati)] := V;
  Inc(FConta);
end;

function TCoda.Estrai: Integer;
begin
  if Vuota then
    raise Exception.Create('Coda vuota');
  Result := FDati[FInizio];
  FInizio := (FInizio + 1) mod Length(FDati);
  Dec(FConta);
end;

var
  C: TCoda;
  I: Integer;
begin
  C := TCoda.Create(3);
  try
    C.Accoda(1); C.Accoda(2); C.Accoda(3);
    Write(C.Estrai, ' ');
    C.Accoda(4);              { riusa il posto liberato }
    while not C.Vuota do
      Write(C.Estrai, ' ');
    WriteLn;
  finally
    C.Free;
  end;
end.
