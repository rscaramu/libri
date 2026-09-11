program PilaLimitata;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TPila<T> = class
  protected
    FDati: TArray<T>;
  public
    procedure Push(const V: T); virtual;
    function Count: Integer;
  end;
  TPilaLimitata<T> = class(TPila<T>)
  private
    FMax: Integer;
  public
    constructor Create(AMax: Integer);
    procedure Push(const V: T); override;
  end;

procedure TPila<T>.Push(const V: T);
begin
  FDati := FDati + [V];
end;

function TPila<T>.Count: Integer;
begin
  Result := Length(FDati);
end;

constructor TPilaLimitata<T>.Create(AMax: Integer);
begin
  inherited Create;
  FMax := AMax;
end;

procedure TPilaLimitata<T>.Push(const V: T);
begin
  if Count >= FMax then
    raise EInvalidOpException.Create('pila piena');
  inherited;
end;

var
  P: TPilaLimitata<Integer>;
begin
  P := TPilaLimitata<Integer>.Create(2);
  try
    P.Push(1);
    P.Push(2);
    try
      P.Push(3);
    except
      on E: EInvalidOpException do
        WriteLn(E.Message, ' (', P.Count, ')');
    end;
  finally
    P.Free;
  end;
end.
