{ Contatore - Manuale completo di Free Pascal e Lazarus }
unit Contatore;
{$mode objfpc}{$H+}

interface

procedure Incrementa(Quanto: Integer = 1);
procedure Azzera;
function Valore: Integer;

implementation

var
  FValore: Integer;

procedure Incrementa(Quanto: Integer);
begin
  Inc(FValore, Quanto);
end;

procedure Azzera;
begin
  FValore := 0;
end;

function Valore: Integer;
begin
  Result := FValore;
end;

initialization
  FValore := 0;

end.
