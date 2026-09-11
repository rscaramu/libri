program FibonacciEnum;

{$APPTYPE CONSOLE}

uses
  Generics.Collections;

type
  TFibonacci = class
  private
    FMax: Int64;
  public
    constructor Create(AMax: Int64);
    function GetEnumerator: TEnumerator<Int64>;
  end;
  TFibEnum = class(TEnumerator<Int64>)
  private
    FA, FB, FMax: Int64;
    FPrimo: Boolean;
  protected
    function DoGetCurrent: Int64; override;
    function DoMoveNext: Boolean; override;
  public
    constructor Create(AMax: Int64);
  end;

constructor TFibonacci.Create(AMax: Int64);
begin
  inherited Create;
  FMax := AMax;
end;

function TFibonacci.GetEnumerator: TEnumerator<Int64>;
begin
  Result := TFibEnum.Create(FMax);
end;

constructor TFibEnum.Create(AMax: Int64);
begin
  inherited Create;
  FA := 0; FB := 1; FMax := AMax; FPrimo := True;
end;

function TFibEnum.DoGetCurrent: Int64;
begin
  Result := FA;
end;

function TFibEnum.DoMoveNext: Boolean;
var
  T: Int64;
begin
  if FPrimo then
    FPrimo := False
  else
  begin
    T := FA + FB;
    FA := FB;
    FB := T;
  end;
  Result := FA <= FMax;
end;

var
  F: TFibonacci;
  X: Int64;
begin
  F := TFibonacci.Create(100);
  try
    for X in F do
      Write(X, ' ');
    WriteLn;
  finally
    F.Free;
  end;
end.
