program RegistroOggetti;

{$APPTYPE CONSOLE}

type
  TRegistro<T: class> = class
  private
    FOggetti: TArray<T>;
  public
    destructor Destroy; override;
    procedure Aggiungi(O: T);
  end;
  TCosa = class
    destructor Destroy; override;
  end;

destructor TRegistro<T>.Destroy;
var
  O: T;
begin
  for O in FOggetti do
    O.Free;
  inherited;
end;

procedure TRegistro<T>.Aggiungi(O: T);
begin
  FOggetti := FOggetti + [O];
end;

destructor TCosa.Destroy;
begin
  WriteLn('libero una cosa');
  inherited;
end;

var
  R: TRegistro<TCosa>;
begin
  R := TRegistro<TCosa>.Create;
  R.Aggiungi(TCosa.Create);
  R.Aggiungi(TCosa.Create);
  R.Free;
end.
