program SenzaInherited;

{$APPTYPE CONSOLE}

type
  TBase = class
    constructor Create;
  end;
  TDerivata = class(TBase)
    constructor Create;
  end;

constructor TBase.Create;
begin
  inherited;
  WriteLn('TBase.Create');
end;

constructor TDerivata.Create;
begin
  WriteLn('TDerivata.Create senza inherited');
end;

begin
  TDerivata.Create.Free;
end.
