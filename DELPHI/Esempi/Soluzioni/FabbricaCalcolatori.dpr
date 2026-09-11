program FabbricaCalcolatori;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  ICalcolatore = interface
    function Calcola(A, B: Double): Double;
  end;
  TSomma = class(TInterfacedObject, ICalcolatore)
    function Calcola(A, B: Double): Double;
  end;
  TMedia = class(TInterfacedObject, ICalcolatore)
    function Calcola(A, B: Double): Double;
  end;

function TSomma.Calcola(A, B: Double): Double;
begin
  Result := A + B;
end;

function TMedia.Calcola(A, B: Double): Double;
begin
  Result := (A + B) / 2;
end;

function NuovoCalcolatore(const Tipo: string): ICalcolatore;
begin
  if SameText(Tipo, 'somma') then
    Result := TSomma.Create
  else if SameText(Tipo, 'media') then
    Result := TMedia.Create
  else
    raise EArgumentException.Create('tipo ignoto: ' + Tipo);
end;

procedure Usa(const C: ICalcolatore);
begin
  WriteLn(C.Calcola(4, 6):0:1);
end;

begin
  Usa(NuovoCalcolatore('somma'));
  Usa(NuovoCalcolatore('MEDIA'));
end.
