program CodaGenerica;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TCoda<T> = class
  private
    FDati: TArray<T>;
    FTesta: Integer;
  public
    procedure Accoda(const V: T);
    function Estrai: T;
    function Count: Integer;
  end;

procedure TCoda<T>.Accoda(const V: T);
begin
  FDati := FDati + [V];
end;

function TCoda<T>.Estrai: T;
begin
  if Count = 0 then
    raise EInvalidOpException.Create('coda vuota');
  Result := FDati[FTesta];
  Inc(FTesta);
  if FTesta > 32 then
  begin
    Delete(FDati, 0, FTesta);
    FTesta := 0;
  end;
end;

function TCoda<T>.Count: Integer;
begin
  Result := Length(FDati) - FTesta;
end;

var
  C: TCoda<string>;
begin
  C := TCoda<string>.Create;
  try
    C.Accoda('primo');
    C.Accoda('secondo');
    WriteLn(C.Estrai, ' ', C.Count);
    WriteLn(C.Estrai, ' ', C.Count);
    try
      C.Estrai;
    except
      on E: EInvalidOpException do
        WriteLn(E.Message);
    end;
  finally
    C.Free;
  end;
end.
