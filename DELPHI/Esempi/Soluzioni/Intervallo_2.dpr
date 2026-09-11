program Intervallo;

{$APPTYPE CONSOLE}

uses
  SysUtils, Rtti;

type
  IntervalloAttribute = class(TCustomAttribute)
  private
    FMin, FMax: Integer;
  public
    constructor Create(AMin, AMax: Integer);
    property Min: Integer read FMin;
    property Max: Integer read FMax;
  end;

  {$M+}
  TOrdine = class
  private
    FQuantita: Integer;
    FSconto: Integer;
  published
    [Intervallo(1, 1000)]
    property Quantita: Integer read FQuantita write FQuantita;
    [Intervallo(0, 50)]
    property Sconto: Integer read FSconto write FSconto;
  end;
  {$M-}

constructor IntervalloAttribute.Create(AMin, AMax: Integer);
begin
  inherited Create;
  FMin := AMin;
  FMax := AMax;
end;

function Valida(O: TObject): TArray<string>;
var
  Ctx: TRttiContext;
  P: TRttiProperty;
  A: TCustomAttribute;
  V: Integer;
begin
  Result := nil;
  Ctx := TRttiContext.Create;
  try
    for P in Ctx.GetType(O.ClassType).GetProperties do
      for A in P.GetAttributes do
        if A is IntervalloAttribute then
        begin
          V := P.GetValue(O).AsInteger;
          if (V < IntervalloAttribute(A).Min) or
             (V > IntervalloAttribute(A).Max) then
            Result := Result + [P.Name];
        end;
  finally
    Ctx.Free;
  end;
end;

var
  O: TOrdine;
begin
  O := TOrdine.Create;
  try
    O.Quantita := 0;
    O.Sconto := 10;
    WriteLn(string.Join(',', Valida(O)));
    O.Quantita := 5;
    O.Sconto := 70;
    WriteLn(string.Join(',', Valida(O)));
  finally
    O.Free;
  end;
end.
