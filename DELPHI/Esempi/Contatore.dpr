program Contatore;

{$APPTYPE CONSOLE}

type
  TContatore = class
  private
    FValore, FMassimo: Integer;
    procedure SetMassimo(const Value: Integer);
  public
    constructor Create(AMassimo: Integer);
    procedure Incrementa;
    property Valore: Integer read FValore;
    property Massimo: Integer read FMassimo write SetMassimo;
  end;

constructor TContatore.Create(AMassimo: Integer);
begin
  inherited Create;
  FMassimo := AMassimo;
end;

procedure TContatore.SetMassimo(const Value: Integer);
begin
  FMassimo := Value;
  if FValore > FMassimo then
    FValore := FMassimo;
end;

procedure TContatore.Incrementa;
begin
  if FValore < FMassimo then
    Inc(FValore);
end;

var
  C: TContatore;
  I: Integer;
begin
  C := TContatore.Create(5);
  try
    for I := 1 to 10 do
      C.Incrementa;
    WriteLn(C.Valore);
    C.Massimo := 3;
    WriteLn(C.Valore);
  finally
    C.Free;
  end;
end.
