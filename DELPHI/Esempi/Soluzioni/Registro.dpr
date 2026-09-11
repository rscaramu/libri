program Registro;

{$APPTYPE CONSOLE}

type
  TRegistro = class
  private
    class var FVive: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    class function Vive: Integer;
  end;

constructor TRegistro.Create;
begin
  inherited;
  Inc(FVive);
end;

destructor TRegistro.Destroy;
begin
  Dec(FVive);
  inherited;
end;

class function TRegistro.Vive: Integer;
begin
  Result := FVive;
end;

var
  A, B, C: TRegistro;
begin
  A := TRegistro.Create;
  B := TRegistro.Create;
  C := TRegistro.Create;
  WriteLn(TRegistro.Vive);
  B.Free;
  WriteLn(TRegistro.Vive);
  A.Free;
  C.Free;
  WriteLn(TRegistro.Vive);
end.
