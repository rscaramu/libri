program DiClasse;

{$APPTYPE CONSOLE}

type
  TSensore = class
  private
    class var FCreati: Integer;
    var FId: Integer;
  public
    constructor Create;
    class function Creati: Integer;
    class function DaId(AId: Integer): TSensore;
    property Id: Integer read FId;
  end;

constructor TSensore.Create;
begin
  inherited;
  Inc(FCreati);
  FId := FCreati;
end;

class function TSensore.Creati: Integer;
begin
  Result := FCreati;
end;

class function TSensore.DaId(AId: Integer): TSensore;
begin
  Result := Create;
  Result.FId := AId;
end;

var
  A, B: TSensore;
begin
  A := TSensore.Create;
  B := TSensore.DaId(100);
  try
    WriteLn(A.Id, ' ', B.Id, ' ', TSensore.Creati);
  finally
    A.Free;
    B.Free;
  end;
end.
